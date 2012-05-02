Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab2EBO4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 10:56:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab2EBOz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 10:55:58 -0400
Date: Wed, 2 May 2012 17:55:56 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kvm@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, gleb@redhat.com,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] kvm: fix cpuid eax
Message-ID: <20120502145554.GA2864@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuid eax should return the max leaf so that
guests can find out the valid range.
This matches Xen et al.
Update documentation to match.

Tested with -cpu host.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Changes from v1:
	Updated documentation.

 Documentation/virtual/kvm/cpuid.txt |    6 +++++-
 arch/x86/kvm/cpuid.c                |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
index 8820685..83afe65 100644
--- a/Documentation/virtual/kvm/cpuid.txt
+++ b/Documentation/virtual/kvm/cpuid.txt
@@ -10,11 +10,15 @@ a guest.
 KVM cpuid functions are:
 
 function: KVM_CPUID_SIGNATURE (0x40000000)
-returns : eax = 0,
+returns : eax = 0x40000001,
           ebx = 0x4b4d564b,
           ecx = 0x564b4d56,
           edx = 0x4d.
 Note that this value in ebx, ecx and edx corresponds to the string "KVMKVMKVM".
+The value in eax corresponds to the maximum cpuid function present in this leaf,
+and will be updated if more functions are added in the future.
+Note also that old hosts set eax value to 0x0. This should
+be interpreted as if the value was 0x40000001.
 This function queries the presence of KVM cpuid leafs.
 
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9fed5be..eba8345 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -397,7 +397,7 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	case KVM_CPUID_SIGNATURE: {
 		char signature[12] = "KVMKVMKVM\0\0";
 		u32 *sigptr = (u32 *)signature;
-		entry->eax = 0;
+		entry->eax = KVM_CPUID_FEATURES;
 		entry->ebx = sigptr[0];
 		entry->ecx = sigptr[1];
 		entry->edx = sigptr[2];
-- 
MST
