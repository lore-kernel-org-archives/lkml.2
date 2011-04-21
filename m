Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1DUUFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:05:25 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37532 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751499Ab1DUUFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:05:20 -0400
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
        Tejun Heo <tj@kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <alpine.DEB.2.00.1104211328000.5741@router.home>
References: <1303337718.2587.51.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104201530430.13948@chino.kir.corp.google.com>
	 <20110421221712.9184.A69D9226@jp.fujitsu.com>
	 <1303403847.4025.11.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104211328000.5741@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 15:05:15 -0500
Message-ID: <1303416315.4025.36.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 13:33 -0500, Christoph Lameter wrote:
> On Thu, 21 Apr 2011, James Bottomley wrote:
> 
> > On Thu, 2011-04-21 at 22:16 +0900, KOSAKI Motohiro wrote:
> > > > This should fix the remaining architectures so they can use CONFIG_SLUB,
> > > > but I hope it can be tested by the individual arch maintainers like you
> > > > did for parisc.
> > >
> > > ia64 and mips have CONFIG_ARCH_POPULATES_NODE_MAP and it initialize
> > > N_NORMAL_MEMORY automatically if my understand is correct.
> > > (plz see free_area_init_nodes)
> > >
> > > I guess alpha and m32r have no active developrs. only m68k seems to be need
> > > fix and we have a chance to get a review...
> >
> > Actually, it's not quite a fix yet, I'm afraid.  I've just been
> > investigating why my main 4 way box got slower with kernel builds:
> > Apparently userspace processes are now all stuck on CPU0, so we're
> > obviously tripping over some NUMA scheduling stuff that's missing.
> 
> The simplest solution may be to move these arches to use SPARSE instead.
> AFAICT this was relatively easy for the arm guys.
> 
> Here is short guide on how to do that from the mips people:
> 
> http://www.linux-mips.org/archives/linux-mips/2008-08/msg00154.html
> 
> http://mytechkorner.blogspot.com/2010/12/sparsemem.html
> 
> Dave Hansen, Mel: Can you provide us with some help? (Its Easter and so
> the europeans may be off for awhile)

It sort of depends on your definition of easy.  The problem going from
DISCONTIGMEM to SPARSEMEM is sorting out the section size (the minimum
indivisible size for a sectional_mem_map array) and also deciding on
whether you need SPARSEMEM_EXTREME (discontigmem allows arbitrarily
different sizes for each contiguous region) or
ARCH_HAS_HOLES_MEMORYMODEL (allows empty mem_map regions as well).  I
suspect most architectures will want SPARSEMEM_EXTREME (it means that
the section array isn't fully populated) because the gaps can be huge
(we've got a 64GB gap on parisc).

However, even though I think we can do this going forwards ... I don't
think we can backport it as a bug fix for the slub panic.

James


