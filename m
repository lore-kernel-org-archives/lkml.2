Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1DRPCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:02:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57552 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1DRPCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:02:24 -0400
Subject: Re: [RFC][PATCH 2/3] track numbers of pagetable pages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110416104456.3915b7de@mfleming-mobl1.ger.corp.intel.com>
References: <20110415173821.62660715@kernel>
	 <20110415173823.EA7A7473@kernel>
	 <20110416104456.3915b7de@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 18 Apr 2011 08:02:04 -0700
Message-ID: <1303138924.9615.2487.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-16 at 10:44 +0100, Matt Fleming wrote:
> >  static inline void pgtable_page_dtor(struct mm_struct *mm, struct page *page)
> >  {
> >  	pte_lock_deinit(page);
> > +	dec_mm_counter(mm, MM_PTEPAGES);
> >  	dec_zone_page_state(page, NR_PAGETABLE);
> >  }
> 
> I'm probably missing something really obvious but...
> 
> Is this safe in the non-USE_SPLIT_PTLOCKS case? If we're not using
> split-ptlocks then inc/dec_mm_counter() are only safe when done under
> mm->page_table_lock, right? But it looks to me like we can end up doing,
> 
>   __pte_alloc()
>       pte_alloc_one()
>           pgtable_page_ctor()
> 
> before acquiring mm->page_table_lock in __pte_alloc().

No, it's probably not safe.  We'll have to come up with something a bit
different in that case.  Either that, or just kill the non-atomic case.
Surely there's some percpu magic counter somewhere in the kernel that is
optimized for fast (unlocked?) updates and rare, slow reads.

-- Dave

