Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0LIRdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:33:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab0LIRdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:33:08 -0500
Date: Thu, 9 Dec 2010 15:32:47 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ian Munsie <imunsie@au1.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 9/9] pref: session: Break event ordering when
	timestamps are missing
Message-ID: <20101209173247.GB15579@ghostprotocols.net>
References: <20101207124527.868085529@linutronix.de> <20101207124551.209741779@linutronix.de> <1291865671-sup-8975@au1.ibm.com> <alpine.LFD.2.00.1012091455590.2653@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012091455590.2653@localhost6.localdomain6>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 09, 2010 at 02:58:10PM +0100, Thomas Gleixner escreveu:
> On Thu, 9 Dec 2010, Ian Munsie wrote:
> > Excerpts from Thomas Gleixner's message of Tue Dec 07 12:49:04 UTC 2010:
> > > Allow the session client to specify that event ordering should be
> > > stopped when not all events have time stamps.
> > 
> > >  	/* These events are processed right away */
> > >  	switch (event->header.type) {
> > >  	case PERF_RECORD_HEADER_ATTR:
> > > -		return ops->attr(event, session);
> > > +		/* This updates session->sample_id_all */
> > > +		ret = ops->attr(event, session);
> > > +		/* Break ordering if sample_id_all is false */
> > > +		if (ops->ordering_requires_timestamps &&
> > > +		    ops->ordered_samples && !session->sample_id_all) {
> > > +			session->ordered_samples.next_flush = ULLONG_MAX;
> > > +			flush_sample_queue(session, ops);
> > > +			ops->ordered_samples = false;
> > > +		}
> > > +		return ret;
> > Since the fall back isn't triggered, not only are COMM and MMAP events
> > processed first (from patch 2 in this series), but EXIT will as well,
> > which causes no userspace events to be attributed.
> 
> So we need to check this in every event processing path? Or do we have
> for this kind of processing some other method which allows us to
> disable the ordered_samples bit once ?

FYI: I merged everything up to 8/9 and will push to Ingo soon, holler
if you disagree.

- Arnaldo
