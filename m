Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1A0Q1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:27:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37163 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab1A0Q1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 11:27:11 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110127161047.GB25060@redhat.com>
References: <20110121204014.GA2870@nowhere>
	 <20110124114234.GA12166@redhat.com> <20110126175322.GA28617@redhat.com>
	 <20110126184957.GA32578@redhat.com> <1296068731.15234.6.camel@laptop>
	 <1296070383.15234.10.camel@laptop> <20110126211931.GA6778@redhat.com>
	 <20110126213317.GA7403@redhat.com> <1296124337.15234.71.camel@laptop>
	 <1296131387.15234.142.camel@laptop>  <20110127161047.GB25060@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 17:27:54 +0100
Message-ID: <1296145674.15234.238.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 17:10 +0100, Oleg Nesterov wrote:
> >  #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
> >       local_irq_enable();
> > +     rq->in_ctxsw = 0;
> 
> If we think that context_switch finishes here, probably it would be
> more clean to clear ->in_ctxsw before local_irq_enable().

It must in fact be done before, otherwise there's a race where we set
ctx after perf_event_task_sched_in() runs, and we send the IPI, the IPI
lands after local_irq_enable() but before rq->in_ctxsq = 0, the IPI is
ignored, nothing happens.

> >  #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
> >       finish_lock_switch(rq, prev);
> 
> But, otoh, maybe finish_lock_switch() can clear in_ctxsw, it already
> checks __ARCH_WANT_INTERRUPTS_ON_CTXSW. Likewise, perhaps it can be
> set in prepare_lock_switch() which enables irqs.
> 
> But this is cosmetic and up to you. 

Can't do because of the above thing..
