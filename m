Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab2EPNEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:04:20 -0400
Received: from natasha.panasas.com ([67.152.220.90]:43972 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702Ab2EPNES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:04:18 -0400
Message-ID: <4FB3A5C5.60808@panasas.com>
Date: Wed, 16 May 2012 16:04:05 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: NVM Mapping API
References: <20120515133450.GD22985@linux.intel.com>
In-Reply-To: <20120515133450.GD22985@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 04:34 PM, Matthew Wilcox wrote:

> 
> There are a number of interesting non-volatile memory (NVM) technologies
> being developed.  Some of them promise DRAM-comparable latencies and
> bandwidths.  At Intel, we've been thinking about various ways to present
> those to software.  This is a first draft of an API that supports the
> operations we see as necessary.  Patches can follow easily enough once
> we've settled on an API.
> 
> We think the appropriate way to present directly addressable NVM to
> in-kernel users is through a filesystem.  Different technologies may want
> to use different filesystems, or maybe some forms of directly addressable
> NVM will want to use the same filesystem as each other.
> 
> For mapping regions of NVM into the kernel address space, we think we need
> map, unmap, protect and sync operations; see kerneldoc for them below.
> We also think we need read and write operations (to copy to/from DRAM).
> The kernel_read() function already exists, and I don't think it would
> be unreasonable to add its kernel_write() counterpart.
> 
> We aren't yet proposing a mechanism for carving up the NVM into regions.
> vfs_truncate() seems like a reasonable API for resizing an NVM region.
> filp_open() also seems reasonable for turning a name into a file pointer.
> 
> What we'd really like is for people to think about how they might use
> fast NVM inside the kernel.  There's likely to be a lot of it (at least in
> servers); all the technologies are promising cheaper per-bit prices than
> DRAM, so it's likely to be sold in larger capacities than DRAM is today.
> 
> Caching is one obvious use (be it FS-Cache, Bcache, Flashcache or
> something else), but I bet there are more radical things we can do
> with it.  



> What if we stored the inode cache in it?  Would booting with
> a hot inode cache improve boot times?  How about storing the tree of
> 'struct devices' in it so we don't have to rescan the busses at startup?
> 


No for fast boots, just use it as an hibernation space. The rest is
already implemented. If you also want protection from crashes and
HW failures. Or power fail with no UPS, you can have a system checkpoint
every once in a while that saves an hibernation and continues. If you
always want a very fast boot to a clean system. checkpoint at entry state
and always resume from that hibernation.

Other uses:

* Journals, Journals, Journals. of other FSs. So one file system has
  it's jurnal as a file in proposed above NVMFS.
  Create an easy API for Kernel subsystems for allocating them.

* Execute in place.
  Perhaps the elf loader can sense that the executable is on an NVMFS
  and execute it in place instead of copy to DRAM. Or that happens
  automatically with your below nvm_map()

> 
> /**
>  * @nvm_filp: The NVM file pointer
>  * @start: The starting offset within the NVM region to be mapped
>  * @length: The number of bytes to map
>  * @protection: Protection bits
>  * @return Pointer to virtual mapping or PTR_ERR on failure
>  *
>  * This call maps a file to a virtual memory address.  The start and length
>  * should be page aligned.
>  *
>  * Errors: 
>  * EINVAL if start and length are not page aligned.
>  * ENODEV if the file pointer does not point to a mappable file
>  */
> void *nvm_map(struct file *nvm_filp, off_t start, size_t length,
> 							pgprot_t protection);
> 


The returned void * here is that a cooked up TLB that points
to real memory bus cycles HW. So is there a real physical
memory region this sits in? What is the difference from
say a PCIE DRAM card with battery.

Could I just use some kind of RAM-FS with this?

> /**
>  * @addr: The address returned by nvm_map()
>  *
>  * Unmaps a region previously mapped by nvm_map.
>  */
> void nvm_unmap(const void *addr);
> 
> /**
>  * @addr: The first byte to affect
>  * @length: The number of bytes to affect
>  * @protection: The new protection to use
>  *
>  * Updates the protection bits for the corresponding pages.
>  * The start and length must be page aligned, but need not be the entirety
>  * of the mapping.
>  */
> void nvm_protect(const void *addr, size_t length, pgprot_t protection);
> 
> /**
>  * @nvm_filp: The kernel file pointer
>  * @addr: The first byte to sync
>  * @length: The number of bytes to sync
>  * @returns Zero on success, -errno on failure
>  *
>  * Flushes changes made to the in-core copy of a mapped file back to NVM.
>  */
> int nvm_sync(struct file *nvm_filp, void *addr, size_t length);


This I do not understand. Is that an on card memory cache flush, or is it
a system memory DMAed to NVM?

Thanks
Boaz
