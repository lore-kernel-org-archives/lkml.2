Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704Ab2EJOb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:31:26 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56053 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab2EJOaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:30:46 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 7/9] x86, MCE, AMD: Make error_count read only
Date: Thu, 10 May 2012 16:30:27 +0200
Message-Id: <1336660229-32644-8-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1336660229-32644-1-git-send-email-bp@amd64.org>
References: <1336660229-32644-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Until now, writing to error count caused the code to reset the
thresholding bank to the current thresholding limit and start counting
errors from the beginning.

This is misleading and unclear, and can be accomplished by writing the
old thresholding limit into ->threshold_limit.

Make error_count read-only with the functionality to show the current
error count.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index a7204ef37223..e5ed2c7cb4de 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -369,14 +369,10 @@ static ssize_t show_error_count(struct threshold_block *b, char *buf)
 				     (THRESHOLD_MAX - b->threshold_limit)));
 }
 
-static ssize_t store_error_count(struct threshold_block *b,
-				 const char *buf, size_t count)
-{
-	struct thresh_restart tr = { .b = b, .reset = 1, .old_limit = 0 };
-
-	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
-	return 1;
-}
+static struct threshold_attr error_count = {
+	.attr = {.name = __stringify(error_count), .mode = 0444 },
+	.show = show_error_count,
+};
 
 #define RW_ATTR(val)							\
 static struct threshold_attr val = {					\
@@ -387,7 +383,6 @@ static struct threshold_attr val = {					\
 
 RW_ATTR(interrupt_enable);
 RW_ATTR(threshold_limit);
-RW_ATTR(error_count);
 
 static struct attribute *default_attrs[] = {
 	&threshold_limit.attr,
-- 
1.7.9.3.362.g71319

