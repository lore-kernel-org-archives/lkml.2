Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab2AEWrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 17:47:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938Ab2AEWrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 17:47:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jan  5 14:44:03 2012
Message-Id: <20120105224402.968395464@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Thu, 05 Jan 2012 14:44:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mandeep Singh Baines <msb@chromium.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        John Kacur <jkacur@redhat.com>
Subject: [70/73] hung_task: fix false positive during vfork
In-Reply-To: <20120105224632.GA14659@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1649
Lines: 48

From: Mandeep Singh Baines <msb@chromium.org>

commit f9fab10bbd768b0e5254e53a4a8477a94bfc4b96 upstream.

vfork parent uninterruptibly and unkillably waits for its child to
exec/exit. This wait is of unbounded length. Ignore such waits
in the hung_task detector.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Reported-by: Sasha Levin <levinsasha928@gmail.com>
LKML-Reference: <1325344394.28904.43.camel@lappy>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Kacur <jkacur@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/hung_task.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -74,11 +74,17 @@ static void check_hung_task(struct task_
 
 	/*
 	 * Ensure the task is not frozen.
-	 * Also, when a freshly created task is scheduled once, changes
-	 * its state to TASK_UNINTERRUPTIBLE without having ever been
-	 * switched out once, it musn't be checked.
+	 * Also, skip vfork and any other user process that freezer should skip.
 	 */
-	if (unlikely(t->flags & PF_FROZEN || !switch_count))
+	if (unlikely(t->flags & (PF_FROZEN | PF_FREEZER_SKIP)))
+	    return;
+
+	/*
+	 * When a freshly created task is scheduled once, changes its state to
+	 * TASK_UNINTERRUPTIBLE without having ever been switched out once, it
+	 * musn't be checked.
+	 */
+	if (unlikely(!switch_count))
 		return;
 
 	if (switch_count != t->last_switch_count) {


