Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2CAWBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:01:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915Ab2CAWBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:01:51 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] memcg: avoid THP split in task migration
Date: Thu,  1 Mar 2012 17:01:38 -0500
Message-Id: <1330639298-10342-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1330633336-10707-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 03:22:16PM -0500, Naoya Horiguchi wrote:
> > > @@ -5219,7 +5255,13 @@ static int mem_cgroup_count_precharge_pte_range(pmd_t *pmd,
> > >  	pte_t *pte;
> > >  	spinlock_t *ptl;
> > >
> > > -	split_huge_page_pmd(walk->mm, pmd);
> > > +	if (pmd_trans_huge_lock(pmd, vma) == 1) {
> > > +		if (is_target_huge_pmd_for_mc(vma, addr, *pmd, NULL))
> > > +			mc.precharge += HPAGE_PMD_NR;
> >
> > Your use of HPAGE_PMD_NR looks fine, that path will be eliminated at
> > build time if THP is off. This is the nice way to write code that is
> > already optimal for THP=off without making special cases or #ifdefs.
> >
> > Other review suggests changing HPAGE_PMD_NR as BUILD_BUG, that sounds
> > good idea too, but in this (correct) usage of HPAGE_PMD_NR it wouldn't
> > make a difference because of the whole branch is correctly eliminated
> > at build time. In short changing it to BUILD_BUG will simply make sure
> > the whole pmd_trans_huge_lock == 1 branch is eliminated at build
> > time. It looks good change too but it's orthogonal so I'd leave it for
> > a separate patch.
> 
> In my trial, without changing HPAGE_PMD_NR as BUILD_BUG a build did not
> pass with !CONFIG_TRANSPARENT_HUGEPAGE as Hillf said.
> Evaluating HPAGE_PMD_NR seems to be prior to eliminating whole
> pmd_trans_huge_lock == 1 branch, so I think this change is necessary.

I said the wrong thing.
The error I experienced was just "HPAGE_PMD_NR is undefined."
This is not related to changeing BUG() to BUILD_BUG() in already defined
HPAGE_PMD_(SHIFT|MASK|SIZE).
And using BUILD_BUG() to confirm elimination is good for me. 

Sorry for confusion.
Naoya
