Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423520Ab2LGA7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:59:45 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46480 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423502Ab2LGA7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:59:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 08/27] mm: soft offline: split thp at the beginning of soft_offline_page()
Date: Thu,  6 Dec 2012 16:58:52 -0800
Message-Id: <20121207005827.935818988@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

commit 783657a7dc20e5c0efbc9a09a9dd38e238a723da upstream.

When we try to soft-offline a thp tail page, put_page() is called on the
tail page unthinkingly and VM_BUG_ON is triggered in put_compound_page().

This patch splits thp before going into the main body of soft-offlining.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory-failure.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1474,9 +1474,17 @@ int soft_offline_page(struct page *page,
 {
 	int ret;
 	unsigned long pfn = page_to_pfn(page);
+	struct page *hpage = compound_trans_head(page);
 
 	if (PageHuge(page))
 		return soft_offline_huge_page(page, flags);
+	if (PageTransHuge(hpage)) {
+		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
+			pr_info("soft offline: %#lx: failed to split THP\n",
+				pfn);
+			return -EBUSY;
+		}
+	}
 
 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)


