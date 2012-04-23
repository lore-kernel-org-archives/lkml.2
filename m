Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2DWKL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:11:58 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60768 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2DWKL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:11:56 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-doc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Xen <xen-devel@lists.xensource.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 23 Apr 2012 15:29:37 +0530
Message-Id: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V6 0/5] kvm : Paravirt-spinlock support for KVM guests
x-cbid: 12042309-8256-0000-0000-0000021A1DD0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 5-patch series to follow this email extends KVM-hypervisor and Linux guest
running on KVM-hypervisor to support pv-ticket spinlocks, based on Xen's 
implementation.

One hypercall is introduced in KVM hypervisor,that allows a vcpu to kick
another vcpu out of halt state.
The blocking of vcpu is done using halt() in (lock_spinning) slowpath.

Note: 1) patch is based on 3.4-rc3 + ticketlock patches in 
	https://lkml.org/lkml/2012/4/19/335 

 [ The patches are targeted for 3.5 window ]

Changes in V6:
- Rebased to 3.4-rc3
- Removed debugfs changes patch which should now be in Xen/linux-next.
  (https://lkml.org/lkml/2012/3/30/687)
- Removed PV_UNHALT_MSR since currently we don't need guest communication,
  and made pv_unhalt folded to GET_MP_STATE (Marcello, Avi[long back])
- Take jumplabel changes from Ingo/Jason into use (static_key_slow_inc usage)
- Added inline to spinlock_init in non PARAVIRT case
- Move arch specific code to arch/x86 and add stubs to other archs (Marcello)
- Added more comments on pv_unhalt usage etc (Marcello)

Changes in V5:
- rebased to 3.3-rc6
- added PV_UNHALT_MSR that would help in live migration (Avi)
- removed PV_LOCK_KICK vcpu request and pv_unhalt flag (re)added.
- Changed hypercall documentaion (Alex).
- mode_t changed to umode_t in debugfs.
- MSR related documentation added.
- rename PV_LOCK_KICK to PV_UNHALT. 
- host and guest patches not mixed. (Marcelo, Alex)
- kvm_kick_cpu now takes cpu so it can be used by flush_tlb_ipi_other 
   paravirtualization (Nikunj)
- coding style changes in variable declarion etc (Srikar)

Changes in V4:
- reabsed to 3.2.0 pre.
- use APIC ID for kicking the vcpu and use kvm_apic_match_dest for matching (Avi)
- fold vcpu->kicked flag into vcpu->requests (KVM_REQ_PVLOCK_KICK) and related 
  changes for UNHALT path to make pv ticket spinlock migration friendly(Avi, Marcello)
- Added Documentation for CPUID, Hypercall (KVM_HC_KICK_CPU)
  and capabilty (KVM_CAP_PVLOCK_KICK) (Avi)
- Remove unneeded kvm_arch_vcpu_ioctl_set_mpstate call. (Marcello)
- cumulative variable type changed (int ==> u32) in add_stat (Konrad)
- remove unneeded kvm_guest_init for !CONFIG_KVM_GUEST case

Changes in V3:
- rebased to 3.2-rc1
- use halt() instead of wait for kick hypercall.
- modify kick hyper call to do wakeup halted vcpu.
- hook kvm_spinlock_init to smp_prepare_cpus call (moved the call out of head##.c).
- fix the potential race when zero_stat is read.
- export debugfs_create_32 and add documentation to API.
- use static inline and enum instead of ADDSTAT macro. 
- add  barrier() in after setting kick_vcpu.
- empty static inline function for kvm_spinlock_init.
- combine the patches one and two readuce overhead.
- make KVM_DEBUGFS depends on DEBUGFS.
- include debugfs header unconditionally.

Changes in V2:
- rebased patchesto -rc9
- synchronization related changes based on Jeremy's changes 
 (Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>) pointed by 
 Stephan Diestelhorst <stephan.diestelhorst@amd.com>
- enabling 32 bit guests
- splitted patches into two more chunks

Results:
results for PLE / non PLE machine were posted for V5 patches in
 https://lkml.org/lkml/2012/3/23/50
 https://lkml.org/lkml/2012/4/5/73

Current series is giving similar results but more formal results will
be posted in next couple of days.
      
Interestingly with current patchset I do not see CPU stalls observed in vanilla.

TODO: 1) remove CONFIG_PARAVIRT_SPINLOCK ?
      2) experiments on further optimization possibilities.
		(discussed in V6 of ticketlock) 
      3) possible debugfs cleanups (combining common code of Xen/KVM)

Let me know if you have any sugestion/comments...
---
 V5 kernel changes:
 https://lkml.org/lkml/2012/3/23/50
 Qemu changes for V5:
 http://lists.gnu.org/archive/html/qemu-devel/2012-03/msg04455.html 

 V4 kernel changes:
 https://lkml.org/lkml/2012/1/14/66

 Qemu changes for V4:
 http://www.mail-archive.com/kvm@vger.kernel.org/msg66450.html

 V3 kernel Changes:
 https://lkml.org/lkml/2011/11/30/62
 V2 kernel changes : 
 https://lkml.org/lkml/2011/10/23/207

 Previous discussions : (posted by Srivatsa V).
 https://lkml.org/lkml/2010/7/26/24
 https://lkml.org/lkml/2011/1/19/212
 
 Qemu patch for V3:
 http://lists.gnu.org/archive/html/qemu-devel/2011-12/msg00397.html
 
Srivatsa Vaddagiri (3): 
  Add a hypercall to KVM hypervisor to support pv-ticketlocks
  Added configuration support to enable debug information for KVM Guests
  pv-ticketlock support for linux guests running on KVM hypervisor

Raghavendra K T (2):
  Fold pv_unhalt flag into GET_MP_STATE ioctl to aid migration
  Add documentation on Hypercalls and features used for PV spinlock

 Documentation/virtual/kvm/api.txt        |    7 +
 Documentation/virtual/kvm/cpuid.txt      |    4 +
 Documentation/virtual/kvm/hypercalls.txt |   59 +++++++
 arch/ia64/include/asm/kvm_host.h         |    3 +
 arch/powerpc/include/asm/kvm_host.h      |    4 +
 arch/s390/include/asm/kvm_host.h         |    4 +
 arch/x86/Kconfig                         |    9 +
 arch/x86/include/asm/kvm_host.h          |    6 +
 arch/x86/include/asm/kvm_para.h          |   16 ++-
 arch/x86/kernel/kvm.c                    |  254 ++++++++++++++++++++++++++++++
 arch/x86/kvm/cpuid.c                     |    3 +-
 arch/x86/kvm/x86.c                       |   46 ++++++-
 include/linux/kvm.h                      |    1 +
 include/linux/kvm_para.h                 |    1 +
 virt/kvm/kvm_main.c                      |    8 +
 15 files changed, 421 insertions(+), 4 deletions(-)

