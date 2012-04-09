Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2DIUDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:03:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53915 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab2DIUDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:03:41 -0400
Subject: [PATCH] mm: sync rss-counters at the end of exit_mm()
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Date: Tue, 10 Apr 2012 00:03:36 +0400
Message-ID: <20120409200336.8368.63793.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On task's exit do_exit() calls sync_mm_rss() but this is not enough,
there can be page-faults after this point, for example exit_mm() ->
mm_release() -> put_user() (for processing tsk->clear_child_tid).
Thus there may be some rss-counters delta in current->rss_stat.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/exit.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/exit.c b/kernel/exit.c
index d8bd3b42..8e09dbe 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -683,6 +683,7 @@ static void exit_mm(struct task_struct * tsk)
 	enter_lazy_tlb(mm, current);
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
+	sync_mm_rss(mm);
 	mmput(mm);
 }
 

