Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0FXJTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:19:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab0FXJTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:19:37 -0400
Message-ID: <4C232324.7070305@redhat.com>
Date: Thu, 24 Jun 2010 12:19:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Slow vmalloc in 2.6.35-rc3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see really slow vmalloc performance on 2.6.35-rc3:

# tracer: function_graph
#
# CPU  DURATION                  FUNCTION CALLS
# |     |   |                     |   |   |   |
  3)   3.581 us    |  vfree();
  3)               |  msr_io() {
  3) ! 523.880 us  |    vmalloc();
  3)   1.702 us    |    vfree();
  3) ! 529.960 us  |  }
  3)               |  msr_io() {
  3) ! 564.200 us  |    vmalloc();
  3)   1.429 us    |    vfree();
  3) ! 568.080 us  |  }
  3)               |  msr_io() {
  3) ! 578.560 us  |    vmalloc();
  3)   1.697 us    |    vfree();
  3) ! 584.791 us  |  }
  3)               |  msr_io() {
  3) ! 559.657 us  |    vmalloc();
  3)   1.566 us    |    vfree();
  3) ! 575.948 us  |  }
  3)               |  msr_io() {
  3) ! 536.558 us  |    vmalloc();
  3)   1.553 us    |    vfree();
  3) ! 542.243 us  |  }
  3)               |  msr_io() {
  3) ! 560.086 us  |    vmalloc();
  3)   1.448 us    |    vfree();
  3) ! 569.387 us  |  }

msr_io() is from arch/x86/kvm/x86.c, allocating at most 4K (yes it 
should use kmalloc()).  The memory is immediately vfree()ed.  There are 
96 entries in /proc/vmallocinfo, and the whole thing is single threaded 
so there should be no contention.

Here's the perf report:

     63.97%             qemu  
[kernel]                                            [k] rb_next
                        |
                        --- rb_next
                           |
                           |--70.75%-- alloc_vmap_area
                           |          __get_vm_area_node
                           |          __vmalloc_node
                           |          vmalloc
                           |          |
                           |          |--99.15%-- msr_io
                           |          |          kvm_arch_vcpu_ioctl
                           |          |          kvm_vcpu_ioctl
                           |          |          vfs_ioctl
                           |          |          do_vfs_ioctl
                           |          |          sys_ioctl
                           |          |          system_call
                           |          |          __GI_ioctl
                           |          |          |
                           |          |           --100.00%-- 
0x1dfc4a8878e71362
                           |          |
                           |           --0.85%-- __kvm_set_memory_region
                           |                     kvm_set_memory_region
                           |                     
kvm_vm_ioctl_set_memory_region
                           |                     kvm_vm_ioctl
                           |                     vfs_ioctl
                           |                     do_vfs_ioctl
                           |                     sys_ioctl
                           |                     system_call
                           |                     __GI_ioctl
                           |
                            --29.25%-- __get_vm_area_node
                                      __vmalloc_node
                                      vmalloc
                                      |
                                      |--98.89%-- msr_io
                                      |          kvm_arch_vcpu_ioctl
                                      |          kvm_vcpu_ioctl
                                      |          vfs_ioctl
                                      |          do_vfs_ioctl
                                      |          sys_ioctl
                                      |          system_call
                                      |          __GI_ioctl
                                      |          |
                                      |           --100.00%-- 
0x1dfc4a8878e71362


It seems completely wrong - iterating 8 levels of a binary tree 
shouldn't take half a millisecond.

-- 
error compiling committee.c: too many arguments to function

