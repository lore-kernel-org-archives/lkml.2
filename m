Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab2G3OOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:14:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45595 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2G3OOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:14:21 -0400
Date: Mon, 30 Jul 2012 07:14:04 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-2fd611a991391a6050cbd139201a2e12fc306540@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com, hpa@zytor.com,
        mingo@kernel.org, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@redhat.com,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120729182231.GA20336@redhat.com>
References: <20120729182231.GA20336@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Suppress uprobe_munmap() from mmput()
Git-Commit-ID: 2fd611a991391a6050cbd139201a2e12fc306540
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jul 2012 07:14:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fd611a991391a6050cbd139201a2e12fc306540
Gitweb:     http://git.kernel.org/tip/2fd611a991391a6050cbd139201a2e12fc306540
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 29 Jul 2012 20:22:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 30 Jul 2012 11:27:21 +0200

uprobes: Suppress uprobe_munmap() from mmput()

uprobe_munmap() does get_user_pages() and it is also called from
the final mmput()->exit_mmap() path. This slows down
exit/mmput() for no reason, and I think  it is simply
dangerous/wrong to try to fault-in a page into the dying mm. If
nothing else, this happens after the last sync_mm_rss(), afaics
handle_mm_fault() can change the task->rss_stat and make the
subsequent check_mm() unhappy.

Change uprobe_munmap() to check mm->mm_users != 0.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120729182231.GA20336@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index bed2161..9db9cdf 100644
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
 
