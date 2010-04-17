Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab0DQIlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 04:41:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61869 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab0DQIlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 04:41:47 -0400
Message-ID: <4BC9744B.1050107@cn.fujitsu.com>
Date: Sat, 17 Apr 2010 16:41:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm-owner@vger.kernel.org
Subject: [PATCH] kvm vmx: free vpid when fail to create vcpu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix bug of the exception path, free allocated vpid when fail
to create vcpu.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 686492e..077cac5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2290,6 +2290,16 @@ static void allocate_vpid(struct vcpu_vmx *vmx)
 	spin_unlock(&vmx_vpid_lock);
 }
 
+static void free_vpid(struct vcpu_vmx *vmx)
+{
+	if (!enable_vpid)
+		return;
+	spin_lock(&vmx_vpid_lock);
+	if (vmx->vpid != 0)
+		__clear_bit(vmx->vpid, vmx_vpid_bitmap);
+	spin_unlock(&vmx_vpid_lock);
+}
+
 static void __vmx_disable_intercept_for_msr(unsigned long *msr_bitmap, u32 msr)
 {
 	int f = sizeof(unsigned long);
@@ -3915,10 +3925,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	spin_lock(&vmx_vpid_lock);
-	if (vmx->vpid != 0)
-		__clear_bit(vmx->vpid, vmx_vpid_bitmap);
-	spin_unlock(&vmx_vpid_lock);
+	free_vpid(vmx);
 	vmx_free_vmcs(vcpu);
 	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
@@ -3980,6 +3987,7 @@ free_msrs:
 uninit_vcpu:
 	kvm_vcpu_uninit(&vmx->vcpu);
 free_vcpu:
+	free_vpid(vmx);
 	kmem_cache_free(kvm_vcpu_cache, vmx);
 	return ERR_PTR(err);
 }

