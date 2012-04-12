Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185Ab2DLIKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:10:00 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44101 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515Ab2DLIJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:09:56 -0400
Subject: [PATCH 2/2] mm: call complete_vfork_done() after clearing child_tid
 and flushing rss-counters
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 12 Apr 2012 12:09:53 +0400
Message-ID: <20120412080952.26401.2025.stgit@zurg>
In-Reply-To: <20120409200336.8368.63793.stgit@zurg>
References: <20120409200336.8368.63793.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Child should wake ups parent from vfork() only after finishing all operations with
shared mm. There is no sense to use CLONE_CHILD_CLEARTID together with CLONE_VFORK,
but it looks more accurate now.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 326bb5b..f10ac1d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -728,9 +728,6 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 	/* Get rid of any cached register state */
 	deactivate_mm(tsk, mm);
 
-	if (tsk->vfork_done)
-		complete_vfork_done(tsk);
-
 	/*
 	 * If we're exiting normally, clear a user-space tid field if
 	 * requested.  We leave this alone when dying by signal, to leave
@@ -759,6 +756,13 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 	 */
 	if (mm)
 		sync_mm_rss(mm);
+
+	/*
+	 * All done, finally we can wake up parent and return this mm to him.
+	 * Also kthread_stop() uses this completion for synchronization.
+	 */
+	if (tsk->vfork_done)
+		complete_vfork_done(tsk);
 }
 
 /*

