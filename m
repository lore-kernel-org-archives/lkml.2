Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab2LFWkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 17:40:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2LFWkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 17:40:10 -0500
Date: Thu, 6 Dec 2012 14:40:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Tony Luck <tony.luck@intel.com>, Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] HWPOISON, hugetlbfs: fix RSS-counter warning
Message-Id: <20121206144008.9b376ec7.akpm@linux-foundation.org>
In-Reply-To: <1354745673-31035-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <3908561D78D1C84285E8C5FCA982C28F1C963B15@ORSMSX108.amr.corp.intel.com>
	<1354745673-31035-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Dec 2012 17:14:33 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Hi Tony,
> 
> On Wed, Dec 05, 2012 at 10:04:50PM +0000, Luck, Tony wrote:
> > 	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
> > -		if (PageAnon(page))
> > +		if (PageHuge(page))
> > +			;
> > +		else if (PageAnon(page))
> >  			dec_mm_counter(mm, MM_ANONPAGES);
> >  		else
> >  			dec_mm_counter(mm, MM_FILEPAGES);
> > 
> > This style minimizes the "diff" ... but wouldn't it be nicer to say:
> > 
> > 		if (!PageHuge(page)) {
> > 			old code in here
> > 		}
> > 
> 
> I think this need more lines in diff because old code should be
> indented without any logical change.

I do agree with Tony on this.  While it is nice to keep the diff
looking simple, it is more important that the resulting code be clean
and idiomatic.

--- a/mm/rmap.c~hwpoison-hugetlbfs-fix-rss-counter-warning-fix
+++ a/mm/rmap.c
@@ -1249,14 +1249,14 @@ int try_to_unmap_one(struct page *page, 
 	update_hiwater_rss(mm);
 
 	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
-		if (PageHuge(page))
-			;
-		else if (PageAnon(page))
-			dec_mm_counter(mm, MM_ANONPAGES);
-		else
-			dec_mm_counter(mm, MM_FILEPAGES);
-		set_pte_at(mm, address, pte,
-				swp_entry_to_pte(make_hwpoison_entry(page)));
+		if (!PageHuge(page)) {
+			if (PageAnon(page))
+				dec_mm_counter(mm, MM_ANONPAGES);
+			else
+				dec_mm_counter(mm, MM_FILEPAGES);
+			set_pte_at(mm, address, pte,
+				   swp_entry_to_pte(make_hwpoison_entry(page)));
+		}
 	} else if (PageAnon(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 
_

