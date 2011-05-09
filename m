Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1EIMY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 08:24:57 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:41514 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1EIMY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 08:24:56 -0400
Date: Mon, 9 May 2011 14:24:41 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Jan Beulich <JBeulich@novell.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 2/8] arch/x86/xen/irq: Cleanup code/data sections definitions
Message-ID: <20110509122441.GB17552@router-fw-old.local.net-space.pl>
References: <20110504181607.GC29218@router-fw-old.local.net-space.pl> <4DC26E82020000780003FC51@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC26E82020000780003FC51@vpn.id2.novell.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 08:31:46AM +0100, Jan Beulich wrote:
> >>> On 04.05.11 at 20:16, Daniel Kiper <dkiper@net-space.pl> wrote:
> > Cleanup code/data sections definitions
> > accordingly to include/linux/init.h.
>
> I'm not clear what the motivation for this patch series is in the first
> place, but I'm particularly unhappy with following inconsistent

The main reason was introduction of git commit a38647837a411f7df79623128421eef2118b5884
(xen/mmu: Add workaround "x86-64, mm: Put early page table high") which
revealed section conflict in arch/x86/xen/mmu.c. Section for
static const struct pv_mmu_ops xen_mmu_ops was set incorrectly to
__initdata. When

static __initdata u64 __last_pgt_set_rw = 0;

was added then it conflicted with xen_mmu_ops definition.
After some investigation I found that Xen kernel code contains
more those type of sections mismatches (const data moved to
__initdata) and inconsistency with include/linux/init.h.
That is why I thought it is worth to clean up that problems.

It should be mentioned that git commit a38647837a411f7df79623128421eef2118b5884
will be removed from next rc, however, it does not invalidate my cleanup
patches.

> guidelines: The placement suggestion for function and data
> definitions are not in sync - the annotation is said to go between
> type and name for functions, but after the name for data, yet
> there's no reason known to me why the rule for data can't be the
> same as that for functions (the other way around doesn't work,
> as gcc's documentation says that for function definitions (other
> than for their declarations) attributes cannot currently follow the
> declarator.
>
> So I'd rather think the guidelines should first be made consistent
> (or it should be explained why they must be different), and then
> the users of those annotations should get updated.

I looked for any explanation, however, I did not find anything strong.
Probably it was done to be in sync with GCC documentation (despite that
__attribute__ in variable definition could be used virtually anywhere).
Please look into:

http://gcc.gnu.org/onlinedocs/gcc-2.95.3/gcc_4.html#SEC90
http://gcc.gnu.org/onlinedocs/gcc-3.3.1/gcc/Variable-Attributes.html
http://gcc.gnu.org/onlinedocs/gcc/Variable-Attributes.html

Daniel
