Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab1FNRHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:07:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43719 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1FNRHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=bafzCSj3Iha66iaGx6AIO1nzFe0YWPhAwPIkXWvjtKcRv3FQQQ+Lt/W70SGvdWNvh2
         iFEGzAB9dMF0nxL/nrSzmzeXIJzRbJNJpkZ5mvgXh+f9C1Ser9TG4YW561AeTyUY0XcX
         etylqxEEPZBhbI+LVNbJrAU+pcE7WdHyroaH4=
From: Tejun Heo <tj@kernel.org>
To: x86@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: [PATCHSET] stop_machine: implement stop_machine_from_offline_cpu()
Date: Tue, 14 Jun 2011 19:06:55 +0200
Message-Id: <1308071218-5912-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This three patch series implements stop_machine_from_offline_cpu(),
which is stop_machine() which can be used from a CPU which isn't yet
online.

This is for mtrr which needs stop_machine while bringing up a CPU.  It
currently implements its own stop_machine directly using
stop_one_cpu().  Duplicating such core functionality is wasteful and
fragile.  e.g. mtrr's implementation currently can deadlock against
generic stop_machine().

This patchset is born from Suresh's attempt at implementing similar
feature into [__]stop_machine()[1], which IMHO is a bit too subtle.
Given the peculiarity of the feature, I think it's better to have
dedicated function with an ugly name.  Also, this way, the
implementation is very well isolated from the rest of stop_cpus
machinery and much simpler.

This patchset contains the following three patches.

  0001-stop_machine-kill-__stop_machine.patch
  0002-stop_machine-reorganize-stop_cpus-implementation.patch
  0003-stop_machine-implement-stop_machine_from_offline_cpu.patch

0001 is a cleanup patch which can go in regardless of the rest (with
ack from x86 people of course).  0002 is pure code reorganization.
0003 implements the feature.

Suresh, how does this look to you?  Can you please put the mtrr
changes on top of this and see how it works?

 arch/x86/kernel/alternative.c |    5 -
 include/linux/stop_machine.h  |   42 +++------------
 kernel/cpu.c                  |    2 
 kernel/stop_machine.c         |  117 +++++++++++++++++++++++++++++++++++-------
 4 files changed, 114 insertions(+), 52 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1154383/focus=1154384
