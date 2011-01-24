Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1AXSLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:11:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab1AXSHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:07:51 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH 03/16] KVM-HDR: KVM Userspace registering ioctl
Date: Mon, 24 Jan 2011 13:06:24 -0500
Message-Id: <1295892397-11354-4-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-1-git-send-email-glommer@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM, which stands for KVM Virtual Memory (I wanted to call it KVM Virtual Mojito),
is a piece of shared memory that is visible to both the hypervisor and the guest
kernel - but not the guest userspace.

The basic idea is that the guest can tell the hypervisor about a specific
piece of memory, and what it expects to find in there. This is a generic
abstraction, that goes to userspace (qemu) if KVM (the hypervisor) can't
handle a specific request, thus giving us flexibility in some features
in the future.

KVM (The hypervisor) can change the contents of this piece of memory at
will. This works well with paravirtual information, and hopefully
normal guest memory - like last update time for the watchdog, for
instance.

This patch contains the header part of the userspace communication implementation.
Userspace can query the presence/absence of this feature in the normal way.
It also tells the hypervisor that it is capable of handling - in whatever
way it chooses, registrations that the hypervisor does not know how to.
In x86, only user so far, this mechanism is implemented as generic userspace
msr exit, that could theorectically be used to implement msr-handling in
userspace.

I am keeping the headers separate to facilitate backports to people
who wants to backport the kernel part but not the hypervisor, or the other way around.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm.h      |   14 +++++++++++++-
 include/linux/kvm_host.h |    1 +
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ea2dc1a..5cc4fe8 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -161,6 +161,7 @@ struct kvm_pit_config {
 #define KVM_EXIT_NMI              16
 #define KVM_EXIT_INTERNAL_ERROR   17
 #define KVM_EXIT_OSI              18
+#define KVM_EXIT_X86_MSR_OP	  19
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 #define KVM_INTERNAL_ERROR_EMULATION 1
@@ -264,6 +265,10 @@ struct kvm_run {
 		struct {
 			__u64 gprs[32];
 		} osi;
+		/* KVM_EXIT_X86_MSR_OP */
+		struct {
+			__u64 msr_data;
+		} msr;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -422,6 +427,11 @@ struct kvm_ppc_pvinfo {
 	__u8  pad[108];
 };
 
+struct kvm_area_info {
+	__u8  enabled;
+	__u8  pad[3];
+};
+
 #define KVMIO 0xAE
 
 /*
@@ -541,6 +551,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_PPC_GET_PVINFO 57
 #define KVM_CAP_PPC_IRQ_LEVEL 58
 #define KVM_CAP_ASYNC_PF 59
+#define KVM_CAP_REGISTER_MEM_AREA 60
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -677,7 +688,8 @@ struct kvm_clock_data {
 #define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct kvm_pit_state2)
 /* Available with KVM_CAP_PPC_GET_PVINFO */
 #define KVM_PPC_GET_PVINFO	  _IOW(KVMIO,  0xa1, struct kvm_ppc_pvinfo)
-
+#define KVM_USERSPACE_REGISTER_MEM_AREA \
+				  _IOW(KVMIO,  0xa8, struct kvm_area_info)
 /*
  * ioctls for vcpu fds
  */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b5021db..b7b361f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -258,6 +258,7 @@ struct kvm {
 	long mmu_notifier_count;
 #endif
 	long tlbs_dirty;
+	int register_mem_area_uspace;
 };
 
 /* The guest did something we don't support. */
-- 
1.7.2.3

