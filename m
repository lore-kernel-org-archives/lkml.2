Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab2KSPI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:08:27 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56788 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2KSPIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:08:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Date: Mon, 19 Nov 2012 07:08:11 -0800
Message-ID: <87lidx8wbo.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/4T0J73PwfZFifx69LatpQItZmlFM50u0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  2.5 XMWhlSbjSex Whole Obfuscated Subjects
	*  0.1 XMSubLong Long Subject
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3934]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 0/16] user namespace and namespace infrastructure completion
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following series of changes completes the user namespace and adds
the much too long delay bits of namespace infrastructure.

This series of changes adds unprivilged creation of all namespaces
support for creating a user namespace with unshare, and support for
entering a user namespace with setns.

The proc namespace files are converted into magic symlinks to avoid
problems with dentry caching excessively keeping a namespace alive and
dentry caching allowing the ptrace_may_access checks to be bypassed.

The proc namespace now have inode numbers that are always the same for
the same user namespace allowing stat to test if two file descriptors
refer to the same namespace.

Eric W. Biederman (16):
      userns: Ignore suid and sgid on binaries if the uid or gid can not be mapped
      userns: Allow unprivileged users to create user namespaces.
      userns: Allow chown and setgid preservation
      userns: Allow setting a userns mapping to your current uid.
      userns: Allow unprivileged users to create new namespaces
      userns: Allow unprivileged use of setns.
      userns: Make create_new_namespaces take a user_ns parameter
      userns: Kill task_user_ns
      userns: Implent proc namespace operations
      userns: Implement unshare of the user namespace
      procfs: Print task uids and gids in the userns that opened the proc file
      userns: For /proc/self/{uid,gid}_map derive the lower userns from the struct file
      userns: Allow unprivilged mounts of proc and sysfs
      proc: Generalize proc inode allocation
      proc: Fix the namespace inode permission checks.
      proc: Usable inode numbers for the namespace file descriptors.

 fs/attr.c                      |   11 ++-
 fs/exec.c                      |    9 +--
 fs/mount.h                     |    1 +
 fs/namespace.c                 |   14 +++
 fs/proc/array.c                |    2 +-
 fs/proc/generic.c              |   26 +++---
 fs/proc/inode.c                |    6 +-
 fs/proc/namespaces.c           |  177 +++++++++++++++++++++++++++++++++++-----
 fs/proc/root.c                 |    1 +
 fs/sysfs/mount.c               |    1 +
 include/linux/cred.h           |    2 -
 include/linux/ipc_namespace.h  |    9 ++-
 include/linux/nsproxy.h        |    2 +-
 include/linux/pid_namespace.h  |    1 +
 include/linux/proc_fs.h        |   18 ++++-
 include/linux/user_namespace.h |   10 ++
 include/linux/utsname.h        |    7 +-
 include/net/net_namespace.h    |    2 +
 init/version.c                 |    2 +
 ipc/msgutil.c                  |    2 +
 ipc/namespace.c                |   32 ++++++--
 kernel/fork.c                  |   33 +++++---
 kernel/nsproxy.c               |   34 ++++----
 kernel/pid.c                   |    1 +
 kernel/pid_namespace.c         |   12 +++
 kernel/ptrace.c                |   10 ++-
 kernel/sched/core.c            |   10 ++-
 kernel/user.c                  |    2 +
 kernel/user_namespace.c        |  147 +++++++++++++++++++++++++++++----
 kernel/utsname.c               |   33 ++++++--
 net/core/net_namespace.c       |   31 +++++++-
 security/yama/yama_lsm.c       |   12 ++-
 32 files changed, 535 insertions(+), 125 deletions(-)
