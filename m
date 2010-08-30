Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab0H3KW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:22:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52832 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab0H3KWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:22:24 -0400
Message-ID: <4C7B8759.60900@cn.fujitsu.com>
Date: Mon, 30 Aug 2010 18:26:33 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 5/5] KVM: MMU: lower the aduit frequency
References: <4C78FA00.8090606@cn.fujitsu.com> <4C7B867D.9080500@cn.fujitsu.com>
In-Reply-To: <4C7B867D.9080500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The audit is very high overhead, so we need lower the frequency to assure the guest running

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu_audit.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index 3bde186..bd2b1be 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -17,6 +17,8 @@
  *
  */
 
+#include <linux/ratelimit.h>
+
 static const char *audit_msg;
 
 typedef void (*inspect_spte_fn) (struct kvm_vcpu *vcpu, u64 *sptep, int level);
@@ -228,6 +230,11 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
 
 static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, int audit_point)
 {
+	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
+
+	if (!__ratelimit(&ratelimit_state))
+		return;
+
 	audit_msg = audit_point_name[audit_point];
 	audit_all_active_sps(vcpu->kvm);
 	audit_vcpu_spte(vcpu);
-- 
1.7.0.4

