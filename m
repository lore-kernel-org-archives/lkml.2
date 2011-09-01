Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab1IARQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:16:15 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:23949
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144Ab1IARQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:16:13 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:160.36.179.113;KIP:(null);UIP:(null);IPVD:NLI;H:kedge4.utk.tennessee.edu;RD:kedge4.utk.tennessee.edu;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 1 Sep 2011 13:16:10 -0400
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Hommey <mh@glandium.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Problem with perf hardware counters grouping
In-Reply-To: <1314895312.1485.2.camel@twins>
Message-ID: <alpine.DEB.2.00.1109011308430.9976@cl320.eecs.utk.edu>
References: <20110831085718.GB13884@glandium.org>  <1314878012.11566.7.camel@twins>  <alpine.DEB.2.00.1109011117200.9976@cl320.eecs.utk.edu> <1314895312.1485.2.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Peter Zijlstra wrote:
> > Is there any good workaround, or do we have to fall back to trying to 
> > start/read/stop every proposed event set to make sure it's valid?
> 
> I guess my first question is going to be, how do you know what the
> maximum number of counters is in the first place?

The use case where this comes up the easiest is where you are adding
events to an eventset one at a time until failure.  Then you assume
failure - 1 is the number available.  So this would boil down
to doing that many sys_perf_open()/close() calls.  This obviously fails
in the current watchdog timer case.

The other way to know is the query libpfm4 which "knows" the number of 
counters available on each CPU.  PAPI uses this as a hueristic not as a 
hard limit, but it can also lead to the problem occurring if the test 
tries the limit, the sys_perf_open() succcedes... and then fails upon 
read.

Does the perf tool work around this in some way?  

> > This is going to seriously impact performance, and perf_event performance 
> > is pretty bad to begin with.  The whole reason I was writing the tests to 
> > trigger this is because PAPI users are complaining that perf_event 
> > overhead is roughly twice that of perfctr or perfmon2, which I've verified 
> > experimentally.
> 
> Yeah, you keep saying this, where does it come from? Only the lack of
> userspace rdpmc?

that's part of it.  I've been working on isolating this, but for a fair 
comparison it involves writing low-level code that accesses perf_event, 
perfctr, and perfmon2 directly at the syscall level and as you can imagine 
that's not easy or fun.  It's also tricky as you can imagine to try to 
profile the perf_event code using perf_events.

Vince
vweaver1@eecs.utk.edu

