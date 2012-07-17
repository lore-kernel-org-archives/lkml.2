Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2GQNvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:51:32 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:53071 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2GQNv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:51:28 -0400
Message-ID: <50056DB8.7080702@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 21:50:48 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/9] KVM: x86: remvoe unnecessary mark_page_dirty
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071703-1618-0000-0000-000002143FEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:
[  132.474633] 3.5.0-rc1+ #50 Not tainted
[  132.474634] -------------------------------
[  132.474635] include/linux/kvm_host.h:369 suspicious rcu_dereference_check() usage!
[  132.474636]
[  132.474636] other info that might help us debug this:
[  132.474636]
[  132.474638]
[  132.474638] rcu_scheduler_active = 1, debug_locks = 1
[  132.474640] 1 lock held by qemu-kvm/2832:
[  132.474657]  #0:  (&vcpu->mutex){+.+.+.}, at: [<ffffffffa01e1636>] vcpu_load+0x1e/0x91 [kvm]
[  132.474658]
[  132.474658] stack backtrace:
[  132.474660] Pid: 2832, comm: qemu-kvm Not tainted 3.5.0-rc1+ #50
[  132.474661] Call Trace:
[  132.474665]  [<ffffffff81092f40>] lockdep_rcu_suspicious+0xfc/0x105
[  132.474675]  [<ffffffffa01e0c85>] kvm_memslots+0x6d/0x75 [kvm]
[  132.474683]  [<ffffffffa01e0ca1>] gfn_to_memslot+0x14/0x4c [kvm]
[  132.474693]  [<ffffffffa01e3575>] mark_page_dirty+0x17/0x2a [kvm]
[  132.474706]  [<ffffffffa01f21ea>] kvm_arch_vcpu_ioctl+0xbcf/0xc07 [kvm]

Actually, we do not write vcpu->arch.time at this time, mark_page_dirty should
be removed

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff0b487..875b8d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2615,7 +2615,6 @@ static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.time_page)
 		return -EINVAL;
 	src->flags |= PVCLOCK_GUEST_STOPPED;
-	mark_page_dirty(vcpu->kvm, vcpu->arch.time >> PAGE_SHIFT);
 	kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 	return 0;
 }
-- 
1.7.7.6

