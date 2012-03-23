Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2CWEQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:16:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65004 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab2CWEQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:16:04 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        Andy Lutomirski <luto@mit.edu>, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/2] x86-64: Inline vdso clock_gettime helpers
Date: Thu, 22 Mar 2012 21:15:52 -0700
Message-Id: <5bc2d286c924b3fd520c82dacb8de7efb49c0c38.1332475308.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1332475308.git.luto@amacapital.net>
References: <cover.1332475308.git.luto@amacapital.net>
In-Reply-To: <cover.1332475308.git.luto@amacapital.net>
References: <cover.1332475308.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@mit.edu>

This is about a 3% speedup on Sandy Bridge.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vclock_gettime.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 6eea70b8..885eff4 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -94,7 +94,8 @@ notrace static inline long vgetns(void)
 	return (v * gtod->clock.mult) >> gtod->clock.shift;
 }
 
-notrace static noinline int do_realtime(struct timespec *ts)
+/* Code size doesn't matter (vdso is 4k anyway) and this is faster. */
+notrace static int __always_inline do_realtime(struct timespec *ts)
 {
 	unsigned long seq, ns;
 	int mode;
@@ -111,7 +112,7 @@ notrace static noinline int do_realtime(struct timespec *ts)
 	return mode;
 }
 
-notrace static noinline int do_monotonic(struct timespec *ts)
+notrace static int do_monotonic(struct timespec *ts)
 {
 	unsigned long seq, ns;
 	int mode;
@@ -128,7 +129,7 @@ notrace static noinline int do_monotonic(struct timespec *ts)
 	return mode;
 }
 
-notrace static noinline int do_realtime_coarse(struct timespec *ts)
+notrace static int do_realtime_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
@@ -139,7 +140,7 @@ notrace static noinline int do_realtime_coarse(struct timespec *ts)
 	return 0;
 }
 
-notrace static noinline int do_monotonic_coarse(struct timespec *ts)
+notrace static int do_monotonic_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
-- 
1.7.7.6

