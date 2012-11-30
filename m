Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2K3CK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:10:27 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54984 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2K3CK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:10:26 -0500
MIME-Version: 1.0
Date: Fri, 30 Nov 2012 00:10:25 -0200
Message-ID: <CACz=WefC5ZKOf9rh-puHNgTsVDpS+_XWLcgRfvyv5wt3R0KT5g@mail.gmail.com>
Subject: [PATCH 1/1] arch/x86/kvm/cpuid.c: cpuid_maxphyaddr "bad" handling.
From: Raphael S Carvalho <raphael.scarv@gmail.com>
To: linux-kernel@vger.kernel.org
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

arch/x86/include/asm/processor.h does provide a generic cpuid function
called native_cpuid, however, I added another procedure for
simplicity/efficiency purposes. Besides, I didn't find where the Linux
kernel defines such flags (PAE flag (1 << 6)). For avoiding duplicated
definitions, it would be a pleasure to get my code modified.
I also would like to share that MAXPHYADDR can be at most 52. However,
not sure if such a implementation is even needed.

Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>

--- cpuid2.c	2012-11-29 22:44:43.881876294 -0200
+++ cpuid.c	2012-11-30 00:02:08.565710892 -0200
@@ -606,6 +606,30 @@
 }
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);

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
