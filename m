Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0EKQVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:21:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab0EKQV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:21:27 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, zamsden@redhat.com
Subject: [PATCH 5/9] export paravirtual cpuid flags in KVM_GET_SUPPORTED_CPUID
Date: Tue, 11 May 2010 12:17:43 -0400
Message-Id: <1273594667-17175-6-git-send-email-glommer@redhat.com>
In-Reply-To: <1273594667-17175-5-git-send-email-glommer@redhat.com>
References: <1273594667-17175-1-git-send-email-glommer@redhat.com>
 <1273594667-17175-2-git-send-email-glommer@redhat.com>
 <1273594667-17175-3-git-send-email-glommer@redhat.com>
 <1273594667-17175-4-git-send-email-glommer@redhat.com>
 <1273594667-17175-5-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, we were using individual KVM_CAP entities to communicate
userspace about which cpuids we support. This is suboptimal, since it
generates a delay between the feature arriving in the host, and
being available at the guest.

A much better mechanism is to list para features in KVM_GET_SUPPORTED_CPUID.
This makes userspace automatically aware of what we provide. And if we
ever add a new cpuid bit in the future, we have to do that again,
which create some complexity and delay in feature adoption.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/kvm/x86.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb84947..a51b560 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1971,6 +1971,23 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		}
 		break;
 	}
+	case KVM_CPUID_SIGNATURE: {
+		char signature[12] = "KVMKVMKVM\0\0";
+		u32 *sigptr = (u32 *)signature;
+		entry->eax = 0;
+		entry->ebx = sigptr[0];
+		entry->ecx = sigptr[1];
+		entry->edx = sigptr[2];
+		break;
+	}
+	case KVM_CPUID_FEATURES:
+		entry->eax = (1 << KVM_FEATURE_CLOCKSOURCE) |
+			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
+			     (1 << KVM_FEATURE_CLOCKSOURCE2);
+		entry->ebx = 0;
+		entry->ecx = 0;
+		entry->edx = 0;
+		break;
 	case 0x80000000:
 		entry->eax = min(entry->eax, 0x8000001a);
 		break;
@@ -2017,6 +2034,23 @@ static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 	for (func = 0x80000001; func <= limit && nent < cpuid->nent; ++func)
 		do_cpuid_ent(&cpuid_entries[nent], func, 0,
 			     &nent, cpuid->nent);
+
+	
+
+	r = -E2BIG;
+	if (nent >= cpuid->nent)
+		goto out_free;
+
+	do_cpuid_ent(&cpuid_entries[nent], KVM_CPUID_SIGNATURE, 0, &nent,
+		     cpuid->nent);
+
+	r = -E2BIG;
+	if (nent >= cpuid->nent)
+		goto out_free;
+
+	do_cpuid_ent(&cpuid_entries[nent], KVM_CPUID_FEATURES, 0, &nent,
+		     cpuid->nent);
+
 	r = -E2BIG;
 	if (nent >= cpuid->nent)
 		goto out_free;
-- 
1.6.2.2

