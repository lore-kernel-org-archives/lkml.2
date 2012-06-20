Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab2FTPyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:54:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:34003 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab2FTPyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:54:37 -0400
Message-ID: <1340207670.21745.108.camel@twins>
Subject: Re: [PATCH 00/10] perf, x86: Add northbridge counter support for
 AMD family 15h
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jun 2012 17:54:30 +0200
In-Reply-To: <20120620122941.GH5046@erda.amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
	 <CABPqkBS9hRxKLsecVK+AgRue6oqTtAg4=0Dpd5Z2VwAUja50fw@mail.gmail.com>
	 <20120620092932.GH1478@erda.amd.com> <1340185084.21745.81.camel@twins>
	 <20120620100031.GI1478@erda.amd.com> <1340187373.21745.95.camel@twins>
	 <20120620122941.GH5046@erda.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 14:29 +0200, Robert Richter wrote:
> On 20.06.12 12:16:13, Peter Zijlstra wrote:
> > Sure it can be done, just not pretty. Combine that with all the other
> > special casing like patches 3 and 10 and one really starts to wonder if
> > its all worth it.
> 
> I actually started writing the code by implementing a different pmu.
> It turned out to be the wrong direction. The pmus would be almost
> identical, just some different config values and a bit nb related
> special code. But you can't really reuse the functions on a 2nd
> running pmu, there are hard wired functions in the x86 pmu code and
> x86_pmu ops do not fit for such a split. It would mean a complete
> rework of x86 perf code. Really, I tried that already. And all this
> effort just to implement nb counters? If someone is willing to help
> here this would be ok, but I guess I would have to do all this on my
> own. And to be fair, this effort was also not make for fixed counters,
> pebs, bts, etc. Maybe the uncore implementation is different here, but
> today is the first day the uncore patches are in tip.

Yeah, the Intel uncore implements an entire new pmu. The code is a
little over the top because Intel went there and decided it was a good
thing to have numerous uncore pmus instead of 1, some in PCI space some
in MSR space.

Still their programming is similar to the core ones -- just like for
AMD.

Yeah, there's a little bit of 'duplicated' code, but that's unavoidable.

> I also do not see the advantage of a separate pmu. Just to have a
> different msr base to avoid the use of counter masks and some
> optimized pmu ops? Masks are wide spread used in the kernel and on x86
> the bsf instruction takes not more than an increment. And switches in
> the code paths to special nb code are not more expensive than other
> switches for other special code.

Well, as it stands this thing is almost certainly doing things wrong. An
uncore pmu wants to put all events for the same NB on the same cpu, not
on whatever cpu they are registered, otherwise event rotation doesn't
work right.

It also wants to migrate events to another cpu if the designated cpu
gets unplugged but there's still active cpus on the NB.

Furthermore, if the uncore does PMI, you want PMI steering, if it
doesn't do PMIs you want to poll the thing to avoid overflowing the
counter.

/me rummages on the interwebs to find the BKDG for Fam15h..

OK, it looks like it does do PMI and it broadcast interrupts to the
entire NB.. ok so that wants special magic too -- you might even want to
disallow sampling on the thing until someone has a good use-case for
that -- but you still need the PMI to deal with the counter overflow
stuff.



