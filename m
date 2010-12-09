Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab0LIN6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:58:41 -0500
Received: from www.tglx.de ([62.245.132.106]:55189 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab0LIN6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:58:40 -0500
Date: Thu, 9 Dec 2010 14:58:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Munsie <imunsie@au1.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 9/9] pref: session: Break event ordering when timestamps
 are missing
In-Reply-To: <1291865671-sup-8975@au1.ibm.com>
Message-ID: <alpine.LFD.2.00.1012091455590.2653@localhost6.localdomain6>
References: <20101207124527.868085529@linutronix.de> <20101207124551.209741779@linutronix.de> <1291865671-sup-8975@au1.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010, Ian Munsie wrote:
> Excerpts from Thomas Gleixner's message of Tue Dec 07 12:49:04 UTC 2010:
> > Allow the session client to specify that event ordering should be
> > stopped when not all events have time stamps.
> 
> >  	/* These events are processed right away */
> >  	switch (event->header.type) {
> >  	case PERF_RECORD_HEADER_ATTR:
> > -		return ops->attr(event, session);
> > +		/* This updates session->sample_id_all */
> > +		ret = ops->attr(event, session);
> > +		/* Break ordering if sample_id_all is false */
> > +		if (ops->ordering_requires_timestamps &&
> > +		    ops->ordered_samples && !session->sample_id_all) {
> > +			session->ordered_samples.next_flush = ULLONG_MAX;
> > +			flush_sample_queue(session, ops);
> > +			ops->ordered_samples = false;
> > +		}
> > +		return ret;
> Since the fall back isn't triggered, not only are COMM and MMAP events
> processed first (from patch 2 in this series), but EXIT will as well,
> which causes no userspace events to be attributed.

So we need to check this in every event processing path? Or do we have
for this kind of processing some other method which allows us to
disable the ordered_samples bit once ?

Thanks,

	tglx
