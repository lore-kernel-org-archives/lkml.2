Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab2AKRZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:25:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38150 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759Ab2AKRZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:25:42 -0500
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        wad@chromium.org, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com
Subject: [RFC,PATCH 0/2] dynamic seccomp policies (using BPF filters)
Date: Wed, 11 Jan 2012 11:25:08 -0600
Message-Id: <1326302710-9427-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of the patchset is straightforward:

 To provide a means of reducing the kernel attack surface.

In practice, this is done at the primary kernel ABI: system calls.
Achieving this goal will address the needs expressed by many systems
projects:
  qemu/kvm, openssh, vsftpd, lxc, and chromium and chromium os (me).

While system call filtering has been attempted many times, I hope that
this approach shows more promise.  It works as described below and in
the patch series.

A userland task may call prctl(PR_ATTACH_SECCOMP_FILTER) to attach a
BPF program to itself.  Once attached, all system calls made by the
task will be evaluated by the BPF program prior to being accepted.
Evaluation is done by executing the BPF program over the struct
user_regs_state for the process.

!! If you don't care about background or reasoning, stop reading !!

Past attempts have used:
- bitmap of system call numbers evaluated by seccomp (or tracehooks)
- standalone data structures and extra entry hooks
  (cgroups syscall, systrace)
- a collection of ftrace filter strings evaluated by seccomp
- perf_event hackery to allow process termination when an event matches
  (or doesn't)

In addition to the publicly posted approaches, I've personally attempted
continued deeper integration with ftrace along a number of different
lines (lead up to that can be found here[1]).  What inspired the current
patch series was a number of realizations:
1. Userland knows its ABI - that's how it made the system calls in the
   first place.
2. We already exposed a filtering system to userland processes in the
   form of BPF and there is continued focus on optimizing evaluation
   even after so many years.
3. System call filtering policies should not expose
   time-of-check-time-of-use (TOCTOU) vulnerable interfaces but should
   expose all the information that may be relevant to a syscall policy
   decision.

The prior seccomp-ftrace  implementations struggled with very
fixable challenges in ftrace: incomplete syscall coverage,
mismatched syscall names versus unistd, incomplete arch coverage,
etc.  These challenges may all be fixed with some time and effort, and
potentially, even closer integration.  I explored a number of
alternative approaches from making system call tracepoints per-thread
and "active" to adding a new less-perf-oriented system call.

In the process of experimentation, a number of things became clear:
- perf/ftrace system-wide analysis goals don't align with lightweight
  per-thread analysis.
- ftrace/perf ABI doesn't mix well with security policy enforcement,
  reduced attack surface environments, or keeping users from specifing
 vulnerable filtering policies.
- other than system calls, tracepoints aren't considered ABI-stable.

The core focus of ftrace and perf is to support system-wide
performance and debugging tracing.  Despite its amazing flexibility,
there are tradeoffs that are made to provide efficient system-wide
behavior that are less efficient at a per-thread level.  For instance,
system call tracepoints are global.  It is possible to make them
per-thread (since they use a TIF anyway).  However, doing so would mean
that a system-wide system call analysis would require one trace event
per thread rather than one total.  It's possible to alleviate that pain,
but that in turn requires more bookkeeping (global versus local
tracepoint registrations mapping to the thread info flag).

Another example is the ftrace ABI.  Both the debugfs entry point with
unstable event ids and the perf-oriented perf_event_open(2) are not
suitable to providing a subsystem which is meant to reduce the attack
surface -- much less avoid maintainer flame wars :) The third aspect of
its ABI was also concerning and hints at yet-another-potential struggle.
The ftrace filter language happily accepts globbing and string matching.
This is excellent for tracing, but horrible for system call
interposition.  If, despite warning, a user decides that blocking a
system call based on a string is what they want, they can do it.  The
result is that their policy may be bypassed due to a time of check, time
of use race.  While addressable, it would mean that the filtering engine
would need to allow operation filtering or offer a "secure" subset.

A side challenge that emerged from the desire to enable tracing to act
as a security policy mechanism was the ability to enact policy over more
than just the system calls.  While this would be doable if all
tracepoints became active, there is a fundamental problem in that very
little, if any, tracepoints aside from system calls can be considered
stable.  If a subset were to emerge as stable, there is still the
challenge of enacting security policy in parallel with tracing policy.
In an example patch where security policy logic was added to
perf_event_open(2), the basics of the system worked, but enforcement of
the security policy was simplistic and intertwined with a large number
of event attributes that were meaningless or altered the behavior.

At every turn, it appears that the tracing infrastructure was unsuited
for being used for attack surface reduction or as a larger security
subsystem on its own.  It is well suited for feeding a policy
enforcement mechanism (like seccomp), but not for letting the logic
co-exist.  It doesn't mean that it has security problems, just that
there will be a continued struggle between having a really good perf
system and and really good kernel attack surface reduction system if
they were merged.  While there may be some distant vision where the
apparent struggle does not exist, I don't see how it would be reached.
Of course, anything is possible with unlimited time. :)

That said, much of that discussion is history and to fill in some of the
gaps since I posted the last ftrace-based patches.  This patch series
should stand on its own as both straightforward and effective.  In my
opinion, this is the direction I should have taken before I sent my
first patch.

I am looking forward to any and all feedback - thanks!
will


[1] http://search.gmane.org/?query=seccomp+wad%40chromium.org&group=gmane.linux.kernel


Will Drewry (3):
  seccomp_filters: dynamic system call filtering using BPF programs
  Documentation: prctl/seccomp_filter

 Documentation/prctl/seccomp_filter.txt |  179 ++++++++
 fs/exec.c                              |    5 +
 include/linux/prctl.h                  |    3 +
 include/linux/seccomp.h                |   70 +++++-
 kernel/Makefile                        |    1 +
 kernel/fork.c                          |    4 +
 kernel/seccomp.c                       |    8 +
 kernel/seccomp_filter.c                |  639 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c                           |    4 +
 security/Kconfig                       |   12 +
 9 files changed, 743 insertions(+), 3 deletions(-)
 create mode 100644 kernel/seccomp_filter.c
 create mode 100644 Documentation/prctl/seccomp_filter.txt
-- 
1.7.5.4
























