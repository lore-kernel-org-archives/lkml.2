Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab2CWIJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:09:49 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56723 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab2CWIJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:09:37 -0400
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
Date: Fri, 23 Mar 2012 13:38:58 +0530
Message-Id: <20120323080855.14568.84830.sendpatchset@codeblue>
In-Reply-To: <20120323080503.14568.43092.sendpatchset@codeblue>
References: <20120323080503.14568.43092.sendpatchset@codeblue>
Subject: [PATCH RFC V5 6/6] Documentation/kvm : Add documentation on Hypercalls and features used for PV spinlock
x-cbid: 12032222-0260-0000-0000-000000BD8EF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> 

KVM_HC_KICK_CPU  hypercall added to wakeup halted vcpu in paravirtual spinlock
enabled guest.

KVM_FEATURE_PV_UNHALT enables guest to check whether pv spinlock can be enabled
in guest. support in host is queried via
ioctl(KVM_CHECK_EXTENSION, KVM_CAP_PV_UNHALT)

Thanks Alex for KVM_HC_FEATURES inputs and Vatsa for rewriting KVM_HC_KICK_CPU

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
---
diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index e1d94bf..cf8bf3b 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1109,6 +1109,13 @@ support.  Instead it is reported via
 if that returns true and you use KVM_CREATE_IRQCHIP, or if you emulate the
 feature in userspace, then you can enable the feature for KVM_SET_CPUID2.
 
+Paravirtualized ticket spinlocks can be enabled in guest by checking whether
+support exists in host via,
+
+  ioctl(KVM_CHECK_EXTENSION, KVM_CAP_PV_UNHALT)
+
+if this call return true, guest can use the feature.
+
 4.47 KVM_PPC_GET_PVINFO
 
 Capability: KVM_CAP_PPC_GET_PVINFO
diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
index 8820685..062dff9 100644
--- a/Documentation/virtual/kvm/cpuid.txt
+++ b/Documentation/virtual/kvm/cpuid.txt
@@ -39,6 +39,10 @@ KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
 KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
                                    ||       || writing to msr 0x4b564d02
 ------------------------------------------------------------------------------
+KVM_FEATURE_PV_UNHALT              ||     6 || guest checks this feature bit
+                                   ||       || before enabling paravirtualized
+                                   ||       || spinlock support.
+------------------------------------------------------------------------------
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT ||    24 || host will warn if no guest-side
                                    ||       || per-cpu warps are expected in
                                    ||       || kvmclock.
diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
new file mode 100644
index 0000000..c9e8b9c
--- /dev/null
+++ b/Documentation/virtual/kvm/hypercalls.txt
@@ -0,0 +1,59 @@
+KVM Hypercalls Documentation
+===========================
+Template for documentation is
+The documenenation for hypercalls should inlcude
+1. Hypercall name, value.
+2. Architecture(s)
+3. status (deprecated, obsolete, active)
+4. Purpose
+
+
+1. KVM_HC_VAPIC_POLL_IRQ
+------------------------
+value: 1
+Architecture: x86
+Purpose:
+
+2. KVM_HC_MMU_OP
+------------------------
+value: 2
+Architecture: x86
+status: deprecated.
+Purpose: Support MMU operations such as writing to PTE,
+flushing TLB, release PT.
+
+3. KVM_HC_FEATURES
+------------------------
+value: 3
+Architecture: PPC
+Purpose: Expose hypercall availability to the guest. On x86 platforms, cpuid
+used to enumerate which hypercalls are available. On PPC, either device tree
+based lookup ( which is also what EPAPR dictates) OR KVM specific enumeration
+mechanism (which is this hypercall) can be used.
+
+4. KVM_HC_PPC_MAP_MAGIC_PAGE
+------------------------
+value: 4
+Architecture: PPC
+Purpose: To enable communication between the hypervisor and guest there is a
+shared page that contains parts of supervisor visible register state.
+The guest can map this shared page to access its supervisor register through
+memory using this hypercall.
+
+5. KVM_HC_KICK_CPU
+------------------------
+value: 5
+Architecture: x86
+Purpose: Hypercall used to wakeup a vcpu from HLT state
+
+Usage example : A vcpu of a paravirtualized guest that is busywaiting in guest
+kernel mode for an event to occur (ex: a spinlock to become available) can
+execute HLT instruction once it has busy-waited for more than a threshold
+time-interval. Execution of HLT instruction would cause the hypervisor to put
+the vcpu to sleep until occurence of an appropriate event. Another vcpu of the
+same guest can wakeup the sleeping vcpu by issuing KVM_HC_KICK_CPU hypercall,
+specifying APIC ID of the vcpu to be wokenup.
+
+TODO:
+1. more information on input and output needed?
+2. Add more detail to purpose of hypercalls.
diff --git a/Documentation/virtual/kvm/msr.txt b/Documentation/virtual/kvm/msr.txt
index 5031780..a7662d3 100644
--- a/Documentation/virtual/kvm/msr.txt
+++ b/Documentation/virtual/kvm/msr.txt
@@ -219,3 +219,12 @@ MSR_KVM_STEAL_TIME: 0x4b564d03
 		steal: the amount of time in which this vCPU did not run, in
 		nanoseconds. Time during which the vcpu is idle, will not be
 		reported as steal time.
+
+MSR_KVM_PV_UNHALT: 0x4b564d04
+	data: 32 bit flag indicating the paravirtual unhalt state of the VCPU.
+	This data is not expected to reside in guest memory. The unhalt state
+	indicates that corresponding VCPU (halted for some reason) is ready for
+	unhalt operation.
+
+	This data is expected to be filled only via ioctl. This is needed for
+	live migration of virtual machine.

