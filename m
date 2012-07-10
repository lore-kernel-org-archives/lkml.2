Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2GJANd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:13:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34782 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab2GJANX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:13:23 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 7/8] pstore/ram: Make tracing log versioned
Date: Mon,  9 Jul 2012 17:10:45 -0700
Message-Id: <1341879046-5197-7-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120710001004.GA22744@lizard>
References: <20120710001004.GA22744@lizard>
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

In this patch we're just passing linux_banner through CRC32. This
way we are protecting from the kernel version mismatch, making sure
that we're running the same image. We could also add CRC of a symbol
table (as suggested by Tony Luck), but for now let's not be that
strict.

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
 fs/pstore/Kconfig          |    1 +
 fs/pstore/ram.c            |   13 ++++++++-----
 fs/pstore/ram_core.c       |   12 +++++++-----
 include/linux/pstore_ram.h |    2 +-
 4 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
index d39bb5c..a123754 100644
--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -36,6 +36,7 @@ config PSTORE_RAM
 	depends on PSTORE
 	depends on HAS_IOMEM
 	depends on HAVE_MEMBLOCK
+	select CRC32
 	select REED_SOLOMON
 	select REED_SOLOMON_ENC8
 	select REED_SOLOMON_DEC8
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 1dd108e..a7610a1 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -31,6 +31,7 @@
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/crc32.h>
 #include <linux/pstore_ram.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
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
+			       crc32_le(0, linux_banner, strlen(linux_banner)));
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
index af848e1..1d779c4 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -46,7 +46,7 @@ struct persistent_ram_zone {
 };
 
 struct persistent_ram_zone * __devinit persistent_ram_new(phys_addr_t start,
-							  size_t size,
+							  size_t size, u32 sig,
 							  int ecc_size);
 void persistent_ram_free(struct persistent_ram_zone *prz);
 void persistent_ram_zap(struct persistent_ram_zone *prz);
-- 
1.7.10.4

