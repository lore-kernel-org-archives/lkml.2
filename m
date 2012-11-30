Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab2K3JSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:18:55 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:59464 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab2K3JSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:18:51 -0500
Message-ID: <1354267121.2552.65.camel@ThinkPad-T5421.cn.ibm.com>
Subject: [RFC PATCH v3] Add rcu user eqs exception hooks for async page fault
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, avi@redhat.com
Date: Fri, 30 Nov 2012 17:18:41 +0800
In-Reply-To: <CAFTL4hyHW3uJHvzxz1o4agtGbicFAP1DuUsifbOrp1Q3ODRBMA@mail.gmail.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
	 <CAFTL4hx0fc_Jo8wkuRZedW4DVEeQceiHMrWVqTqB5k065Wsg8Q@mail.gmail.com>
	 <1354090704.3054.13.camel@ThinkPad-T5421.cn.ibm.com>
	 <CAFTL4hxPSp1fs4=2g0yFs0d5nFisfUsfDAA9bHWcu+-+tO_ySw@mail.gmail.com>
	 <20121128135345.GG928@redhat.com>
	 <CAFTL4hxoFBLNQCABBpJRBgV-r-Mg5GSq7HbPfWJRraSvtviz4A@mail.gmail.com>
	 <20121129110717.GA9711@redhat.com>
	 <CAFTL4hyHW3uJHvzxz1o4agtGbicFAP1DuUsifbOrp1Q3ODRBMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12113009-1618-0000-0000-000002F2FCCF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds user eqs exception hooks for async page fault page not
present code path, to exit the user eqs and re-enter it as necessary. 

Async page fault is different from other exceptions that it may be
triggered from idle process, so we still need rcu_irq_enter() and
rcu_irq_exit() to exit cpu idle eqs when needed, to protect the code
that needs use rcu.

As Frederic pointed out it would be safest and simplest to protect the
whole kvm_async_pf_task_wait(). Otherwise, "we need to check all the
code there deeply for potential RCU uses and ensure it will never be
extended later to use RCU.".

However, We'd better re-enter the cpu idle eqs if we get the exception
in cpu idle eqs, by calling rcu_irq_exit() before native_safe_halt(). 

So the patch does what Frederic suggested for rcu_irq_*() API usage
here, except that I moved the rcu_irq_*() pair originally in
do_async_page_fault() into kvm_async_pf_task_wait(). 

That's because, I think it's better to have rcu_irq_*() pairs to be in
one function ( rcu_irq_exit() after rcu_irq_enter() ), especially here,
kvm_async_pf_task_wait() has other callers, which might cause
rcu_irq_exit() be called without a matching rcu_irq_enter() before it,
which is illegal if the cpu happens to be in rcu idle state. 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/x86/kernel/kvm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 4180a87..342b00b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -42,6 +42,7 @@
 #include <asm/apic.h>
 #include <asm/apicdef.h>
 #include <asm/hypervisor.h>
+#include <asm/rcu.h>
 
 static int kvmapf = 1;
 
@@ -112,6 +113,8 @@ void kvm_async_pf_task_wait(u32 token)
 	DEFINE_WAIT(wait);
 	int cpu, idle;
 
+	rcu_irq_enter();
+
 	cpu = get_cpu();
 	idle = idle_cpu(cpu);
 	put_cpu();
@@ -123,6 +126,8 @@ void kvm_async_pf_task_wait(u32 token)
 		hlist_del(&e->link);
 		kfree(e);
 		spin_unlock(&b->lock);
+
+		rcu_irq_exit();
 		return;
 	}
 
@@ -147,13 +152,16 @@ void kvm_async_pf_task_wait(u32 token)
 			/*
 			 * We cannot reschedule. So halt.
 			 */
+			rcu_irq_exit();
 			native_safe_halt();
+			rcu_irq_enter();
 			local_irq_disable();
 		}
 	}
 	if (!n.halted)
 		finish_wait(&n.wq, &wait);
 
+	rcu_irq_exit();
 	return;
 }
 EXPORT_SYMBOL_GPL(kvm_async_pf_task_wait);
@@ -247,10 +255,10 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
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

