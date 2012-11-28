Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab2K1Mzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 07:55:45 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61096 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab2K1Mzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 07:55:43 -0500
MIME-Version: 1.0
In-Reply-To: <1354090704.3054.13.camel@ThinkPad-T5421.cn.ibm.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
	<CAFTL4hx0fc_Jo8wkuRZedW4DVEeQceiHMrWVqTqB5k065Wsg8Q@mail.gmail.com>
	<1354090704.3054.13.camel@ThinkPad-T5421.cn.ibm.com>
Date: Wed, 28 Nov 2012 13:55:42 +0100
Message-ID: <CAFTL4hxPSp1fs4=2g0yFs0d5nFisfUsfDAA9bHWcu+-+tO_ySw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] Add rcu user eqs exception hooks for async page fault
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, gleb@redhat.com, avi@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/28 Li Zhong <zhong@linux.vnet.ibm.com>:
> Thank you all for the review and education.
>
> Below are my current understandings and an update version. Would you
> please help to review it again and give your comments?
>
> Thanks, Zhong
>
> Now it seems to me that it is legal to call rcu_irq_exit/enter() without
> a matching rcu_irq_enter/exit() if the cpu is in non rcu idle state.
>
> As opposite, it is illegal to call rcu_irq_exit() without a matching
> rcu_irq_enter() if the cpu is in rcu idle state.
>
> But it seems legal to call rcu_irq_enter() without a matching
> rcu_irq_exit() if the cpu is in rcu idle state, regarding the
> dynticks_nesting value.   However, it seems not good to exit the rcu
> idle state, if we are actually entering into idle mode, so maybe it's
> better to call a matching rcu_irq_exit() before actually idle?
>
> As Frederic pointed out, we need a rcu_user_exit() to exit the user eqs
> (if we are in this state) in the beginning. But after some more
> thinking, I guess we might also need to call rcu_user_enter() after the
> waiting, if we get this page fault from user space. So maybe it's better
> to use rcu user eqs exception hooks here?

Makes sense.

>
> With rcu_user_exit() at the beginning, now rcu_irq_enter() only protects
> the cpu idle eqs, but it's not good to call rcu_irq_exit() after the cpu
> halt and the page ready.

Hmm, why is it not good?

>
> So I still want to remove it. And later if it shows that we really needs
> rcu somewhere in this code path, maybe we could use RCU_NONIDLE() to
> protect it. ( The suspicious RCU usage reported in commit
> c5e015d4949aa665 seems related to schedule(), which is not in the code
> path if we are in cpu idle eqs )

Yes but if rcu_irq_*() calls are fine to be called there, and I
believe they are because exception_enter() exits the user mode, we
should start to protect there right now instead of waiting for a
potential future warning of illegal RCU use.

>
> I think we still need Gleb's patch about the idle check in
> kvm_async_pf_task_wait(), and maybe another patch for the
> exit_idle()/enter_idle() issue.

Right.

Thanks.
