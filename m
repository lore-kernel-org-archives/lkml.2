Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab2KVV5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:57:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:49649 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab2KVSkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Zhao Yakui <yakui.zhao@intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 47/83] ttm: Clear the ttm page allocated from high memory zone correctly
Date: Wed, 21 Nov 2012 16:42:09 -0800
Message-Id: <20121122004217.783198356@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -749,7 +749,10 @@ static int ttm_get_pages(struct page **p
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
 


