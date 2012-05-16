Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab2EPM65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:58:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53623 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933417Ab2EPM6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:58:54 -0400
Date: Wed, 16 May 2012 05:57:24 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
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
Subject: [PATCH 6/6] pstore/ram_core: Remove now unused code
Message-ID: <20120516125723.GF20475@lizard>
References: <20120516125330.GA15460@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120516125330.GA15460@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code tried to maintain the global list of persistent ram zones,
which isn't a great idea overall, plus since Android's ram_console
is no longer there, we can remove some unused functions.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram_core.c       |   77 --------------------------------------------
 include/linux/pstore_ram.h |   19 -----------
 2 files changed, 96 deletions(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index e0d8429..b216381 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -35,8 +35,6 @@ struct persistent_ram_buffer {
 
 #define PERSISTENT_RAM_SIG (0x43474244) /* DBGC */
 
-static __initdata LIST_HEAD(persistent_ram_list);
-
 static inline size_t buffer_size(struct persistent_ram_zone *prz)
 {
 	return atomic_read(&prz->buffer->size);
@@ -455,78 +453,3 @@ err:
 	kfree(prz);
 	return ERR_PTR(ret);
 }
-
-#ifndef MODULE
-static int __init persistent_ram_buffer_init(const char *name,
-		struct persistent_ram_zone *prz)
-{
-	int i;
-	struct persistent_ram *ram;
-	struct persistent_ram_descriptor *desc;
-	phys_addr_t start;
-
-	list_for_each_entry(ram, &persistent_ram_list, node) {
-		start = ram->start;
-		for (i = 0; i < ram->num_descs; i++) {
-			desc = &ram->descs[i];
-			if (!strcmp(desc->name, name))
-				return persistent_ram_buffer_map(start,
-						desc->size, prz);
-			start += desc->size;
-		}
-	}
-
-	return -EINVAL;
-}
-
-static  __init
-struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
-{
-	struct persistent_ram_zone *prz;
-	int ret = -ENOMEM;
-
-	prz = kzalloc(sizeof(struct persistent_ram_zone), GFP_KERNEL);
-	if (!prz) {
-		pr_err("persistent_ram: failed to allocate persistent ram zone\n");
-		goto err;
-	}
-
-	ret = persistent_ram_buffer_init(dev_name(dev), prz);
-	if (ret) {
-		pr_err("persistent_ram: failed to initialize buffer\n");
-		goto err;
-	}
-
-	persistent_ram_post_init(prz, ecc);
-
-	return prz;
-err:
-	kfree(prz);
-	return ERR_PTR(ret);
-}
-
-struct persistent_ram_zone * __init
-persistent_ram_init_ringbuffer(struct device *dev, bool ecc)
-{
-	return __persistent_ram_init(dev, ecc);
-}
-
-int __init persistent_ram_early_init(struct persistent_ram *ram)
-{
-	int ret;
-
-	ret = memblock_reserve(ram->start, ram->size);
-	if (ret) {
-		pr_err("Failed to reserve persistent memory from %08lx-%08lx\n",
-			(long)ram->start, (long)(ram->start + ram->size - 1));
-		return ret;
-	}
-
-	list_add_tail(&ram->node, &persistent_ram_list);
-
-	pr_info("Initialized persistent memory from %08lx-%08lx\n",
-		(long)ram->start, (long)(ram->start + ram->size - 1));
-
-	return 0;
-}
-#endif
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index 7ed7fd4..d1d7d51 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -25,21 +25,6 @@
 
 struct persistent_ram_buffer;
 
-struct persistent_ram_descriptor {
-	const char	*name;
-	phys_addr_t	size;
-};
-
-struct persistent_ram {
-	phys_addr_t	start;
-	phys_addr_t	size;
-
-	int					num_descs;
-	struct persistent_ram_descriptor	*descs;
-
-	struct list_head node;
-};
-
 struct persistent_ram_zone {
 	phys_addr_t paddr;
 	size_t size;
@@ -63,14 +48,10 @@ struct persistent_ram_zone {
 	size_t old_log_size;
 };
 
-int persistent_ram_early_init(struct persistent_ram *ram);
-
 struct persistent_ram_zone * __init persistent_ram_new(phys_addr_t start,
 						       size_t size,
 						       bool ecc);
 void persistent_ram_free(struct persistent_ram_zone *prz);
-struct persistent_ram_zone *persistent_ram_init_ringbuffer(struct device *dev,
-		bool ecc);
 
 int persistent_ram_write(struct persistent_ram_zone *prz, const void *s,
 	unsigned int count);
-- 
1.7.9.2
