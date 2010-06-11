Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915Ab0FKJWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 05:22:00 -0400
Received: from sh.osrg.net ([192.16.179.4]:47292 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757858Ab0FKJV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 05:21:56 -0400
Date: Fri, 11 Jun 2010 18:16:47 +0900
To: npiggin@suse.de
Cc: hancockrwd@gmail.com, catalin.marinas@arm.com, tj@kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       colin.tuckley@arm.com, jeff@garzik.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] sata_sil24: Use memory barriers before issuing
 commands
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100611013829.GB16436@laptop>
References: <1276187002.24535.88.camel@e102109-lin.cambridge.arm.com>
	<4C118697.9090305@gmail.com>
	<20100611013829.GB16436@laptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100611181546G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 11 Jun 2010 18:16:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 11:38:29 +1000
Nick Piggin <npiggin@suse.de> wrote:

> On Thu, Jun 10, 2010 at 06:43:03PM -0600, Robert Hancock wrote:
> > On 06/10/2010 10:23 AM, Catalin Marinas wrote:
> > >On Thu, 2010-06-10 at 17:12 +0100, Tejun Heo wrote:
> > >>On 06/10/2010 06:02 PM, Catalin Marinas wrote:
> > >>>The data in the cmd_block buffers may reach the main memory after the
> > >>>writel() to the device ports. This patch introduces two calls to wmb()
> > >>>to ensure the relative ordering.
> > >>>
> > >>>Signed-off-by: Catalin Marinas<catalin.marinas@arm.com>
> > >>>Tested-by: Colin Tuckley<colin.tuckley@arm.com>
> > >>>Cc: Tejun Heo<tj@kernel.org>
> > >>>Cc: Jeff Garzik<jeff@garzik.org>
> > >>
> > >>I suppose you have tested and verified that this is actually
> > >>necessary, right?
> > >
> > >Yes, otherwise we get random failures with this device on ARM.
> > >
> > >>I've been looking through the docs but couldn't
> > >>find anything which described the ordering between writes to main
> > >>memory and write[bwl]()'s.  One thing that kind of bothers me is that
> > >>r/wmb()'s are for ordering memory accesses among CPUs which
> > >>participate in cache coherency protocol and although it may work right
> > >>in the above case I'm not really sure whether this is the right thing
> > >>to do.  Do you have more information on the subject?
> > >
> > >The mb() are not for ordering accesses among CPUs (though they would
> > >cover this case as well). For inter-CPU ordering, we have smp_mb() and
> > >friends. For all other cases, we have the mandatory barriers mb() and
> > >friends and DMA is one of them.
> > >
> > >Apart from the memory-barriers.txt document, there is the Device I/O
> > >docbook which mentions something about DMA buffers, though not very
> > >clear on which barriers to use (something like just make sure that the
> > >writes to the buffer reached the memory).
> > >
> > >There were some past discussions on linux-arch before and I'm cc'ing
> > >this list again (ARM is not the only architecture with a weakly memory
> > >ordering model).
> > >
> > >I'm copying the patch below again for the linux-arch people that haven't
> > >seen the beginning of the thread:
> > 
> > My memory is fuzzy but I thought this came up before on PPC and I
> > also thought the conclusion was that the platform code (for writel,
> > etc.) should enforce ordering of MMIO accesses with respect to
> > normal RAM accesses. (Or maybe it was just MMIO accesses with
> > respect to each other?) I don't think the answer to that question
> > has been clearly documented anywhere, which is somewhat unfortunate.
> > 
> > If the answer is that this is needed then there are likely a lot of
> > other drivers in libata and elsewhere which need to be fixed as
> > well. For example, I don't see any such barriers in libahci.c when I
> > presume it would need them.
> > 
> > IMHO, it would be better for the platform code to ensure that MMIO
> > access was strongly ordered with respect to each other and to RAM
> > access. Drivers are just too likely to get this wrong, especially
> > when x86, the most tested platform, doesn't have such issues.
> 
> The plan is to make all platforms do this. writes should be
> strongly ordered with memory. That serves to keep them inside
> critical sections as well.

I support the plan, however looks like nothing has changed in any
platforms since the plan was made (in 2008 ?).

I guess that we need to add something to Documentation/ now then we
can shout, "fix arch's code instead of a driver". The consensus was
that strongly ordered with any memory?
