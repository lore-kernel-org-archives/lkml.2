Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab2FUOoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 10:44:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60126 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665Ab2FUOoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 10:44:14 -0400
Message-ID: <1340289834.18025.14.camel@twins>
Subject: Re: What is the right practice to get new code upstream( was Fwd:
 [patch] a simple hardware detector for latency as well as throughput ver.
 0.1.0)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Luming Yu <luming.yu@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        tglx@linutronix.de, sfr@canb.auug.org.au,
        Andrew Morton <akpm@linux-foundation.org>, jcm@jonmasters.org,
        linux-next@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        torvalds@linux-foundation.org
Date: Thu, 21 Jun 2012 16:43:54 +0200
In-Reply-To: <20120621132914.GA24632@erda.amd.com>
References: <CAJRGBZw2TctmBxRuA-byaGNCs=1v+M-1PXSm+OuwWApSqu7UjA@mail.gmail.com>
	 <1339668296.2559.25.camel@twins> <20120621132914.GA24632@erda.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 15:29 +0200, Robert Richter wrote:
> On 14.06.12 12:04:56, Peter Zijlstra wrote:
>  For AMD there's only event 02Bh, which is SMIs Received. I'm not sure it
> > has anything like the FREEZE or if the event is modifyable to count the
> > cycles in SMI.
> 
> Peter, which use cases do you have in mind. Is it to root cause
> latencies? Or just to see what happens on the system, you long it
> spends in smi mode? On current systems counting smi cycles seems not
> to be possible.

Yeah exactly. So we can whack vendors over the head with hard evidence
their BIOS is utter shite.

So what we do now is disable interrupts, run a tight TSC read loop and
report fail when you see a big delta.

Now some 'creative' BIOS people thought it would be a good idea to
save/restore TSC over the SMI, this avoids detection. It also completely
wrecks TSC sync across cores.

But the SMI stuff is a real problem for -rt, this feature^Wfailure-add
is a real problem, we've seen SMIs that go well above a ms in duration,
which of course completely wreck the system.

IIRC the worst tglx ever encountered was 0.5s or so.

So ideally the PMU would have 2 events, one counting SMIs one counting
cycles in SMM. Both should ignore any and all FREEZE_IN_SMM bits if such
a thing exists. The hardware should also hard fail if such a counter is
fiddled with from SMM context.

This would give us the capability to log exactly when and for how long
the system is taken from us and makes it impossible to 'fix' from SMM.
