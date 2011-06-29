Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab1F2PiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:38:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061Ab1F2PiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:38:05 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH v3 3/9] KVM-HDR: KVM Steal time implementation
Date: Wed, 29 Jun 2011 11:29:42 -0400
Message-Id: <1309361388-30163-4-git-send-email-glommer@redhat.com>
In-Reply-To: <1309361388-30163-1-git-send-email-glommer@redhat.com>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To implement steal time, we need the hypervisor to pass the guest information
about how much time was spent running other processes outside the VM.
This is per-vcpu, and using the kvmclock structure for that is an abuse
we decided not to make.

In this patchset, I am introducing a new msr, KVM_MSR_STEAL_TIME, that
holds the memory area address containing information about steal time

This patch contains the headers for it. I am keeping it separate to facilitate
backports to people who wants to backport the kernel part but not the
hypervisor, or the other way around.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <aliguori@us.ibm.com>
CC: Eric B Munson <emunson@mgebm.net>
---
 Documentation/virtual/kvm/msr.txt |   33 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_para.h   |    9 +++++++++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/Documentation/virtual/kvm/msr.txt b/Documentation/virtual/kvm/msr.txt
index d079aed..fab9b30 100644
--- a/Documentation/virtual/kvm/msr.txt
+++ b/Documentation/virtual/kvm/msr.txt
@@ -185,3 +185,36 @@ MSR_KVM_ASYNC_PF_EN: 0x4b564d02
 
 	Currently type 2 APF will be always delivered on the same vcpu as
 	type 1 was, but guest should not rely on that.
+
+MSR_KVM_STEAL_TIME: 0x4b564d03
+
+	data: 64-byte alignment physical address of a memory area which must be
+	in guest RAM, plus an enable bit in bit 0. This memory is expected to
+	hold a copy of the following structure:
+
+	struct kvm_steal_time {
+	  	__u64 steal;
+ 		__u32 version;
+ 		__u32 flags;
+	 	__u32 pad[12];
+	}
+
+	whose data will be filled in by the hypervisor periodically. Only one
+	write, or registration, is needed for each VCPU. The interval between
+	updates of this structure is arbitrary and implementation-dependent.
+	The hypervisor may update this structure at any time it sees fit until
+	anything with bit0 == 0 is written to it. Guest is required to make sure
+	this structure is initialized to zero.
+
+	Fields have the following meanings:
+
+		version: guest has to check version before and after grabbing
+		time information and check that they are both equal and even.
+		An odd version indicates an in-progress update.
+
+		flags: At this point, always zero. May be used to indicate
+		changes in this structure in the future.
+
+		steal: the amount of time in which this vCPU did not run, in
+		nanoseconds.
+
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index d6cd79b..65f8bb9 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -21,6 +21,7 @@
  */
 #define KVM_FEATURE_CLOCKSOURCE2        3
 #define KVM_FEATURE_ASYNC_PF		4
+#define KVM_FEATURE_STEAL_TIME		5
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
@@ -35,6 +36,14 @@
 #define MSR_KVM_WALL_CLOCK_NEW  0x4b564d00
 #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
+#define MSR_KVM_STEAL_TIME  0x4b564d03
+
+struct kvm_steal_time {
+	__u64 steal;
+	__u32 version;
+	__u32 flags;
+	__u32 pad[12];
+};
 
 #define KVM_MAX_MMU_OP_BATCH           32
 
-- 
1.7.3.4

