Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab2K0Q3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:29:12 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46239 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab2K0Q3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:29:10 -0500
MIME-Version: 1.0
In-Reply-To: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
Date: Tue, 27 Nov 2012 17:29:09 +0100
Message-ID: <CAFTL4hx0fc_Jo8wkuRZedW4DVEeQceiHMrWVqTqB5k065Wsg8Q@mail.gmail.com>
Subject: Re: [RFC PATCH] Fix abnormal rcu dynticks_nesting values related to
 async page fault
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, gleb@redhat.com, avi@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/27 Li Zhong <zhong@linux.vnet.ibm.com>:
> @@ -247,10 +247,17 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
>                 break;
>         case KVM_PV_REASON_PAGE_NOT_PRESENT:
>                 /* page is swapped out by the host. */
> -               rcu_irq_enter();
> +               if (is_idle_task(current) && rcu_is_cpu_idle())

If the task is idle we can't schedule so I guess we don't need to call
rcu_idle_exit()

> +                       rcu_idle_exit();
> +               else
> +                       rcu_user_exit();

rcu_user_exit() must be called in any case yeah.

> +
>                 exit_idle();
>                 kvm_async_pf_task_wait((u32)read_cr2());
> -               rcu_irq_exit();
> +
> +               if (is_idle_task(current) && rcu_is_cpu_idle())
> +                       rcu_idle_enter();
> +

I think that only adding rcu_user_exit() in the beginning and let the
rest as is (rcu_irq_enter() / rcu_irq_exit()) is enough. If we are
idle we won't schedule out. If we are not idle then we exit rcu user
mode if necessary and we can call rcu_irq_enter() in any case. If we
schedule we can safely cal rcu_irq_exit() even if somebody called
rcu_idle_enter() / rcu_idle_exit() since our matching rcu_irq_enter()
called before we scheduled. This works because we are not in RCU idle
mode and Paul says this is legal to have irq exit without matching irq
entry (his famous "vice-versa" on his previous email ;-)
