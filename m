Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab2CWIGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:06:48 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:44905 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab2CWIGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:06:37 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 <x86@kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Date: Fri, 23 Mar 2012 13:35:06 +0530
Message-Id: <20120323080503.14568.43092.sendpatchset@codeblue>
Subject: [PATCH RFC V5 0/6] kvm : Paravirt-spinlock support for KVM guests
x-cbid: 12032308-5564-0000-0000-000001F04D29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 6-patch series to follow this email extends KVM-hypervisor and Linux guest
running on KVM-hypervisor to support pv-ticket spinlocks, based on Xen's 
implementation.

One hypercall is introduced in KVM hypervisor,that allows a vcpu to kick
another vcpu out of halt state.
The blocking of vcpu is done using halt() in (lock_spinning) slowpath.
one MSR is added to aid live migration.

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

Test Set up :
The BASE patch is  3.3.0-rc6 + jumplabel split patch (https://lkml.org/lkml/2012/2/21/167)
+  ticketlock cleanup patch (https://lkml.org/lkml/2012/3/21/161)

Results:
 The performance gain is mainly because of reduced busy-wait time.
 From the results we can see that patched kernel performance is similar to
 BASE when there is no lock contention. But once we start seeing more
 contention, patched kernel outperforms BASE.

3 guests with 8VCPU, 8GB RAM, 1 used for kernbench
(kernbench -f -H -M -o 20) other for cpuhog (shell script while
true with an instruction)

1x: no hogs
2x: 8hogs in one guest
3x: 8hogs each in two guest

1) kernbench
Machine : IBM xSeries with Intel(R) Xeon(R) x5570 2.93GHz CPU with 8 core , 64GB RAM
		 BASE                    BASE+patch            %improvement
		 mean (sd)               mean (sd)
case 1x:	 38.1033 (43.502) 	 38.09 (43.4269) 	0.0349051
case 2x:	 778.622 (1092.68) 	 129.342 (156.324) 	83.3883
case 3x:	 2399.11 (3548.32) 	 114.913 (139.5) 	95.2102

2) pgbench:
pgbench version: http://www.postgresql.org/ftp/snapshot/dev/
tool used for benchmarking: git://git.postgresql.org/git/pgbench-tools.git
Ananlysis is done using ministat.
Test is done for 1x overcommit to check overhead of pv spinlock.
There is small performance penalty in non contention scenario (note BASE
is jeremy's ticketlock). But with increase in number of threads, improvement is
seen. 

guest: 64bit 8 vCPU and 8GB RAM
shared buffer size = 2GB
x base_kernel
+ patched_kernel
    N           Min           Max        Median           Avg        Stddev
+--------------------- NRCLIENT = 1 ----------------------------------------+
x  10     7468.0719     7774.0026     7529.9217     7594.9696      128.7725
+  10      7280.413     7650.6619     7425.7968     7434.9344     144.59127
Difference at 95.0% confidence
	-160.035 +/- 128.641
	-2.10712% +/- 1.69376%
+--------------------- NRCLIENT = 2 ----------------------------------------+
x  10     14604.344     14849.358     14725.845     14724.722     76.866294
+  10     14070.064     14246.013     14125.556     14138.169     60.556379
Difference at 95.0% confidence
	-586.553 +/- 65.014
	-3.98346% +/- 0.441529%
+--------------------- NRCLIENT = 4 ----------------------------------------+
x  10     27891.073     28305.466     28059.892     28060.231     115.65612
+  10     27237.685     27639.645      27297.79     27375.966     145.31006
Difference at 95.0% confidence
	-684.265 +/- 123.39
	-2.43856% +/- 0.439734%
+--------------------- NRCLIENT = 8 ----------------------------------------+
x  10     53063.509     53498.677      53343.24     53309.697     138.77983
+  10     51705.708     52208.274      52030.06     51987.067     156.65323
Difference at 95.0% confidence
	-1322.63 +/- 139.048
	-2.48103% +/- 0.26083%
+--------------------- NRCLIENT = 16 ---------------------------------------+
x  10     50043.347     52701.253     52235.978     51993.466     817.44911
+  10     51562.772     52272.412     51905.317     51946.557     228.54314
No difference proven at 95.0% confidence
+--------------------- NRCLIENT = 32 --------------------------------------+
x  10     49178.789     51284.599     50288.185     50275.212     616.80154
+  10     50722.097     52145.041     51551.112     51512.423     469.18898
Difference at 95.0% confidence
	1237.21 +/- 514.888
	2.46088% +/- 1.02414%
+--------------------------------------------------------------------------+

Let me know if you have any sugestion/comments...

---
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
 
Srivatsa Vaddagiri, Suzuki Poulose, Raghavendra K T (6): 
  Add debugfs support to print u32-arrays in debugfs
  Add a hypercall to KVM hypervisor to support pv-ticketlocks
  Add  unhalt msr to aid migration
  Added configuration support to enable debug information for KVM Guests
  pv-ticketlock support for linux guests running on KVM hypervisor
  Add documentation on Hypercalls and features used for PV spinlock

 Documentation/virtual/kvm/api.txt        |    7 +
 Documentation/virtual/kvm/cpuid.txt      |    4 +
 Documentation/virtual/kvm/hypercalls.txt |   59 +++++++
 Documentation/virtual/kvm/msr.txt        |    9 +
 arch/x86/Kconfig                         |    9 +
 arch/x86/include/asm/kvm_para.h          |   18 ++-
 arch/x86/kernel/kvm.c                    |  254 ++++++++++++++++++++++++++++++
 arch/x86/kvm/cpuid.c                     |    3 +-
 arch/x86/kvm/x86.c                       |   40 +++++-
 arch/x86/xen/debugfs.c                   |  104 ------------
 arch/x86/xen/debugfs.h                   |    4 -
 arch/x86/xen/spinlock.c                  |    2 +-
 fs/debugfs/file.c                        |  128 +++++++++++++++
 include/linux/debugfs.h                  |   11 ++
 include/linux/kvm.h                      |    1 +
 include/linux/kvm_host.h                 |    1 +
 include/linux/kvm_para.h                 |    1 +
 virt/kvm/kvm_main.c                      |    4 +
 18 files changed, 545 insertions(+), 114 deletions(-)

