Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab2JUJ1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 05:27:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab2JUJ1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 05:27:16 -0400
Date: Sun, 21 Oct 2012 11:27:11 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: avi@redhat.com, mtosatti@redhat.com, davej@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] kvm, async_pf: exit idleness when handling
 KVM_PV_REASON_PAGE_NOT_PRESENT
Message-ID: <20121021092710.GA29310@redhat.com>
References: <1350663115-11373-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350663115-11373-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 12:11:55PM -0400, Sasha Levin wrote:
> KVM_PV_REASON_PAGE_NOT_PRESENT kicks cpu out of idleness, but we haven't
> marked that spot as an exit from idleness.
> 
> Not doing so can cause RCU warnings such as:
> 
> [  732.788386] ===============================
> [  732.789803] [ INFO: suspicious RCU usage. ]
> [  732.790032] 3.7.0-rc1-next-20121019-sasha-00002-g6d8d02d-dirty #63 Tainted: G        W
> [  732.790032] -------------------------------
> [  732.790032] include/linux/rcupdate.h:738 rcu_read_lock() used illegally while idle!
> [  732.790032]
> [  732.790032] other info that might help us debug this:
> [  732.790032]
> [  732.790032]
> [  732.790032] RCU used illegally from idle CPU!
> [  732.790032] rcu_scheduler_active = 1, debug_locks = 1
> [  732.790032] RCU used illegally from extended quiescent state!
> [  732.790032] 2 locks held by trinity-child31/8252:
> [  732.790032]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff83a67528>] __schedule+0x178/0x8f0
> [  732.790032]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff81152bde>] cpuacct_charge+0xe/0x200
> [  732.790032]
> [  732.790032] stack backtrace:
> [  732.790032] Pid: 8252, comm: trinity-child31 Tainted: G        W    3.7.0-rc1-next-20121019-sasha-00002-g6d8d02d-dirty #63
> [  732.790032] Call Trace:
> [  732.790032]  [<ffffffff8118266b>] lockdep_rcu_suspicious+0x10b/0x120
> [  732.790032]  [<ffffffff81152c60>] cpuacct_charge+0x90/0x200
> [  732.790032]  [<ffffffff81152bde>] ? cpuacct_charge+0xe/0x200
> [  732.790032]  [<ffffffff81158093>] update_curr+0x1a3/0x270
> [  732.790032]  [<ffffffff81158a6a>] dequeue_entity+0x2a/0x210
> [  732.790032]  [<ffffffff81158ea5>] dequeue_task_fair+0x45/0x130
> [  732.790032]  [<ffffffff8114ae29>] dequeue_task+0x89/0xa0
> [  732.790032]  [<ffffffff8114bb9e>] deactivate_task+0x1e/0x20
> [  732.790032]  [<ffffffff83a67c29>] __schedule+0x879/0x8f0
> [  732.790032]  [<ffffffff8117e20d>] ? trace_hardirqs_off+0xd/0x10
> [  732.790032]  [<ffffffff810a37a5>] ? kvm_async_pf_task_wait+0x1d5/0x2b0
> [  732.790032]  [<ffffffff83a67cf5>] schedule+0x55/0x60
> [  732.790032]  [<ffffffff810a37c4>] kvm_async_pf_task_wait+0x1f4/0x2b0
> [  732.790032]  [<ffffffff81139e50>] ? abort_exclusive_wait+0xb0/0xb0
> [  732.790032]  [<ffffffff81139c25>] ? prepare_to_wait+0x25/0x90
> [  732.790032]  [<ffffffff810a3a66>] do_async_page_fault+0x56/0xa0
> [  732.790032]  [<ffffffff83a6a6e8>] async_page_fault+0x28/0x30
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Gleb Natapov <gleb@redhat.com>

> ---
>  arch/x86/kernel/kvm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index b3e5e51..4180a87 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -247,7 +247,10 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
>  		break;
>  	case KVM_PV_REASON_PAGE_NOT_PRESENT:
>  		/* page is swapped out by the host. */
> +		rcu_irq_enter();
> +		exit_idle();
>  		kvm_async_pf_task_wait((u32)read_cr2());
> +		rcu_irq_exit();
>  		break;
>  	case KVM_PV_REASON_PAGE_READY:
>  		rcu_irq_enter();
> -- 
> 1.7.12.3

--
			Gleb.
