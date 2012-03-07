Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031017Ab2CGBzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:55:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49600 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965301Ab2CGBy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:54:59 -0500
X-IronPort-AV: E=Sophos;i="4.73,542,1325433600"; 
   d="scan'208";a="4474616"
Message-ID: <4F56C058.7010406@cn.fujitsu.com>
Date: Wed, 07 Mar 2012 09:56:40 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 2/2 v2] kvm: set exit_reason to KVM_EXIT_GUEST_PANICED when
 guest paniced
References: <4F56BEF2.4020405@cn.fujitsu.com>
In-Reply-To: <4F56BEF2.4020405@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 09:53:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 09:53:03,
	Serialize complete at 2012-03-07 09:53:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new request bit KVM_REQ_GUEST_PANICED.
If this bit is set, set vcpu's exit_reason to KVM_EXIT_GUEST_PANICED.
And then the user space can know the guest paniced.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c       |   11 +++++++++++
 include/linux/kvm.h      |    1 +
 include/linux/kvm_host.h |    1 +
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9d99e5..978e398 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5013,6 +5013,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	case KVM_HC_VAPIC_POLL_IRQ:
 		ret = 0;
 		break;
+	case KVM_HC_GUEST_PANICED:
+		ret = 0;
+		kvm_make_request(KVM_REQ_GUEST_PANICED, vcpu);
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
@@ -5228,6 +5232,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = 0;
 			goto out;
 		}
+
+		if (kvm_check_request(KVM_REQ_GUEST_PANICED, vcpu)) {
+			vcpu->run->exit_reason = KVM_EXIT_GUEST_PANICED;
+			r = 0;
+			goto out;
+		}
+
 		if (kvm_check_request(KVM_REQ_DEACTIVATE_FPU, vcpu)) {
 			vcpu->fpu_active = 0;
 			kvm_x86_ops->fpu_deactivate(vcpu);
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index acbe429..a46052e 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -163,6 +163,7 @@ struct kvm_pit_config {
 #define KVM_EXIT_OSI              18
 #define KVM_EXIT_PAPR_HCALL	  19
 #define KVM_EXIT_S390_UCONTROL	  20
+#define KVM_EXIT_GUEST_PANICED	  21
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 #define KVM_INTERNAL_ERROR_EMULATION 1
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 355e445..026bbe5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -54,6 +54,7 @@
 #define KVM_REQ_IMMEDIATE_EXIT    15
 #define KVM_REQ_PMU               16
 #define KVM_REQ_PMI               17
+#define KVM_REQ_GUEST_PANICED     18
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID	0
 
-- 
1.7.1

