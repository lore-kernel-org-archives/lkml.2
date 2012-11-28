Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2K1ISk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 03:18:40 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:33065 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab2K1ISi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 03:18:38 -0500
Message-ID: <1354090704.3054.13.camel@ThinkPad-T5421.cn.ibm.com>
Subject: [RFC PATCH v2] Add rcu user eqs exception hooks for async page fault
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, gleb@redhat.com, avi@redhat.com
Date: Wed, 28 Nov 2012 16:18:24 +0800
In-Reply-To: <CAFTL4hx0fc_Jo8wkuRZedW4DVEeQceiHMrWVqTqB5k065Wsg8Q@mail.gmail.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
	 <CAFTL4hx0fc_Jo8wkuRZedW4DVEeQceiHMrWVqTqB5k065Wsg8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12112808-1396-0000-0000-00000239B0F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you all for the review and education. 

Below are my current understandings and an update version. Would you
please help to review it again and give your comments? 

Thanks, Zhong

Now it seems to me that it is legal to call rcu_irq_exit/enter() without
a matching rcu_irq_enter/exit() if the cpu is in non rcu idle state.

As opposite, it is illegal to call rcu_irq_exit() without a matching
rcu_irq_enter() if the cpu is in rcu idle state.

But it seems legal to call rcu_irq_enter() without a matching
rcu_irq_exit() if the cpu is in rcu idle state, regarding the
dynticks_nesting value.   However, it seems not good to exit the rcu
idle state, if we are actually entering into idle mode, so maybe it's
better to call a matching rcu_irq_exit() before actually idle?

As Frederic pointed out, we need a rcu_user_exit() to exit the user eqs
(if we are in this state) in the beginning. But after some more
thinking, I guess we might also need to call rcu_user_enter() after the
waiting, if we get this page fault from user space. So maybe it's better
to use rcu user eqs exception hooks here? 

With rcu_user_exit() at the beginning, now rcu_irq_enter() only protects
the cpu idle eqs, but it's not good to call rcu_irq_exit() after the cpu
halt and the page ready. 

So I still want to remove it. And later if it shows that we really needs
rcu somewhere in this code path, maybe we could use RCU_NONIDLE() to
protect it. ( The suspicious RCU usage reported in commit
c5e015d4949aa665 seems related to schedule(), which is not in the code
path if we are in cpu idle eqs )

I think we still need Gleb's patch about the idle check in
kvm_async_pf_task_wait(), and maybe another patch for the
exit_idle()/enter_idle() issue. 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/x86/kernel/kvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 4180a87..e3e7752 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -42,6 +42,7 @@
 #include <asm/apic.h>
 #include <asm/apicdef.h>
 #include <asm/hypervisor.h>
+#include <asm/rcu.h>
 
 static int kvmapf = 1;
 
@@ -247,10 +248,10 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 		break;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		/* page is swapped out by the host. */
-		rcu_irq_enter();
+		exception_enter(regs);
 		exit_idle();
 		kvm_async_pf_task_wait((u32)read_cr2());
-		rcu_irq_exit();
+		exception_exit(regs);
 		break;
 	case KVM_PV_REASON_PAGE_READY:
 		rcu_irq_enter();
-- 
1.7.11.4

