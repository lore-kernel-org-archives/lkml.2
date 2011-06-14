Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab1FNJU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:20:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38719 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1FNJUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:20:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=FgXK3xmWbCgdW9YcNctNIa86RQ/7JNBdwbgaJQWTRD3cfFY8oWiGqo/bKSo2BFjp+9
         fPXUQsmIIFZuZLnM+VjlfirdF/PStQmh0hVAx9QoU8jZ5UEA8v+Ppk6/TPhdWeeyMsri
         N9kxd9k7mcxg2e1+PCo75fZIm7i6bXEDQyyho=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification, take#5
Date: Tue, 14 Jun 2011 11:20:13 +0200
Message-Id: <1308043218-23619-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the fifth take of PTRACE_SEIZE/INTERRUPT and group stop
notification patchset.

Changes from the last take[1] are,

* Rebased on top of Oleg's ptrace branch[2] which now contains prep
  patches from the last take[1], so prep patches are dropped from this
  series.

* si_pt_flags and PTRACE_SI_STOPPED are dropped in favor of encoding
  the current group stop state in exit_code of STOP traps.  If group
  stop is in effect for the tracee, signr part of exit_code is the
  stopping signal; otherwise, it's SIGTRAP.

  Note that SIGCONT isn't used for NOTIFY traps - SIGTRAP is used
  instead, so signr is either SIG(stop) or SIGTRAP.  NOTIFY traps
  aren't differen't from any other STOP traps and all we need is the
  current state of group stop.  There's no need to distinguish NOTIFY
  traps.

* LISTENING test moved from wait_task_stopped() to
  task_stopped_code().

This patchset contains the following five patches.

  0001-job-control-introduce-JOBCTL_TRAP_STOP-and-use-it-fo.patch
  0002-ptrace-implement-PTRACE_SEIZE.patch
  0003-ptrace-implement-PTRACE_INTERRUPT.patch
  0004-ptrace-implement-TRAP_NOTIFY-and-use-it-for-group-st.patch
  0005-ptrace-implement-PTRACE_LISTEN.patch

and available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ptrace-seize

The HEAD is 20b0913886 (ptrace: implement PTRACE_LISTEN).  If you see
older branch, please retry after a while (korg is still syncing).

The patchset is on top of Oleg's ptrace branch[2] - dd1d677269
(signal: remove three noop tracehooks).

diffstat follows.

 include/linux/ptrace.h |    9 ++
 include/linux/sched.h  |   10 ++-
 kernel/exit.c          |    3
 kernel/ptrace.c        |  116 +++++++++++++++++++++++++++++++----
 kernel/signal.c        |  162 ++++++++++++++++++++++++++++++++++++++-----------
 5 files changed, 249 insertions(+), 51 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1147384
[2] git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git ptrace
