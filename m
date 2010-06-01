Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab0FAMbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:31:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab0FAMbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:31:04 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, zamsden@redhat.com
Subject: [PATCH v4] Add Documentation/kvm/msr.txt
Date: Tue,  1 Jun 2010 08:22:48 -0400
Message-Id: <1275394968-16168-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a file that documents the usage of KVM-specific
MSRs.

[ v2: added comments from Randy ]
[ v3: added comments from Avi ]
[ v4: added information about wallclock alignment ]

Signed-off-by: Glauber Costa <glommer@redhat.com>
Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kvm/msr.txt |  153 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 153 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/kvm/msr.txt

diff --git a/Documentation/kvm/msr.txt b/Documentation/kvm/msr.txt
new file mode 100644
index 0000000..a8502e3
--- /dev/null
+++ b/Documentation/kvm/msr.txt
@@ -0,0 +1,153 @@
+KVM-specific MSRs.
+Glauber Costa <glommer@redhat.com>, Red Hat Inc, 2010
+=====================================================
+
+KVM makes use of some custom MSRs to service some requests.
+At present, this facility is only used by kvmclock.
+
+Custom MSRs have a range reserved for them, that goes from
+0x4b564d00 to 0x4b564dff. There are MSRs outside this area,
+but they are deprecated and their use is discouraged.
+
+Custom MSR list
+--------
+
+The current supported Custom MSR list is:
+
+MSR_KVM_WALL_CLOCK_NEW:   0x4b564d00
+
+	data: 4-byte alignement physical address of a memory area which must be
+	in guest RAM. This memory is expected to hold a copy of the following
+	structure:
+
+	struct pvclock_wall_clock {
+		u32   version;
+		u32   sec;
+		u32   nsec;
+	} __attribute__((__packed__));
+
+	whose data will be filled in by the hypervisor. The hypervisor is only 
+	guaranteed to update this data at the moment of MSR write.
+	Users that want to reliably query this information more than once have
+	to write more than once to this MSR. Fields have the following meanings:
+
+		version: guest has to check version before and after grabbing
+		time information and check that they are both equal and even.
+		An odd version indicates an in-progress update.
+
+		sec: number of seconds for wallclock.
+
+		nsec: number of nanoseconds for wallclock.
+
+	Note that although MSRs are per-CPU entities, the effect of this
+	particular MSR is global.
+
+	Availability of this MSR must be checked via bit 3 in 0x4000001 cpuid
+	leaf prior to usage. 
+
+MSR_KVM_SYSTEM_TIME_NEW:  0x4b564d01
+
+	data: 4-byte aligned physical address of a memory area which must be in
+	guest RAM, plus an enable bit in bit 0. This memory is expected to hold
+	a copy of the following structure:
+
+	struct pvclock_vcpu_time_info {
+		u32   version;
+		u32   pad0;
+		u64   tsc_timestamp;
+		u64   system_time;
+		u32   tsc_to_system_mul;
+		s8    tsc_shift;
+		u8    flags;
+		u8    pad[2];
+	} __attribute__((__packed__)); /* 32 bytes */
+
+	whose data will be filled in by the hypervisor periodically. Only one
+	write, or registration, is needed for each VCPU. The interval between
+	updates of this structure is arbitrary and implementation-dependent.
+	The hypervisor may update this structure at any time it sees fit until
+	anything with bit0 == 0 is written to it.
+
+	Fields have the following meanings:
+
+		version: guest has to check version before and after grabbing
+		time information and check that they are both equal and even.
+		An odd version indicates an in-progress update.
+
+		tsc_timestamp: the tsc value at the current VCPU at the time
+		of the update of this structure. Guests can subtract this value
+		from current tsc to derive a notion of elapsed time since the
+		structure update.
+
+		system_time: a host notion of monotonic time, including sleep
+		time at the time this structure was last updated. Unit is
+		nanoseconds.
+
+		tsc_to_system_mul: a function of the tsc frequency. One has
+		to multiply any tsc-related quantity by this value to get
+		a value in nanoseconds, besides dividing by 2^tsc_shift
+
+		tsc_shift: cycle to nanosecond divider, as a power of two, to
+		allow for shift rights. One has to shift right any tsc-related
+		quantity by this value to get a value in nanoseconds, besides
+		multiplying by tsc_to_system_mul.
+
+		With this information, guests can derive per-CPU time by
+		doing:
+
+			time = (current_tsc - tsc_timestamp)
+			time = (time * tsc_to_system_mul) >> tsc_shift 
+			time = time + system_time
+
+		flags: bits in this field indicate extended capabilities
+		coordinated between the guest and the hypervisor. Availability
+		of specific flags has to be checked in 0x40000001 cpuid leaf.
+		Current flags are:
+
+		 flag bit   | cpuid bit    | meaning
+		-------------------------------------------------------------
+			    |	           | time measures taken across
+		     0      |	   24      | multiple cpus are guaranteed to
+			    |		   | be monotonic
+		-------------------------------------------------------------
+
+	Availability of this MSR must be checked via bit 3 in 0x4000001 cpuid
+	leaf prior to usage. 
+
+
+MSR_KVM_WALL_CLOCK:  0x11
+
+	data and functioning: same as MSR_KVM_WALL_CLOCK_NEW. Use that instead.
+
+	This MSR falls outside the reserved KVM range and may be removed in the
+	future. Its usage is deprecated.
+
+	Availability of this MSR must be checked via bit 0 in 0x4000001 cpuid
+	leaf prior to usage. 
+
+MSR_KVM_SYSTEM_TIME: 0x12
+
+	data and functioning: same as MSR_KVM_SYSTEM_TIME_NEW. Use that instead.
+
+	This MSR falls outside the reserved KVM range and may be removed in the
+	future. Its usage is deprecated.
+
+	Availability of this MSR must be checked via bit 0 in 0x4000001 cpuid
+	leaf prior to usage. 
+
+	The suggested algorithm for detecting kvmclock presence is then:
+
+		if (!kvm_para_available())    /* refer to cpuid.txt */
+			return NON_PRESENT;
+
+		flags = cpuid_eax(0x40000001);
+		if (flags & 3) {
+			msr_kvm_system_time = MSR_KVM_SYSTEM_TIME_NEW;
+			msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK_NEW;
+			return PRESENT;
+		} else if (flags & 0) {
+			msr_kvm_system_time = MSR_KVM_SYSTEM_TIME;
+			msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK;
+			return PRESENT;
+		} else
+			return NON_PRESENT;
-- 
1.6.2.2

