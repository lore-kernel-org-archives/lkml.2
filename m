Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab1CHT6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:58:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36021 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab1CHT56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:57:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=aPDwxYeEcSvURIyeUP8sOfB6sY8cOIIbHUBiTebAIsUJ0lFIvJ9TJes3B4lAOOg8YW
         Ng1y3zjOz6SdLR24DD5hOVyCQWn9n8DsGSR82JxbdOMHjJwk7CAOX7P5F/HVaqRLd3uQ
         Ffkq9elQfo3iqN1F4yQXkdE/QnRS2Et2TPXPs=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: [RFC PATCHSET] ptrace,signal: Fix notifications to the real parent while ptraced
Date: Tue,  8 Mar 2011 20:56:31 +0100
Message-Id: <1299614199-25142-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset implements "P2. Fix notifications to the real parent" of
the ptrace job control improvements proposal[1].

As the whole job control / ptrace logic is quite delicate, I tried to
be very granual with changes and add plenty of explanations for
subtleties.

This patchset contains the following eight patches.

 0001-job-control-Don-t-set-group_stop-exit_code-if-re-ent.patch
 0002-job-control-Small-reorganization-of-wait_consider_ta.patch
 0003-job-control-Fix-ptracer-wait-2-hang-and-explain-nota.patch
 0004-job-control-Allow-access-to-job-control-events-throu.patch
 0005-job-control-Add-for_ptrace-to-do_notify_parent_cldst.patch
 0006-job-control-Job-control-stop-notifications-should-al.patch
 0007-job-control-Notify-the-real-parent-of-job-control-ev.patch
 0008-job-control-Don-t-send-duplicate-job-control-stop-no.patch

0001-0003 fix subtle issues and prepare for wait(2) related changes.
I don't think any of this needs to be backported.  0004 make the job
control stopped/continued states visible to the real parent regardless
of ptrace.

0005-0006 prepare for notification related changes.  0007-0008 enable
proper job control notifications to the real parent regardless of
ptrace.

This patchset introduces behavior changes; however, all the changes
are visible only to the real parent.  As basically everything job
control related was broken while ptraced, I don't think these changes
need to be conditionalized (ie. enabled only when explicitly told so).
Doing so is likely to only increase confusion with few benefits.

After this patchset, I can ^Z a strace(1) attached command and get a
shell prompt.  The interaction of course is not perfect yet because
strace(1) currently unconditionally overrides job control stop, but
it's a progress.  For strace(1) itself, nothing really changes.

This patchset is based on 2.6.38-rc7 (212e3499b2) + "group stop /
ptrace updates, take#2" patchset[2] which implements P1.  The git
branch for the P1 patchset has been regenerated with Oleg's Acked-by's
added and available in ptrace-review-P1 branch.

This patchset is available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ptrace-review-P2

HEAD is fbbe61c532ba23d2d00bff7c2b354e0522ae4afc.  git.korg takes some
time to sync so if it shows older commit, please try again after a
while.  diffstat follows.

 kernel/exit.c   |   83 +++++++++++++++++++++++++++++++---------
 kernel/signal.c |  116 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 170 insertions(+), 29 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1107045
[2] http://thread.gmane.org/gmane.linux.kernel/1109224
