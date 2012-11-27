Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2K0Vj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 16:39:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab2K0Vj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 16:39:56 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm, soft offline: split thp at the beginning of soft_offline_page()
Date: Tue, 27 Nov 2012 16:39:41 -0500
Message-Id: <1354052381-28687-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <m2k3t6hhyh.fsf@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 01:08:38PM -0800, Andi Kleen wrote:
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
> 
> > When we try to soft-offline a thp tail page, put_page() is called on the
> > tail page unthinkingly and VM_BUG_ON is triggered in put_compound_page().
> > This patch splits thp before going into the main body of soft-offlining.
> 
> Looks good.
> 
> >
> > The interface of soft-offlining is open for userspace, so this bug can
> > lead to DoS attack and should be fixed immedately.
> 
> The interface is root only and root can do everything anyways, so it's
> not really a security issue.

OK, this description had better not be here. I replace with attached one.

(.. and I forgot to disable suppress-cc for stable@vger.kernel.org in
the initial post so did it now, sorry.)

---
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Date: Tue, 27 Nov 2012 15:38:23 -0500
Subject: [PATCH] mm, soft offline: split thp at the beginning of
 soft_offline_page()

When we try to soft-offline a thp tail page, put_page() is called on the
tail page unthinkingly and VM_BUG_ON is triggered in put_compound_page().
This patch splits thp before going into the main body of soft-offlining.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: stable@vger.kernel.org
---
 mm/memory-failure.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 8fe3640..e48e235 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1548,9 +1548,17 @@ int soft_offline_page(struct page *page, int flags)
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
-- 
1.7.11.7

