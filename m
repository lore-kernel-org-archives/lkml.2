Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab2EKJG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:06:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46382 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2EKJGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:06:25 -0400
Message-ID: <1336726989.2527.143.camel@twins>
Subject: Re: [PATCH v4 4/7] x86/tlb: fall back to flush all when meet a THP
 large page
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alex Shi <alex.shi@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org,
        fweisbec@gmail.com, jeremy@goop.org, gregkh@linuxfoundation.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>
Date: Fri, 11 May 2012 11:03:09 +0200
In-Reply-To: <4FAC60F7.4010704@intel.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
	 <1336626013-28413-5-git-send-email-alex.shi@intel.com>
	 <1336642145.2527.79.camel@twins>
	 <20120510104058.GA31257@aftab.osrc.amd.com> <4FAC60F7.4010704@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 08:44 +0800, Alex Shi wrote:
> On 05/10/2012 06:40 PM, Borislav Petkov wrote:
> 
> > On Thu, May 10, 2012 at 11:29:05AM +0200, Peter Zijlstra wrote:
> >> On Thu, 2012-05-10 at 13:00 +0800, Alex Shi wrote:
> >>> We don't need to flush large pages by PAGE_SIZE step, that just waste
> >>> time. and actually, large page don't need 'invlpg' optimizing according
> >>> to our macro benchmark. So, just flush whole TLB is enough for them.
> >>>
> >>> The following result is tested on a 2CPU * 4cores * 2HT NHM EP machine,
> >>> with THP 'always' setting.
> >>
> >> What does it do when you disable THP? That has_large_page() thing is a
> >> massive amount of pointer chasing..
> > 
> > Yeah, this looks like a bit of a overhead. Don't we have some per-mm
> > accounting of whether that mm struct has hugepages in mm/huge_memory.c,
> > i.e. something like what collapse_huge_page() does, for example, at the
> > end by incrementing khugepaged_pages_collapsed but in a per-mm variable?
> > 
> > And make this part of the THP code so we get it for free here.
> > 
> > Is Andrea on the CC list... hm, no, CCed.
> 
> 
> Andrea has said there is no easy way to know if there is a large page in
> mm or vma.
> 
> Actually, has_large_page just called only once, that due to the
> act_entries limit. But your opinion is worth to consider, the only one
> calling can be avoid if the 'start' address is not align on HPAGE_SIZE.

One possibility is to extend vm_flags and add have THP set a new flag
whenever it installs a new page. Then have mmu_gather collect this
vm_flag just like it collects VM_EXEC and VM_HUGETLB.
