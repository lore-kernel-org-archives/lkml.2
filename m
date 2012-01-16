Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab2APRUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 12:20:11 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58229 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab2APRUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 12:20:07 -0500
Message-ID: <4F145BE7.1060802@ah.jp.nec.com>
Date: Mon, 16 Jan 2012 12:18:31 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Organization: NEC Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] pagemap: avoid splitting thp when reading /proc/pid/pagemap
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 06:00:26PM +0100, Andrea Arcangeli wrote:
> On Thu, Jan 12, 2012 at 02:34:53PM -0500, Naoya Horiguchi wrote:
> > +		if (pmd_trans_splitting(*pmd)) {
> > +			spin_unlock(&walk->mm->page_table_lock);
> > +			wait_split_huge_page(vma->anon_vma, pmd);
> > +		} else {
> > +			for (; addr != end; addr += PAGE_SIZE) {
> > +				unsigned long offset = (addr & ~PAGEMAP_WALK_MASK)
> > +					>> PAGE_SHIFT;
> > +				pfn = thp_pte_to_pagemap_entry(*(pte_t *)pmd,
> > +							       offset);
> 
> What is this that then morphs into a pme (which still has a cast
> inside its creation)? thp_pte_to_pagemap_entry don't seem to be passed
> ptes too. The only case where it is valid to do a cast like that is
> when a function is used by both ptes sand pmds and the code tends to
> work for both with minimal modification to differentiate the two
> cases. Considering the function that gets the cast is called thp_ this
> is hardly the case here.

Agreed.

> Why don't you pass the pmd and then do "if (pmd_present(pmd))
> page_to_pfn(pmd_page(pmd)) ? What's the argument for the cast. I'm
> just reviewing this series and maybe it was covered in previous
> versions.

OK, I can do this by introducing pmd_pte as you commented in another email.

> I don't get this pme thing for something as trivial as above that
> shouldn't require any cast at all.
