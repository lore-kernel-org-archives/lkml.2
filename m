Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2H2Xbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 19:31:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35263 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab2H2Xbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 19:31:32 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 1/8] KVM: x86: minor size optimization
Date: Thu, 30 Aug 2012 01:30:13 +0200
Message-Id: <1346283020-22385-2-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
References: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some fields can be constified and/or made static to reduce code and data
size.

Numbers for a 32 bit build:

        text    data     bss     dec     hex filename
before: 3351      80       0    3431     d67 cpuid.o
 after: 3391       0       0    3391     d3f cpuid.o

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/kvm/cpuid.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b496da6..ec79e77 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -397,8 +397,8 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		break;
 	}
 	case KVM_CPUID_SIGNATURE: {
-		char signature[12] = "KVMKVMKVM\0\0";
-		u32 *sigptr = (u32 *)signature;
+		static const char signature[12] = "KVMKVMKVM\0\0";
+		const u32 *sigptr = (const u32 *)signature;
 		entry->eax = KVM_CPUID_FEATURES;
 		entry->ebx = sigptr[0];
 		entry->ecx = sigptr[1];
@@ -484,10 +484,10 @@ struct kvm_cpuid_param {
 	u32 func;
 	u32 idx;
 	bool has_leaf_count;
-	bool (*qualifier)(struct kvm_cpuid_param *param);
+	bool (*qualifier)(const struct kvm_cpuid_param *param);
 };
 
-static bool is_centaur_cpu(struct kvm_cpuid_param *param)
+static bool is_centaur_cpu(const struct kvm_cpuid_param *param)
 {
 	return boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR;
 }
@@ -498,7 +498,7 @@ int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 	struct kvm_cpuid_entry2 *cpuid_entries;
 	int limit, nent = 0, r = -E2BIG, i;
 	u32 func;
-	static struct kvm_cpuid_param param[] = {
+	static const struct kvm_cpuid_param param[] = {
 		{ .func = 0, .has_leaf_count = true },
 		{ .func = 0x80000000, .has_leaf_count = true },
 		{ .func = 0xC0000000, .qualifier = is_centaur_cpu, .has_leaf_count = true },
@@ -517,7 +517,7 @@ int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 
 	r = 0;
 	for (i = 0; i < ARRAY_SIZE(param); i++) {
-		struct kvm_cpuid_param *ent = &param[i];
+		const struct kvm_cpuid_param *ent = &param[i];
 
 		if (ent->qualifier && !ent->qualifier(ent))
 			continue;
-- 
1.7.10.4

