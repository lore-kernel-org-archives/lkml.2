Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab1GWHcC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 03:32:02 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30968 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1GWHb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 03:31:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=YczMAb2G4PPe2iUesSzjsjEM8r1SMa9ieYD3FMV2OtA8hBOtWPCdM42SSxa4q3JMR
	K7ptJ9e1rRaEytEyIXwNw==
From: Mike Waychison <mikew@google.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Waychison <mikew@google.com>
Subject: [PATCH] kvm: Really fix HV_X64_MSR_APIC_ASSIST_PAGE
Date: Sat, 23 Jul 2011 00:31:45 -0700
Message-Id: <1311406305-24523-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0945d4b228 tried to fix the get_msr path for the
HV_X64_MSR_APIC_ASSIST_PAGE msr, but was poorly tested.  We should be
returning 0 if the read succeeded, and passing the value back to the
caller via the pdata out argument, not returning the value directly.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15148ef..6960efe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1749,7 +1749,8 @@ static int get_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case HV_X64_MSR_TPR:
 		return kvm_hv_vapic_msr_read(vcpu, APIC_TASKPRI, pdata);
 	case HV_X64_MSR_APIC_ASSIST_PAGE:
-		return vcpu->arch.hv_vapic;
+		data = vcpu->arch.hv_vapic;
+		break;
 	default:
 		pr_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
 		return 1;
-- 
1.7.3.1

