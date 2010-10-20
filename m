Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab0JTLAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 07:00:22 -0400
Received: from canuck.infradead.org ([134.117.69.58]:47185 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0JTLAV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 07:00:21 -0400
Subject: Re: [PATCH] perf_events: fix time tracking in samples
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com
In-Reply-To: <AANLkTimjabS1MEkheJ0z2keceH=0eEfC_NbyCjZ-Ltxz@mail.gmail.com>
References: <4cbdcbea.8491d80a.25b0.ffffece8@mx.google.com>
	 <1287507178.1998.3440.camel@laptop>
	 <AANLkTik5_h1hVfX=1chezE6z25r4KV6GfzQZ+JvD8J_p@mail.gmail.com>
	 <1287508187.1998.3445.camel@laptop>
	 <AANLkTimjabS1MEkheJ0z2keceH=0eEfC_NbyCjZ-Ltxz@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Oct 2010 13:00:03 +0200
Message-ID: <1287572403.2703.35.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 21:03 +0200, Stephane Eranian wrote:

> >> Ok, I missed that. But I don't understand why you need the lock to
> >> udpate the time. The lower-level clock is lockless if I recall. Can't you
> >> use an atomic ops in update_context_time()?
> >
> > atomic ops would slow down those code paths, also, I don't think you can
> > fully get the ordering between ->tstamp_$foo and ->total_time_$foo just
> > right.
> >
> 
> I don't get that. Could you give an example?

Take update_context_time(), it has:

 now = perf_clock();
 ctx->time += now - ctx->timestamp;
 ctx->timestamp = now;

If you interleave two of those you get:

 ctx->timestamp = T0;


 now = perf_clock(); /* T1 */
 ctx->time += now - ctx->timestamp;
					now = perf_clock(); /* T2 */
					ctx->time += now - ctx->timestamp;
					ctx->timestamp = now;
 ctx->timestamp = now;


So at this point you would expect timestamp = T2 and time += T2-T0.

Except that: time += T1 - T0 + T2 - T0 != T2 - T0 and
             timestamp = T1

You can of course write it as something like x86_perf_event_update(),
but then there's trying to keep total_time_running and
total_time_enabled in sync.


> > Not sure, but barring 64bit atomics for all these, 32bit archs and NMI
> > are going to be 'interesting'
> >
> 
> Every sample needs to be correct, otherwise you run the risk of introducing
> bias.
> 
> I think if the tradeoffs is correctness vs. speed, I'd choose correctness.

Well, yes, but it sucks, esp. since its only relevant for
PERF_SAMPLE_READ.
