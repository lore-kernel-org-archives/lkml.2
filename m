Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab2ELATa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:19:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42602 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761472Ab2ELATV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:19:21 -0400
Date: Fri, 11 May 2012 17:17:54 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 06/11] persistent_ram: Make it possible to use memory outside
 of bootmem
Message-ID: <20120512001754.GF14782@lizard>
References: <20120512001506.GA8653@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120512001506.GA8653@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes devices' memory (e.g. framebuffers or memory mapped
EEPROMs on a local bus), as well as the normal RAM that we don't use
for the main memory.

For the normal (but unused) ram we could use kmaps, but this assumes
highmem support, so we don't bother and just use the memory via
ioremap.

As a side effect, the following hack is possible: when used together
with pstore_ram (new ramoops) module, we can limit the normal RAM region
with mem= and then point ramoops to use the rest of the memory, e.g.

	mem=128M ramoops.mem_address=0x8000000

Sure, we could just reserve the region with memblock_reserve() early in
the arch/ code, and then register a pstore_ram platform device pointing
to the reserved region. It's still a viable option if platform wants
to do so.

Also, we might want to use IO accessors in case of a real device,
but for now we don't bother (the old ramoops wasn't using it either, so
at least we don't make things worse).

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/persistent_ram.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
index ab8bff1..c16d7c2 100644
--- a/drivers/staging/android/persistent_ram.c
+++ b/drivers/staging/android/persistent_ram.c
@@ -23,6 +23,7 @@
 #include <linux/rslib.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <asm/page.h>
 #include "persistent_ram.h"
 
 struct persistent_ram_buffer {
@@ -349,10 +350,25 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size)
 	return vaddr;
 }
 
+static void *persistent_ram_iomap(phys_addr_t start, size_t size)
+{
+	if (!request_mem_region(start, size, "persistent_ram")) {
+		pr_err("request mem region (0x%llx@0x%llx) failed\n",
+			(unsigned long long)size, (unsigned long long)start);
+		return NULL;
+	}
+
+	return ioremap(start, size);
+}
+
 static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
 		struct persistent_ram_zone *prz)
 {
-	prz->vaddr = persistent_ram_vmap(start, size);
+	if (pfn_valid(start >> PAGE_SHIFT))
+		prz->vaddr = persistent_ram_vmap(start, size);
+	else
+		prz->vaddr = persistent_ram_iomap(start, size);
+
 	if (!prz->vaddr) {
 		pr_err("%s: Failed to map 0x%llx pages at 0x%llx\n", __func__,
 			(unsigned long long)size, (unsigned long long)start);
-- 
1.7.9.2

