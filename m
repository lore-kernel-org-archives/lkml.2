Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab1JWTDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 15:03:33 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:59152 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1JWTDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 15:03:31 -0400
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
Cc: Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Date: Mon, 24 Oct 2011 00:33:08 +0530
Message-Id: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH RFC V2 0/5] kvm : Paravirt-spinlock support for KVM guests
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 5-patch series to follow this email extends KVM-hypervisor and Linux guest 
running on KVM-hypervisor to support pv-ticket spinlocks, based heavily on Xen's implementation.

Two hypercalls are being introduced in KVM hypervisor, one that allows a
vcpu (spinning on a lock) to block and another that allows a vcpu to kick
another out of blocking state.

This is discussed in : (posted by Srivatsa V).
https://lkml.org/lkml/2010/7/26/24
https://lkml.org/lkml/2011/1/19/212

The BASE patch is tip rc9 + Jeremy's following patches.
compare exchange (https://lkml.org/lkml/2011/8/29/321), 
xadd (https://lkml.org/lkml/2011/10/4/328)
x86/ticketlocklock  (https://lkml.org/lkml/2011/10/12/496).

Changes since last posting:
- rebased patchesto -rc9
- synchronization related changes based on Jeremy's changes (Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>) pointed by
Stephan Diestelhorst <stephan.diestelhorst@amd.com>
- enabling 32 bit guests
- splitted patches into two more chunks

Results:

set up : 
Kernel for host/guest : 3.1-rc9 + Jeremys ticketlock cleanup, xadd, pv spinlock patches as BASE

3 guests with 8VCPU, 4GB RAM, 1 used for kernbench (kernbench -f -H -M -o 20) other for cpuhog (shell script while 
true with an instruction)

scenario A: unpinned
scenario B: each vcpu pinned to corresponding cpu

1x: no hogs
2x: 8hogs in one guest
3x: 8hogs each in two guest

Result for Non PLE machine :
Machine : IBM xSeries with Intel(R) Xeon(R) x5570 2.93GHz CPU with 8 core , 64GB RAM
		 BASE                    BASE+patch            %improvement
		 mean (sd)               mean (sd)
Scenario A:	 			
case 1x:	 157.495 (15.2924) 	 148.355 (7.35479) 	5.80336
case 2x:	 761.955 (581.384) 	 247.306 (64.4707) 	67.5432
case 3x:	 2804.36 (2613.57) 	 261.522 (85.0856) 	90.6744

Scenario B				
case 1x:	 1241.86 (812.155) 	 313.805 (140.99) 	74.731
case 2x:	 1277.32 (771.316) 	 308.325 (124.808) 	75.8616
case 3x:	 1239.45 (860.012) 	 307.535 (124.243) 	75.1878

Result for PLE machine:
Machine : IBM xSeries with Intel(R) Xeon(R)  X7560 2.27GHz CPU with 32/64 core, with 8  
         online cores and 4*64GB RAM

		 BASE                    BASE+patch            %improvement
		 mean (sd)               mean (sd)
Scenario A:	 			
case 1x:	 72.7133 (43.7109) 	 70.0734 (37.7866) 	3.63056
case 2x:	 124.138 (79.9515) 	 119.28 (81.3597) 	3.91339
case 3x:	 174.561 (132.209) 	 159.283 (116.232) 	8.75224

Scenario B				
case 1x:	 166.101 (119.313) 	 160.056 (117.446) 	3.63935
case 2x:	 167.421 (120.767) 	 158.133 (115.022) 	5.54769
case 3x:	 169.317 (122.088) 	 159.353 (116.737) 	5.88482

 Srivatsa Vaddagiri, Suzuki Poulose, Raghavendra K T (5): 
  Add debugfs support to print u32-arrays in debugfs
  Renaming of xen functions and change unsigned to u32
  Add two hypercalls to KVM hypervisor to support pv-ticketlocks
  Added configuration support to enable debug information for KVM Guests
  pv-ticketlocks support for linux guests running on KVM hypervisor
 
 arch/x86/Kconfig                |    9 ++
 arch/x86/include/asm/kvm_para.h |   12 ++-
 arch/x86/kernel/head32.c        |    3 +
 arch/x86/kernel/head64.c        |    3 +
 arch/x86/kernel/kvm.c           |  247 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |   67 +++++++++++-
 arch/x86/xen/debugfs.c          |  104 ----------------
 arch/x86/xen/debugfs.h          |    4 -
 arch/x86/xen/spinlock.c         |    2 +-
 fs/debugfs/file.c               |  108 +++++++++++++++++
 include/linux/debugfs.h         |   11 ++
 include/linux/kvm.h             |    1 +
 include/linux/kvm_host.h        |    5 +
 include/linux/kvm_para.h        |    2 +
 virt/kvm/kvm_main.c             |    1 +
 15 files changed, 468 insertions(+), 111 deletions(-)
---
