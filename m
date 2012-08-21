Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2HUC5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 22:57:54 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54092 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2HUC5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 22:57:51 -0400
Message-ID: <5032F926.7020801@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2012 10:57:42 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v6 01/12] KVM: x86: fix possible infinite loop caused by reexecute_instruction
References: <5032F8FD.2020306@linux.vnet.ibm.com>
In-Reply-To: <5032F8FD.2020306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082102-4790-0000-0000-0000043853CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we reexecute all unhandleable instructions if they do not
access on the mmio, however, it can not work if host map the readonly
memory to guest. If the instruction try to write this kind of memory,
it will fault again when guest retry it, then we will goto a infinite
loop: retry instruction -> write #PF -> emulation fail ->
retry instruction -> ...

Fix it by retrying the instruction only when it faults on the writable
memory

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb0d937..704680d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4473,6 +4473,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
 static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	gpa_t gpa;
+	pfn_t pfn;

 	if (tdp_enabled)
 		return false;
@@ -4490,8 +4491,17 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
 	if (gpa == UNMAPPED_GVA)
 		return true; /* let cpu generate fault */

-	if (!kvm_is_error_hva(gfn_to_hva(vcpu->kvm, gpa >> PAGE_SHIFT)))
+	/*
+	 * Do not retry the unhandleable instruction if it faults on the
+	 * readonly host memory, otherwise it will goto a infinite loop:
+	 * retry instruction -> write #PF -> emulation fail -> retry
+	 * instruction -> ...
+	 */
+	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
+	if (!is_error_pfn(pfn)) {
+		kvm_release_pfn_clean(pfn);
 		return true;
+	}

 	return false;
 }
-- 
1.7.7.6

