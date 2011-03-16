Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1CPM2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 08:28:38 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:6663 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1CPM2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 08:28:34 -0400
X-IronPort-AV: E=Sophos;i="4.63,193,1299456000"; 
   d="scan'208";a="4817265"
Date: Wed, 16 Mar 2011 12:28:03 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Yinghai Lu <yinghai@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL tip/x86/mm] xen/x86 fixes
In-Reply-To: <20110311222129.GA3168@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1103161150010.3382@kaball-desktop>
References: <alpine.DEB.2.00.1103111201470.2968@kaball-desktop> <20110311222129.GA3168@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Konrad Rzeszutek Wilk wrote:
> On Fri, Mar 11, 2011 at 01:17:23PM +0000, Stefano Stabellini wrote:
> > Hello,
> > recently we had a couple of long discussions with Yinghai about boot
> > crashes on xen, related to pagetable initialization.
> > As a result we came up with three patches, two of them fix the first [1]
> > boot crash and provide a nice cleanup on native:
> 
> I don't know why this is happening now, but it could be very well
> related to the build config. Smaller builds don't seem to encounter this, while
> this is a distro type build. If I use:
> 
> > Stefano Stabellini (1):
> >       xen: set max_pfn_mapped to the last pfn mapped
> 
> it hangs during bootup. The machine hangs during the box (no keyboard interaction)
> and I can see this in the bootup.

Konrad sent me few other logs offline: log1 is the log of the hang and
log2 is a successful boot (reverting the problematic patch).
It looks like the SP5100 TCO WatchDog Timer Driver is using ioremap on
an address (0xb8fe00) that belongs to the memory range used for the
pagetable (0x9fc000-0xf43fff).
In the succesful case max_pfn_mapped is higher so the pagetable is
located at an higher address (0x16dfb000-0x17342fff) so the problem
doesn't occur.

I still have few unaswered questions on this issue: if we assume that
the ioremap address is the same in the two cases (0xb8fe00), how is it
possible that in the first case it is ram (page_is_ram returns true)
while in the second case it is not (otherwise we would still get a
warning from ioremap): page_is_ram shouldn't be affected by the position
of the kernel pagetable, and the e820 is still the same.
In any case if 0xb8fe00 is really an MMIO address memblock_find_in_range
shouldn't have returned the range (0x9fc000-0xf43fff) in
find_early_table_space.
I think that lowering the value of max_pfn_mapped is likely to cause
bugs like this one, where a low memory range is not properly marked as
reserved and gets mistakenly used for the pagetable.

Considering that meanwhile Linux 2.6.38 was released with this bug, I
think is better if we change approach and fix the regression in a more
straightforward way, like for example: 

- 2M align _end;
- do not clean initial mapping between _brk_end to _end;
- resurrect the patch "respect memblock reserved regions when
destroying mappings", trying to minimize the number of memblock reserved
checks.

Opinions?



Regarding the other commit "x86-64, mm: Put early page table high" that
causes a reliable crash on Xen: I noticed that Ingo sent a pull request
to Linus with this commit included.
At this point I can send the patch to fix the Xen issue to Linus
directly, no need to rebased the patch on tip?
