Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2LCO5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:57:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43567 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932105Ab2LCOfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:47 -0500
Message-Id: <20121203143149.168857201@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:01 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zhao Yakui <yakui.zhao@intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 15/89] ttm: Clear the ttm page allocated from high memory zone correctly
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -708,7 +708,10 @@ int ttm_get_pages(struct list_head *page
 	/* clear the pages coming from the pool if requested */
 	if (flags & TTM_PAGE_FLAG_ZERO_ALLOC) {
 		list_for_each_entry(p, pages, lru) {
-			clear_page(page_address(p));
+			if (PageHighMem(p))
+				clear_highpage(p);
+			else
+				clear_page(page_address(p));
 		}
 	}
 


