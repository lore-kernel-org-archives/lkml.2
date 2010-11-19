Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab0KSV6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:58:36 -0500
Received: from kroah.org ([198.145.64.141]:45043 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215Ab0KSV6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:33 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:40 2010
Message-Id: <20101119215640.638800214@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [23/82] KVM: X86: Report SVM bit to userspace only when supported
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 4c62a2dc92518c5adf434df8e5c2283c6762672a upstream.

This patch fixes a bug in KVM where it _always_ reports the
support of the SVM feature to userspace. But KVM only
supports SVM on AMD hardware and only when it is enabled in
the kernel module. This patch fixes the wrong reporting.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |    4 ++++
 arch/x86/kvm/x86.c |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3253,6 +3253,10 @@ static void svm_cpuid_update(struct kvm_
 static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 {
 	switch (func) {
+	case 0x80000001:
+		if (nested)
+			entry->ecx |= (1 << 2); /* Set SVM bit */
+		break;
 	case 0x8000000A:
 		entry->eax = 1; /* SVM revision 1 */
 		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1910,7 +1910,7 @@ static void do_cpuid_ent(struct kvm_cpui
 		0 /* Reserved, XSAVE, OSXSAVE */;
 	/* cpuid 0x80000001.ecx */
 	const u32 kvm_supported_word6_x86_features =
-		F(LAHF_LM) | F(CMP_LEGACY) | F(SVM) | 0 /* ExtApicSpace */ |
+		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
 		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(XOP) |
 		0 /* SKINIT */ | 0 /* WDT */;


