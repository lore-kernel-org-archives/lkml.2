Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934076Ab1CZA1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:27:32 -0400
Received: from kroah.org ([198.145.64.141]:41469 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257Ab1CYXwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:40 2011
Message-Id: <20110325234840.417557459@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrey Vagin <avagin@openvz.org>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [14/55] oom: skip zombies when iterating tasklist
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrey Vagin <avagin@openvz.org>

commit 30e2b41f20b6238f51e7cffb879c7a0f0073f5fe upstream.

We shouldn't defer oom killing if a thread has already detached its ->mm
and still has TIF_MEMDIE set.  Memory needs to be freed, so find kill
other threads that pin the same ->mm or find another task to kill.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/oom_kill.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -299,6 +299,8 @@ static struct task_struct *select_bad_pr
 	do_each_thread(g, p) {
 		unsigned int points;
 
+		if (!p->mm)
+			continue;
 		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
 
@@ -324,7 +326,7 @@ static struct task_struct *select_bad_pr
 		 * the process of exiting and releasing its resources.
 		 * Otherwise we could get an easy OOM deadlock.
 		 */
-		if ((p->flags & PF_EXITING) && p->mm) {
+		if (p->flags & PF_EXITING) {
 			if (p != current)
 				return ERR_PTR(-1UL);
 


