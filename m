Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab0DQJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 05:28:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59379 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755550Ab0DQJ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 05:28:22 -0400
Message-ID: <4BC97F3A.2030003@cn.fujitsu.com>
Date: Sat, 17 Apr 2010 17:28:26 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 2/2] kvm: set new alias directly when old one is not valid
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When old one is not valid, we don't need set the flags
KVM_ALIAS_INVALID. Because no one {will use}/{be using} it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db8d7fe..6120e33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2474,6 +2474,9 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 
 	/* invalidate any gfn reference in case of deletion/shrinking */
 	memcpy(aliases, kvm->arch.aliases, sizeof(struct kvm_mem_aliases));
+	if (!aliases->aliases[alias->slot].npages)
+		goto set_new_alias;
+
 	aliases->aliases[alias->slot].flags |= KVM_ALIAS_INVALID;
 	old_aliases = kvm->arch.aliases;
 	rcu_assign_pointer(kvm->arch.aliases, aliases);
@@ -2481,6 +2484,8 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 	kvm_mmu_zap_all(kvm);
 
 	aliases = old_aliases;
+
+set_new_alias:
 	p = &aliases->aliases[alias->slot];
 	p->base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
 	p->npages = alias->memory_size >> PAGE_SHIFT;

