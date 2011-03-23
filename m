Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab1CWKGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:06:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65002 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab1CWKGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=fsttN+8DFmO+nutCanh+SsX2Y5jybiKi4Rl2pp/6wRIkReT7VVjJw4onv9wY3/5QnY
         B7azLL3wawcmCoEz77x+Ia7Jf7ghjpDklkA6UmDLYABvDBS8Q5TUKaCq1junNTQ0YB9k
         zYDRlzbziwLxJ3kWTx7Slo/GhhSN7mMeYvMwE=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: [PATCHSET] ptrace,signal: Improve ptrace and job control interaction
Date: Wed, 23 Mar 2011 11:05:46 +0100
Message-Id: <1300874766-12941-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is repost of the following two pending patchsets.

 [1] group stop / ptrace updates, take#2
 [2] ptrace,signal: Fix notifications to the real parent while ptraced

Combined these patches implement "P1. Always TASK_TRACED while
ptraced", "P2. Fix notifications to the real parent" and "P3. Keep
ptrace resume separate from and beneath jctl stop" of the ptrace job
control improvements proposal[3].

All patches have been reviewed and acked by Oleg and this will be the
last repost of these patches.  They're being committed to a stable git
tree (will eventually be managed by Oleg) and will be pulled into
linux-next once -rc1 is released.

 0001-signal-Fix-SIGCONT-notification-code.patch
 0002-ptrace-Remove-the-extra-wake_up_state-from-ptrace_de.patch
 0003-signal-Remove-superflous-try_to_freeze-loop-in-do_si.patch
 0004-ptrace-Kill-tracehook_notify_jctl.patch
 0005-ptrace-Add-why-to-ptrace_stop.patch
 0006-signal-Fix-premature-completion-of-group-stop-when-i.patch
 0007-signal-Use-GROUP_STOP_PENDING-to-stop-once-for-a-sin.patch
 0008-ptrace-Participate-in-group-stop-from-ptrace_stop-if.patch
 0009-ptrace-Make-do_signal_stop-use-ptrace_stop-if-the-ta.patch
 0010-ptrace-Clean-transitions-between-TASK_STOPPED-and-TR.patch
 0011-ptrace-Collapse-ptrace_untrace-into-__ptrace_unlink.patch
 0012-ptrace-Always-put-ptracee-into-appropriate-execution.patch
 0013-job-control-Don-t-set-group_stop-exit_code-if-re-ent.patch
 0014-job-control-Small-reorganization-of-wait_consider_ta.patch
 0015-job-control-Fix-ptracer-wait-2-hang-and-explain-nota.patch
 0016-job-control-Allow-access-to-job-control-events-throu.patch
 0017-job-control-Add-for_ptrace-to-do_notify_parent_cldst.patch
 0018-job-control-Job-control-stop-notifications-should-al.patch
 0019-job-control-Notify-the-real-parent-of-job-control-ev.patch
 0020-job-control-Don-t-send-duplicate-job-control-stop-no.patch

0001-0010 are from the first patchset and unchanged.  0010-0020 are
from the second patchset.  0010 and 0011 are the additional ones
posted as 0.1 and 0.2.  0015, 0016 and 0019 are the updated version
per Oleg's reviews.  The rest remain unchanged.

The patches are on top of the current mainline (6447f55da) and is
available in the following git branch

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ptrace

and contains the following changes.

 fs/exec.c                 |    1 
 include/linux/sched.h     |   11 +
 include/linux/tracehook.h |   27 ---
 kernel/exit.c             |   84 +++++++++--
 kernel/ptrace.c           |  110 ++++++++++----
 kernel/signal.c           |  341 +++++++++++++++++++++++++++++++++++++---------
 6 files changed, 434 insertions(+), 140 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1109224
[2] http://thread.gmane.org/gmane.linux.kernel/1110403
[3] http://thread.gmane.org/gmane.linux.kernel/1107045
