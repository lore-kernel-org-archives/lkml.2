Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2LMOGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:06:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44424 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab2LMOGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhao Yakui <yakui.zhao@intel.com>, Dave Airlie <airlied@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 097/241] ttm: Clear the ttm page allocated from high memory zone correctly
Date: Thu, 13 Dec 2012 11:57:42 -0200
Message-Id: <1355407206-17100-98-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit ac207ed2471150e06af0afc76e4becc701fa2733 upstream.

The TTM page can be allocated from high memory. In such case it is
wrong to use the page_address(page) as the virtual address for the high memory
page.

bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=50241

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index ebc6fac..578207e 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -749,7 +749,10 @@ static int ttm_get_pages(struct page **pages, unsigned npages, int flags,
 	/* clear the pages coming from the pool if requested */
 	if (flags & TTM_PAGE_FLAG_ZERO_ALLOC) {
 		list_for_each_entry(p, &plist, lru) {
-			clear_page(page_address(p));
+			if (PageHighMem(p))
+				clear_highpage(p);
+			else
+				clear_page(page_address(p));
 		}
 	}
 
-- 
1.7.9.5

