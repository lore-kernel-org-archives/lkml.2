Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab2KPQdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:33:18 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46796 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab2KPQdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:33:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 16 Nov 2012 08:32:43 -0800
Message-ID: <8739097bkk.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19szExPhq7D+3Cd5leoNocbo38NrZo+ViM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 0/11] pid namespace cleanups and enhancements
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset is my pile of pid namespace patches that I have been
sitting on for entirely too long.  I have been running and testing these
changes for a while but if anyone sees any problems please let me know.

Feature wise this patchset adds unshare and setns support for the pid
namespace.

Cleanup wise this patchset adds an explicit count of how many pids are
hashed in a pid namespace and uses that count to trigger the unmounting
of the internal kernel mount of proc.  The current scheme is buggy and
entirely too clever to continue living.

Some proc bits that were added to support the pid namespace initially
are removed, as they are no no longer necessary.

These patches are also available at:
git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git pidns-v73

Since some of this work is closely allied with the user namespace bits I
have pending I intend to merge these changes through my user namespace
tree.

Eric W. Biederman (11):
      procfs: Use the proc generic infrastructure for proc/self.
      procfs: Don't cache a pid in the root inode.
      pidns: Capture the user namespace and filter ns_last_pid
      pidns: Use task_active_pid_ns where appropriate
      pidns: Make the pidns proc mount/umount logic obvious.
      pidns: Don't allow new processes in a dead pid namespace.
      pidns: Wait in zap_pid_ns_processes until pid_ns->nr_hashed == 1
      pidns: Deny strange cases when creating pid namespaces.
      pidns: Add setns support
      pidns: Consolidate initialzation of special init task state
      pidns: Support unsharing the pid namespace.

 arch/powerpc/platforms/cell/spufs/sched.c |    2 +-
 arch/um/drivers/mconsole_kern.c           |    2 +-
 drivers/staging/android/binder.c          |    3 +-
 fs/hppfs/hppfs.c                          |    2 +-
 fs/proc/Makefile                          |    1 +
 fs/proc/base.c                            |  169 +----------------------------
 fs/proc/internal.h                        |    1 +
 fs/proc/namespaces.c                      |    3 +
 fs/proc/root.c                            |   16 +---
 fs/proc/self.c                            |   59 ++++++++++
 include/linux/pid_namespace.h             |   10 ++-
 include/linux/proc_fs.h                   |    1 +
 init/main.c                               |    1 -
 kernel/cgroup.c                           |    2 +-
 kernel/events/core.c                      |    2 +-
 kernel/exit.c                             |   12 --
 kernel/fork.c                             |   42 +++++---
 kernel/nsproxy.c                          |    4 +-
 kernel/pid.c                              |   46 +++++++--
 kernel/pid_namespace.c                    |   99 +++++++++++++----
 kernel/signal.c                           |    2 +-
 kernel/sysctl_binary.c                    |    2 +-
 22 files changed, 231 insertions(+), 250 deletions(-)
