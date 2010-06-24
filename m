Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab0FXPOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:14:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab0FXPOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:14:36 -0400
Date: Fri, 25 Jun 2010 01:14:27 +1000
From: Nick Piggin <npiggin@suse.de>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Slow vmalloc in 2.6.35-rc3
Message-ID: <20100624151427.GH10441@laptop>
References: <4C232324.7070305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C232324.7070305@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 12:19:32PM +0300, Avi Kivity wrote:
> I see really slow vmalloc performance on 2.6.35-rc3:

Can you try this patch?
http://userweb.kernel.org/~akpm/mmotm/broken-out/mm-vmap-area-cache.patch

 
> # tracer: function_graph
> #
> # CPU  DURATION                  FUNCTION CALLS
> # |     |   |                     |   |   |   |
>  3)   3.581 us    |  vfree();
>  3)               |  msr_io() {
>  3) ! 523.880 us  |    vmalloc();
>  3)   1.702 us    |    vfree();
>  3) ! 529.960 us  |  }
>  3)               |  msr_io() {
>  3) ! 564.200 us  |    vmalloc();
>  3)   1.429 us    |    vfree();
>  3) ! 568.080 us  |  }
>  3)               |  msr_io() {
>  3) ! 578.560 us  |    vmalloc();
>  3)   1.697 us    |    vfree();
>  3) ! 584.791 us  |  }
>  3)               |  msr_io() {
>  3) ! 559.657 us  |    vmalloc();
>  3)   1.566 us    |    vfree();
>  3) ! 575.948 us  |  }
>  3)               |  msr_io() {
>  3) ! 536.558 us  |    vmalloc();
>  3)   1.553 us    |    vfree();
>  3) ! 542.243 us  |  }
>  3)               |  msr_io() {
>  3) ! 560.086 us  |    vmalloc();
>  3)   1.448 us    |    vfree();
>  3) ! 569.387 us  |  }
> 
> msr_io() is from arch/x86/kvm/x86.c, allocating at most 4K (yes it
> should use kmalloc()).  The memory is immediately vfree()ed.  There
> are 96 entries in /proc/vmallocinfo, and the whole thing is single
> threaded so there should be no contention.

Yep, it should use kmalloc.

 
> Here's the perf report:
> 
>     63.97%             qemu  [kernel]
> [k] rb_next
>                        |
>                        --- rb_next
>                           |
>                           |--70.75%-- alloc_vmap_area
>                           |          __get_vm_area_node
>                           |          __vmalloc_node
>                           |          vmalloc
>                           |          |
>                           |          |--99.15%-- msr_io
>                           |          |          kvm_arch_vcpu_ioctl
>                           |          |          kvm_vcpu_ioctl
>                           |          |          vfs_ioctl
>                           |          |          do_vfs_ioctl
>                           |          |          sys_ioctl
>                           |          |          system_call
>                           |          |          __GI_ioctl
>                           |          |          |
>                           |          |           --100.00%--
> 0x1dfc4a8878e71362
>                           |          |
>                           |           --0.85%-- __kvm_set_memory_region
>                           |                     kvm_set_memory_region
>                           |
> kvm_vm_ioctl_set_memory_region
>                           |                     kvm_vm_ioctl
>                           |                     vfs_ioctl
>                           |                     do_vfs_ioctl
>                           |                     sys_ioctl
>                           |                     system_call
>                           |                     __GI_ioctl
>                           |
>                            --29.25%-- __get_vm_area_node
>                                      __vmalloc_node
>                                      vmalloc
>                                      |
>                                      |--98.89%-- msr_io
>                                      |          kvm_arch_vcpu_ioctl
>                                      |          kvm_vcpu_ioctl
>                                      |          vfs_ioctl
>                                      |          do_vfs_ioctl
>                                      |          sys_ioctl
>                                      |          system_call
>                                      |          __GI_ioctl
>                                      |          |
>                                      |           --100.00%--
> 0x1dfc4a8878e71362
> 
> 
> It seems completely wrong - iterating 8 levels of a binary tree
> shouldn't take half a millisecond.

It's not iterating down the tree, it's iterating through the
nodes to find a free area. Slows down because lazy vunmap means
that quite a lot of little areas build up right at the start of
our search start address. The vmap cache should hopefully fix
it up.

Thanks,
Nick

