Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1I1TKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 15:10:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47511 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1I1TJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 15:09:59 -0400
Subject: Re: [RFD 1/9] Change cpustat fields to an array.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com
Date: Wed, 28 Sep 2011 21:09:17 +0200
In-Reply-To: <4E836546.7010004@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
	  <1316816432-9237-2-git-send-email-glommer@parallels.com>
	 <1317157252.21836.3.camel@twins> <4E836546.7010004@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317236957.24040.62.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 15:19 -0300, Glauber Costa wrote:
> On 09/27/2011 06:00 PM, Peter Zijlstra wrote:
> > On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
> >>   /* Must have preemption disabled for this to be meaningful. */
> >> -#define kstat_this_cpu __get_cpu_var(kstat)
> >> +#define kstat_this_cpu this_cpu_ptr(task_group_kstat(current))
> >
> > This just lost you a debug check, the former would whinge when called
> > without preemption, the new one wont. Its part of the this_cpu feature
> > set to make debugging impossible.
> >
> >> +#else
> >> +#define kstat_cpu(cpu) per_cpu(kstat, cpu)
> >> +#define kstat_this_cpu (&__get_cpu_var(kstat))
> >> +#endif
> >>
> >>   extern unsigned long long nr_context_switches(void);
> >>
> >> @@ -52,8 +62,8 @@ struct irq_desc;
> >>   static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
> >>                                              struct irq_desc *desc)
> >>   {
> >> -       __this_cpu_inc(kstat.irqs[irq]);
> >> -       __this_cpu_inc(kstat.irqs_sum);
> >> +       kstat_this_cpu->irqs[irq]++;
> >> +       kstat_this_cpu->irqs_sum++;
> >
> > It might be worth looking at the asm output of that, I think you made it
> > worse, but I'm not quite sure how smart gcc is, it might just figure out
> > what you meant.
> 
> I'd say leave it alone.
> The biggest difference is that we don't have access to task_group(), or 
> any of the fields in struct task_group. Because of that, we end up 
> having to export a function to do the job of dealing with it.
> 
> Users inside sched.c won't have this problem. Outside of it, we'll add a 
> call to some paths. True, mostly handle_irq paths, but I don't think 
> that's what's going to kill us.
> 
> Now if we really really want to save it, we'd have to move struct 
> task_group and its friends to a more visible location like a header...

I'm not quite getting how task_group is relevant here.

The above will do something like:

	mov gs:$per-cpu-offset-of-kstat, reg
	inc reg + idx*8

whereas __this_cpu_inc() could end up like:

	inc gs:$per-cpu-offset-of-kstat + idx*8

or whatnot. Now clearly gcc could be smart and optimize the temporary
reg thing away in the earlier case, or it might not, I really don't know
how smart that thing is.
