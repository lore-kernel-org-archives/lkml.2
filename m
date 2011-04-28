Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1D1DOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:14:39 -0400
Received: from mail-gx0-f180.google.com ([209.85.161.180]:48159 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1D1DOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:14:38 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Apr 2011 23:14:38 EDT
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        mingo@elte.hu, jmorris@namei.org, rostedt@goodmis.org
Subject: [PATCH 0/7] Revisiting expanded seccomp functionality
Date: Wed, 27 Apr 2011 22:04:02 -0500
Message-Id: <1303959855-13830-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to revisit the past discussions around extending seccomp
functionality:
1. http://lwn.net/Articles/332438/
2. http://thread.gmane.org/gmane.linux.kernel/1086816/focus=1096626

First, some background and motivation, feel free to skip straight to the
patches!

kernel/seccomp.c provides early system call interception hooks which
have been used for reducing the kernel attack surface for a given
user-level task. Normally, seccomp limits the kernel interfaces to read,
write, sigreturn, and exit. These restrictions have proved effective,
but for many common uses, the model is too draconion.  That reality
doesn't mean that a less aggressive reduction of the attack surface
wouldn't still have beneficial effects.

To accomodate the lack of flexibility, there are several out-of-tree
patches for system call interception (with and without farther reaching
"policy" enforcements) and even a complex pure-assembly trusted
supervisor-thread to broker the requests of seccomp-guarded threads
(http://code.google.com/p/seccompsandbox). The latter requires severe
contortions with a high chance of accidental attack surface exposure
while out-of-tree patches are just that.  (This ignores the handful of
userspace solutions, like plash and systrace, which jump through their
own hurdles and suffer not only from complexity but from a heavy
performance penalty. Of course, those approaches often include policy
enforcement work in addition to pure attack surface reduction, but
that's tangential.)

In general, attack surface reduction is applicable in most
circumstances, but it is especially true when handling untrusted data
(which seccomp was originally meant to help with!).

Some simple motivating examples are as follows:
- disallowing perf system calls inside a selinux sandbox (before parsing
  occursm such that true policy logic can be applied when appropriate.)
- minimizing kernel attack surface during untrusted JIT execution
  (Actionscript, Javascript, etc).
- ...

This patchset provides a flexible means to perform kernel attack surface
reduction using the early seccomp system call hooks and the ftrace
filter engine for system call name to number translation along with
limited argument-based filtering decision making.

Patches 1 through 5 cover the meat of this change.  Patch 3 contains the
more controversial pieces, I suspect.  Patches 6 and 7 show some of the
work that is needed to make this system even more effective.  (Even
without those patches, it is still quite useful.)

Core changes as part of this proposal:
[PATCH 1/7] tracing: split out filter init, access, tear down.
[PATCH 2/7] tracing: split out syscall_trace_enter construction
[PATCH 3/7] seccomp_filter: Enable ftrace-based system call filtering
[PATCH 4/7] seccomp_filter: add process state reporting
[PATCH 5/7] seccomp_filter: Document what seccomp_filter is and how it works.

Nice-to-haves, imo, for ftrace and this proposal:
[PATCH 6/7] include/linux/syscalls.h: add __ layer of macros with return types.
[PATCH 7/7] arch/x86: hook int returning system calls

Any and all commentary will be appreciated!

I feel that the approach of this patch series addresses both the
continued need for attack surface reduction when handling untrusted
content, as well as the need to reuse the developing ftrace
infrastructure.  I'm certain there are bugs, style-issues, etc, but I
hope that the general design leaves everyone else feeling that this
approach also addresses those needs too.  I will happily address any
issues if it means we might make progress on this iteration of the
exposed-kernel-surface-discussion!

Thanks!
will
