Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2GHUcl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 16:32:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab2GHUci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 16:32:38 -0400
Date: Sun, 8 Jul 2012 22:30:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] uprobes: suppress uprobe_munmap() from mmput()
Message-ID: <20120708203003.GA18226@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120708202917.GA18188@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_munmap() does get_user_pages() and it is also called from
the final mmput()->exit_mmap() path. This slows down exit/mmput()
for no reason, and I think  it is simply dangerous/wrong to try to
fault-in a page into the dying mm. If nothing else, this happens
after the last sync_mm_rss(), afaics handle_mm_fault() can change
the task->rss_stat and make the subsequent check_mm() unhappy.

Change uprobe_munmap() to check mm->mm_users != 0.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index a93b6df..47c4e24 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1082,6 +1082,9 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
 	if (!atomic_read(&uprobe_events) || !valid_vma(vma, false))
 		return;
 
+	if (!atomic_read(&vma->vm_mm->mm_users)) /* called by mmput() ? */
+		return;
+
 	if (!atomic_read(&vma->vm_mm->uprobes_state.count))
 		return;
 
-- 
1.5.5.1

