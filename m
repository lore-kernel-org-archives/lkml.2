Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0E0BJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 21:09:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab0E0BJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 21:09:53 -0400
Message-ID: <4BFDC657.4040902@redhat.com>
Date: Wed, 26 May 2010 15:09:43 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH] Fix SVM longmode guests
Content-Type: multipart/mixed;
 boundary="------------080309090600080008060508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080309090600080008060508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

In recent testing, I discovered guests failed to boot on my AMD box.  
Bisecting revealed an EFER related change caused the problem; here is 
the fix.

Cheers,

Zach

--------------080309090600080008060508
Content-Type: text/plain;
 name="svm-lm-efer-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="svm-lm-efer-fix.patch"

Fix 64-bit guests on SVM.

Must set VCPU register to be the guest notion of EFER even if that
setting is not valid on hardware.  This was masked by the set in
set_efer until 7657fd5ace88e8092f5f3a84117e093d7b893f26 broke that.
Fix is simply to set the VCPU register before stripping bits.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 100bd4b..a05b63f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -285,11 +285,11 @@ static inline void flush_guest_tlb(struct kvm_vcpu *vcpu)
 
 static void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
+	vcpu->arch.efer = efer;
 	if (!npt_enabled && !(efer & EFER_LMA))
 		efer &= ~EFER_LME;
 
 	to_svm(vcpu)->vmcb->save.efer = efer | EFER_SVME;
-	vcpu->arch.efer = efer;
 }
 
 static int is_external_interrupt(u32 info)

--------------080309090600080008060508--
