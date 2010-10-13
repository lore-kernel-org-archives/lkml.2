Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0JMOk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 10:40:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36097 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab0JMOk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 10:40:58 -0400
Date: Wed, 13 Oct 2010 15:40:44 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pacman@kosh.dhis.org, linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
Message-ID: <20101013144044.GS30667@csn.ul.ie>
References: <20101009095718.1775.qmail@kosh.dhis.org> <20101011143022.GD30667@csn.ul.ie> <20101011140039.15a2c78d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101011140039.15a2c78d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 02:00:39PM -0700, Andrew Morton wrote:
> (cc linuxppc-dev@lists.ozlabs.org)
> 
> On Mon, 11 Oct 2010 15:30:22 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > On Sat, Oct 09, 2010 at 04:57:18AM -0500, pacman@kosh.dhis.org wrote:
> > > (What a big Cc: list... scripts/get_maintainer.pl made me do it.)
> > > 
> > > This will be a long story with a weak conclusion, sorry about that, but it's
> > > been a long bug-hunt.
> > > 
> > > With recent kernels I've seen a bug that appears to corrupt random 4-byte
> > > chunks of memory. It's not easy to reproduce. It seems to happen only once
> > > per boot, pretty quickly after userspace has gotten started, and sometimes it
> > > doesn't happen at all.
> > > 
> > 
> > A corruption of 4 bytes could be consistent with a pointer value being
> > written to an incorrect location.
> 
> It's corruption of user memory, which is unusual.  I'd be wondering if
> there was a pre-existing bug which 6dda9d55bf545013597 has exposed -
> previously the corruption was hitting something harmless.  Something
> like a missed CPU cache writeback or invalidate operation.
> 

This seems somewhat plausible although it's hard to tell for sure. But
lets say we had the following situation in memory

[<----MAX_ORDER_NR_PAGES---->][<----MAX_ORDER_NR_PAGES---->]
INITRD                        memmap array

initrd gets freed and someone else very early in boot gets allocated in
there. Lets further guess that the struct pages in the memmap area are
managing the page frame where the INITRD was because it makes the situation
slightly easier to trigger. As pages get freed in the memmap array, we could
reference memory where initrd used to be but the physical memory is mapped
at two virtual addresses.

CPU A							CPU B
							Reads kernelspace virtual (gets cache line)
Writes userspace virtual (gets different cache line)
							IO, writes buffer destined for userspace (via cache line)
Cache line eviction, writeback to memory

This is somewhat contrived but I can see how it might happen even on one
CPU particularly if the L1 cache is virtual and is loose about checking
physical tags.

> How sensitive/vulnerable is PPC32 to such things?
> 

I can not tell you specifically but if the above scenario is in any way
plausible, I believe it would depend on what sort of L1 cache the CPU
has. Maybe this particular version has a virtual cache with no physical
tagging and is depending on the OS not to make virtual aliasing mistakes.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
