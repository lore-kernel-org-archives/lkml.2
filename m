Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2DWKA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:00:59 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:36044 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab2DWKA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:00:57 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KVM <kvm@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Xen <xen-devel@lists.xensource.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 23 Apr 2012 15:30:34 +0530
Message-Id: <20120423100034.30893.81866.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com>
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V6 5/5] Documentation/kvm : Add documentation on Hypercalls and features used for PV spinlock
x-cbid: 12042223-7014-0000-0000-000000F74429
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

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 6386f8c..7e2eba0 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1119,6 +1119,13 @@ support.  Instead it is reported via
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

