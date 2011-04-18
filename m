Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab1DRRUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:20:45 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:45475 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab1DRRUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:20:41 -0400
X-IronPort-AV: E=Sophos;i="4.64,233,1301875200"; 
   d="scan'208";a="5360388"
Date: Mon, 18 Apr 2011 18:21:05 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 2/4] x86,xen: introduce
 x86_init.mapping.pagetable_reserve
In-Reply-To: <4DAC4DEF.3090200@zytor.com>
Message-ID: <alpine.DEB.2.00.1104181817520.10886@kaball-desktop>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com> <4DA5EAE4.2060406@linux.intel.com> <alpine.DEB.2.00.1104141218110.22672@kaball-desktop> <4DA70A4A.4030805@zytor.com>
 <alpine.DEB.2.00.1104141746430.10886@kaball-desktop> <alpine.DEB.2.00.1104181507180.10886@kaball-desktop> <4DAC4DEF.3090200@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011, H. Peter Anvin wrote:
> On 04/18/2011 07:09 AM, Stefano Stabellini wrote:
> > 
> > Sorry, I don't mean to be pushy, it is just that I'll be AFK for 12 days
> > starting from next Friday and I think that this issue should really be
> > fixed in time for the 2.6.39 release, otherwise no 2.6.39 kernels will
> > be able to boot on any xen system.
> 
> YOU STILL HAVEN'T PROPOSED ANY SEMANTICS.
> 
> The semantics of a hook is a description of what the preconditions are,
> what the postconditions are, and what exactly they are allowed or not
> allowed to do.
> 
> This is a real pain to do, *exactly because hooks are a real pain*.
> Most hooks that have been put in has been "oh, just do something at
> point X in the code", which is a case of definition by implementation,
> which is exactly how we ended up with the current mess.
> 


x86_init.mapping.pagetable_setup_start(start, max_end)

    Notifies the subarch that the kernel early startup intends to
    use pages as page table pages.
    These pages will have physical addresses in the range
    start..max_end.

    Can be called multiple times to setup kernel page table pages,
    always in a pair with x86_init.mapping.pagetable_setup_done.
    It must be called before x86_init.paging.pagetable_setup_start().

    Preconditions: no kernel code after the 32-bit kernel entry point
    has hooked any new page table pages into the active page table
    except between a pair of
    x86_init.mapping.pagetable_setup_start and
    x86_init.mapping.pagetable_setup_done.

    Postcondition: pages in the range start..max_end may be used as
    page table pages and hooked into active page tables.
    Pages in this range may NOT be used for any other purpose.


x86_init.mapping.pagetable_setup_done(real_end)

    Notifies the subarch that the initial memory mapping is complete,
    and of the actual range of pages used.

    Preconditions:

    x86_init.mapping.pagetable_setup_start was previously called; the
    arguments to the calls must satisfy start <= real_end <= max_end

    The pages in the range start..real_end have been hooked into the
    active page table.
    The pages in the range real_end..max_end are not currently in use.

    Postconditions:

    Pages in the range real_end..max_end may be used as normal
    memory.

    Pages in the range start..real_end might be hooked into the active
    page table and cannot be used for other purposes.

    New page table pages must be allocated using
    pv_mmu_ops.alloc_pte/pmd/pud.
