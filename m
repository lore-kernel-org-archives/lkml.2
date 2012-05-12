Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523Ab2ELATS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:19:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42602 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761481Ab2ELATL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:19:11 -0400
Date: Fri, 11 May 2012 17:17:43 -0700
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
Subject: [PATCH 05/11] persistent_ram: Introduce persistent_ram_vmap()
Message-ID: <20120512001743.GE14782@lizard>
References: <20120512001506.GA8653@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120512001506.GA8653@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out vmap logic out of persistent_ram_buffer_map(), this will
make the code a bit more understandable when we'll add support for
non-bootmem memory.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/persistent_ram.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
index c0c3d32..ab8bff1 100644
--- a/drivers/staging/android/persistent_ram.c
+++ b/drivers/staging/android/persistent_ram.c
@@ -318,14 +318,14 @@ void persistent_ram_free_old(struct persistent_ram_zone *prz)
 	prz->old_log_size = 0;
 }
 
-static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
-		struct persistent_ram_zone *prz)
+static void *persistent_ram_vmap(phys_addr_t start, size_t size)
 {
 	struct page **pages;
 	phys_addr_t page_start;
 	unsigned int page_count;
 	pgprot_t prot;
 	unsigned int i;
+	void *vaddr;
 
 	page_start = start - offset_in_page(start);
 	page_count = DIV_ROUND_UP(size + offset_in_page(start), PAGE_SIZE);
@@ -336,17 +336,26 @@ static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
 	if (!pages) {
 		pr_err("%s: Failed to allocate array for %u pages\n", __func__,
 			page_count);
-		return -ENOMEM;
+		return NULL;
 	}
 
 	for (i = 0; i < page_count; i++) {
 		phys_addr_t addr = page_start + i * PAGE_SIZE;
 		pages[i] = pfn_to_page(addr >> PAGE_SHIFT);
 	}
-	prz->vaddr = vmap(pages, page_count, VM_MAP, prot);
+	vaddr = vmap(pages, page_count, VM_MAP, prot);
 	kfree(pages);
+
+	return vaddr;
+}
+
+static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
+		struct persistent_ram_zone *prz)
+{
+	prz->vaddr = persistent_ram_vmap(start, size);
 	if (!prz->vaddr) {
-		pr_err("%s: Failed to map %u pages\n", __func__, page_count);
+		pr_err("%s: Failed to map 0x%llx pages at 0x%llx\n", __func__,
+			(unsigned long long)size, (unsigned long long)start);
 		return -ENOMEM;
 	}
 
-- 
1.7.9.2

