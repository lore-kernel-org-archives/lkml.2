Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2JJR0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:26:21 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:62419 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2JJR0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:26:20 -0400
X-IronPort-AV: E=Sophos;i="4.80,565,1344211200"; 
   d="scan'208";a="15081739"
Date: Wed, 10 Oct 2012 18:26:02 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] x86, mm: setup page table from top-down
In-Reply-To: <CAE9FiQVuU=KfMM0Q16Lddz8ZL_wzg5PLkWWK=6navQdC_j0KbA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1210101821540.2689@kaball.uk.xensource.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org> <1349827115-16600-7-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210101733220.2689@kaball.uk.xensource.com> <CAE9FiQVuU=KfMM0Q16Lddz8ZL_wzg5PLkWWK=6navQdC_j0KbA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Yinghai Lu wrote:
> On Wed, Oct 10, 2012 at 9:38 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> >> -     if (pfn >= pgt_buf_top)
> >> -             panic("alloc_low_page: ran out of memory");
> >> +     if ((pgt_buf_end + 1) >= pgt_buf_top) {
> >> +             unsigned long ret;
> >> +             if (min_pfn_mapped >= max_pfn_mapped)
> >> +                     panic("alloc_low_page: ran out of memory");
> >> +             ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
> >> +                                     max_pfn_mapped << PAGE_SHIFT,
> >> +                                     PAGE_SIZE, PAGE_SIZE);
> >> +             if (!ret)
> >> +                     panic("alloc_low_page: can not alloc memory");
> >> +             memblock_reserve(ret, PAGE_SIZE);
> >> +             pfn = ret >> PAGE_SHIFT;
> >
> > This cannot be right: you are allocating another page to be used as
> > pagetable page, outside the range pgt_buf_start-pgt_buf_top.
> >
> > When that page is going to be hooked into the live pagetable, the kernel
> > is going to panic on Xen because the page wasn't marked RO.
> >
> > If you want to do that you need to tell the Xen subsystem of the new
> > page. pagetable_reserve is not the right call, we need a new one (see
> > past emails).
> 
> ok, will change that interface and call in from alloc_low_page.
> 
> how about the pages from BRK, do we need to call xen hooks to mark it as RO?
> 

It doesn't matter whether they come from BRK or other memory: Xen
assumes that all the pagetable pages come from
pgt_buf_start-pgt_buf_top, so if you are going to use another range you
need to tell Xen about it.

Alternatively, you can follow Peter's suggestion and replace the current
hooks with a new one with a more precise and well defined semantic.
Something along the lines of "this pagetable page is about to be hooked
into the live pagetable". Xen would use the hook to mark it RO.
