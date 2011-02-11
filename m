Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab1BKSVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:21:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255Ab1BKSVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:21:24 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH v3 1/6] KVM-HDR: KVM Steal time implementation
Date: Fri, 11 Feb 2011 13:19:19 -0500
Message-Id: <1297448364-14051-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1297448364-14051-1-git-send-email-glommer@redhat.com>
References: <1297448364-14051-1-git-send-email-glommer@redhat.com>
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
---
 arch/x86/include/asm/kvm_para.h |    9 +++++++++
 include/linux/kvm.h             |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index a427bf7..8ba33ed 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -21,6 +21,7 @@
  */
 #define KVM_FEATURE_CLOCKSOURCE2        3
 #define KVM_FEATURE_ASYNC_PF		4
+#define KVM_FEATURE_STEAL_TIME		5
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
@@ -34,6 +35,14 @@
 #define MSR_KVM_WALL_CLOCK_NEW  0x4b564d00
 #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
+#define MSR_KVM_STEAL_TIME  0x4b564d03
+
+struct kvm_steal_time {
+	__u64 steal;
+	__u32 version;
+	__u32 flags;
+	__u32 pad[6];
+};
 
 #define KVM_MAX_MMU_OP_BATCH           32
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ea2dc1a..233374a 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -541,6 +541,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_PPC_GET_PVINFO 57
 #define KVM_CAP_PPC_IRQ_LEVEL 58
 #define KVM_CAP_ASYNC_PF 59
+#define KVM_CAP_STEAL_TIME 60
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.7.2.3

