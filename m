Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965757Ab2FBTYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 15:24:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54046 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965698Ab2FBTYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 15:24:18 -0400
Date: Sat, 2 Jun 2012 12:24:08 -0700
From: "tip-bot for H.J. Lu" <hjl.tools@gmail.com>
Message-ID: <tip-bad1a753d4d4deb09d4bc0bac1dd4fc3298502e9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
In-Reply-To: <CAMe9rOpDzHfS7NH7m1vmD9QRw8SSj4Sc+aNOgcWm_WJME2eRsQ@mail.gmail.com>
References: <CAMe9rOpDzHfS7NH7m1vmD9QRw8SSj4Sc+aNOgcWm_WJME2eRsQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, x32, ptrace:
  Remove PTRACE_ARCH_PRCTL for x32
Git-Commit-ID: bad1a753d4d4deb09d4bc0bac1dd4fc3298502e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 02 Jun 2012 12:24:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bad1a753d4d4deb09d4bc0bac1dd4fc3298502e9
Gitweb:     http://git.kernel.org/tip/bad1a753d4d4deb09d4bc0bac1dd4fc3298502e9
Author:     H.J. Lu <hjl.tools@gmail.com>
AuthorDate: Mon, 21 May 2012 20:29:45 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 1 Jun 2012 13:54:21 -0700

x86, x32, ptrace: Remove PTRACE_ARCH_PRCTL for x32

When I added x32 ptrace to 3.4 kernel, I also include PTRACE_ARCH_PRCTL
support for x32 GDB  For ARCH_GET_FS/GS, it takes a pointer to int64.  But
at user level, ARCH_GET_FS/GS takes a pointer to int32.  So I have to add
x32 ptrace to glibc to handle it with a temporary int64 passed to kernel and
copy it back to GDB as int32.  Roland suggested that PTRACE_ARCH_PRCTL
is obsolete and x32 GDB should use fs_base and gs_base fields of
user_regs_struct instead.

Accordingly, remove PTRACE_ARCH_PRCTL completely from the x32 code to
avoid possible memory overrun when pointer to int32 is passed to
kernel.

Link: http://lkml.kernel.org/r/CAMe9rOpDzHfS7NH7m1vmD9QRw8SSj4Sc%2BaNOgcWm_WJME2eRsQ@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@vger.kernel.org> v3.4
---
 arch/x86/kernel/ptrace.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 13b1990..c4c6a5c 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1211,12 +1211,6 @@ static long x32_arch_ptrace(struct task_struct *child,
 					     0, sizeof(struct user_i387_struct),
 					     datap);
 
-		/* normal 64bit interface to access TLS data.
-		   Works just like arch_prctl, except that the arguments
-		   are reversed. */
-	case PTRACE_ARCH_PRCTL:
-		return do_arch_prctl(child, data, addr);
-
 	default:
 		return compat_ptrace_request(child, request, addr, data);
 	}
