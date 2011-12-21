Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1LUK0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:26:00 -0500
Received: from goliath.siemens.de ([192.35.17.28]:20336 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1LUKZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:25:55 -0500
Message-ID: <4EF1B423.8050707@siemens.com>
Date: Wed, 21 Dec 2011 11:25:39 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>, Avi Kivity <avi@redhat.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Garrett D'Amore" <garrett@nexenta.com>, kvm <kvm@vger.kernel.org>
Subject: [PATCH v2] KVM: x86: Prevent exposing TSC deadline timer feature
 in the absence of in-kernel APIC
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com> <CAB9v_DFs_Rz04+waeBpVoJsLX+Ao7vQ4EtH2TJsX6jHZewWLQA@mail.gmail.com> <CAB9v_DEz44d54tZMyFenNoNNyu3LSA6dw31S_G8MaWp7UbAULQ@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E289048778E@shsmsx502.ccr.corp.intel.com> <CAB9v_DFL9K+hSum4k_TJBBP4jcenFiqggyzNNk3QHiPhkiqtxA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E28904877AE@shsmsx502.ccr.corp.intel.com> <CAB9v_DEA4HJ2Xyc_fMrZ9gi9oNmKPTmG5LLCiwgsPDHbhgRaQw@mail.gmail.com> <CA+55aFwZ02yUBbUjJYuXjZnKcQRHC7uT9T1dckZQNSaC6SdnvA@mail.gmail.com> <4EF1146D.208@siemens.com> <4EF1B081.3010109@siemens.com>
In-Reply-To: <4EF1B081.3010109@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must not report the TSC deadline timer feature on our own when user
space provides the APIC as we have no clue about its features.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---

Changes in v2:
 - reorganized code to make the flow clearer

 arch/x86/kvm/cpuid.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 230f713..b7cdd3b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -27,7 +27,6 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 timer_mode_mask;
 
 	best = kvm_find_cpuid_entry(vcpu, 1, 0);
 	if (!best)
@@ -40,15 +39,14 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 			best->ecx |= bit(X86_FEATURE_OSXSAVE);
 	}
 
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
-		best->function == 0x1) {
-		best->ecx |= bit(X86_FEATURE_TSC_DEADLINE_TIMER);
-		timer_mode_mask = 3 << 17;
-	} else
-		timer_mode_mask = 1 << 17;
-
-	if (apic)
-		apic->lapic_timer.timer_mode_mask = timer_mode_mask;
+	if (apic) {
+		if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+		    best->function == 0x1) {
+			best->ecx |= bit(X86_FEATURE_TSC_DEADLINE_TIMER);
+			apic->lapic_timer.timer_mode_mask = 3 << 17;
+		} else
+			apic->lapic_timer.timer_mode_mask = 1 << 17;
+	}
 
 	kvm_pmu_cpuid_update(vcpu);
 }
-- 
1.7.3.4
