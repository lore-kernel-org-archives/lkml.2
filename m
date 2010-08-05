Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699Ab0HEOjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:39:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:41205 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933223Ab0HEOio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:44 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Dongdong Deng <dongdong.deng@windriver.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 16/17] kgdb,x86: use macro HBP_NUM to replace magic number 4
Date: Thu,  5 Aug 2010 09:37:57 -0500
Message-Id: <1281019078-6636-17-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-16-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-5-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-6-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-7-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-8-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-9-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-10-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-11-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-12-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-13-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-14-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-15-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-16-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:24.0230 (UTC) FILETIME=[DBD34860:01CB34AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongdong Deng <dongdong.deng@windriver.com>

Use the macros provided by the HW breakpoint API.

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index a8b8097..ef10940 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -195,7 +195,7 @@ static struct hw_breakpoint {
 	int			len;
 	int			type;
 	struct perf_event	**pev;
-} breakinfo[4];
+} breakinfo[HBP_NUM];
 
 static unsigned long early_dr7;
 
@@ -203,7 +203,7 @@ static void kgdb_correct_hw_break(void)
 {
 	int breakno;
 
-	for (breakno = 0; breakno < 4; breakno++) {
+	for (breakno = 0; breakno < HBP_NUM; breakno++) {
 		struct perf_event *bp;
 		struct arch_hw_breakpoint *info;
 		int val;
@@ -290,10 +290,10 @@ kgdb_remove_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 {
 	int i;
 
-	for (i = 0; i < 4; i++)
+	for (i = 0; i < HBP_NUM; i++)
 		if (breakinfo[i].addr == addr && breakinfo[i].enabled)
 			break;
-	if (i == 4)
+	if (i == HBP_NUM)
 		return -1;
 
 	if (hw_break_release_slot(i)) {
@@ -311,7 +311,7 @@ static void kgdb_remove_all_hw_break(void)
 	int cpu = raw_smp_processor_id();
 	struct perf_event *bp;
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < HBP_NUM; i++) {
 		if (!breakinfo[i].enabled)
 			continue;
 		bp = *per_cpu_ptr(breakinfo[i].pev, cpu);
@@ -331,10 +331,10 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 {
 	int i;
 
-	for (i = 0; i < 4; i++)
+	for (i = 0; i < HBP_NUM; i++)
 		if (!breakinfo[i].enabled)
 			break;
-	if (i == 4)
+	if (i == HBP_NUM)
 		return -1;
 
 	switch (bptype) {
@@ -395,7 +395,7 @@ void kgdb_disable_hw_debug(struct pt_regs *regs)
 
 	/* Disable hardware debugging while we are in kgdb: */
 	set_debugreg(0UL, 7);
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < HBP_NUM; i++) {
 		if (!breakinfo[i].enabled)
 			continue;
 		if (dbg_is_early) {
@@ -640,7 +640,7 @@ void kgdb_arch_late(void)
 	attr.bp_len = HW_BREAKPOINT_LEN_1;
 	attr.bp_type = HW_BREAKPOINT_W;
 	attr.disabled = 1;
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < HBP_NUM; i++) {
 		if (breakinfo[i].pev)
 			continue;
 		breakinfo[i].pev = register_wide_hw_breakpoint(&attr, NULL);
-- 
1.6.3.3

