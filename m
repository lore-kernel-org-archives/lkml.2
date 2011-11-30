Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab1K3I7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 03:59:41 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34482 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab1K3I7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 03:59:39 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Sedat Dilek <sedat.dilek@gmail.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        KVM <kvm@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Xen <xen-devel@lists.xensource.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 30 Nov 2011 14:29:21 +0530
Message-Id: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH RFC V3 0/4] kvm : Paravirt-spinlock support for KVM guests
x-cbid: 11113008-5930-0000-0000-000002BD9117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 4-patch series to follow this email extends KVM-hypervisor and Linux guest 
running on KVM-hypervisor to support pv-ticket spinlocks, based on Xen's implementation.

One hypercall is introduced in KVM hypervisor,that allows a vcpu to kick
another vcpu out of halt state.
The blocking of vcpu is done using halt() in (lock_spinning) slowpath.

The V2 change discussion was in:  
 https://lkml.org/lkml/2011/10/23/207
 
Previous discussions : (posted by Srivatsa V).
https://lkml.org/lkml/2010/7/26/24
https://lkml.org/lkml/2011/1/19/212

The BASE patch is tip 3.2-rc1 + Jeremy's following patches.
xadd (https://lkml.org/lkml/2011/10/4/328)
x86/ticketlocklock  (https://lkml.org/lkml/2011/10/12/496).

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
- synchronization related changes based on Jeremy's changes (Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>) pointed by
Stephan Diestelhorst <stephan.diestelhorst@amd.com>
- enabling 32 bit guests
- splitted patches into two more chunks

 Srivatsa Vaddagiri, Suzuki Poulose, Raghavendra K T (4): 
  Add debugfs support to print u32-arrays in debugfs
  Add a hypercall to KVM hypervisor to support pv-ticketlocks
  Added configuration support to enable debug information for KVM Guests
  pv-ticketlocks support for linux guests running on KVM hypervisor
 
Results:
 From the results we can see that patched kernel performance is similar to
 BASE when  there is no lock contention. But once we start seeing more 
 contention, patched kernel outperforms BASE.

set up : 
Kernel for host/guest : 3.2-rc1 + Jeremy's xadd, pv spinlock patches as BASE

3 guests with 8VCPU, 4GB RAM, 1 used for kernbench (kernbench -f -H -M -o 20) other for cpuhog (shell script while 
true with an instruction)

scenario A: unpinned

1x: no hogs
2x: 8hogs in one guest
3x: 8hogs each in two guest

Result for Non PLE machine :
Machine : IBM xSeries with Intel(R) Xeon(R) x5570 2.93GHz CPU with 8 core , 64GB RAM
		 BASE                    BASE+patch            %improvement
		 mean (sd)               mean (sd)
Scenario A:	 			
case 1x:	 157.548 (10.624) 	 156.408 (11.1622) 	0.723589
case 2x:	 1110.18 (807.019) 	 310.96 (105.194) 	71.9901
case 3x:	 3110.36 (2408.03) 	 303.688 (110.474) 	90.2362

Result for PLE machine:
Machine : IBM xSeries with Intel(R) Xeon(R)  X7560 2.27GHz CPU with 32/64 core, with 8  
         online cores and 4*64GB RAM

		 BASE                    BASE+patch            %improvement
		 mean (sd)               mean (sd)
Scenario A:	 			
case 1x:	 159.725 (47.4906) 	 159.07 (47.8133) 	0.41008
case 2x:	 190.957 (49.2976) 	 187.273 (50.5469) 	1.92923
case 3x:	 226.317 (88.6023) 	 223.698 (90.4362) 	1.15723

---
 13 files changed, 454 insertions(+), 112 deletions(-)
 arch/x86/Kconfig                |    9 ++
 arch/x86/include/asm/kvm_para.h |   17 +++-
 arch/x86/kernel/kvm.c           |  247 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |   28 +++++-
 arch/x86/xen/debugfs.c          |  104 ----------------
 arch/x86/xen/debugfs.h          |    4 -
 arch/x86/xen/spinlock.c         |    2 +-
 fs/debugfs/file.c               |  128 ++++++++++++++++++++
 include/linux/debugfs.h         |   11 ++
 include/linux/kvm.h             |    1 +
 include/linux/kvm_host.h        |    5 +
 include/linux/kvm_para.h        |    1 +
 virt/kvm/kvm_main.c             |    7 +
 13 files changed, 452 insertions(+), 112 deletions(-)

