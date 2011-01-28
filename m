Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1A1PIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:08:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51211 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab1A1PIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:08:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=V5XGGva01ypMH3eMWfihjPFd7TxjtN/34owVdqURgDKKfXLwr1NGvMXGNM/N9koTfS
         Z4Jh5JOlMCzBCgwwB+F7I73uW+AANFHZ2i4Kx/CgatXlc3U6ZRJc01ytYt/gVNMBEHXO
         aSrrr+Q6iAuVIEK3VL9r29pRrvdJnOi7knXmc=
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [PATCHSET] ptrace,signal: group stop / ptrace updates
Date: Fri, 28 Jan 2011 16:08:34 +0100
Message-Id: <1296227324-25295-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is another posting of ptrace and group stop interaction update.
The last posting was split over two patchsets[1][2].  Changes are,

* Rebased on top of v2.6.38-rc2

* 0010-ptrace-clean-transitions-between-TASK_STOPPED-and-TR.patch
  updated as per Oleg's comments - the TRACED/TRAPPING race condition
  closed and trapping clearing separated out from group_stop clearing.

0001-signal-fix-SIGCONT-notification-code.patch
0002-ptrace-remove-the-extra-wake_up_process-from-ptrace_.patch
0003-signal-remove-superflous-try_to_freeze-loop-in-do_si.patch
0004-ptrace-kill-tracehook_notify_jctl.patch
0005-ptrace-add-why-to-ptrace_stop.patch
0006-signal-fix-premature-completion-of-group-stop-when-i.patch
0007-signal-use-GROUP_STOP_PENDING-to-stop-once-for-a-sin.patch
0008-ptrace-participate-in-group-stop-from-ptrace_stop-if.patch
0009-ptrace-make-do_signal_stop-use-ptrace_stop-if-the-ta.patch
0010-ptrace-clean-transitions-between-TASK_STOPPED-and-TR.patch

0001-0004 are cleanup/bugfix patches.  0005-0010 improve group stop
handling.

Discussions are still on-going on the following points.

1. Removal of spurious wake_up_process() by 0002 may not be safe[3].

2. STOPPED -> RUNNING -> TRACED transition window may be visible to
   tasks which are not the tracer[4].  Tracee always entering TRACED
   also causes one ptrace test case to fail[5].

3. After immediately re-attaching to a detached task in stopped state,
   WNOHANG wait(2) may fail.

This patchset does change ptrace behavior but the changed aspects are
somewhere between awkward and outright buggy before the changes and
the changes are visible only through very convoluted use cases.
Regardless of future directions from here, I don't think the patches
posted in this patchset would be a problem.

The patchset is available in the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ptrace-review

Thank you.

 fs/exec.c                 |    1 
 include/linux/sched.h     |   11 ++
 include/linux/tracehook.h |   27 -----
 kernel/ptrace.c           |   51 ++++++++--
 kernel/signal.c           |  226 ++++++++++++++++++++++++++++++++++------------
 5 files changed, 225 insertions(+), 91 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1079975
[2] http://thread.gmane.org/gmane.linux.kernel/1080700
[3] http://thread.gmane.org/gmane.linux.kernel/1079975/focus=1088490
[4] http://thread.gmane.org/gmane.linux.kernel/1080700/focus=1088538
[5] http://thread.gmane.org/gmane.linux.kernel/1080700/focus=1093056
