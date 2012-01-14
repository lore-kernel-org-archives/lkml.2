Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab2ANS0l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 13:26:41 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57885 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199Ab2ANS0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 13:26:21 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Glauber Costa <glommer@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Rik van Riel <riel@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, X86 <x86@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Paul Mackerras <paulus@samba.org>, Sedat Dilek <sedat.dilek@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Rob Landley <rlandley@parallels.com>,
        Xen <xen-devel@lists.xensource.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Date: Sat, 14 Jan 2012 23:55:02 +0530
Message-Id: <20120114182501.8604.68416.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH RFC V4 0/5] kvm : Paravirt-spinlock support for KVM guests
x-cbid: 12011418-1976-0000-0000-00000980BE9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 5-patch series to follow this email extends KVM-hypervisor and Linux guest 
running on KVM-hypervisor to support pv-ticket spinlocks, based on Xen's implementation.

One hypercall is introduced in KVM hypervisor,that allows a vcpu to kick
another vcpu out of halt state.
The blocking of vcpu is done using halt() in (lock_spinning) slowpath.

Changes in V4:
- reabsed to 3.2.0 pre.
- use APIC ID for kicking the vcpu and use kvm_apic_match_dest for matching. (Avi)
- fold vcpu->kicked flag into vcpu->requests (KVM_REQ_PVLOCK_KICK) and related 
  changes for UNHALT path to make pv ticket spinlock migration friendly. (Avi, Marcello)
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

 Srivatsa Vaddagiri, Suzuki Poulose, Raghavendra K T (5): 
  Add debugfs support to print u32-arrays in debugfs
  Add a hypercall to KVM hypervisor to support pv-ticketlocks
  Added configuration support to enable debug information for KVM Guests
  pv-ticketlocks support for linux guests running on KVM hypervisor
  Add documentation on Hypercalls and features used for PV spinlock
 
Test Set up :
The BASE patch is pre 3.2.0 + Jeremy's following patches.
xadd (https://lkml.org/lkml/2011/10/4/328)
x86/ticketlocklock  (https://lkml.org/lkml/2011/10/12/496).
Kernel for host/guest : 3.2.0 + Jeremy's xadd, pv spinlock patches as BASE
(Note:locked add change is not taken yet)

Results:
 The performance gain is mainly because of reduced busy-wait time.
 From the results we can see that patched kernel performance is similar to
 BASE when there is no lock contention. But once we start seeing more
 contention, patched kernel outperforms BASE (non PLE).
 On PLE machine we do not see greater performance improvement because of PLE
 complimenting halt()

3 guests with 8VCPU, 4GB RAM, 1 used for kernbench
(kernbench -f -H -M -o 20) other for cpuhog (shell script while
true with an instruction)

scenario A: unpinned

1x: no hogs
2x: 8hogs in one guest
3x: 8hogs each in two guest

scenario B: unpinned, run kernbench on all the guests no hogs.

Dbench on PLE machine:
dbench run on all the guest simultaneously with
dbench --warmup=30 -t 120 with NRCLIENTS=(8/16/32).

Result for Non PLE machine :
============================
Machine : IBM xSeries with Intel(R) Xeon(R) x5570 2.93GHz CPU with 8 core , 64GB RAM
		 BASE                    BASE+patch            %improvement
		 mean (sd)               mean (sd)
Scenario A:
case 1x:	 164.233 (16.5506) 	 163.584 (15.4598 	0.39517
case 2x:	 897.654 (543.993) 	 328.63 (103.771) 	63.3901
case 3x:	 2855.73 (2201.41) 	 315.029 (111.854) 	88.9685

Dbench:
Throughput is in MB/sec
NRCLIENTS	 BASE                    BASE+patch            %improvement
               	 mean (sd)               mean (sd)
8       	1.774307  (0.061361) 	1.725667  (0.034644) 	-2.74135
16      	1.445967  (0.044805) 	1.463173  (0.094399) 	1.18993
32        	2.136667  (0.105717) 	2.193792  (0.129357) 	2.67356

Result for PLE machine:
======================
Machine : IBM xSeries with Intel(R) Xeon(R)  X7560 2.27GHz CPU with 32/64 core, with 8
         online cores and 4*64GB RAM

Kernbench:
		 BASE                    BASE+patch            %improvement
		 mean (sd)               mean (sd)
Scenario A:	 			
case 1x:	 161.263 (56.518) 	 159.635 (40.5621) 	1.00953
case 2x:	 190.748 (61.2745) 	 190.606 (54.4766) 	0.0744438
case 3x:	 227.378 (100.215) 	 225.442 (92.0809) 	0.851446

Scenario B:
		 446.104 (58.54 )	 433.12733 (54.476)	2.91

Dbench:
Throughput is in MB/sec
NRCLIENTS	 BASE                    BASE+patch            %improvement
               	 mean (sd)               mean (sd)
8       	1.101190  (0.875082) 	1.700395  (0.846809) 	54.4143
16      	1.524312  (0.120354) 	1.477553  (0.058166) 	-3.06755
32        	2.143028  (0.157103) 	2.090307  (0.136778) 	-2.46012

---
 V3 kernel Changes:
 https://lkml.org/lkml/2011/11/30/62
 V2 kernel changes : 
 https://lkml.org/lkml/2011/10/23/207

 Previous discussions : (posted by Srivatsa V).
 https://lkml.org/lkml/2010/7/26/24
 https://lkml.org/lkml/2011/1/19/212
 
 Qemu patch for V3:
 http://lists.gnu.org/archive/html/qemu-devel/2011-12/msg00397.html

 Documentation/virtual/kvm/api.txt        |    7 +
 Documentation/virtual/kvm/cpuid.txt      |    4 +
 Documentation/virtual/kvm/hypercalls.txt |   54 +++++++
 arch/x86/Kconfig                         |    9 +
 arch/x86/include/asm/kvm_para.h          |   16 ++-
 arch/x86/kernel/kvm.c                    |  249 ++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                       |   37 ++++-
 arch/x86/xen/debugfs.c                   |  104 -------------
 arch/x86/xen/debugfs.h                   |    4 -
 arch/x86/xen/spinlock.c                  |    2 +-
 fs/debugfs/file.c                        |  128 +++++++++++++++
 include/linux/debugfs.h                  |   11 ++
 include/linux/kvm.h                      |    1 +
 include/linux/kvm_host.h                 |    1 +
 include/linux/kvm_para.h                 |    1 +
 15 files changed, 514 insertions(+), 114 deletions(-)

