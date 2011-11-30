Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1K3NEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:04:47 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:51457 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752433Ab1K3NEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:04:45 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/3gn4LBl/3ou/IHRcpmawUgV7j9w19qpTqa/UVwC
	sQEhq3/8v8CAMX
Subject: Re: [PATCH RT] tasklet/rt: Prevent tasklets from going into
 infinite spin in RT
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Clark Williams <williams@redhat.com>
In-Reply-To: <1322657130.5297.12.camel@marge.simson.net>
References: <1322618120.17003.104.camel@frodo>
	 <1322627551.17283.11.camel@marge.simson.net>
	 <alpine.LFD.2.02.1111301117240.2735@ionos>
	 <1322657130.5297.12.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Nov 2011 14:04:35 +0100
Message-ID: <1322658275.5297.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 13:45 +0100, Mike Galbraith wrote:
> On Wed, 2011-11-30 at 11:24 +0100, Thomas Gleixner wrote:
> > On Wed, 30 Nov 2011, Mike Galbraith wrote:

> > > @@ -131,11 +155,18 @@ void softirq_check_pending_idle(void)
> > >   */
> > >  static void wakeup_softirqd(void)
> > >  {
> > > -	/* Interrupts are disabled: no need to stop preemption */
> > > -	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
> > > +	struct task_struct *tsk;
> > > +	u32 pending = local_softirq_pending(), mask, i;
> > >  
> > > -	if (tsk && tsk->state != TASK_RUNNING)
> > > -		wake_up_process(tsk);
> > > +	/* Interrupts are disabled: no need to stop preemption */
> > > +	for (i = 0; pending && i < NR_SOFTIRQ_THREADS; i++) {
> > > +		mask = __get_cpu_var(ksoftirqd)[i].mask;
> > > +		if (!(pending & mask))
> > > +			continue;
> > > +		tsk = __get_cpu_var(ksoftirqd)[i].tsk;
> > > +		if (tsk && tsk->state != TASK_RUNNING)
> > > +			wake_up_process(tsk);
> > > +	}
> > >  }
> > 
> > Dammned serious is seems. :)

'course here I should have just used the busy bits directly.

	-Mike

