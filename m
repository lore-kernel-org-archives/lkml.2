Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0DOSjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:39:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab0DOSjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:39:10 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH 4/5] export new cpuid KVM_CAP
Date: Thu, 15 Apr 2010 14:37:27 -0400
Message-Id: <1271356648-5108-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1271356648-5108-4-git-send-email-glommer@redhat.com>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
 <1271356648-5108-2-git-send-email-glommer@redhat.com>
 <1271356648-5108-3-git-send-email-glommer@redhat.com>
 <1271356648-5108-4-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we're changing the msrs kvmclock uses, we have to communicate
that to the guest, through cpuid. We can add a new KVM_CAP to the
hypervisor, and then patch userspace to recognize it.

And if we ever add a new cpuid bit in the future, we have to do that again,
which create some complexity and delay in feature adoption.

Instead, what I'm proposing in this patch is a new capability, called
KVM_CAP_X86_CPUID_FEATURE_LIST, that returns the current feature list
currently supported by the hypervisor. If we ever want to add or remove
some feature, we only need to tweak into the HV, leaving userspace untouched.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/kvm/x86.c  |    6 ++++++
 include/linux/kvm.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 714aae2..74f0dc3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1545,6 +1545,12 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_MCE:
 		r = KVM_MAX_MCE_BANKS;
 		break;
+	case KVM_CAP_X86_CPUID_FEATURE_LIST:
+		r = (1 << KVM_FEATURE_CLOCKSOURCE) |
+		(1 << KVM_FEATURE_NOP_IO_DELAY) |
+		(1 << KVM_FEATURE_MMU_OP) |
+		(1 << KVM_FEATURE_CLOCKSOURCE2);
+		break;
 	default:
 		r = 0;
 		break;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ce28767..1ce124f 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -507,6 +507,7 @@ struct kvm_ioeventfd {
 #define KVM_CAP_DEBUGREGS 50
 #endif
 #define KVM_CAP_X86_ROBUST_SINGLESTEP 51
+#define KVM_CAP_X86_CPUID_FEATURE_LIST 52
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.6.2.2

