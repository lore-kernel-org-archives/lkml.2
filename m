Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab2BEWrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:47:35 -0500
Received: from 1wt.eu ([62.212.114.60]:61862 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab2BEW0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:18 -0500
Message-Id: <20120205220950.344285644@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:10 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric B Munson <emunson@mgebm.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 21/91] powerpc/oprofile: Handle events that raise an exception without overflowing
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/oprofile/op_model_power4.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/arch/powerpc/oprofile/op_model_power4.c
===================================================================
--- longterm-2.6.27.orig/arch/powerpc/oprofile/op_model_power4.c	2012-02-05 22:34:34.372915404 +0100
+++ longterm-2.6.27/arch/powerpc/oprofile/op_model_power4.c	2012-02-05 22:34:37.870914576 +0100
@@ -254,6 +254,28 @@
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
@@ -274,7 +296,7 @@
 
 	for (i = 0; i < cur_cpu_spec->num_pmcs; ++i) {
 		val = classic_ctr_read(i);
-		if (val < 0) {
+		if (pmc_overflow(val)) {
 			if (oprofile_running && ctr[i].enabled) {
 				oprofile_add_ext_sample(pc, regs, i, is_kernel);
 				classic_ctr_write(i, reset_value[i]);


