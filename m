Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab2JJXI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:08:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34378 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758096Ab2JJXDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:03:06 -0400
X-Sasl-enc: iN/1DK1U2GG/oFm3yfyAZIFBixnfAFkZIOeSxR/WwplF 1349910185
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 059/122] kpageflags: fix wrong KPF_THP on non-huge compound pages
Date: Thu, 11 Oct 2012 07:53:45 +0900
Message-Id: <20121010225348.711511315@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

commit 7a71932d5676b7410ab64d149bad8bde6b0d8632 upstream.

KPF_THP can be set on non-huge compound pages (like slab pages or pages
allocated by drivers with __GFP_COMP) because PageTransCompound only
checks PG_head and PG_tail.  Obviously this is a bug and breaks user space
applications which look for thp via /proc/kpageflags.

This patch rules out setting KPF_THP wrongly by additionally checking
PageLRU on the head pages.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/page.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -115,7 +115,13 @@ u64 stable_page_flags(struct page *page)
 		u |= 1 << KPF_COMPOUND_TAIL;
 	if (PageHuge(page))
 		u |= 1 << KPF_HUGE;
-	else if (PageTransCompound(page))
+	/*
+	 * PageTransCompound can be true for non-huge compound pages (slab
+	 * pages or pages allocated by drivers with __GFP_COMP) because it
+	 * just checks PG_head/PG_tail, so we need to check PageLRU to make
+	 * sure a given page is a thp, not a non-huge compound page.
+	 */
+	else if (PageTransCompound(page) && PageLRU(compound_trans_head(page)))
 		u |= 1 << KPF_THP;
 
 	/*


