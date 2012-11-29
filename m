Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2K2BuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:50:02 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:49282 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2K2BuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:50:00 -0500
Message-ID: <1354153788.2499.9.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v2] Add rcu user eqs exception hooks for async page
 fault
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, gleb@redhat.com, avi@redhat.com
Date: Thu, 29 Nov 2012 09:49:48 +0800
In-Reply-To: <CAFTL4hxPSp1fs4=2g0yFs0d5nFisfUsfDAA9bHWcu+-+tO_ySw@mail.gmail.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
	 <CAFTL4hx0fc_Jo8wkuRZedW4DVEeQceiHMrWVqTqB5k065Wsg8Q@mail.gmail.com>
	 <1354090704.3054.13.camel@ThinkPad-T5421.cn.ibm.com>
	 <CAFTL4hxPSp1fs4=2g0yFs0d5nFisfUsfDAA9bHWcu+-+tO_ySw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12112901-3568-0000-0000-000002D79146
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-28 at 13:55 +0100, Frederic Weisbecker wrote:
> 2012/11/28 Li Zhong <zhong@linux.vnet.ibm.com>:
> > Thank you all for the review and education.
> >
> > Below are my current understandings and an update version. Would you
> > please help to review it again and give your comments?
> >
> > Thanks, Zhong
> >
> > Now it seems to me that it is legal to call rcu_irq_exit/enter() without
> > a matching rcu_irq_enter/exit() if the cpu is in non rcu idle state.
> >
> > As opposite, it is illegal to call rcu_irq_exit() without a matching
> > rcu_irq_enter() if the cpu is in rcu idle state.
> >
> > But it seems legal to call rcu_irq_enter() without a matching
> > rcu_irq_exit() if the cpu is in rcu idle state, regarding the
> > dynticks_nesting value.   However, it seems not good to exit the rcu
> > idle state, if we are actually entering into idle mode, so maybe it's
> > better to call a matching rcu_irq_exit() before actually idle?
> >
> > As Frederic pointed out, we need a rcu_user_exit() to exit the user eqs
> > (if we are in this state) in the beginning. But after some more
> > thinking, I guess we might also need to call rcu_user_enter() after the
> > waiting, if we get this page fault from user space. So maybe it's better
> > to use rcu user eqs exception hooks here?
> 
> Makes sense.
> 
> >
> > With rcu_user_exit() at the beginning, now rcu_irq_enter() only protects
> > the cpu idle eqs, but it's not good to call rcu_irq_exit() after the cpu
> > halt and the page ready.
> 
> Hmm, why is it not good?

I think in this case, as cpu halts and waits for page ready, it is
really in idle, and it's better for rcu to think it as rcu idle. But
with rcu_irq_enter(), the rcu would not think this cpu as idle. And the
rcu_irq_exit() is only called after this idle period to mark this cpu as
rcu idle again. 
> 
> >
> > So I still want to remove it. And later if it shows that we really needs
> > rcu somewhere in this code path, maybe we could use RCU_NONIDLE() to
> > protect it. ( The suspicious RCU usage reported in commit
> > c5e015d4949aa665 seems related to schedule(), which is not in the code
> > path if we are in cpu idle eqs )
> 
> Yes but if rcu_irq_*() calls are fine to be called there, and I
> believe they are because exception_enter() exits the user mode, we
> should start to protect there right now instead of waiting for a
> potential future warning of illegal RCU use.

I agree, but I think by only protecting the necessary code avoids
marking the entire waiting period as rcu non idle.

Thanks, Zhong

> 
> >
> > I think we still need Gleb's patch about the idle check in
> > kvm_async_pf_task_wait(), and maybe another patch for the
> > exit_idle()/enter_idle() issue.
> 
> Right.
> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


