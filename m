Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1AUNjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:39:23 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50935 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1AUNjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:39:22 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110121130323.GA12900@elte.hu>
References: <20101108145647.GA3426@redhat.com>
	 <20101108145725.GA3434@redhat.com> <20110119182141.GA12183@redhat.com>
	 <20110120193033.GA13924@redhat.com> <1295611905.28776.269.camel@laptop>
	 <20110121130323.GA12900@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 21 Jan 2011 14:39:45 +0100
Message-ID: <1295617185.28776.273.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 14:03 +0100, Ingo Molnar wrote:
> > > But, it seems, there is another problem. Forget about the exiting,
> > > I can't understand why we can trust current in the code above.
> > > With __ARCH_WANT_INTERRUPTS_ON_CTXSW schedule() does:
> > > 
> > >     // sets cpuctx->task_ctx = NULL
> > >     perf_event_task_sched_out();
> > > 
> > >     // enables irqs
> > >     prepare_lock_switch();
> > > 
> > > 
> > >     // updates current_task
> > >     switch_to();
> > > 
> > > What if IPI comes in the window before switch_to() ?
> > > 
> > > (the same questions for __perf_event_enable).
> > 
> > Ingo, do you have any insights in that, I think you wrote all that
> > initially?
> 
> Not sure. Can an IPI come there - we have irqs disabled usually, dont we?

Ah, I think I see how that works:

  __perf_event_task_sched_out()
    perf_event_context_sched_out()
      if (do_switch)
        cpuctx->task_ctx = NULL;

vs

  __perf_install_in_context()
   if (cpu_ctx->task_ctx != ctx)


