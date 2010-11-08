Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0KHQPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:15:41 -0500
Received: from qmta11.westchester.pa.mail.comcast.net ([76.96.59.211]:46082
	"EHLO QMTA11.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284Ab0KHQPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:15:40 -0500
Date: Mon, 8 Nov 2010 16:15:38 +0000 (UTC)
From: houston.jim@comcast.net
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Udo A. Steinberg" <udo@hypervisor.org>, Joe Korty <joe.korty@ccur.com>,
        mathieu desnoyers <mathieu.desnoyers@efficios.com>,
        dhowells@redhat.com, loic minier <loic.minier@linaro.org>,
        dhaval giani <dhaval.giani@gmail.com>, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Message-ID: <881839960.950383.1289232938613.JavaMail.root@sz0076a.westchester.pa.mail.comcast.net>
In-Reply-To: <757455806.950179.1289232791283.JavaMail.root@sz0076a.westchester.pa.mail.comcast.net>
Subject: Re: [PATCH] a local-timer-free version of RCU
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.183.159.239]
X-Mailer: Zimbra 6.0.5_GA_2431.RHEL5_64 (ZimbraWebClient - FF3.0 (Linux)/6.0.5_GA_2427.RHEL4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

I'm sorry started this thread and have not been able to keep up
with the discussion.  I agree that the problems described are real.

> > UAS> PEM> o	CPU 1 continues in rcu_grace_period_complete(),
> > UAS> PEM> incorrectly ending the new grace period.
> > UAS> PEM> 
> > UAS> PEM> Or am I missing something here?
> > UAS> 
> > UAS> The scenario you describe seems possible. However, it should be easily
> > UAS> fixed by passing the perceived batch number as another parameter to
> > UAS> rcu_set_state() and making it part of the cmpxchg. So if the caller
> > UAS> tries to set state bits on a stale batch number (e.g., batch !=
> > UAS> rcu_batch), it can be detected.

My thought on how to fix this case is to only hand off the DO_RCU_COMPLETION
to a single cpu.  The rcu_unlock which receives this hand off would clear its
own bit and then call rcu_poll_other_cpus to complete the process.

> What is scary with this is that it also changes rcu sched semantics, and users
> of call_rcu_sched() and synchronize_sched(), who rely on that to do more
> tricky things than just waiting for rcu_derefence_sched() pointer grace periods,
> like really wanting for preempt_disable and local_irq_save/disable, those
> users will be screwed... :-(  ...unless we also add relevant rcu_read_lock_sched()
> for them...

I need to stare at the code and get back up to speed. I expect that the synchronize_sched
path in my patch is just plain broken.

Jim Houston
