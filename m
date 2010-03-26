Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab0CZT1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 15:27:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44395 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab0CZT1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 15:27:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QCEfJVI5gst0KotkVe6xMq66LbOw/pV9r853xKJcJwwNgGwji+P6PU69yyY0bbUj94
         2vT3OLnUBzmDcUWNkGc8Yf8uZV7wH2Vbjjtdm1lVye5yZExEgSXW5/l4YYkjputei4rB
         3pKQuSzcoVBJn6LUBx2i9A0Y/5g2gEEYMt4Ic=
Date: Fri, 26 Mar 2010 20:27:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [BUG] perf: hard lockup when using perf-sched
Message-ID: <20100326192712.GA7166@nowhere>
References: <4BA082EC.8030101@cn.fujitsu.com> <4BA9A885.9050105@cn.fujitsu.com> <1269415964.6530.25.camel@marge.simson.net> <1269418671.6465.6.camel@marge.simson.net> <4BAB1924.4060304@cn.fujitsu.com> <1269509241.8438.30.camel@marge.simson.net> <1269598293.6174.8.camel@marge.simson.net> <20100326172350.GC5188@nowhere> <1269630640.6331.18.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269630640.6331.18.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 08:10:40PM +0100, Mike Galbraith wrote:
> On Fri, 2010-03-26 at 18:23 +0100, Frederic Weisbecker wrote:
> > On Fri, Mar 26, 2010 at 11:11:33AM +0100, Mike Galbraith wrote:
> 
> > > perf: fix perf sched record forkbomb deadlock
> > > 
> > > perf sched record can deadlock a box should the holder of handle->data->lock
> > > take an interrupt, and then attempt to acquire an rq lock held by a CPU trying
> > > to acquire the same lock.  Disable interrupts.
> > 
> > 
> > 
> > Aah.
> > 
> > So the scenario is the following inversion?
> > 
> > 	CPU0				CPU1
> > sched event with rq->lock held
> > 				grab handle->data->lock
> > spin on handle->data->lock
> > 				interrupt
> > 				try to grab rq->lock
> 
> Yeah, handle->data->lock holder dare not try to grab any rq lock because
> of sched event with rq->lock held.
> 


But if that happens with perf sched, there is something weird.
perf sched only use sched events, which have interrupt disabled
from the trace event handler, so this is not supposed to happen.

But if there is another kind of event involved, something that has
interrupts enabled, may be some software events, then it may
happen indeed.

