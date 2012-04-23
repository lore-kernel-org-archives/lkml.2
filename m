Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2DWXt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:49:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57617 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2DWXtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:49:55 -0400
Date: Mon, 23 Apr 2012 16:49:39 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-d643bdca8ab9cd333da1b68267d0e47328e56f56@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bruce.j.beare@intel.com, arnd@arndb.de, tglx@linutronix.de,
        hjl.rools@gmail.com, hpa@linux.intel.com
Reply-To: arnd@arndb.de, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, bruce.j.beare@intel.com,
        hjl.rools@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com>
References: <CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] asm-generic:
  Allow overriding clock_t and add attributes to siginfo_t
Git-Commit-ID: d643bdca8ab9cd333da1b68267d0e47328e56f56
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 23 Apr 2012 16:49:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d643bdca8ab9cd333da1b68267d0e47328e56f56
Gitweb:     http://git.kernel.org/tip/d643bdca8ab9cd333da1b68267d0e47328e56f56
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 23 Apr 2012 16:29:18 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 23 Apr 2012 16:29:18 -0700

asm-generic: Allow overriding clock_t and add attributes to siginfo_t

For the particular issue of x32, which shares code with i386 in the
handling of compat_siginfo_t, the use of a 64-bit clock_t bumps the
sigchld structure out of alignment, which triggers a messy cascade of
padding.

This was already handled on the kernel compat side, but it needs
handling on the user space side, which uses the generic header.  To
make that possible:

1. Allow __kernel_clock_t to be overridden in struct siginfo;
2. Allow there to be attributes added to struct siginfo.

Reported-by: H.J. Lu <hjl.rools@gmail.com>
Cc: Bruce J. Beare <bruce.j.beare@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Link: http://lkml.kernel.org/r/CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU%2BG53hwBbSD4iA2UzyxuA@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/asm-generic/siginfo.h |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/siginfo.h b/include/asm-generic/siginfo.h
index 0dd4e87..5e5e386 100644
--- a/include/asm-generic/siginfo.h
+++ b/include/asm-generic/siginfo.h
@@ -35,6 +35,14 @@ typedef union sigval {
 #define __ARCH_SI_BAND_T long
 #endif
 
+#ifndef __ARCH_SI_CLOCK_T
+#define __ARCH_SI_CLOCK_T __kernel_clock_t
+#endif
+
+#ifndef __ARCH_SI_ATTRIBUTES
+#define __ARCH_SI_ATTRIBUTES
+#endif
+
 #ifndef HAVE_ARCH_SIGINFO_T
 
 typedef struct siginfo {
@@ -72,8 +80,8 @@ typedef struct siginfo {
 			__kernel_pid_t _pid;	/* which child */
 			__ARCH_SI_UID_T _uid;	/* sender's uid */
 			int _status;		/* exit code */
-			__kernel_clock_t _utime;
-			__kernel_clock_t _stime;
+			__ARCH_SI_CLOCK_T _utime;
+			__ARCH_SI_CLOCK_T _stime;
 		} _sigchld;
 
 		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
@@ -91,7 +99,7 @@ typedef struct siginfo {
 			int _fd;
 		} _sigpoll;
 	} _sifields;
-} siginfo_t;
+} __ARCH_SI_ATTRIBUTES siginfo_t;
 
 #endif
 
