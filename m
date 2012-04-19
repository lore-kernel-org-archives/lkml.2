Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab2DSVGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:06:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38883 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626Ab2DSVGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:06:05 -0400
Message-Id: <20120419210305.006128264@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jason Wessel <jason.wessel@windriver.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [ 22/75] panic: fix stack dump print on direct call to panic()
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wessel <jason.wessel@windriver.com>

commit 026ee1f66aaa7f01b617a0ba89ac4b531f9603f1 upstream.

Commit 6e6f0a1f0fa6 ("panic: don't print redundant backtraces on oops")
causes a regression where no stack trace will be printed at all for the
case where kernel code calls panic() directly while not processing an
oops, and of course there are 100's of instances of this type of call.

The original commit executed the check (!oops_in_progress), but this will
always be false because just before the dump_stack() there is a call to
bust_spinlocks(1), which does the following:

  void __attribute__((weak)) bust_spinlocks(int yes)
  {
	if (yes) {
		++oops_in_progress;

The proper way to resolve the problem that original commit tried to
solve is to avoid printing a stack dump from panic() when the either of
the following conditions is true:

  1) TAINT_DIE has been set (this is done by oops_end())
     This indicates and oops has already been printed.
  2) oops_in_progress > 1
     This guards against the rare case where panic() is invoked
     a second time, or in between oops_begin() and oops_end()

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 


