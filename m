Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab0EDJhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 05:37:36 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:44072 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab0EDJhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 05:37:33 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432P98dN936eM9371Pzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1W2PX-02-30U-02
X-M-MSG: 
Date: Tue, 4 May 2010 11:37:09 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/22] KVM: MMU: Track page fault data in struct vcpu
Message-ID: <20100504093709.GE28950@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
 <1272364712-17425-17-git-send-email-joerg.roedel@amd.com>
 <4BD6DF7C.1090203@redhat.com>
 <20100503163221.GB28950@amd.com>
 <4BDFD295.7000702@redhat.com>
 <20100504091157.GC28950@amd.com>
 <4BDFE6C2.2040601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BDFE6C2.2040601@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 05:20:02AM -0400, Avi Kivity wrote:
> On 05/04/2010 12:11 PM, Roedel, Joerg wrote:
> > On Tue, May 04, 2010 at 03:53:57AM -0400, Avi Kivity wrote:
> >    
> >> On 05/03/2010 07:32 PM, Joerg Roedel wrote:
> >>      
> >>> On Tue, Apr 27, 2010 at 03:58:36PM +0300, Avi Kivity wrote:
> >>>
> >>>        
> >>>> So we probably need to upgrade gva_t to a u64.  Please send this as
> >>>> a separate patch, and test on i386 hosts.
> >>>>
> >>>>          
> >>> Are there _any_ regular tests of KVM on i386 hosts? For me this is
> >>> terribly broken (also after I fixed the issue which gave me a
> >>> VMEXIT_INVALID at the first vmrun).
> >>>
> >>>
> >>>        
> >> No, apart from the poor users.  I'll try to set something up using nsvm.
> >>      
> > Ok. I will post an initial fix for the VMEXIT_INVALID bug soon. Apart
> > from that I get a lockdep warning when I try to start a guest. The guest
> > actually boots if it is single-vcpu. SMP guests don't even boot through
> > the BIOS for me.
> >
> >    
> 
> Strange.  i386 vs x86_64 shouldn't have that much effect!

This is the lockdep warning I get when I start booting a Linux kernel.
It is with the nested-npt patchset but the warning occurs without it too
(slightly different backtraces then).

[60390.953424] =======================================================
[60390.954324] [ INFO: possible circular locking dependency detected ]
[60390.954324] 2.6.34-rc5 #7
[60390.954324] -------------------------------------------------------
[60390.954324] qemu-system-x86/2506 is trying to acquire lock:
[60390.954324]  (&mm->mmap_sem){++++++}, at: [<c10ab0f4>] might_fault+0x4c/0x86
[60390.954324] 
[60390.954324] but task is already holding lock:
[60390.954324]  (&(&kvm->mmu_lock)->rlock){+.+...}, at: [<f8ec1b50>] spin_lock+0xd/0xf [kvm]
[60390.954324] 
[60390.954324] which lock already depends on the new lock.
[60390.954324] 
[60390.954324] 
[60390.954324] the existing dependency chain (in reverse order) is:
[60390.954324] 
[60390.954324] -> #1 (&(&kvm->mmu_lock)->rlock){+.+...}:
[60390.954324]        [<c10575ad>] __lock_acquire+0x9fa/0xb6c
[60390.954324]        [<c10577b8>] lock_acquire+0x99/0xb8
[60390.954324]        [<c15afa2b>] _raw_spin_lock+0x20/0x2f
[60390.954324]        [<f8eafe19>] spin_lock+0xd/0xf [kvm]
[60390.954324]        [<f8eb104e>] kvm_mmu_notifier_invalidate_range_start+0x2f/0x71 [kvm]
[60390.954324]        [<c10bc994>] __mmu_notifier_invalidate_range_start+0x31/0x57
[60390.954324]        [<c10b1de3>] mprotect_fixup+0x153/0x3d5
[60390.954324]        [<c10b21ca>] sys_mprotect+0x165/0x1db
[60390.954324]        [<c10028cc>] sysenter_do_call+0x12/0x32
[60390.954324] 
[60390.954324] -> #0 (&mm->mmap_sem){++++++}:
[60390.954324]        [<c10574af>] __lock_acquire+0x8fc/0xb6c
[60390.954324]        [<c10577b8>] lock_acquire+0x99/0xb8
[60390.954324]        [<c10ab111>] might_fault+0x69/0x86
[60390.954324]        [<c11d5987>] _copy_from_user+0x36/0x119
[60390.954324]        [<f8eafcd9>] copy_from_user+0xd/0xf [kvm]
[60390.954324]        [<f8eb0ac0>] kvm_read_guest_page+0x24/0x33 [kvm]
[60390.954324]        [<f8ebb362>] kvm_read_guest_page_mmu+0x55/0x63 [kvm]
[60390.954324]        [<f8ebb397>] kvm_read_nested_guest_page+0x27/0x2e [kvm]
[60390.954324]        [<f8ebb3da>] load_pdptrs+0x3c/0x9e [kvm]
[60390.954324]        [<f84747ac>] svm_cache_reg+0x25/0x2b [kvm_amd]
[60390.954324]        [<f8ec7894>] kvm_mmu_load+0xf1/0x1fa [kvm]
[60390.954324]        [<f8ebbdfc>] kvm_arch_vcpu_ioctl_run+0x252/0x9c7 [kvm]
[60390.954324]        [<f8eb1fb5>] kvm_vcpu_ioctl+0xee/0x432 [kvm]
[60390.954324]        [<c10cf8e9>] vfs_ioctl+0x2c/0x96
[60390.954324]        [<c10cfe88>] do_vfs_ioctl+0x491/0x4cf
[60390.954324]        [<c10cff0c>] sys_ioctl+0x46/0x66
[60390.954324]        [<c10028cc>] sysenter_do_call+0x12/0x32
[60390.954324] 
[60390.954324] other info that might help us debug this:
[60390.954324] 
[60390.954324] 3 locks held by qemu-system-x86/2506:
[60390.954324]  #0:  (&vcpu->mutex){+.+.+.}, at: [<f8eb1185>] vcpu_load+0x16/0x32 [kvm]
[60390.954324]  #1:  (&kvm->srcu){.+.+.+}, at: [<f8eb952c>] srcu_read_lock+0x0/0x33 [kvm]
[60390.954324]  #2:  (&(&kvm->mmu_lock)->rlock){+.+...}, at: [<f8ec1b50>] spin_lock+0xd/0xf [kvm]
[60390.954324] 
[60390.954324] stack backtrace:
[60390.954324] Pid: 2506, comm: qemu-system-x86 Not tainted 2.6.34-rc5 #7
[60390.954324] Call Trace:
[60390.954324]  [<c15adf46>] ? printk+0x14/0x16
[60390.954324]  [<c1056877>] print_circular_bug+0x8a/0x96
[60390.954324]  [<c10574af>] __lock_acquire+0x8fc/0xb6c
[60390.954324]  [<f8ec1b50>] ? spin_lock+0xd/0xf [kvm]
[60390.954324]  [<c10ab0f4>] ? might_fault+0x4c/0x86
[60390.954324]  [<c10577b8>] lock_acquire+0x99/0xb8
[60390.954324]  [<c10ab0f4>] ? might_fault+0x4c/0x86
[60390.954324]  [<c10ab111>] might_fault+0x69/0x86
[60390.954324]  [<c10ab0f4>] ? might_fault+0x4c/0x86
[60390.954324]  [<c11d5987>] _copy_from_user+0x36/0x119
[60390.954324]  [<f8eafcd9>] copy_from_user+0xd/0xf [kvm]
[60390.954324]  [<f8eb0ac0>] kvm_read_guest_page+0x24/0x33 [kvm]
[60390.954324]  [<f8ebb362>] kvm_read_guest_page_mmu+0x55/0x63 [kvm]
[60390.954324]  [<f8ebb397>] kvm_read_nested_guest_page+0x27/0x2e [kvm]
[60390.954324]  [<f8ebb3da>] load_pdptrs+0x3c/0x9e [kvm]
[60390.954324]  [<f8ec1b50>] ? spin_lock+0xd/0xf [kvm]
[60390.954324]  [<c15afa32>] ? _raw_spin_lock+0x27/0x2f
[60390.954324]  [<f84747ac>] svm_cache_reg+0x25/0x2b [kvm_amd]
[60390.954324]  [<f84747ac>] ? svm_cache_reg+0x25/0x2b [kvm_amd]
[60390.954324]  [<f8ec7894>] kvm_mmu_load+0xf1/0x1fa [kvm]
[60390.954324]  [<f8ebbdfc>] kvm_arch_vcpu_ioctl_run+0x252/0x9c7 [kvm]
[60390.954324]  [<f8eb1fb5>] kvm_vcpu_ioctl+0xee/0x432 [kvm]
[60390.954324]  [<c1057710>] ? __lock_acquire+0xb5d/0xb6c
[60390.954324]  [<c107a300>] ? __rcu_process_callbacks+0x6/0x244
[60390.954324]  [<c119eb09>] ? file_has_perm+0x84/0x8d
[60390.954324]  [<c10cf8e9>] vfs_ioctl+0x2c/0x96
[60390.954324]  [<f8eb1ec7>] ? kvm_vcpu_ioctl+0x0/0x432 [kvm]
[60390.954324]  [<c10cfe88>] do_vfs_ioctl+0x491/0x4cf
[60390.954324]  [<c119ece0>] ? selinux_file_ioctl+0x43/0x46
[60390.954324]  [<c10cff0c>] sys_ioctl+0x46/0x66
[60390.954324]  [<c10028cc>] sysenter_do_call+0x12/0x32

What makes me wondering about this is that the two traces to the locks seem to
belong to different threads.

HTH, Joerg


