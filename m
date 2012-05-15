Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925Ab2EONd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:33:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:46304 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758872Ab2EONd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:33:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="140858363"
Date: Tue, 15 May 2012 09:34:51 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: NVM Mapping API
Message-ID: <20120515133450.GD22985@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are a number of interesting non-volatile memory (NVM) technologies
being developed.  Some of them promise DRAM-comparable latencies and
bandwidths.  At Intel, we've been thinking about various ways to present
those to software.  This is a first draft of an API that supports the
operations we see as necessary.  Patches can follow easily enough once
we've settled on an API.

We think the appropriate way to present directly addressable NVM to
in-kernel users is through a filesystem.  Different technologies may want
to use different filesystems, or maybe some forms of directly addressable
NVM will want to use the same filesystem as each other.

For mapping regions of NVM into the kernel address space, we think we need
map, unmap, protect and sync operations; see kerneldoc for them below.
We also think we need read and write operations (to copy to/from DRAM).
The kernel_read() function already exists, and I don't think it would
be unreasonable to add its kernel_write() counterpart.

We aren't yet proposing a mechanism for carving up the NVM into regions.
vfs_truncate() seems like a reasonable API for resizing an NVM region.
filp_open() also seems reasonable for turning a name into a file pointer.

What we'd really like is for people to think about how they might use
fast NVM inside the kernel.  There's likely to be a lot of it (at least in
servers); all the technologies are promising cheaper per-bit prices than
DRAM, so it's likely to be sold in larger capacities than DRAM is today.

Caching is one obvious use (be it FS-Cache, Bcache, Flashcache or
something else), but I bet there are more radical things we can do
with it.  What if we stored the inode cache in it?  Would booting with
a hot inode cache improve boot times?  How about storing the tree of
'struct devices' in it so we don't have to rescan the busses at startup?


/**
 * @nvm_filp: The NVM file pointer
 * @start: The starting offset within the NVM region to be mapped
 * @length: The number of bytes to map
 * @protection: Protection bits
 * @return Pointer to virtual mapping or PTR_ERR on failure
 *
 * This call maps a file to a virtual memory address.  The start and length
 * should be page aligned.
 *
 * Errors: 
 * EINVAL if start and length are not page aligned.
 * ENODEV if the file pointer does not point to a mappable file
 */
void *nvm_map(struct file *nvm_filp, off_t start, size_t length,
							pgprot_t protection);

/**
 * @addr: The address returned by nvm_map()
 *
 * Unmaps a region previously mapped by nvm_map.
 */
void nvm_unmap(const void *addr);

/**
 * @addr: The first byte to affect
 * @length: The number of bytes to affect
 * @protection: The new protection to use
 *
 * Updates the protection bits for the corresponding pages.
 * The start and length must be page aligned, but need not be the entirety
 * of the mapping.
 */
void nvm_protect(const void *addr, size_t length, pgprot_t protection);

/**
 * @nvm_filp: The kernel file pointer
 * @addr: The first byte to sync
 * @length: The number of bytes to sync
 * @returns Zero on success, -errno on failure
 *
 * Flushes changes made to the in-core copy of a mapped file back to NVM.
 */
int nvm_sync(struct file *nvm_filp, void *addr, size_t length);
