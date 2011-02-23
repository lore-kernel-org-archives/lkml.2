Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab1BWS1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:27:19 -0500
Received: from blu0-omc1-s21.blu0.hotmail.com ([65.55.116.32]:34558 "EHLO
	blu0-omc1-s21.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377Ab1BWS1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:27:18 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP674602DA4CC177BF5E9ED96DB0@phx.gbl>
Date: Wed, 23 Feb 2011 13:27:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
	to kthread
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com> <20110223161645.GA1819@nowhere> <1298479302.7666.94.camel@gandalf.stny.rr.com> <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl> <alpine.DEB.2.00.1102231132140.562@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102231132140.562@router.home>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:26:49 up 322 days,  4:16,  6 users,  load average: 1.70, 2.01,
	1.89
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 23 Feb 2011 18:27:16.0808 (UTC) FILETIME=[4C85E480:01CBD387]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Wed, 23 Feb 2011, Mathieu Desnoyers wrote:
> 
> > > > > +
> > > > > +	local_irq_save(flags);
> > > > > +	cpu = smp_processor_id();
> 
> Drop this line.
> 
> > > > > +	if (per_cpu(rcu_cpu_kthread_task, cpu) == NULL) {
> 
> use this_cpu_read(rcu_cpu_kthread_task)
> 
> > > > > +		local_irq_restore(flags);
> > > > > +		return;
> > > > > +	}
> > > > > +	per_cpu(rcu_cpu_has_work, cpu) = 1;
> 
> this_cpu_write(rcu_cpu_has_work, 1);
> 
> > This is not quite true on x86_64 and s390 anymore. __get_cpu_var() now
> > uses a segment selector override to get the local CPU variable on x86.
> > See x86's percpu.h for details.
> 
> __get_cpu_var cannot use a segment override since there are places where
> the address of the variable is taken. One needs to use this_cpu_ops for
> that.

Ah, thanks for the clarification :)

> 
> 
> > > True, but we could also argue that the multiple checks for being preempt
> > > can also be an issue.
> >
> > At least on x86 preemption don't actually need to be disabled: selection
> > of the right per-cpu memory location is done atomically with the rest of
> > the instruction by the segment selector.
> 
> Right.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
