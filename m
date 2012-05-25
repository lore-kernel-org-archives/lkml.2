Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab2EYQBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 12:01:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab2EYQBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 12:01:37 -0400
Date: Fri, 25 May 2012 18:00:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH -mm 1/1] pidns: find_new_reaper() can no longer switch to
	init_pid_ns.child_reaper
Message-ID: <20120525160008.GB16885@redhat.com>
References: <20120517170015.GA12436@redhat.com> <87d3628oqa.fsf@xmission.com> <20120518123911.GA417@redhat.com> <87zk95kper.fsf@xmission.com> <20120521124414.GA20391@redhat.com> <87d35x5ank.fsf_-_@xmission.com> <20120522122315.c3f2118c.akpm@linux-foundation.org> <20120523145239.GA20378@redhat.com> <20120525151526.GA13111@redhat.com> <20120525155941.GA16885@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525155941.GA16885@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_new_reaper() changes pid_ns->child_reaper, see add0d4df
"pid_ns: zap_pid_ns_processes: fix the ->child_reaper changing".

The original reason has gone away after the previous patch,
->children list must be empty after zap_pid_ns_processes().
However, "can't clear ->child_reaper or leave it alone" is
still true, and now we can not use init_pid_ns.child_reaper.

__unhash_process() relies on the "->child_reaper == parent"
check, but this check does not work if the last exiting task
is also the child reaper.

Change find_new_reaper() to use pid_ns->parent->child_reaper.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index b3e6e0e..9f9af91 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -733,11 +733,11 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 		zap_pid_ns_processes(pid_ns);
 		write_lock_irq(&tasklist_lock);
 		/*
-		 * We can not clear ->child_reaper or leave it alone.
-		 * There may by stealth EXIT_DEAD tasks on ->children,
-		 * forget_original_parent() must move them somewhere.
+		 * Our parent can be ->child_reaper as well, make sure
+		 * we don't break the "child_reaper == parent" logic in
+		 * __unhash_process().
 		 */
-		pid_ns->child_reaper = init_pid_ns.child_reaper;
+		pid_ns->child_reaper = pid_ns->parent->child_reaper;
 	} else if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
 
-- 
1.5.5.1


