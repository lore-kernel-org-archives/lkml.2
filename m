Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab0KYV1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 16:27:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:58486 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab0KYV1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 16:27:24 -0500
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
 label key entries
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: michael@ellerman.id.au
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, linux-kernel@vger.kernel.org
In-Reply-To: <1290692564.689.28.camel@concordia>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com>
	 <1290586809.2072.424.camel@laptop> <20101124145401.GA2815@redhat.com>
	 <1290611478.2072.482.camel@laptop> <20101124151936.GB2815@redhat.com>
	 <1290612245.2072.486.camel@laptop>  <20101124154200.GD2815@redhat.com>
	 <1290613997.30543.529.camel@gandalf.stny.rr.com>
	 <1290652762.18088.4.camel@concordia>  <1290667950.2072.545.camel@laptop>
	 <1290692564.689.28.camel@concordia>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 08:26:05 +1100
Message-ID: <1290720365.32570.133.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 00:42 +1100, Michael Ellerman wrote:
> > Ooh, nice, so the CPUs won't get all confused because you change
> code
> > from under their ifetch cache?
> 
> Apparently not, at least according to the architecture.

As long as you are atomically changing one word fully aligned (remember,
no variable length instructions on ppc :-) you are fine. The other CPU
will see either the old or the new value, not something in between.

The dcbf/sync/icbi/isync is really only necessary on older processors.
dcbf will broadcast a request to flush that line out of D, sync will
wait for that to complete, icbi will broadcast an invalidate of that
line out of I, sync will wait for that to have gone out and isync will
locally synchronize the pipeline (toss prefetch).

Now, P5 and later have a HW snoop of I/D, so dcbf isn't useful. You need
at least an isync tho to ensure prefetched stuff has been tossed or you
may still execute the "old" instructions for a little while.

On P7 (I'm not sure about 5 and 6 here), additionally, they have sneaky
optimisations in isync (bcs some people abuse it as a read barrier)
using a scoreboard to decide what to do. In essence, that means that
alone, it won't toss prefetch unless scoreboarded to do so by a previous
icbi. So one icbi (regardless of how much you want to invalidate and
with any address) followed by isync will do.

An interrupt will do too tho :-)

Cheers,
Ben.

