Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978Ab2EOCQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:16:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:48954 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964846Ab2EOCQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 006/179] powerpc/oprofile: Handle events that raise an exception without overflowing
Date: Mon, 14 May 2012 22:11:42 -0400
Message-ID: <1337048075-6132-7-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric B Munson <emunson@mgebm.net>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit ad5d5292f16c6c1d7d3e257c4c7407594286b97e upstream.

Commit 0837e3242c73566fc1c0196b4ec61779c25ffc93 fixes a situation on POWER7
where events can roll back if a specualtive event doesn't actually complete.
This can raise a performance monitor exception.  We need to catch this to ensure
that we reset the PMC.  In all cases the PMC will be less than 256 cycles from
overflow.

This patch lifts Anton's fix for the problem in perf and applies it to oprofile
as well.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/oprofile/op_model_power4.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/oprofile/op_model_power4.c b/arch/powerpc/oprofile/op_model_power4.c
index 8077409..93636ca 100644
--- a/arch/powerpc/oprofile/op_model_power4.c
+++ b/arch/powerpc/oprofile/op_model_power4.c
@@ -261,6 +261,28 @@ static int get_kernel(unsigned long pc, unsigned long mmcra)
 	return is_kernel;
 }
 
+static bool pmc_overflow(unsigned long val)
+{
+	if ((int)val < 0)
+		return true;
+
+	/*
+	 * Events on POWER7 can roll back if a speculative event doesn't
+	 * eventually complete. Unfortunately in some rare cases they will
+	 * raise a performance monitor exception. We need to catch this to
+	 * ensure we reset the PMC. In all cases the PMC will be 256 or less
+	 * cycles from overflow.
+	 *
+	 * We only do this if the first pass fails to find any overflowing
+	 * PMCs because a user might set a period of less than 256 and we
+	 * don't want to mistakenly reset them.
+	 */
+	if (__is_processor(PV_POWER7) && ((0x80000000 - val) <= 256))
+		return true;
+
+	return false;
+}
+
 static void power4_handle_interrupt(struct pt_regs *regs,
 				    struct op_counter_config *ctr)
 {
@@ -281,7 +303,7 @@ static void power4_handle_interrupt(struct pt_regs *regs,
 
 	for (i = 0; i < cur_cpu_spec->num_pmcs; ++i) {
 		val = classic_ctr_read(i);
-		if (val < 0) {
+		if (pmc_overflow(val)) {
 			if (oprofile_running && ctr[i].enabled) {
 				oprofile_add_ext_sample(pc, regs, i, is_kernel);
 				classic_ctr_write(i, reset_value[i]);
-- 
1.7.9.6

