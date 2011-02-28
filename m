Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1B1XsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:48:05 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:55218 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1B1XsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:48:03 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Feb 2011 18:48:02 EST
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id; q=dns; s=sasl; b=GuxV+qnvyhwOWcHJUHQ1r
	L5pxDU440MWPyY0lQU27GEQI1Gom9F4+9+z9Nzt1z9yU5aoVnebgvfgIKFaW5Xbf
	hzCrEtIAMILM2b4HR3cRD2irC1oiSBG1iAQ8IrWtf5BQOi8de9/NPZUgxVdqHbag
	KFiiGZYBiU53r/v+l8sq10=
From: ntl@pobox.com
To: linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org, Oren Laadan <orenl@cs.columbia.edu>,
        Nathan Lynch <ntl@pobox.com>
Subject: [RFC 00/10] container-based checkpoint/restart prototype
Date: Mon, 28 Feb 2011 17:40:22 -0600
Message-Id: <1298936432-29607-1-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.7.4
X-Pobox-Relay-ID: 53C71728-4394-11E0-838D-AF401E47CF6F-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <ntl@pobox.com>

Checkpoint/restart is a facility by which one can save the state of a
job to a file and restart it later under the right conditions.  This
is a C/R prototype intended to illustrate how well (or poorly) it
would fit into the Linux kernel.  It is basically a fork of the
"linux-cr" patch set by Oren Laadan and others, but it is more limited
in scope and has a different system call interface.  I believe what I
have here is a decent starting point for a C/R implementation that can
go upstream, but I'm releasing early with the hope of receiving some
feedback/review on the overall approach before pursuing it too much
further.

The intended users are HPC, big homogeneous clusters, environments
with long-running jobs that are not easily interrupted without losing
work, for whatever reason (perhaps you've misplaced the source code
for your program and can't modify it to checkpoint and restore its own
state).  In these situations checkpoint/restart provides a rollback
mechanism to mitigate the effects of hardware/system failures as well
as a means of migrating jobs between nodes.


How it works:

Only a process with PID 1 ("init") can call checkpoint or restart.

Checkpoint freezes the rest of the pidns and goes about dumping the
state of all the other tasks in the PID namespace to the specificed
file descriptor.  The state of the caller is not recorded.

Before calling restart, init is expected to set up the environment
(mounts, net devices and such) in accord with the checkpointed job's
"expectations".  The restart system call recreates the task tree
(except for init itself) and the tasks resume execution; init can
then wait(2) for tasks to exit in the normal fashion.


Limitations:

This implementation is limited to containers by design (and this
prototype is limited to checkpoint/restore of a single simple task).
A Linux "container" doesn't have a universally agreed upon definition,
but in this context we are referring to a group of processes for which
the PID namespace (and possibly other namespaces) is isolated from the
rest of the system (see clone(2)).  This is the tradeoff we ask users
to make - the ability to C/R and migrate is provided in exchange for
accepting some isolation and slightly reduced ease of use.  A tool
such as lxc (http://lxc.sourceforge.net) can be used to isolate jobs.
A patch against lxc is available which adds C/R capability.

The user must ensure that a restarted job's view of the filesystem is
effectively the same as it was at the time of checkpoint.

Processes that map device memory and other such hardware-dependent
things will probably not be supported.


To do:

Multiple tasks
Signal state
System call restart blocks
More code cleanup/simplification
Other architecture support
System V IPC
Network/sockets
And much more


 Documentation/filesystems/vfs.txt  |   13 +-
 arch/x86/Kconfig                   |    4 +
 arch/x86/include/asm/checkpoint.h  |   17 +
 arch/x86/include/asm/elf.h         |    5 +
 arch/x86/include/asm/ldt.h         |    7 +
 arch/x86/include/asm/unistd_32.h   |    4 +-
 arch/x86/kernel/Makefile           |    2 +
 arch/x86/kernel/checkpoint.c       |  677 +++++++++++++++++++++++++++
 arch/x86/kernel/syscall_table_32.S |    2 +
 arch/x86/vdso/vdso32-setup.c       |   25 +-
 drivers/char/mem.c                 |    6 +
 drivers/char/random.c              |    6 +
 fs/Makefile                        |    1 +
 fs/aio.c                           |   27 ++
 fs/checkpoint.c                    |  695 +++++++++++++++++++++++++++
 fs/exec.c                          |    2 +-
 fs/ext2/dir.c                      |    3 +
 fs/ext2/file.c                     |    6 +
 fs/ext3/dir.c                      |    3 +
 fs/ext3/file.c                     |    3 +
 fs/ext4/dir.c                      |    3 +
 fs/ext4/file.c                     |    6 +
 fs/fcntl.c                         |   21 +-
 fs/locks.c                         |   35 ++
 include/linux/aio.h                |    2 +
 include/linux/checkpoint.h         |  347 ++++++++++++++
 include/linux/fs.h                 |   15 +
 include/linux/magic.h              |    3 +
 include/linux/mm.h                 |   15 +
 init/Kconfig                       |    2 +
 kernel/Makefile                    |    1 +
 kernel/checkpoint/Kconfig          |   15 +
 kernel/checkpoint/Makefile         |    9 +
 kernel/checkpoint/checkpoint.c     |  437 +++++++++++++++++
 kernel/checkpoint/objhash.c        |  368 +++++++++++++++
 kernel/checkpoint/restart.c        |  651 ++++++++++++++++++++++++++
 kernel/checkpoint/sys.c            |  208 +++++++++
 kernel/sys_ni.c                    |    4 +
 mm/Makefile                        |    1 +
 mm/checkpoint.c                    |  906 ++++++++++++++++++++++++++++++++++++
 mm/filemap.c                       |    4 +
 mm/mmap.c                          |    3 +
 42 files changed, 4549 insertions(+), 15 deletions(-)
 create mode 100644 arch/x86/include/asm/checkpoint.h
 create mode 100644 arch/x86/kernel/checkpoint.c
 create mode 100644 fs/checkpoint.c
 create mode 100644 include/linux/checkpoint.h
 create mode 100644 kernel/checkpoint/Kconfig
 create mode 100644 kernel/checkpoint/Makefile
 create mode 100644 kernel/checkpoint/checkpoint.c
 create mode 100644 kernel/checkpoint/objhash.c
 create mode 100644 kernel/checkpoint/restart.c
 create mode 100644 kernel/checkpoint/sys.c
 create mode 100644 mm/checkpoint.c

-- 
1.7.4

