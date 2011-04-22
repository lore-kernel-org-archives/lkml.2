Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1DVIUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:20:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:53590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab1DVIUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:20:17 -0400
Date: Fri, 22 Apr 2011 08:19:21 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-b52c55c6a25e4515b5e075a989ff346fc251ed09@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1302658203-4239-1-git-send-email-andi@firstfloor.org>
References: <1302658203-4239-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86, perf event: Turn off unstructured raw event access to offcore registers
Git-Commit-ID: b52c55c6a25e4515b5e075a989ff346fc251ed09
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Apr 2011 08:19:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b52c55c6a25e4515b5e075a989ff346fc251ed09
Gitweb:     http://git.kernel.org/tip/b52c55c6a25e4515b5e075a989ff346fc251ed09
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 22 Apr 2011 08:44:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Apr 2011 10:02:53 +0200

x86, perf event: Turn off unstructured raw event access to offcore registers

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
