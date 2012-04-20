Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2DTT6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:58:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47591 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2DTT6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:58:36 -0400
Date: Fri, 20 Apr 2012 20:58:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
Message-ID: <20120420195833.GM6871@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor>
 <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor>
 <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor>
 <20120420004303.GB6871@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1204201133340.1450@eggly.anvils>
 <20120420190418.GK6871@ZenIV.linux.org.uk>
 <CA+55aFwVJ7SFbb3ZVxnon-Vv19pbNvUN4oungH479q7DUjBtwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwVJ7SFbb3ZVxnon-Vv19pbNvUN4oungH479q7DUjBtwQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 12:18:43PM -0700, Linus Torvalds wrote:

> The *bigger* annoyance is actually "do_mmap()", which does a
> do_munmap() as part of it, so it needs the same cleanup too.

So does a bunch of other places.  Let me dig out the call graph circa
3.3.0...  Here is the relevant part:
do_munmap() -
        <- pfm_do_munmap() <- pfm_remove_smpl_mapping() which grabs mmap_sem excl
        <- 64_munmap(2) which grabs mmap_sem excl
        <- kvm_arch_commit_memory_region() which grabs mmap_sem excl
        <- i810_unmap_buffer() which grabs mmap_sem excl
        <- aio_free_ring() which grabs mmap_sem excl
        <- elf_map() which grabs mmap_sem excl
        <- [flat] load_flat_file() --- BUG HERE
        <- shmdt(2) which grabs mmap_sem excl
        <- brk(2) which grabs mmap_sem excl
        <- mmap_region() [see below]
        <- munmap(2) which grabs mmap_sem excl
        <- do_brk() [see below]
        <- move_vma()
                <- mremap_to() <- do_mremap() [see below]
                <- do_mremap() [see below]
        <- mremap_to() <- do_mremap() [see below]
        <- do_mremap() [see below]
do_brk() -
        <- brk(2) which grabs mmap_sem excl
        <- [ia32_aout] set_brk() which grabs mmap_sem excl
        <- [ia32_aout] load_aout_binary() which grabs mmap_sem excl
        <- [ia32_aout] load_aout_library() which grabs mmap_sem excl
        <- [aout] set_brk() which grabs mmap_sem excl
        <- [aout] load_aout_binary() which grabs mmap_sem excl
        <- [aout] load_aout_library() which grabs mmap_sem excl
        <- [elf] set_brk() which grabs mmap_sem excl
        <- [elf] load_elf_interp() which grabs mmap_sem excl
        <- [elf] load_elf_library() which grabs mmap_sem excl
mmap_region() -
        <- remap_file_pages(2) which grabs mmap_sem excl
        <- do_mmap_pgoff() [see below]
        <- [tile] arch_setup_additional_pages() which grabs mmap_sem excl
                (a bit too late, BTW, but not for this one)
do_mmap_pgoff() -
        <- do_mmap() [see below]
        <- mmap_pgoff(2) which grabs mmap_sem excl
do_mmap() -
        <- shmat(2) which grabs mmap_sem excl
        <- aio_setup_ring() which grabs mmap_sem excl [NB: only because ctx->mm == current->mm]
        <- kvm_arch_prepare_memory_region() which grabs mmap_sem excl
        <- drm_mapbufs() which grabs mmap_sem excl
        <- exynos_drm_gem_mmap_ioctl() which grabs mmap_sem excl
        <- i810_map_buffer() which grabs mmap_sem excl [NB: racy changes of ->f_op]
        <- i915_gem_mmap_ioctl() which grabs mmap_sem excl
        <- [tile] single_step_once() which grabs mmap_sem excl
        <- [elf] elf_map() which grabs mmap_sem excl
        <- [elf] load_elf_binary() which grabs mmap_sem excl
        <- [elf_fdpic] load_elf_fdpic_binary() which grabs mmap_sem excl
        <- [elf_fdpic] elf_fdpic_map_file_constdisp_on_uclinux() which grabs mmap_sem excl
        <- [elf_fdpic] elf_fdpic_map_file_by_direct_mmap() which grabs mmap_sem excl
        <- [aout] load_aout_binary() which grabs mmap_sem excl
        <- [aout] load_aout_library() which grabs mmap_sem excl
        <- [ia32_aout] load_aout_binary() which grabs mmap_sem excl
        <- [ia32_aout] load_aout_library() which grabs mmap_sem excl
        <- [flat] load_flat_file() which grabs mmap_sem excl
        <- [som] map_som_binary() which grabs mmap_sem excl
do_mremap() -
        <- mremap(2) which grabs mmap_sem excl

(bug mentioned re load_flat_file() is still there, but it's irrelevant
for our purposes - no ->mmap_sem held by caller of do_munmap()).  That's
a metric arseload of sites to propagate that thing to...
