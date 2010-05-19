Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab0ESLzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:55:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:37422 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab0ESLzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:55:42 -0400
Date: Wed, 19 May 2010 20:54:29 +0900
To: linux@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, albert_herranz@yahoo.es,
       konrad.wilk@oracle.com, Ian.Campbell@eu.citrix.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org
Subject: Re: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions
	visible in the header file.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100519071057.GB22212@n2100.arm.linux.org.uk>
References: <4BF2C5C1.2020807@yahoo.es>
	<20100519123626P.fujita.tomonori@lab.ntt.co.jp>
	<20100519071057.GB22212@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100519205638E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 19 May 2010 20:54:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 08:10:57 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Wed, May 19, 2010 at 12:34:18PM +0900, FUJITA Tomonori wrote:
> > On Tue, 18 May 2010 18:52:17 +0200
> > Albert Herranz <albert_herranz@yahoo.es> wrote:
> > > Every single KB counts on the Wii. It has just 24MB of MEM1 and 64MB of MEM2 (discontiguous memory ranges).
> > > I'm using 1MB for the SWIOTLB for now, but of course that can be further tweaked down.
> > 
> > You can decrease the swiotlb memory however you can't fix the root
> > problems of swiotlb:
> > 
> > - it needs pre-allocated memory
> > - it can't handle the out-of-pre-allocated memory situation.
> 
> That's actually the advantage of swiotlb over dmabounce.  dmabounce's
> dynamic allocation results in OOMs under some IO activity patterns.
> dmabounce also produces the occasional WARN_ON() from the dma coherent
> allocator depending on the driver.

However, we can't guarantee that allocation always succeeds in any IO
patters. And the I/O subsystems and drivers can handle the dma
allocation failure nicely. With SCSI, commands that hit the allocation
failure are re-queued. Nothing bad happens. We shouldn't use WARN_ON
in the dma allocation failure path.

For me, the problems are:

- swiotlb could waste too much pre-allocated memory if there are not
  much IO activities.

- Allocation failure could happen even if the system has lots of free
  memory because swiotlb use only pre-allocated memory.

> We really need to kill off dmabounce.

Agreed. What changes to swiotlb are necessary to replace dmabounce?
Needs to use coherent memory (I'm not sure why dmabounce uses coherent
memory to dma_map_single though)? I'll try to take care of them.
