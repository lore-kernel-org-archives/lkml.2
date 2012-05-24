Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab2EXQIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:08:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56605 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab2EXQIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:08:37 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: mcgrathr@google.com, hpa@zytor.com, indan@nul.nu, netdev@parisplace.org,
        linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org,
        Will Drewry <wad@chromium.org>
Subject: [RFC PATCH 0/3] move the secure_computing call
Date: Thu, 24 May 2012 11:07:58 -0500
Message-Id: <1337875681-20717-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120522173942.GJ11775@ZenIV.linux.org.uk>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an RFC based on the comments from Al Viro and Eric Paris
regarding ptrace()rs being able to change the system call the kernel
sees after the seccomp enforcement has occurred (for mode 1 or 2).

With this series applied, a (p)tracer of a process with seccomp enabled
will be unable to change the tracee's system call number after the
secure computing check has been performed.

The x86 change is tested, as is the seccomp.c change.  For other arches,
it is not (RFC :).  Given that there are other inconsistencies in this
code across architectures, I'm not sure if it makes sense to attempt to
fix them all at once or to roll through as I attempt to add seccomp
filter support.

As is, the biggest benefit of this change is just setting consistent
expectations in what the ptrace/seccomp interactions should be.  The
current ability for ptrace to "bypass" secure computing (by remapping
allowed system calls) is not necessarily a problem, but it is not
necessarily intuitive behavior.

Thoughts, comments, flames will be appreciated!


Will Drewry (3):
  seccomp: Don't allow tracers to abuse RET_TRACE
  arch/x86: move secure_computing after ptrace
  arch/*: move secure_computing after trace

 arch/arm/kernel/entry-common.S  |    7 +------
 arch/arm/kernel/ptrace.c        |   42 +++++++++++++++++++--------------------
 arch/microblaze/kernel/ptrace.c |    4 ++--
 arch/mips/kernel/ptrace.c       |   16 ++++++---------
 arch/powerpc/kernel/ptrace.c    |    5 +++--
 arch/s390/kernel/ptrace.c       |    6 +++---
 arch/sh/kernel/ptrace_32.c      |    5 +++--
 arch/sh/kernel/ptrace_64.c      |    5 +++--
 arch/sparc/kernel/ptrace_64.c   |    7 ++++---
 arch/x86/kernel/ptrace.c        |   13 ++++++------
 kernel/seccomp.c                |    4 ++++
 11 files changed, 56 insertions(+), 58 deletions(-)

-- 
1.7.9.5

