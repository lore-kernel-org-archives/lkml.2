Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab0H1L7N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 07:59:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49241 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab0H1L7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 07:59:11 -0400
Message-ID: <4C78FAF4.4070302@cn.fujitsu.com>
Date: Sat, 28 Aug 2010 20:03:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/4] KVM: MMU: lower the aduit frequency
References: <4C78FA00.8090606@cn.fujitsu.com>
In-Reply-To: <4C78FA00.8090606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The audit is very high overhead, so we need lower the frequency to assure the guest running

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu_debug.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu_debug.c b/arch/x86/kvm/mmu_debug.c
index c4ebe6a..bc61b3d 100644
--- a/arch/x86/kvm/mmu_debug.c
+++ b/arch/x86/kvm/mmu_debug.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/debugfs.h>
+#include <linux/ratelimit.h>
 
 static struct dentry *debugfs_file;
 static bool mmu_debug;
@@ -233,6 +234,11 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
 
 static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, const char *msg)
 {
+	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
+
+	if (!__ratelimit(&ratelimit_state))
+		return;
+
 	audit_msg = msg;
 	audit_all_active_sps(vcpu->kvm);
 	audit_vcpu_spte(vcpu);
-- 
1.7.0.4

