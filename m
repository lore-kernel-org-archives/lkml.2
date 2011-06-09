Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab1FIAMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 20:12:01 -0400
Received: from blu0-omc1-s24.blu0.hotmail.com ([65.55.116.35]:2507 "EHLO
	blu0-omc1-s24.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890Ab1FIAMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 20:12:00 -0400
X-Originating-IP: [184.145.208.36]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP554442FCF79C11301E4AB696650@phx.gbl>
Date: Wed, 8 Jun 2011 20:11:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 05/28] rcu: Move rcu_head definition to
	types.h
References: <20110608192943.GA13211@linux.vnet.ibm.com> <1307561407-13809-5-git-send-email-paulmck@linux.vnet.ibm.com> <BLU0-SMTP635E2E394E1488A2717A5B96620@phx.gbl> <20110609000203.GO2324@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20110609000203.GO2324@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:08:25 up 427 days,  9:58,  3 users,  load average: 0.31, 0.19,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 09 Jun 2011 00:11:55.0941 (UTC) FILETIME=[D79EED50:01CC2639]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Wed, Jun 08, 2011 at 07:26:21PM -0400, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > Take a first step towards untangling Linux kernel header files by
> > > placing the struct rcu_head definition into include/linux/types.h.
> > > Once this is in place, then header files that need only rcu_head
> > > can include types.h rather than rcupdate.h.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Yes! I'm suddenly feeling the temperature drop by a few degrees in
> > #include hell ;) One detail though: I think rcupdate.h should then
> > include types.h.
> 
> Glad you like it!
> 
> But please see below.
> 
> > Thanks,
> > 
> > Mathieu
> > 
> > 
> > > ---
> > >  include/linux/rcupdate.h |   10 +---------
> > >  include/linux/types.h    |   10 ++++++++++
> > >  2 files changed, 11 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > > index 8be0433..ad09eb8 100644
> > > --- a/include/linux/rcupdate.h
> > > +++ b/include/linux/rcupdate.h
> > > @@ -64,15 +64,7 @@ static inline void rcutorture_record_progress(unsigned long vernum)
> > >  #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
> > >  #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
> > >  
> > > -/**
> > > - * struct rcu_head - callback structure for use with RCU
> > > - * @next: next update requests in a list
> > > - * @func: actual update function to call after the grace period.
> > > - */
> > > -struct rcu_head {
> > > -	struct rcu_head *next;
> > > -	void (*func)(struct rcu_head *head);
> > > -};
> > > +#include <linux/types.h>
> 
> And here you go!

Hrm, I see. Here is why I missed it: I was expecting this #include to be
added at the top of rcupdate.h instead of being added in the middle like
you do here. Would it be acceptable to move this #include to the top of
the file, or is there some other obscure reason for not doing so ? (I
feel the temperature is suddenly rising) ;-)

Thanks,

Mathieu

> 
> > >  
> > >  /* Exported common interfaces */
> > >  extern void call_rcu_sched(struct rcu_head *head,
> > > diff --git a/include/linux/types.h b/include/linux/types.h
> > > index 176da8c..57a9723 100644
> > > --- a/include/linux/types.h
> > > +++ b/include/linux/types.h
> > > @@ -238,6 +238,16 @@ struct ustat {
> > >  	char			f_fpack[6];
> > >  };
> > >  
> > > +/**
> > > + * struct rcu_head - callback structure for use with RCU
> > > + * @next: next update requests in a list
> > > + * @func: actual update function to call after the grace period.
> > > + */
> > > +struct rcu_head {
> > > +	struct rcu_head *next;
> > > +	void (*func)(struct rcu_head *head);
> > > +};
> > > +
> > >  #endif	/* __KERNEL__ */
> > >  #endif /*  __ASSEMBLY__ */
> > >  #endif /* _LINUX_TYPES_H */
> > > -- 
> > > 1.7.3.2
> > > 
> > 
> > -- 
> > Mathieu Desnoyers
> > Operating System Efficiency R&D Consultant
> > EfficiOS Inc.
> > http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
