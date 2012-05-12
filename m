Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab2ELATk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:19:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42602 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab2ELATe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:19:34 -0400
Date: Fri, 11 May 2012 17:18:05 -0700
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
Subject: [PATCH 07/11] persistent_ram: Introduce persistent_ram_free()
Message-ID: <20120512001804.GG14782@lizard>
References: <20120512001506.GA8653@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120512001506.GA8653@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A corresponding function to persistent_ram_new().

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/persistent_ram.c |   15 +++++++++++++++
 drivers/staging/android/persistent_ram.h |    3 +++
 2 files changed, 18 insertions(+)

diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
index c16d7c2..63481da 100644
--- a/drivers/staging/android/persistent_ram.c
+++ b/drivers/staging/android/persistent_ram.c
@@ -364,6 +364,9 @@ static void *persistent_ram_iomap(phys_addr_t start, size_t size)
 static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
 		struct persistent_ram_zone *prz)
 {
+	prz->paddr = start;
+	prz->size = size;
+
 	if (pfn_valid(start >> PAGE_SHIFT))
 		prz->vaddr = persistent_ram_vmap(start, size);
 	else
@@ -437,6 +440,18 @@ static int __init persistent_ram_post_init(struct persistent_ram_zone *prz, bool
 	return 0;
 }
 
+void persistent_ram_free(struct persistent_ram_zone *prz)
+{
+	if (pfn_valid(prz->paddr >> PAGE_SHIFT)) {
+		vunmap(prz->vaddr);
+	} else {
+		iounmap(prz->vaddr);
+		release_mem_region(prz->paddr, prz->size);
+	}
+	persistent_ram_free_old(prz);
+	kfree(prz);
+}
+
 struct persistent_ram_zone * __init persistent_ram_new(phys_addr_t start,
 						       size_t size,
 						       bool ecc)
diff --git a/drivers/staging/android/persistent_ram.h b/drivers/staging/android/persistent_ram.h
index 8154d15..d3b2b45 100644
--- a/drivers/staging/android/persistent_ram.h
+++ b/drivers/staging/android/persistent_ram.h
@@ -39,6 +39,8 @@ struct persistent_ram {
 };
 
 struct persistent_ram_zone {
+	phys_addr_t paddr;
+	size_t size;
 	void *vaddr;
 	struct persistent_ram_buffer *buffer;
 	size_t buffer_size;
@@ -66,6 +68,7 @@ int persistent_ram_early_init(struct persistent_ram *ram);
 struct persistent_ram_zone * __init persistent_ram_new(phys_addr_t start,
 						       size_t size,
 						       bool ecc);
+void persistent_ram_free(struct persistent_ram_zone *prz);
 struct persistent_ram_zone *persistent_ram_init_ringbuffer(struct device *dev,
 		bool ecc);
 
-- 
1.7.9.2

