Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1CEKhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 05:37:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61048 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1CEKhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 05:37:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=D+HgqCey/GEeStp/Y1MFB1YXMHZYnqoK6L4fNPsf36xv55CyIfdhXAVke9gMh9yz2j
         czrGh+/WqhkoIHN0RshTrHrcT56oYFKdiIln5qzDmdnqYolgvuPeaQzEz5/SmnXvlK0l
         VFb1iF5mwggDC7OQ9rHkMNQkWR1jbmClcTi08=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: [PATCHSET] ptrace,signal: group stop / ptrace updates, take#2
Date: Sat,  5 Mar 2011 11:36:57 +0100
Message-Id: <1299321427-15051-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is yet another posting of ptrace and group stop interaction
updates.  Patches themselves remain mostly unchanged from the previous
posting[1] other than additions of Acked-by's and rebasing on top of
the current mainline.

The biggest change is that we now, hopefully, have an agreeable plan
as laid out by the proposal for ptrace improvements[2] and the
discussion which followed.  Naturally, not everyone is ecstatic about
it but I think there's enough level of agreement to proceed.

This patchset contains the following ten patches.

 0001-signal-fix-SIGCONT-notification-code.patch
 0002-ptrace-remove-the-extra-wake_up_state-from-ptrace_de.patch
 0003-signal-remove-superflous-try_to_freeze-loop-in-do_si.patch
 0004-ptrace-kill-tracehook_notify_jctl.patch
 0005-ptrace-add-why-to-ptrace_stop.patch
 0006-signal-fix-premature-completion-of-group-stop-when-i.patch
 0007-signal-use-GROUP_STOP_PENDING-to-stop-once-for-a-sin.patch
 0008-ptrace-participate-in-group-stop-from-ptrace_stop-if.patch
 0009-ptrace-make-do_signal_stop-use-ptrace_stop-if-the-ta.patch
 0010-ptrace-clean-transitions-between-TASK_STOPPED-and-TR.patch

In light of the proposal, this patchset can be separated into two
parts.  The first part, patches 0001 through 0006, tightens various
loose ends and prepare for further changes.  Except for 0004, every
patch is acked by Oleg and/or Roland.  0004 doesn't cause any behavior
change and removes a tracehook for future changes.

The second part, 0007-0010, fixes group stop participation accounting
and make tracees always stop in TASK_TRACED instead of TASK_STOPPED.
IOW, it implements "P1. Always TASK_TRACED while ptraced" of the
proposal.

Roland, Oleg, Andrew, if there's no objection, I'd like to set up a
git tree to route further developments in the area.  We're going to
see a lot of patches and it's simply much more efficient to have a
dedicated stable git branch.  A lot of changes which got folded into
the posted patches after Oleg's review should have been separate
commits rather than growing list of starred items in the patch
descriptions.

I don't really care who controls the tree and don't intend to commit
any patch without Oleg's Acked-by so it would make most sense for Oleg
to control the branch but, if Oleg dosnn't want to, I'd be happy to do
it.  No matter who does it, let's _PLEASE_ establish a stable tree.

This patchset is available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ptrace-review

HEAD is 31578b14d460dcac2946eff35c358ab1bebf2d7d.  git.korg takes some
time to sync so if it shows older commit, please try again after a
while.  diffstat follows.

 fs/exec.c                 |    1 
 include/linux/sched.h     |   11 ++
 include/linux/tracehook.h |   27 -----
 kernel/ptrace.c           |   51 ++++++++--
 kernel/signal.c           |  226 ++++++++++++++++++++++++++++++++++------------
 5 files changed, 225 insertions(+), 91 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1093410
[2] http://thread.gmane.org/gmane.linux.kernel/1107045
