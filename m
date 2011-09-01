Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab1IAPVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:21:52 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:35017
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932346Ab1IAPVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:21:51 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:160.36.179.132;KIP:(null);UIP:(null);IPVD:NLI;H:kedge1.utk.tennessee.edu;RD:kedge1.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 1 Sep 2011 11:21:42 -0400
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Hommey <mh@glandium.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Problem with perf hardware counters grouping
In-Reply-To: <1314878012.11566.7.camel@twins>
Message-ID: <alpine.DEB.2.00.1109011117200.9976@cl320.eecs.utk.edu>
References: <20110831085718.GB13884@glandium.org> <1314878012.11566.7.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Peter Zijlstra wrote:

> What happens with your >3 case is that while the group is valid and
> could fit on the PMU, it won't fit at runtime because the NMI watchdog
> is taking one and won't budge (cpu-pinned counter have precedence over
> any other kind), effectively starving your group of pmu runtime.
> 
> Also, we should fix that return to say -EINVAL or so.

UGH!  I just noticed this problem yesterday and was meaning to track it 
down.

This obviously causes PAPI to fail if you try to use the maximum number of 
counters.  Instead of getting EINVAL at open time or even at start time, 
you just silently read all zeros at read time, and by then it's too late 
to do anything useful about the problem because you just missed measuring 
what you were trying to.

Is there any good workaround, or do we have to fall back to trying to 
start/read/stop every proposed event set to make sure it's valid?

This is going to seriously impact performance, and perf_event performance 
is pretty bad to begin with.  The whole reason I was writing the tests to 
trigger this is because PAPI users are complaining that perf_event 
overhead is roughly twice that of perfctr or perfmon2, which I've verified 
experimentally.

Vince

