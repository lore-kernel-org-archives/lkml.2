Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1LYQvy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 11:51:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57032 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab1LYQv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 11:51:27 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>, Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 4/4] x86-64: Inline vdso clock_gettime helpers
Date: Sun, 25 Dec 2011 08:51:03 -0800
Message-Id: <4ee248995a08806733757429fdb0a2d7066b1e08.1324831829.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <cover.1324831829.git.luto@amacapital.net>
References: <cover.1324831829.git.luto@amacapital.net>
In-Reply-To: <cover.1324831829.git.luto@amacapital.net>
References: <cover.1324831829.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is about a 6% speedup on Sandy Bridge.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vclock_gettime.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index fe960ac..40eead5 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -82,7 +82,8 @@ notrace static inline long vgetns(void)
 	return (v * gtod->clock.mult) >> gtod->clock.shift;
 }
 
-notrace static noinline void do_realtime(struct timespec *ts)
+/* Code size doesn't matter (vdso is 4k anyway) and this is faster. */
+notrace static void __always_inline do_realtime(struct timespec *ts)
 {
 	unsigned long seq, ns;
 	do {
@@ -94,7 +95,7 @@ notrace static noinline void do_realtime(struct timespec *ts)
 	timespec_add_ns(ts, ns);
 }
 
-notrace static noinline u64 do_realtime_ns(void)
+notrace static u64 do_realtime_ns(void)
 {
 	unsigned long seq, ns;
 	do {
@@ -104,7 +105,7 @@ notrace static noinline u64 do_realtime_ns(void)
 	return ns;
 }
 
-notrace static noinline void do_monotonic(struct timespec *ts)
+notrace static void do_monotonic(struct timespec *ts)
 {
 	unsigned long seq, ns;
 	do {
@@ -116,7 +117,7 @@ notrace static noinline void do_monotonic(struct timespec *ts)
 	timespec_add_ns(ts, ns);
 }
 
-notrace static noinline u64 do_monotonic_ns(void)
+notrace static u64 do_monotonic_ns(void)
 {
 	unsigned long seq, ns;
 	do {
@@ -126,7 +127,7 @@ notrace static noinline u64 do_monotonic_ns(void)
 	return ns;
 }
 
-notrace static noinline void do_realtime_coarse(struct timespec *ts)
+notrace static void do_realtime_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
@@ -136,13 +137,13 @@ notrace static noinline void do_realtime_coarse(struct timespec *ts)
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
 }
 
-notrace static noinline u64 do_realtime_coarse_ns(void)
+notrace static u64 do_realtime_coarse_ns(void)
 {
 	/* This is atomic on x86-64. */
 	return ACCESS_ONCE(gtod->wall_time_coarse_flat_ns);
 }
 
-notrace static noinline void do_monotonic_coarse(struct timespec *ts)
+notrace static void do_monotonic_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
@@ -152,7 +153,7 @@ notrace static noinline void do_monotonic_coarse(struct timespec *ts)
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
 }
 
-notrace static noinline u64 do_monotonic_coarse_ns(void)
+notrace static u64 do_monotonic_coarse_ns(void)
 {
 	/* This is atomic on x86-64. */
 	return ACCESS_ONCE(gtod->monotonic_time_coarse_flat_ns);
-- 
1.7.7.4

