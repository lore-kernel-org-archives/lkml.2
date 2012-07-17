Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab2GQTNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:13:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33419 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab2GQTNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:13:15 -0400
Date: Tue, 17 Jul 2012 12:11:12 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, devel@driverdev.osuosl.org,
        linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH fixed] pstore/ram: Make tracing log versioned
Message-ID: <20120717191112.GA16292@lizard>
References: <20120710001004.GA22744@lizard>
 <1341879046-5197-7-git-send-email-anton.vorontsov@linaro.org>
 <20120717165601.GA16001@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120717165601.GA16001@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decoding the binary trace w/ a different kernel might be troublesome
since we convert addresses to symbols. For kernels with minimal changes,
the mappings would probably match, but it's not guaranteed at all.
(But still we could convert the addresses by hand, since we do print
raw addresses.)

If we use modules, the symbols could be loaded at different addresses
from the previously booted kernel, and so this would also fail, but
there's nothing we can do about it.

Also, the binary data format that pstore/ram is using in its ringbuffer
may change between the kernels, so here we too must ensure that we're
running the same kernel.

So, there are two questions really:

1. How to compute the unique kernel tag;
2. Where to store it.

In this patch we're using LINUX_VERSION_CODE, just as hibernation
(suspend-to-disk) does. This way we are protecting from the kernel
version mismatch, making sure that we're running the same kernel
version and patch level. We could use CRC of a symbol table (as
suggested by Tony Luck), but for now let's not be that strict.

And as for storing, we are using a small trick here. Instead of
allocating a dedicated buffer for the tag (i.e. another prz), or
hacking ram_core routines to "reserve" some control data in the
buffer, we are just encoding the tag into the buffer signature
(and XOR'ing it with the actual signature value, so that buffers
not needing a tag can just pass zero, which will result into the
plain old PRZ signature).

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Tony Luck <tony.luck@intel.com>
Suggested-by: Colin Cross <ccross@android.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---

On Tue, Jul 17, 2012 at 09:56:01AM -0700, Greg Kroah-Hartman wrote:
[...]
> That's nice, but it breaks the build on my system as linux_banner
> somehow isn't enabled as part of the build?
> 
> Is there something else you can use?  Or fix the build to work properly?

Yeah, as you say, linux_banner is not available for modules.

Looking into the hibernation/suspend-to-disk code, I see it uses
LINUX_VERSION_CODE. It is less strict as it does not include build
date, but I guess if it is not an issue for hibernation code, then it
should not be an issue for pstore/ftrace as well. And if we see any
issue with verison code, then we should "fix" it for all. Or switch
to CRC'ing kernel symbols.

So, let do things even simpler, just as hibernation code does: don't
involve CRC and other stuff, just use linux version code. Here is
the updated patch.

Thanks!

p.s. Checkpatch complains 'WARNING: LINUX_VERSION_CODE should be
avoided, code should be for the version to which it is merged',
but surely it's not for our case. :-)

 fs/pstore/ram.c            |   13 ++++++++-----
 fs/pstore/ram_core.c       |   12 +++++++-----
 include/linux/pstore_ram.h |    2 +-
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 1dd108e..0b311bc 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/version.h>
 #include <linux/pstore.h>
 #include <linux/time.h>
 #include <linux/io.h>
@@ -309,7 +310,7 @@ static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
 	for (i = 0; i < cxt->max_dump_cnt; i++) {
 		size_t sz = cxt->record_size;
 
-		cxt->przs[i] = persistent_ram_new(*paddr, sz, cxt->ecc_size);
+		cxt->przs[i] = persistent_ram_new(*paddr, sz, 0, cxt->ecc_size);
 		if (IS_ERR(cxt->przs[i])) {
 			err = PTR_ERR(cxt->przs[i]);
 			dev_err(dev, "failed to request mem region (0x%zx@0x%llx): %d\n",
@@ -327,7 +328,7 @@ fail_prz:
 
 static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 			    struct persistent_ram_zone **prz,
-			    phys_addr_t *paddr, size_t sz)
+			    phys_addr_t *paddr, size_t sz, u32 sig)
 {
 	if (!sz)
 		return 0;
@@ -335,7 +336,7 @@ static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 	if (*paddr + sz > *paddr + cxt->size)
 		return -ENOMEM;
 
-	*prz = persistent_ram_new(*paddr, sz, cxt->ecc_size);
+	*prz = persistent_ram_new(*paddr, sz, sig, cxt->ecc_size);
 	if (IS_ERR(*prz)) {
 		int err = PTR_ERR(*prz);
 
@@ -394,11 +395,13 @@ static int __devinit ramoops_probe(struct platform_device *pdev)
 	if (err)
 		goto fail_out;
 
-	err = ramoops_init_prz(dev, cxt, &cxt->cprz, &paddr, cxt->console_size);
+	err = ramoops_init_prz(dev, cxt, &cxt->cprz, &paddr,
+			       cxt->console_size, 0);
 	if (err)
 		goto fail_init_cprz;
 
-	err = ramoops_init_prz(dev, cxt, &cxt->fprz, &paddr, cxt->ftrace_size);
+	err = ramoops_init_prz(dev, cxt, &cxt->fprz, &paddr, cxt->ftrace_size,
+			       LINUX_VERSION_CODE);
 	if (err)
 		goto fail_init_fprz;
 
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 4dabbb8..eecd2a8 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -391,7 +391,7 @@ static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
 }
 
 static int __devinit persistent_ram_post_init(struct persistent_ram_zone *prz,
-					      int ecc_size)
+					      u32 sig, int ecc_size)
 {
 	int ret;
 
@@ -399,7 +399,9 @@ static int __devinit persistent_ram_post_init(struct persistent_ram_zone *prz,
 	if (ret)
 		return ret;
 
-	if (prz->buffer->sig == PERSISTENT_RAM_SIG) {
+	sig ^= PERSISTENT_RAM_SIG;
+
+	if (prz->buffer->sig == sig) {
 		if (buffer_size(prz) > prz->buffer_size ||
 		    buffer_start(prz) > buffer_size(prz))
 			pr_info("persistent_ram: found existing invalid buffer,"
@@ -417,7 +419,7 @@ static int __devinit persistent_ram_post_init(struct persistent_ram_zone *prz,
 			" (sig = 0x%08x)\n", prz->buffer->sig);
 	}
 
-	prz->buffer->sig = PERSISTENT_RAM_SIG;
+	prz->buffer->sig = sig;
 	persistent_ram_zap(prz);
 
 	return 0;
@@ -442,7 +444,7 @@ void persistent_ram_free(struct persistent_ram_zone *prz)
 }
 
 struct persistent_ram_zone * __devinit persistent_ram_new(phys_addr_t start,
-							  size_t size,
+							  size_t size, u32 sig,
 							  int ecc_size)
 {
 	struct persistent_ram_zone *prz;
@@ -458,7 +460,7 @@ struct persistent_ram_zone * __devinit persistent_ram_new(phys_addr_t start,
 	if (ret)
 		goto err;
 
-	ret = persistent_ram_post_init(prz, ecc_size);
+	ret = persistent_ram_post_init(prz, sig, ecc_size);
 	if (ret)
 		goto err;
 
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index ba2b211..098d2a8 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -47,7 +47,7 @@ struct persistent_ram_zone {
 };
 
 struct persistent_ram_zone * __devinit persistent_ram_new(phys_addr_t start,
-							  size_t size,
+							  size_t size, u32 sig,
 							  int ecc_size);
 void persistent_ram_free(struct persistent_ram_zone *prz);
 void persistent_ram_zap(struct persistent_ram_zone *prz);
-- 
1.7.10.4

