Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab0DLIGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:06:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52831 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab0DLIGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:06:18 -0400
Message-ID: <4BC2D3E0.8070602@cn.fujitsu.com>
Date: Mon, 12 Apr 2010 16:03:44 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] KVM MMU: optimize for writing cr4
References: <4BC2D2E2.1030604@cn.fujitsu.com>
In-Reply-To: <4BC2D2E2.1030604@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually, OS changes CR4.PGE bit to flush all global page, under this
case, no need reset mmu and just flush tlb

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd5c3d3..2aaa6fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -463,6 +463,15 @@ void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE;
 
+	if (cr4 == old_cr4)
+		return;
+
+	if ((cr4 ^ old_cr4) == X86_CR4_PGE) {
+		kvm_mmu_sync_roots(vcpu);
+		kvm_mmu_flush_tlb(vcpu);
+		return;
+	}
+
 	if (cr4 & CR4_RESERVED_BITS) {
 		kvm_inject_gp(vcpu, 0);
 		return;
-- 
1.6.1.2


