Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab1BPAnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:43:19 -0500
Received: from kroah.org ([198.145.64.141]:49391 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757598Ab1BPAXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:21 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:43 2011
Message-Id: <20110216001443.610757076@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "J. Bruce Fields" <bfields@fieldses.org>, Ingo Molnar <mingo@elte.hu>
Subject: [185/272] sched: Change wait_for_completion_*_timeout() to return a signed long
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 6bf4123760a5aece6e4829ce90b70b6ffd751d65 upstream.

wait_for_completion_*_timeout() can return:

   0: if the wait timed out
 -ve: if the wait was interrupted
 +ve: if the completion was completed.

As they currently return an 'unsigned long', the last two cases
are not easily distinguished which can easily result in buggy
code, as is the case for the recently added
wait_for_completion_interruptible_timeout() call in
net/sunrpc/cache.c

So change them both to return 'long'.  As MAX_SCHEDULE_TIMEOUT
is LONG_MAX, a large +ve return value should never overflow.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: J.  Bruce Fields <bfields@fieldses.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20110105125016.64ccab0e@notabene.brown>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/completion.h |    8 ++++----
 kernel/sched.c             |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -81,10 +81,10 @@ extern int wait_for_completion_interrupt
 extern int wait_for_completion_killable(struct completion *x);
 extern unsigned long wait_for_completion_timeout(struct completion *x,
 						   unsigned long timeout);
-extern unsigned long wait_for_completion_interruptible_timeout(
-			struct completion *x, unsigned long timeout);
-extern unsigned long wait_for_completion_killable_timeout(
-			struct completion *x, unsigned long timeout);
+extern long wait_for_completion_interruptible_timeout(
+	struct completion *x, unsigned long timeout);
+extern long wait_for_completion_killable_timeout(
+	struct completion *x, unsigned long timeout);
 extern bool try_wait_for_completion(struct completion *x);
 extern bool completion_done(struct completion *x);
 
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4526,7 +4526,7 @@ EXPORT_SYMBOL(wait_for_completion_interr
  * This waits for either a completion of a specific task to be signaled or for a
  * specified timeout to expire. It is interruptible. The timeout is in jiffies.
  */
-unsigned long __sched
+long __sched
 wait_for_completion_interruptible_timeout(struct completion *x,
 					  unsigned long timeout)
 {
@@ -4559,7 +4559,7 @@ EXPORT_SYMBOL(wait_for_completion_killab
  * signaled or for a specified timeout to expire. It can be
  * interrupted by a kill signal. The timeout is in jiffies.
  */
-unsigned long __sched
+long __sched
 wait_for_completion_killable_timeout(struct completion *x,
 				     unsigned long timeout)
 {


