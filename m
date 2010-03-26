Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0CZNnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:43:52 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:53000 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753448Ab0CZNnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:43:50 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Mar 2010 09:43:50 EDT
X-AuditID: 12074425-b7d00ae000002295-58-4bacb8e887e8
From: Andy Lutomirski <luto@MIT.EDU>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 0/3] Taming execve, setuid, and LSMs
Date: Fri, 26 Mar 2010 07:38:33 -0600
Message-Id: <cover.1269610458.git.luto@mit.edu>
X-Mailer: git-send-email 1.6.6.1
X-Brightmail-Tracker: AAAAARNt6nE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every now and then, someone wants to let unprivileged programs change
something about their execution environment (think unsharing namespaces,
changing capabilities, disabling networking, chrooting, mounting and
unmounting filesystems).  Whether or not any of these abilities are good
ideas, there's a recurring problem that gets most of these patches shot
down: setuid executables.

The obvious solution is to allow a process to opt out of setuid
semantics and require processes to do this before using these shiny new
features. [1] [2]

But there's a problem with this, too: with LSMs running, execve can do
pretty much anything, and even unprivileged users running unprivileged
programs can have crazy security implications.  (Take a look at a
default install of Fedora.  If you can understand the security
implications of disabling setuid, you get a cookie.  If you can figure
out which programs will result in a change of security label when
exec'd, you get another cookie.)

So here's another solution, based on the idea that in a sane world,
execve should be a lot less magical than it is.  Any unprivileged
program can open an executable, parse its headers, map it, and run it,
although getting all the details right is tedious at best (and there's
no good way to get all of the threading semantics right from userspace).

Patch 1 adds a new syscall execve_nosecurity.  It does an exec, but
without changing any security properties.  This means no setuid, no
setgid, no LSM credential hooks (e.g. no SELinux type transitions), and
no ptrace restrictions.  (You have to have read access to the program,
because disabling security stuff could allow someone to ptrace a program
that they couldn't otherwise ptrace.)  This shouldn't be particularly
scary -- any process could do much the same thing with open and mmap.
(You can easily shoot yourself in the foot with this syscall -- think
LD_PRELOAD or running some program with insufficient error checking that
can get subverted when run in the wrong security context.  So don't do
that.)

Patch 2 adds a prctl that irrevocably disables execve.  Making execve do
something different that could confuse LSMs is dangerous.  Turning the
whole thing off shouldn't be.  (Of course, with execve disabled, you can
still use execve_nosecurity.  But any program that does that should take
precautions not to shoot itself in the foot.)  (In a future revision,
this should probably be a new syscall.)

Sadly, programs that have opted out of execve might want to use
subprocesses that in turn run execve.  This will fail.  So patch 3
(which is ugly, but I don't see anything fundamentally wrong with it)
allows processes to set a flag that turns execve into execve_nosecurity.
This flag survives exec.  Of course, this could be used to subvert
setuid programs, so you can't set this flag unless you disable ordinary
exec first.

[1] Unprivileged: http://lkml.org/lkml/2009/12/30/265
[2] securebit approach: http://lwn.net/Articles/368600/

Andy Lutomirski (3):
  Add the execve_nosecurity syscall.
  Add PR_RESTRICT_ME to disable security-sensitive features for a
    process tree.
  Add PR_SET_FORCE_EXECVE_NOSECURITY to turn execve calls into
    execve_nosecurity.

 arch/x86/ia32/sys_ia32.c         |    2 +-
 arch/x86/include/asm/unistd_64.h |    2 +
 arch/x86/kernel/entry_64.S       |   16 +++++
 arch/x86/kernel/process.c        |   28 ++++++++-
 fs/binfmt_elf.c                  |    6 +-
 fs/binfmt_elf_fdpic.c            |    6 +-
 fs/binfmt_em86.c                 |    2 +-
 fs/binfmt_flat.c                 |    7 ++-
 fs/binfmt_misc.c                 |    2 +-
 fs/binfmt_script.c               |    2 +-
 fs/compat.c                      |   14 ++++-
 fs/exec.c                        |  126 ++++++++++++++++++++++++-------------
 include/linux/binfmts.h          |    3 +
 include/linux/compat.h           |    2 +-
 include/linux/fs.h               |    2 +-
 include/linux/prctl.h            |   11 +++
 include/linux/sched.h            |    5 +-
 kernel/fork.c                    |    3 +
 kernel/sys.c                     |   42 +++++++++++++
 19 files changed, 221 insertions(+), 60 deletions(-)

The code below can be used to play with these new features.


/* gcc -I /lib/modules/2.6.33/build/usr/include no_exec.c */

#include <asm/unistd.h>
#include <linux/prctl.h>
#include <stdio.h>

int execve_nosecurity(const char *filename, char *const argv[],
		      char *const envp[])
{
	return syscall(__NR_execve_nosecurity, filename, argv, envp);
}

int main(int argc, char **argv, char **envp)
{
	if (argc < 3) {
		fprintf(stderr, "Usage: %s <force | noforce> program args...\n");
		return 1;
	}

	int force_execve_nosecurity;
	if (!strcmp(argv[1], "force")) {
		force_execve_nosecurity = 1;
	} else if (!strcmp(argv[1], "noforce")) {
		force_execve_nosecurity = 0;
	} else {
		fprintf(stderr, "Invalid argument\n");
		return 1;
	}	

	if (prctl(PR_RESTRICT_ME, PR_RESTRICT_EXEC, 0, 0, 0) != 0) {
		perror("PR_RESTRICT_ME");
		return 1;
	}

	if (prctl(PR_SET_FORCE_EXECVE_NOSECURITY, force_execve_nosecurity,
		  0, 0, 0) != 0) {
		perror("PR_SET_FORCE_EXECVE_NOSECURITY");
		return 1;
	}
	execve_nosecurity(argv[2], argv + 2, envp);
	perror("execve_nosecurity");
	return 1;
}

