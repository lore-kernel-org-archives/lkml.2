Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1CQRuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:50:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37209 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab1CQRur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:50:47 -0400
Date: Thu, 17 Mar 2011 10:50:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
Message-ID: <20110317175034.GJ2304@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D7F356C.8020903@cn.fujitsu.com>
 <1300194693.10062.15.camel@edumazet-laptop>
 <20110316040308.GC2273@linux.vnet.ibm.com>
 <4D81D451.4020203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D81D451.4020203@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 05:28:49PM +0800, Lai Jiangshan wrote:
> On 03/16/2011 12:03 PM, Paul E. McKenney wrote:
> > On Tue, Mar 15, 2011 at 02:11:33PM +0100, Eric Dumazet wrote:
> >> Le mardi 15 mars 2011 à 17:46 +0800, Lai Jiangshan a écrit :
> >>
> >>
> >>> --- a/kernel/rcutiny.c
> >>> +++ b/kernel/rcutiny.c
> >>> @@ -167,7 +167,7 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
> >>>  		prefetch(next);
> >>>  		debug_rcu_head_unqueue(list);
> >>>  		local_bh_disable();
> >>> -		list->func(list);
> >>> +		__rcu_reclaim(list);
> >>>  		local_bh_enable();
> >>>  		list = next;
> >>>  		RCU_TRACE(cb_count++);
> >>
> >> Paul, I am just wondering why we disable BH before calling list->func()
> >>
> >> This should be done in callbacks that really need it ?
> >>
> >> At least the disable/enable pair is not necessary before calling kfree()
> > 
> > Good point, we could bury the enable/disable pair in __rcu_reclaim().
> > 
> > Lai, am I forgetting any reason why we disable BH?
> > 
> > 							Thanx, Paul
> > 
> 
> For many years, rcu callbacks are called on BH since rcu is added to kernel,
> and someone assume they always called in BH. So we have to disable BH before
> calling list->func() to avoid bad result. It's a *historical* reason.
> 
> I greed the disable/enable pair is not necessary before calling kfree(), but
> __rcu_reclaim() is also called in rcutree which rcu_process_callbacks()
> is in BH currently, I don't want to write 2 different version of
> __rcu_reclaim()s (one for rcutree, another for rcutiny).
> 
> rcutree's rcu_process_callbacks() will be moved to process context, we may
> remove disable/enable BH pair for kfree() then.

OK, so if I sequence your patches after the rcutree priority boosting,
which threadifies rcutree's callback processing, I should be able to
omit BH for the kfree() case.

							Thanx, Paul
