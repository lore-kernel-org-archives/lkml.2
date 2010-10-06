Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab0JFNat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:30:49 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49270 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879Ab0JFNaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:30:46 -0400
Date: Wed, 6 Oct 2010 22:30:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Matt Fleming <matt@console-pimps.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/7] perf: New helper function for pmu name
Message-ID: <20101006133041.GA29273@linux-sh.org>
References: <cover.1286222593.git.matt@console-pimps.org> <59a8e68894a2e755232189abbe9b1a3b892e309c.1286222593.git.matt@console-pimps.org> <20101006122736.GL13563@erda.amd.com> <20101006123950.GA29118@linux-sh.org> <20101006131825.GO13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006131825.GO13563@erda.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 03:18:25PM +0200, Robert Richter wrote:
> I don't want to be the perf_pmu_name() discussion a show stopper for
> this patch set. We don't have a generic perf interface available now
> that allows us to detect the pmu type for sh cpus. I also don't see a
> name string as a final solution for pmu detection. So it will be more
> than just adding perf_pmu_name().
> 
Whether you see it as a show stopper or not is not the issue, I will not
expose sh_pmu generically. Nor do I imagine that the x86 people or any
other architecture wishing to tie in to the oprofile wrapper are
interested in doing the equivalent there. We have a registration
interface to do, and I will not provide oprofile-specific workarounds
for it hidden in the arch code.

> Until then, as we currently would only need the name for SH, I don't
> see something wrong here to include architectural interfaces from
> <asm/perf_event.h> directly by architectural code until a general
> solution is available.  If you run a 'git grep include..asm/perf' this
> is common for other architectures.
> 
This is nonsense. Every architecture that needs to support the oprofile
userspace tools needs to support the string interface. At the same time,
everyone supporting hardware perf events in the kernel today already has
a string to pmu mapping somewhere in their data structures. This can
easily be exposed generically, and platforms that have special mangling
they need to do before exposing the string to oprofile can do so if the
need to.

> I am not against adding the pmu name to the perf API. But the oprofile
> cpu_type strings are oprofile centric esp. for the userland. So these
> strings will remain part of oprofile. Also I don't think we want to
> polute the perf pmu names with it.
> 
And those architectures that have opted to use different strings for perf
events are free to mangle them however they want for the oprofile case.
It doesn't change the fact that strings are still being managed by all of
the architectures. The perf PMU names aren't presently locked in to an
ABI, whereas the oprofile strings are, so it seems fairly straightforward
to develop standard mangling rules for preventing an oprofile-facing
string, or to simply reuse the strings verbatim.

> > sh_pmu is created for use solely by the perf events code, we are not
> > going to have oprofile poking around in data structures it has no place
> > knowing anything about when 99% of everything else it is doing is already
> > abstracted cleanly through the perf events interfaces. Likewise for
> > special oprofile-specific APIs.
> 
> So, I am also fine with implementing a generic perf_pmu_name() for sh
> and then derive the oprofile cpu_type string from it in the oprofile
> code.
> 
Again, this is unacceptable.
