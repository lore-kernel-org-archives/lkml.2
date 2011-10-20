Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1JTHbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 03:31:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:59444 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab1JTHbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 03:31:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="64975972"
Subject: [PATCH 2/3] kvm: use this_cpu_xxx replace percpu_xxx funcs
From: "Alex,Shi" <alex.shi@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>, "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jeremy@xensource.com" <jeremy@xensource.com>
In-Reply-To: <4E9E97D2.1040807@redhat.com>
References: <1318237851.27949.190.camel@debian>
	 <alpine.DEB.2.00.1110101026080.16264@router.home>
	 <1318324774.27949.693.camel@debian>
	 <alpine.DEB.2.00.1110110910480.3388@router.home>
	 <1318382964.27949.782.camel@debian> <1318428673.29699.13.camel@debian>
	 <alpine.DEB.2.00.1110120910540.26610@router.home>
	 <1318908091.23426.52.camel@debian>
	 <alpine.DEB.2.00.1110180932330.687@router.home>
	 <1319016218.23426.104.camel@debian>  <4E9E97D2.1040807@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 15:34:01 +0800
Message-ID: <1319096041.23426.182.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_xxx funcs are duplicated with this_cpu_xxx funcs, so replace them
for further code clean up.

And in preempt safe scenario, __this_cpu_xxx funcs has a bit better
performance since __this_cpu_xxx has no redundant preempt_disable()

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/kvm/x86.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 84a28ea..432c4bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5024,15 +5024,15 @@ static DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
 
 static int kvm_is_in_guest(void)
 {
-	return percpu_read(current_vcpu) != NULL;
+	return __this_cpu_read(current_vcpu) != NULL;
 }
 
 static int kvm_is_user_mode(void)
 {
 	int user_mode = 3;
 
-	if (percpu_read(current_vcpu))
-		user_mode = kvm_x86_ops->get_cpl(percpu_read(current_vcpu));
+	if (__this_cpu_read(current_vcpu))
+		user_mode = kvm_x86_ops->get_cpl(__this_cpu_read(current_vcpu));
 
 	return user_mode != 0;
 }
@@ -5041,8 +5041,8 @@ static unsigned long kvm_get_guest_ip(void)
 {
 	unsigned long ip = 0;
 
-	if (percpu_read(current_vcpu))
-		ip = kvm_rip_read(percpu_read(current_vcpu));
+	if (__this_cpu_read(current_vcpu))
+		ip = kvm_rip_read(__this_cpu_read(current_vcpu));
 
 	return ip;
 }
@@ -5055,13 +5055,13 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu)
 {
-	percpu_write(current_vcpu, vcpu);
+	__this_cpu_write(current_vcpu, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_before_handle_nmi);
 
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu)
 {
-	percpu_write(current_vcpu, NULL);
+	__this_cpu_write(current_vcpu, NULL);
 }
 EXPORT_SYMBOL_GPL(kvm_after_handle_nmi);
 
-- 
1.6.3.3



