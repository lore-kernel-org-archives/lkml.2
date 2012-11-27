Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2K0NHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:07:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab2K0NH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:07:29 -0500
Date: Tue, 27 Nov 2012 15:07:03 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, avi@redhat.com, fweisbec@gmail.com
Subject: Re: [RFC PATCH] Fix abnormal rcu dynticks_nesting values related to
 async page fault
Message-ID: <20121127130703.GW25516@redhat.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 01:15:25PM +0800, Li Zhong wrote:
> I noticed some warnings complaining about dynticks_nesting value, like 
> 
> [  267.545032] ------------[ cut here ]------------
> [  267.545032] WARNING: at kernel/rcutree.c:382 rcu_eqs_enter+0xab/0xc0()
> [  267.545032] Hardware name: Bochs
> [  267.545032] Modules linked in:
> [  267.545032] Pid: 0, comm: swapper/2 Not tainted 3.7.0-rc5-next-20121115 #8
> [  267.545032] Call Trace:
> [  267.545032]  [<ffffffff8104714f>] warn_slowpath_common+0x7f/0xc0
> [  267.545032]  [<ffffffff810471aa>] warn_slowpath_null+0x1a/0x20
> [  267.545032]  [<ffffffff810e607b>] rcu_eqs_enter+0xab/0xc0
> [  267.545032]  [<ffffffff810e60bb>] rcu_idle_enter+0x2b/0x70
> [  267.545032]  [<ffffffff8100d44f>] cpu_idle+0x6f/0x100
> [  267.545032]  [<ffffffff814bf055>] start_secondary+0x205/0x20c
> [  267.545032] ---[ end trace 924ae80da035028d ]---
> 
> After enabling rcu-dyntick tracing, I got following abnormal
> dynticks_nesting values (13fffffffffffff, ff00000000000001,etc):
> 			...
>  1	<idle>-0     [002] dN.2 18739.518567: rcu_dyntick: End 0 140000000000000		rcu_idle_exit
>  2	  sshd-696   [002] d..1 18739.518675: rcu_dyntick: ++= 140000000000000 140000000000001	rcu_irq_enter   - apf (not present)
> 
>  3	<idle>-0     [002] d..2 18739.518705: rcu_dyntick: Start 140000000000001 0		rcu_idle_enter
>  4	<idle>-0     [002] d..2 18739.521252: rcu_dyntick: End 0 1				rcu_irq_enter	- apf (page ready)
>  5	<idle>-0     [002] dN.2 18739.521261: rcu_dyntick: Start 1 0				rcu_irq_exit	- apf (page ready)
>  6	<idle>-0     [002] dN.2 18739.521263: rcu_dyntick: End 0 140000000000000		rcu_idle_exit
> 
>  7	  sshd-696   [002] d..1 18739.521299: rcu_dyntick: --= 140000000000000 13fffffffffffff	rcu_irq_exit	- apf (not present)
>  8	  sshd-696   [002] d..1 18739.521302: rcu_dyntick: Start 13fffffffffffff 0		rcu_user_enter
>  9	  sshd-696   [002] d..1 18739.521330: rcu_dyntick: End 0 1				rcu_irq_enter   - apf (not present)
> 
> 10	<idle>-0     [002] d..2 18739.521346: rcu_dyntick: Start 1 0				rcu_idle_enter - old value 1, warning
> 11	<idle>-0     [002] d..2 18739.530021: rcu_dyntick: ++= ff00000000000001 ff00000000000002
> 12	<idle>-0     [002] dN.2 18739.530029: rcu_dyntick: --= ff00000000000002 ff00000000000001
> 		...
> 
> I added the functions I guess which printed the tracing after each
> line. 
> 
> Line #1, the idle-0 process calls rcu_idle_exit(), and finishes one
> loop, to switch to sshd-696
> 
> Line #2, sshd-696 calls rcu_irq_enter() because of async page fault(page
> not present), and puts itself to wait for page ready
> 
> Line #3, idle-0 is switched in, and clears the dynticks_nesting to 0
> 
> Line #4-5, I think the rcu_irq_enter/exit() is called because the page
> for sshd-696 is ready
> 
> Line #6, idle-0 calls rcu_idle_exit(), to switch to sshd-696
> 
> Line #7, sshd-696 calls rcu_irq_exit() in the apf (page not present)
> code path, decreasing dynticks_nesting to 13fffffffffffff. 
> 
> Line #8-9, sshd-696 calls rcu_user_enter() to start user eqs, and gets
> async page fault again. It puts itself sleep again, with
> dynticks_nesting value as 1.
> 
> Line #10, idle-0 switches in, as the dynticks_nesting value is 1, so
> warning is reported in rcu_idle_enter(), then the value is decreased to
> ff00000000000001. (In the tracing log, the new value is 0, that's
> because rcu hard-code the value to be 0. I will send another patch for
> this.)
> 
> This patch below tries to replace the rcu_irq_enter/exit() with
> rcu_idle_exit/enter(), if it is in rcu idle, and it is idle process;
> otherwise, rcu_user_exit() is called to exit user eqs if necessary. 
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/kvm.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 4180a87..f65648d 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -247,10 +247,17 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
>  		break;
>  	case KVM_PV_REASON_PAGE_NOT_PRESENT:
>  		/* page is swapped out by the host. */
> -		rcu_irq_enter();
> +		if (is_idle_task(current) && rcu_is_cpu_idle())
> +			rcu_idle_exit();
> +		else
> +			rcu_user_exit();
> +
>  		exit_idle();
>  		kvm_async_pf_task_wait((u32)read_cr2());
> -		rcu_irq_exit();
> +
> +		if (is_idle_task(current) && rcu_is_cpu_idle())
> +			rcu_idle_enter();
> +
>  		break;
>  	case KVM_PV_REASON_PAGE_READY:
>  		rcu_irq_enter();
Those rcu_irq_enter()/rcu_irq_exit() were introduced by commit
c5e015d4949aa665 "KVM guest: exit idleness when handling
KVM_PV_REASON_PAGE_NOT_PRESENT", but now I am starting to question this
commit. KVM_PV_REASON_PAGE_NOT_PRESENT should not kick cpu out of
idleness. kvm_async_pf_task_wait() checks that cpu is idle and calls
halt if it is. After that commit schedule() may be called between
rcu_irq_enter()/rcu_irq_exit() which is probably illegal. Paul?

--
			Gleb.
