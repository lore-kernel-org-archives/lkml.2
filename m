Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab2C0RBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 13:01:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52582 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab2C0RBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 13:01:11 -0400
MIME-Version: 1.0
Date: Tue, 27 Mar 2012 10:01:10 -0700
Message-ID: <CAGXu5jK3ezCN2=hy=AARh=T9L8YzCTKAXH6dbAH7FGX3P8VkoQ@mail.gmail.com>
Subject: Correct way to include siginfo.h?
From: Kees Cook <keescook@google.com>
To: LKML <linux-kernel@vger.kernel.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Does anyone know the right way to include siginfo.h when building
userspace tools that need it?

Here are things that work:

#include <stdio.h>
#include <linux/signal.h>

or

#include <stdio.h>
#include <stdlib.h> // adding this breaks <linux/signal.h>
#include <asm/siginfo.h>

But the moment I need <signal.h>, things go badly due to glibc's
siginfo headers:

#include <stdio.h>
#include <signal.h>
#include <asm/siginfo.h>
...
/usr/include/asm-generic/siginfo.h:7:15: error: redefinition of ‘union sigval’
/usr/include/x86_64-linux-gnu/bits/siginfo.h:33:15: note: originally
defined here
...

If I use the attached patch (against the installed headers -- with
seccomp patches), I can do:

#include <asm/siginfo.h>
#include <signal.h>

But order matters, due to the #defines that libc wants to use. What's
the right way to get access to the kernel's siginfo structure
definition?

-Kees

--- /usr/include/asm-generic/siginfo.h~	2012-03-27 09:55:28.094751505 -0700
+++ /usr/include/asm-generic/siginfo.h	2012-03-27 09:57:06.368057279 -0700
@@ -4,10 +4,13 @@

 #include <linux/types.h>

+#ifndef __have_sigval_t
+# define __have_sigval_t
 typedef union sigval {
 	int sival_int;
 	void *sival_ptr;
 } sigval_t;
+#endif

 /*
  * This is the size (including padding) of the part of the
@@ -36,6 +39,8 @@
 #endif

 #ifndef HAVE_ARCH_SIGINFO_T
+#ifndef __have_siginfo_t
+#define __have_siginfo_t 1

 typedef struct siginfo {
 	int si_signo;
@@ -103,6 +108,7 @@
 /* If the arch shares siginfo, then it has SIGSYS. */
 #define __ARCH_SIGSYS
 #endif
+#endif

 /*
  * How these fields are to be accessed.
@@ -248,6 +254,8 @@
  * thread manager then catches and does the appropriate nonsense.
  * However, everything is written out here so as to not get lost.
  */
+#ifndef __have_sigevent_t
+#define __have_sigevent_t 1
 #define SIGEV_SIGNAL	0	/* notify via signal */
 #define SIGEV_NONE	1	/* other notification: meaningless */
 #define SIGEV_THREAD	2	/* deliver via thread creation */
@@ -283,5 +291,6 @@
 #define sigev_notify_function	_sigev_un._sigev_thread._function
 #define sigev_notify_attributes	_sigev_un._sigev_thread._attribute
 #define sigev_notify_thread_id	 _sigev_un._tid
+#endif

 #endif

-- 
Kees Cook
Chrome OS Security
