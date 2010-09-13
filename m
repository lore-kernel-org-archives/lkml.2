Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab0IMVzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:55:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:48635 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab0IMVzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:55:14 -0400
Date: Mon, 13 Sep 2010 21:54:54 GMT
From: tip-bot for Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        penguin-kernel@I-love.SAKURA.ne.jp, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <201008300127.o7U1RC6Z044051@www262.sakura.ne.jp>
References: <201008300127.o7U1RC6Z044051@www262.sakura.ne.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, cpufeature: Suppress compiler warning with gcc 3.x
Message-ID: <tip-2fd818642a3c3a257f3b1262145a52bc1bfebd26@git.kernel.org>
Git-Commit-ID: 2fd818642a3c3a257f3b1262145a52bc1bfebd26
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 13 Sep 2010 21:54:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fd818642a3c3a257f3b1262145a52bc1bfebd26
Gitweb:     http://git.kernel.org/tip/2fd818642a3c3a257f3b1262145a52bc1bfebd26
Author:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
AuthorDate: Mon, 30 Aug 2010 09:45:40 +0900
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 13 Sep 2010 14:48:41 -0700

x86, cpufeature: Suppress compiler warning with gcc 3.x

Gcc 3.x generates a warning

  arch/x86/include/asm/cpufeature.h: In function `__static_cpu_has':
  arch/x86/include/asm/cpufeature.h:326: warning: asm operand 1 probably doesn't match constraints

on each file.
But static_cpu_has() for gcc 3.x does not need __static_cpu_has().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
LKML-Reference: <201008300127.o7U1RC6Z044051@www262.sakura.ne.jp>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 781a50b..c6fbb7b 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -296,6 +296,7 @@ extern const char * const x86_power_flags[32];
 
 #endif /* CONFIG_X86_64 */
 
+#if __GNUC__ >= 4
 /*
  * Static testing of CPU features.  Used the same as boot_cpu_has().
  * These are only valid after alternatives have run, but will statically
@@ -304,7 +305,7 @@ extern const char * const x86_power_flags[32];
  */
 static __always_inline __pure bool __static_cpu_has(u16 bit)
 {
-#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)
+#if __GNUC__ > 4 || __GNUC_MINOR__ >= 5
 		asm goto("1: jmp %l[t_no]\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
@@ -345,7 +346,6 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 #endif
 }
 
-#if __GNUC__ >= 4
 #define static_cpu_has(bit)					\
 (								\
 	__builtin_constant_p(boot_cpu_has(bit)) ?		\
