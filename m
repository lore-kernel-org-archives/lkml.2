Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0EDJp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 05:45:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab0EDJp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 05:45:56 -0400
Message-ID: <4BDFECD1.8040109@redhat.com>
Date: Tue, 04 May 2010 12:45:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/22] KVM: MMU: Track page fault data in struct vcpu
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-17-git-send-email-joerg.roedel@amd.com> <4BD6DF7C.1090203@redhat.com> <20100503163221.GB28950@amd.com> <4BDFD295.7000702@redhat.com> <20100504091157.GC28950@amd.com> <4BDFE6C2.2040601@redhat.com> <20100504093709.GE28950@amd.com>
In-Reply-To: <20100504093709.GE28950@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 12:37 PM, Roedel, Joerg wrote:
>
> This is the lockdep warning I get when I start booting a Linux kernel.
> It is with the nested-npt patchset but the warning occurs without it too
> (slightly different backtraces then).
>
> [60390.953424] =======================================================
> [60390.954324] [ INFO: possible circular locking dependency detected ]
> [60390.954324] 2.6.34-rc5 #7
> [60390.954324] -------------------------------------------------------
> [60390.954324] qemu-system-x86/2506 is trying to acquire lock:
> [60390.954324]  (&mm->mmap_sem){++++++}, at: [<c10ab0f4>] might_fault+0x4c/0x86
> [60390.954324]
> [60390.954324] but task is already holding lock:
> [60390.954324]  (&(&kvm->mmu_lock)->rlock){+.+...}, at: [<f8ec1b50>] spin_lock+0xd/0xf [kvm]
> [60390.954324]
> [60390.954324] which lock already depends on the new lock.
> [60390.954324]
> [60390.954324]
> [60390.954324] the existing dependency chain (in reverse order) is:
> [60390.954324]
> [60390.954324] ->  #1 (&(&kvm->mmu_lock)->rlock){+.+...}:
> [60390.954324]        [<c10575ad>] __lock_acquire+0x9fa/0xb6c
> [60390.954324]        [<c10577b8>] lock_acquire+0x99/0xb8
> [60390.954324]        [<c15afa2b>] _raw_spin_lock+0x20/0x2f
> [60390.954324]        [<f8eafe19>] spin_lock+0xd/0xf [kvm]
> [60390.954324]        [<f8eb104e>] kvm_mmu_notifier_invalidate_range_start+0x2f/0x71 [kvm]
> [60390.954324]        [<c10bc994>] __mmu_notifier_invalidate_range_start+0x31/0x57
> [60390.954324]        [<c10b1de3>] mprotect_fixup+0x153/0x3d5
> [60390.954324]        [<c10b21ca>] sys_mprotect+0x165/0x1db
> [60390.954324]        [<c10028cc>] sysenter_do_call+0x12/0x32
>    

Unrelated.  This can take the lock and free it.  It only shows up 
because we do memory ops inside the mmu_lock, which is deeply forbidden 
(anything which touches user memory, including kmalloc(), can trigger 
mmu notifiers and recursive locking).

> [60390.954324]
> [60390.954324] ->  #0 (&mm->mmap_sem){++++++}:
> [60390.954324]        [<c10574af>] __lock_acquire+0x8fc/0xb6c
> [60390.954324]        [<c10577b8>] lock_acquire+0x99/0xb8
> [60390.954324]        [<c10ab111>] might_fault+0x69/0x86
> [60390.954324]        [<c11d5987>] _copy_from_user+0x36/0x119
> [60390.954324]        [<f8eafcd9>] copy_from_user+0xd/0xf [kvm]
> [60390.954324]        [<f8eb0ac0>] kvm_read_guest_page+0x24/0x33 [kvm]
> [60390.954324]        [<f8ebb362>] kvm_read_guest_page_mmu+0x55/0x63 [kvm]
> [60390.954324]        [<f8ebb397>] kvm_read_nested_guest_page+0x27/0x2e [kvm]
> [60390.954324]        [<f8ebb3da>] load_pdptrs+0x3c/0x9e [kvm]
> [60390.954324]        [<f84747ac>] svm_cache_reg+0x25/0x2b [kvm_amd]
> [60390.954324]        [<f8ec7894>] kvm_mmu_load+0xf1/0x1fa [kvm]
> [60390.954324]        [<f8ebbdfc>] kvm_arch_vcpu_ioctl_run+0x252/0x9c7 [kvm]
> [60390.954324]        [<f8eb1fb5>] kvm_vcpu_ioctl+0xee/0x432 [kvm]
> [60390.954324]        [<c10cf8e9>] vfs_ioctl+0x2c/0x96
> [60390.954324]        [<c10cfe88>] do_vfs_ioctl+0x491/0x4cf
> [60390.954324]        [<c10cff0c>] sys_ioctl+0x46/0x66
> [60390.954324]        [<c10028cc>] sysenter_do_call+0x12/0x32
>    


Just a silly bug.  kvm_pdptr_read() can cause a guest memory read on 
svm, in this case with the mmu lock taken.  I'll post something to fix it.

> What makes me wondering about this is that the two traces to the locks seem to
> belong to different threads.
>    

Ever increasing complexity...

-- 
error compiling committee.c: too many arguments to function

