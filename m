Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2DIRUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:20:36 -0400
Received: from mail1.windriver.com ([147.11.146.13]:59993 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab2DIRUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:20:35 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <akpm@linux-foundation.org>
CC: <ak@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH][REGRESSION] panic: fix stack dump print on direct call to panic()
Date: Mon, 9 Apr 2012 12:20:30 -0500
Message-ID: <1333992030-21181-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6e6f0a1f0 (panic: don't print redundant backtraces on oops)
causes a regression where no stack trace will be printed at all for
the case where kernel code calls panic() directly while not processing
an oops, and of course there are 100's of instances of this type of
call.

The original commit executed the check (!oops_in_progress), but this
will always be false because just before the dump_stack() there is a
call to bust_spinlocks(1), which does the following:

  void __attribute__((weak)) bust_spinlocks(int yes)
  {
	if (yes) {
		++oops_in_progress;

The proper way to resolve the problem that original commit tried to
solve is to avoid printing a stack dump from panic() when the either
of the following conditions is true:

  1) TAINT_DIE has been set (this is done by oops_end())
     This indicates and oops has already been printed.
  2) oops_in_progress > 1
     This guards against the rare case where panic() is invoked
     a second time, or in between oops_begin() and oops_end()

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: stable@vger.kernel.org # >= 3.3
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 80aed44..8ed89a1 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -97,7 +97,7 @@ void panic(const char *fmt, ...)
 	/*
 	 * Avoid nested stack-dumping if a panic occurs during oops processing
 	 */
-	if (!oops_in_progress)
+	if (!test_taint(TAINT_DIE) && oops_in_progress <= 1)
 		dump_stack();
 #endif
 
-- 
1.7.9.4

