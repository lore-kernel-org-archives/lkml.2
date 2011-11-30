Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1K3Mpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 07:45:45 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:57895 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751193Ab1K3Mpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 07:45:42 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Rhf5E49KR8SX3Y8SasAmYWGm/PAngQJrC//DNai
	QcIYU4T2rMDLdd
Subject: Re: [PATCH RT] tasklet/rt: Prevent tasklets from going into
 infinite spin in RT
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Clark Williams <williams@redhat.com>
In-Reply-To: <alpine.LFD.2.02.1111301117240.2735@ionos>
References: <1322618120.17003.104.camel@frodo>
	 <1322627551.17283.11.camel@marge.simson.net>
	 <alpine.LFD.2.02.1111301117240.2735@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Nov 2011 13:45:30 +0100
Message-ID: <1322657130.5297.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 11:24 +0100, Thomas Gleixner wrote:
> On Wed, 30 Nov 2011, Mike Galbraith wrote:

> > @@ -486,12 +495,43 @@ extern void softirq_check_pending_idle(v
> >   */
> >  DECLARE_PER_CPU(struct list_head [NR_SOFTIRQS], softirq_work_list);
> >  
> > -DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
> > +struct softirqdata {
> > +	int			mask;
> > +	struct task_struct	*tsk;
> > +};
> > +
> > +DECLARE_PER_CPU(struct softirqdata [NR_SOFTIRQ_THREADS], ksoftirqd);
> > +
> > +static inline bool this_cpu_ksoftirqd(struct task_struct *p)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
> > +		if (p == __get_cpu_var(ksoftirqd)[i].tsk)
> > +			return true;
> 
> You are not serious about that loop, are you ?

Well, it's a short loop, especially when NR_SOFTIRQ_THREADS = 1 (poof).

> > @@ -131,11 +155,18 @@ void softirq_check_pending_idle(void)
> >   */
> >  static void wakeup_softirqd(void)
> >  {
> > -	/* Interrupts are disabled: no need to stop preemption */
> > -	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
> > +	struct task_struct *tsk;
> > +	u32 pending = local_softirq_pending(), mask, i;
> >  
> > -	if (tsk && tsk->state != TASK_RUNNING)
> > -		wake_up_process(tsk);
> > +	/* Interrupts are disabled: no need to stop preemption */
> > +	for (i = 0; pending && i < NR_SOFTIRQ_THREADS; i++) {
> > +		mask = __get_cpu_var(ksoftirqd)[i].mask;
> > +		if (!(pending & mask))
> > +			continue;
> > +		tsk = __get_cpu_var(ksoftirqd)[i].tsk;
> > +		if (tsk && tsk->state != TASK_RUNNING)
> > +			wake_up_process(tsk);
> > +	}
> >  }
> 
> Dammned serious is seems. :)

Deadly serious :)

For the problem at hand (timer wakeups), NR_SOFTIRQ_THREADS could be 2.

> I was looking into that as well, though I did not want to inflict it
> on 3.0 at this point.
> 
> Thanks,
> 
> 	tglx


