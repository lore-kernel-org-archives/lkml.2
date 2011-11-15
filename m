Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1KOMzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:55:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:51238 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1KOMzk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:55:40 -0500
Subject: Re: [PATCH RFC] perf, core: disable pmu while context rotation only
 if needed
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Date: Tue, 15 Nov 2011 13:55:18 +0100
In-Reply-To: <20111115123814.GE3225@redhat.com>
References: <20111115113414.GD3225@redhat.com>
	 <1321358833.1421.62.camel@twins> <20111115123814.GE3225@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321361719.1421.67.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 14:38 +0200, Gleb Natapov wrote:
> On Tue, Nov 15, 2011 at 01:07:13PM +0100, Peter Zijlstra wrote:
> > On Tue, 2011-11-15 at 13:34 +0200, Gleb Natapov wrote:
> > > 
> > > Currently pmu is disabled and re-enabled on each timer interrupt even
> > > when no rotation or frequency adjustment is needed. On Intel CPU this
> > > results in two writes into PERF_GLOBAL_CTRL MSR per tick. On bare metal
> > > it does not cause significant slowdown, but when running perf in a virtual
> > > machine it leads to 20% slowdown on my machine.
> > 
> > 
> > I detest asymmetric locking like that, does something like the below
> > also work for you?
> > 
> It does.

ok, great.

> >  
> > +	if (!rotate && !freq)
> > +		goto done;
> > +
> >  	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> >  	perf_pmu_disable(cpuctx->ctx.pmu);
> > +
> > +	if (!freq)
> > +		goto rotate;
> > +
> Why goto, why not
> 
> 	if (freq) {
> >  	perf_ctx_adjust_freq(&cpuctx->ctx, interval);
> >  	if (ctx)
> >  		perf_ctx_adjust_freq(ctx, interval);
>         }
> 
> And the same with next goto.

Because, uhm,. dunno. Let me make that if()s and commit the thing.
Thanks!
