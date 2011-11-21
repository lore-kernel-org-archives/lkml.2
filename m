Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab1KUWHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:07:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59854 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab1KUWHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:07:13 -0500
Message-ID: <1321913111.28118.40.camel@twins>
Subject: Re: [tip:perf/urgent] perf/x86: Enable raw event access to Intel
 offcore events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Stephane Eranian <eranian@google.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Date: Mon, 21 Nov 2011 23:05:11 +0100
In-Reply-To: <alpine.DEB.2.00.1111211559190.24943@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>
	 <tip-ed13ec58bfe0d5dc95f748e6118432cb0fa283cb@git.kernel.org>
	 <alpine.DEB.2.00.1111211321390.21667@cl320.eecs.utk.edu>
	 <1321901536.28118.20.camel@twins>
	 <alpine.DEB.2.00.1111211358570.23676@cl320.eecs.utk.edu>
	 <CABPqkBRHW0ZmeqADptvBySLZpi6jc_bEFKoukkA6rtd5o04ziQ@mail.gmail.com>
	 <alpine.DEB.2.00.1111211559190.24943@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 16:04 -0500, Vince Weaver wrote:

> The PAPI code currently uses FORMAT_GROUP and puts as many events as 
> possible in a group.  The way we maximize events in a group is to
> add events until perf_events indicates a failure.
> 
> When NMI watchdog is enabled, a counter is stolen.  Yet the perf_events
> code does not account for this.
> 
> So say on an AMD machine with 4 counters (3 after one is stolen) 
> perf_events lets you add 4 events to an event group, even though only 3 
> are available.  It does not report failure upon open or start, only at 
> read.  By then it's too late.
> 
> We have to work around this, by doing an extra read at open time to verify 
> that the event group actually is valid, adding overhead.

So strictly speaking this is a starvation case, we create a group that
requires the entire PMU but then run a higher priority event that won't
yield resulting in the group never getting scheduled.

Now fully agreed that starvation sucks, but I'm not exactly sure what to
do about it.

What isn't helping either is that all this scheduling code is per
arch :/
