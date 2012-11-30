Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab2K3RUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:20:34 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42142 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430Ab2K3RU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:20:29 -0500
MIME-Version: 1.0
In-Reply-To: <CACz=WefC5ZKOf9rh-puHNgTsVDpS+_XWLcgRfvyv5wt3R0KT5g@mail.gmail.com>
References: <CACz=WefC5ZKOf9rh-puHNgTsVDpS+_XWLcgRfvyv5wt3R0KT5g@mail.gmail.com>
Date: Fri, 30 Nov 2012 15:20:27 -0200
Message-ID: <CACz=WecbxF3ccS5brqqh1HfCJQeLViRfpp1UHtw9yZY8Fm1BKA@mail.gmail.com>
Subject: [PATCH 1/1] arch/x86/kvm/cpuid.c: cpuid_maxphyaddr "bad" handling.
From: Raphael S Carvalho <raphael.scarv@gmail.com>
To: avi@redhat.com, mtosatti@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, the below function reports the physical-address width supported
by the processor.
It does its work very well, though I found a detail which it doesn't
handle at all.

PS: The following function is not a patch.
int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
{
        struct kvm_cpuid_entry2 *best;

        best = kvm_find_cpuid_entry(vcpu, 0x80000000, 0);
        if (!best || best->eax < 0x80000008)
                goto not_found;
        best = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
        if (best)
                return best->eax & 0xff;
not_found:
        return 36;
}

As I'm seeing, its(above function) first step is to check whether the
CPU provides the CPUID function 80000008H,
if so, it gets the physical-address width from the available CPUID
function, otherwise it implicitly returns 36.

Intel manual says the following:
"For processors that do not support CPUID function 80000008H, the
width is generally 36 if CPUID.01H:EDX.PAE [bit 6] = 1
and 32 otherwise."
According to the above-mentioned statement, we would have to return 32
whether PAE is not supported by the CPU.
So I was wondering if such a function would work efficiently on
processors that do not support PAE extension.
I also would like to share that MAXPHYADDR can be at most 52. However,
not sure if such an implementation is even needed.

NOTE:
arch/x86/include/asm/cpufeature.h provides the below macro.
#define cpu_has_pae             boot_cpu_has(X86_FEATURE_PAE)
Does the above macro return 1 whether CPU does support the PAE feature?
If so, we would have to make a single change in the code:

Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>

--- a/arch/x86/kvm/cpuid.c	2012-11-19 23:44:29.000000000 -0200
+++ b/arch/x86/kvm/cpuid.c	2012-11-30 15:05:51.000000000 -0200
@@ -617,7 +617,10 @@
 	if (best)
 		return best->eax & 0xff;
 not_found:
-	return 36;
+	/* Check whether CPU supports PAE, if so the MAXPHYADDR
+	 * is 36, otherwise 32.
+	 */
+	return (cpu_has_pae) ? 36 : 32;
 }

Follows a different patch otherwise:
arch/x86/include/asm/processor.h does provide a generic cpuid function
called native_cpuid, however, I added another procedure for
simplicity/efficiency purposes.

Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>

--- a/arch/x86/kvm/cpuid.c	2012-11-19 23:44:29.000000000 -0200
+++ b/arch/x86/kvm/cpuid.c	2012-11-30 14:28:22.000000000 -0200
@@ -606,6 +606,30 @@

+#ifndef PAE_BIT
+#define PAE_BIT (1ULL << 6)
+#endif
+static inline unsigned cpuid_cpu_pae_support(void)
+{
+	unsigned int __edx;
+	const unsigned int cpu_id_param = 0x01;
+
+	/* According to Intel Manual we can check
+	 * whether the processor does provide PAE by
+	 * using the CPUID instruction.
+	 * Syntax: CPUID.01H:EDX.PAE [bit 6] = 1
+	 */
+	__edx = 0;
+	asm volatile(
+		"cpuid"
+		: "=d"(__edx)
+		: "a"(cpu_id_param)
+		: "ecx","ebx"
+		);
+
+	return (__edx & PAE_BIT);
+}
+
 int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -617,7 +641,10 @@
 	if (best)
 		return best->eax & 0xff;
 not_found:
-	return 36;
+	/* Check whether CPU supports PAE, if so the MAXPHYADDR
+	 * is 36, otherwise 32.
+	 */
+	return (cpuid_cpu_pae_support()) ? 36 : 32;
 }

Regards,
Raphael S.Carvalho <raphael.scarv@gmail.com>
