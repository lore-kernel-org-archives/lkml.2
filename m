Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab2KSFdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:33:10 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44071 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2KSFdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:33:06 -0500
X-Originating-IP: 217.70.178.151
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 52/58] x86: vdso: Add prototypes for __vdso_* functions
Date: Sun, 18 Nov 2012 21:28:31 -0800
Message-Id: <1353302917-13995-53-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/vdso/vclock_gettime.c and arch/x86/vdso/vgetcpu.c define
several functions prefixed by __vdso_*, used in the alias definitions
for the actual vdso symbols calls.  Add prototypes of these functions
right before their definitions, to satisfy gcc (-Wmissing-prototypes)
and Sparse (-Wdecl).

arch/x86/vdso/vclock_gettime.c:161:45: warning: no previous prototype for ‘__vdso_clock_gettime’ [-Wmissing-prototypes]
arch/x86/vdso/vclock_gettime.c:185:45: warning: no previous prototype for ‘__vdso_gettimeofday’ [-Wmissing-prototypes]
arch/x86/vdso/vclock_gettime.c:213:48: warning: no previous prototype for ‘__vdso_time’ [-Wmissing-prototypes]
arch/x86/vdso/vgetcpu.c:16:1: warning: no previous prototype for ‘__vdso_getcpu’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/vdso/vclock_gettime.c |    3 +++
 arch/x86/vdso/vgetcpu.c        |    2 ++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 4df6c37..bc8b276 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -158,6 +158,7 @@ notrace static int do_monotonic_coarse(struct timespec *ts)
 	return 0;
 }
 
+int __vdso_clock_gettime(clockid_t clock, struct timespec *ts);
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
 	int ret = VCLOCK_NONE;
@@ -182,6 +183,7 @@ notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 int clock_gettime(clockid_t, struct timespec *)
 	__attribute__((weak, alias("__vdso_clock_gettime")));
 
+int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz);
 notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	long ret = VCLOCK_NONE;
@@ -210,6 +212,7 @@ int gettimeofday(struct timeval *, struct timezone *)
  * This will break when the xtime seconds get inaccurate, but that is
  * unlikely
  */
+time_t __vdso_time(time_t *t);
 notrace time_t __vdso_time(time_t *t)
 {
 	/* This is atomic on x86_64 so we don't need any locks. */
diff --git a/arch/x86/vdso/vgetcpu.c b/arch/x86/vdso/vgetcpu.c
index 5463ad5..b55350f 100644
--- a/arch/x86/vdso/vgetcpu.c
+++ b/arch/x86/vdso/vgetcpu.c
@@ -12,6 +12,8 @@
 #include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 
+long __vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused);
+
 notrace long
 __vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused)
 {
-- 
1.7.10.4

