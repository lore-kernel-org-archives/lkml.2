Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225Ab2EPScL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:32:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:3898 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab2EPScI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:32:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153730480"
Date: Wed, 16 May 2012 14:33:04 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NVM Mapping API
Message-ID: <20120516183303.GL22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
 <4FB3A5C5.60808@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB3A5C5.60808@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 04:04:05PM +0300, Boaz Harrosh wrote:
> No for fast boots, just use it as an hibernation space. The rest is
> already implemented. If you also want protection from crashes and
> HW failures. Or power fail with no UPS, you can have a system checkpoint
> every once in a while that saves an hibernation and continues. If you
> always want a very fast boot to a clean system. checkpoint at entry state
> and always resume from that hibernation.

Yes, checkpointing to it is definitely a good idea.  I was thinking
more along the lines of suspend rather than hibernate.  We trash a lot
of clean pages as part of the hibernation process, when it'd be better
to copy them to NVM and restore them.

> Other uses:
> 
> * Journals, Journals, Journals. of other FSs. So one file system has
>   it's jurnal as a file in proposed above NVMFS.
>   Create an easy API for Kernel subsystems for allocating them.

That's a great idea.  I could see us having a specific journal API.

> * Execute in place.
>   Perhaps the elf loader can sense that the executable is on an NVMFS
>   and execute it in place instead of copy to DRAM. Or that happens
>   automatically with your below nvm_map()

If there's an executable on the NVMFS, it's going to get mapped into
userspace, so as long as the NVMFS implements the ->mmap method, that will
get called.  It'll be up to the individual NVMFS whether it uses the page
cache to buffer a read-only mmap or whether it points directly to the NVM.

> > void *nvm_map(struct file *nvm_filp, off_t start, size_t length,
> > 							pgprot_t protection);
> 
> The returned void * here is that a cooked up TLB that points
> to real memory bus cycles HW. So is there a real physical
> memory region this sits in? What is the difference from
> say a PCIE DRAM card with battery.

The concept we're currently playing with would have the NVM appear as
part of the CPU address space, yes.

> Could I just use some kind of RAM-FS with this?

For prototyping, sure.

> > /**
> >  * @nvm_filp: The kernel file pointer
> >  * @addr: The first byte to sync
> >  * @length: The number of bytes to sync
> >  * @returns Zero on success, -errno on failure
> >  *
> >  * Flushes changes made to the in-core copy of a mapped file back to NVM.
> >  */
> > int nvm_sync(struct file *nvm_filp, void *addr, size_t length);
> 
> This I do not understand. Is that an on card memory cache flush, or is it
> a system memory DMAed to NVM?

Up to the implementation; if it works out best to have a CPU with
write-through caches pointing directly to the address space of the NVM,
then it can be a no-op.  If the CPU is using a writeback cache for the
NVM, then it'll flush the CPU cache.  If the nvmfs has staged the writes
in DRAM, this will copy from DRAM to NVM.  If the NVM card needs some
magic to flush an internal buffer, that will happen here.

Just as with mmaping a file in userspace today, there's no guarantee that
a store gets to stable storage until after a sync.
