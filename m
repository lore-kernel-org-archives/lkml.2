Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2K1MxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 07:53:24 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:60437 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2K1MxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 07:53:22 -0500
Message-ID: <50B6093B.7040404@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2012 20:53:15 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/2] KVM: VMX: fix invalid cpu passed to smp_call_function_single
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112812-1396-0000-0000-00000239EB51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In loaded_vmcs_clear, loaded_vmcs->cpu is the fist parameter passed to
smp_call_function_single, if the target cpu is downing (doing cpu hot remove),
loaded_vmcs->cpu can become -1 then -1 is passed to smp_call_function_single

It can be triggered when vcpu is being destroyed, loaded_vmcs_clear is called
in the preemptionable context

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/vmx.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6599e45..29e8f42 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1007,9 +1007,11 @@ static void __loaded_vmcs_clear(void *arg)

 static void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
 {
-	if (loaded_vmcs->cpu != -1)
-		smp_call_function_single(
-			loaded_vmcs->cpu, __loaded_vmcs_clear, loaded_vmcs, 1);
+	int cpu = loaded_vmcs->cpu;
+
+	if (cpu != -1)
+		smp_call_function_single(cpu,
+			 __loaded_vmcs_clear, loaded_vmcs, 1);
 }

 static inline void vpid_sync_vcpu_single(struct vcpu_vmx *vmx)
-- 
1.7.7.6

