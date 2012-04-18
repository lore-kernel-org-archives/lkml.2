Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab2DRVYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 17:24:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42318 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab2DRVYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 17:24:18 -0400
Message-ID: <4F8F30F5.9030704@zytor.com>
Date: Wed, 18 Apr 2012 14:24:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org> <CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com> <4F8EFE4D.2040201@zytor.com> <CAMe9rOpfPQghra1PQTUwsFOvjgNpzFDEGS5=BbFBjn=HZGL93g@mail.gmail.com> <4F8F0385.5090901@zytor.com> <CAMe9rOq7LduF4aLPe9qatedxps4WPCgOHTD=E_Lje4_tu6tyZw@mail.gmail.com> <4F8F0614.9010604@zytor.com> <CAMe9rOqBd29LKB==NaKscpedRMR1uL_ZhHqSw1HQj-3_d9PSCw@mail.gmail.com>
In-Reply-To: <CAMe9rOqBd29LKB==NaKscpedRMR1uL_ZhHqSw1HQj-3_d9PSCw@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: multipart/mixed;
 boundary="------------040405000100070004070907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040405000100070004070907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Something like this works for you?

Note: we should promote __compat_[us]64 to a global type when we do the
cleanup work requested by Linus (change __[us]64 to explicitly aligned
types, with all users that require the old types using __compat_[us]64),
but we need the compiler warning to do that, realistically.

	-hpa


--------------040405000100070004070907
Content-Type: text/plain; charset=UTF-8;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="diff"

diff --git a/arch/x86/include/asm/siginfo.h b/arch/x86/include/asm/siginfo.h
index fc1aa55..eb91735 100644
--- a/arch/x86/include/asm/siginfo.h
+++ b/arch/x86/include/asm/siginfo.h
@@ -1,8 +1,14 @@
 #ifndef _ASM_X86_SIGINFO_H
 #define _ASM_X86_SIGINFO_H
 
+#include <linux/types.h>
+
 #ifdef __x86_64__
-# define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
+# ifdef __ILP32__
+#  define __ARCH_SI_CLOCK_T		__compat_s64  /* x32 */
+# else
+#  define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
+# endif
 #endif
 
 #include <asm-generic/siginfo.h>
diff --git a/arch/x86/include/asm/types.h b/arch/x86/include/asm/types.h
index 8e8c23f..89d461b 100644
--- a/arch/x86/include/asm/types.h
+++ b/arch/x86/include/asm/types.h
@@ -3,4 +3,7 @@
 
 #include <asm-generic/types.h>
 
+typedef __u64 __attribute__((aligned(4))) __compat_u64;
+typedef __s64 __attribute__((aligned(4))) __compat_s64;
+
 #endif /* _ASM_X86_TYPES_H */
diff --git a/include/asm-generic/siginfo.h b/include/asm-generic/siginfo.h
index 0dd4e87..4ed2ed0 100644
--- a/include/asm-generic/siginfo.h
+++ b/include/asm-generic/siginfo.h
@@ -35,6 +35,10 @@ typedef union sigval {
 #define __ARCH_SI_BAND_T long
 #endif
 
+#ifndef __ARCH_SI_CLOCK_T
+#define __ARCH_SI_CLOCK_T __kernel_clock_t
+#endif
+
 #ifndef HAVE_ARCH_SIGINFO_T
 
 typedef struct siginfo {
@@ -72,8 +76,8 @@ typedef struct siginfo {
 			__kernel_pid_t _pid;	/* which child */
 			__ARCH_SI_UID_T _uid;	/* sender's uid */
 			int _status;		/* exit code */
-			__kernel_clock_t _utime;
-			__kernel_clock_t _stime;
+			__ARCH_SI_CLOCK_T _utime;
+			__ARCH_SI_CLOCK_T _stime;
 		} _sigchld;
 
 		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */

--------------040405000100070004070907--
