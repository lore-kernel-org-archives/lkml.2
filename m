Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1DVIGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:06:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60430 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab1DVIGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:06:20 -0400
Date: Fri, 22 Apr 2011 10:06:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110422080604.GA22611@elte.hu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
 <1303407662-15564-2-git-send-email-acme@infradead.org>
 <20110422063429.GA16643@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422063429.GA16643@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> This needs to be a *lot* more user friendly. Users do not want to type in 
> stupid hexa magic numbers to get profiling. We have moved beyond the oprofile 
> era really.
> 
> Unless there's proper generalized and human usable support i'm leaning 
> towards turning off the offcore user-space accessible raw bits for now, and 
> use them only kernel-internally, for the cache events.

I'm about to push out the patch attached below - it lays out the arguments in 
detail. I don't think we have time to fix this properly for .39 - but memory 
profiling could be a nice feature for v2.6.40.

Thanks,

	Ingo

--------------------->
>From b52c55c6a25e4515b5e075a989ff346fc251ed09 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 22 Apr 2011 08:44:38 +0200
Subject: [PATCH] x86, perf event: Turn off unstructured raw event access to offcore registers

Andi Kleen pointed out that the Intel offcore support patches were merged
without user-space tool support to the functionality:

 |
 | The offcore_msr perf kernel code was merged into 2.6.39-rc*, but the
 | user space bits were not. This made it impossible to set the extra mask
 | and actually do the OFFCORE profiling
 |

Andi submitted a preliminary patch for user-space support, as an
extension to perf's raw event syntax:

 |
 | Some raw events -- like the Intel OFFCORE events -- support additional
 | parameters. These can be appended after a ':'.
 |
 | For example on a multi socket Intel Nehalem:
 |
 |    perf stat -e r1b7:20ff -a sleep 1
 |
 | Profile the OFFCORE_RESPONSE.ANY_REQUEST with event mask REMOTE_DRAM_0
 | that measures any access to DRAM on another socket.
 |

But this kind of usability is absolutely unacceptable - users should not
be expected to type in magic, CPU and model specific incantations to get
access to useful hardware functionality.

The proper solution is to expose useful offcore functionality via
generalized events - that way users do not have to care which specific
CPU model they are using, they can use the conceptual event and not some
model specific quirky hexa number.

We already have such generalization in place for CPU cache events,
and it's all very extensible.

"Offcore" events measure general DRAM access patters along various
parameters. They are particularly useful in NUMA systems.

We want to support them via generalized DRAM events: either as the
fourth level of cache (after the last-level cache), or as a separate
generalization category.

That way user-space support would be very obvious, memory access
profiling could be done via self-explanatory commands like:

  perf record -e dram ./myapp
  perf record -e dram-remote ./myapp

... to measure DRAM accesses or more expensive cross-node NUMA DRAM
accesses.

These generalized events would work on all CPUs and architectures that
have comparable PMU features.

( Note, these are just examples: actual implementation could have more
  sophistication and more parameter - as long as they center around
  similarly simple usecases. )

Now we do not want to revert *all* of the current offcore bits, as they
are still somewhat useful for generic last-level-cache events, implemented
in this commit:

  e994d7d23a0b: perf: Fix LLC-* events on Intel Nehalem/Westmere

But we definitely do not yet want to expose the unstructured raw events
to user-space, until better generalization and usability is implemented
for these hardware event features.

( Note: after generalization has been implemented raw offcore events can be
  supported as well: there can always be an odd event that is marginally
  useful but not useful enough to generalize. DRAM profiling is definitely
  *not* such a category so generalization must be done first. )

Furthermore, PERF_TYPE_RAW access to these registers was not intended
to go upstream without proper support - it was a side-effect of the above
e994d7d23a0b commit, not mentioned in the changelog.

As v2.6.39 is nearing release we go for the simplest approach: disable
the PERF_TYPE_RAW offcore hack for now, before it escapes into a released
kernel and becomes an ABI.

Once proper structure is implemented for these hardware events and users
are offered usable solutions we can revisit this issue.

Reported-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1302658203-4239-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index eed3673a..632e5dc 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -586,8 +586,12 @@ static int x86_setup_perfctr(struct perf_event *event)
 			return -EOPNOTSUPP;
 	}
 
+	/*
+	 * Do not allow config1 (extended registers) to propagate,
+	 * there's no sane user-space generalization yet:
+	 */
 	if (attr->type == PERF_TYPE_RAW)
-		return x86_pmu_extra_regs(event->attr.config, event);
+		return 0;
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, event);
