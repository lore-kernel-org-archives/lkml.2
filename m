Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab2JRQRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:17:55 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:16657 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab2JRQRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:17:54 -0400
X-IronPort-AV: E=Sophos;i="4.80,608,1344211200"; 
   d="scan'208";a="15260215"
Date: Thu, 18 Oct 2012 17:17:28 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
In-Reply-To: <CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1210181444380.2689@kaball.uk.xensource.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com> <CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012, Yinghai Lu wrote:
> On Wed, Oct 10, 2012 at 9:40 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> >
> > So you are missing the Xen patches entirely in this iteration of the
> > series?
> 
> please check updated for-x86-mm branch.
> 
> [PATCH -v4 00/15] x86: Use BRK to pre mapping page table to make xen happy
> 
> on top of current linus/master and tip/x86/mm2, but please zap last
> patch in that branch.
> 
> 1. use brk to mapping first PMD_SIZE range.
> 2. top down to initialize page table range by range.
> 3. get rid of calculate page table, and find_early_page_table.
> 4. remove early_ioremap in page table accessing.
> 
> v2: changes, update xen interface about pagetable_reserve, so not
>    use pgt_buf_* in xen code directly.
> v3: use range top-down to initialize page table, so will not use
>    calculating/find early table anymore.
>    also reorder the patches sequence.
> v4: add mapping_mark_page_ro to fix xen, also move pgt_buf_* to init.c
>     and merge alloc_low_page()
> 
> could be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-mm

I find that patch series are easier to review than having to checkout
your code and read the commit messages. Please post your patch series to
the LKML next time.

In any case, regarding "x86, xen: Add xen_mapping_mark_page_ro": please
take Peter's feedback into account; mark_page_ro is not a good name for
a pvops.
Also I don't believe that this call is actually needed, see below.

Regarding "x86, mm: setup page table in top-down": if you mark the
pagetable page RO in alloc_low_page, won't the entire thing crash as
soon as you try to write to it? You are supposed to mark it RO after
filling up the pagetable page and before hooking it into the live
pagetable.
However contrary to my expectations, I did a quick test and it seems to
be working, that is probably due to a bug: maybe __pa or lookup_address
don't work correctly when called so early?

In any case we don't care about that because if we assume that
alloc_low_pages will always return a page from a range that is already
mapped, then we do not need this pvop anymore. That's because
xen_alloc_pte_init, xen_alloc_pmd_init, etc, will mark the page RO
before hooking it into the pagetable automatically.
Sorry for I misled you last time.

Let me repeat it again:
Can we assume that the page returned by alloc_low_pages is already mapped?

Yes? In that case let's get rid of mark_page_ro and everything should
work.

It is worth stating it in clear letters in a comment on top of
alloc_low_pages:

"This function always returns a page from a memory range already
mapped."
