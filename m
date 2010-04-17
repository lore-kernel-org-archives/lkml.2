Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab0DQJUe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 05:20:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49535 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755465Ab0DQJUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 05:20:33 -0400
Message-ID: <4BC97D62.2090908@cn.fujitsu.com>
Date: Sat, 17 Apr 2010 17:20:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 1/2] kvm: simplify kvm_vm_ioctl_set_memory_alias
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's just time waste if we free a object and allocate it immediately.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 24cd0ee..db8d7fe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2479,15 +2479,8 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 	rcu_assign_pointer(kvm->arch.aliases, aliases);
 	synchronize_srcu_expedited(&kvm->srcu);
 	kvm_mmu_zap_all(kvm);
-	kfree(old_aliases);
-
-	r = -ENOMEM;
-	aliases = kzalloc(sizeof(struct kvm_mem_aliases), GFP_KERNEL);
-	if (!aliases)
-		goto out_unlock;
-
-	memcpy(aliases, kvm->arch.aliases, sizeof(struct kvm_mem_aliases));
 
+	aliases = old_aliases;
 	p = &aliases->aliases[alias->slot];
 	p->base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
 	p->npages = alias->memory_size >> PAGE_SHIFT;
@@ -2505,7 +2498,6 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 	kfree(old_aliases);
 	r = 0;
 
-out_unlock:
 	mutex_unlock(&kvm->slots_lock);
 out:
 	return r;

