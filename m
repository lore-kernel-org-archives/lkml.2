Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab0FWUjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:39:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab0FWUjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:39:25 -0400
Date: Wed, 23 Jun 2010 22:37:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] pid_ns: move pid_ns_release_proc() from
	proc_flush_task() to zap_pid_ns_processes()
Message-ID: <20100623203735.GB25298@redhat.com>
References: <1276706068-18567-1-git-send-email-louis.rilling@kerlabs.com> <20100617212003.GA4182@redhat.com> <20100618082033.GD16877@hawkmoon.kerlabs.com> <20100618111554.GA3252@redhat.com> <20100618160849.GA7404@redhat.com> <20100618173320.GG16877@hawkmoon.kerlabs.com> <20100618175541.GA13680@redhat.com> <20100618212355.GA29478@redhat.com> <20100619190840.GA3424@redhat.com> <20100623203652.GA25298@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623203652.GA25298@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mostly cleanup and optimization, but also fixes the bug.

proc_flush_task() checks upid->nr == 1 to detect the case when
a sub-namespace exits. However, this doesn't work in case when
a multithreaded init execs and calls release_task(old_leader),
the old leader has the same pid 1.

Move pid_ns_release_proc() to zap_pid_ns_processes(), it is called
when we know for sure that init is exiting.

Note: with or without this change this mntput() can happen before the
EXIT_DEAD tasks not visible to do_wait() have passed proc_flush_task().
We need more fixes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/proc/base.c         |    4 ----
 kernel/pid_namespace.c |    2 ++
 2 files changed, 2 insertions(+), 4 deletions(-)

--- 35-rc3/fs/proc/base.c~PNS_5_MOVE_MNTPUT_TO_ZAP	2010-06-23 22:06:01.000000000 +0200
+++ 35-rc3/fs/proc/base.c	2010-06-23 22:10:26.000000000 +0200
@@ -2745,10 +2745,6 @@ void proc_flush_task(struct task_struct 
 		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
 					tgid->numbers[i].nr);
 	}
-
-	upid = &pid->numbers[pid->level];
-	if (upid->nr == 1)
-		pid_ns_release_proc(upid->ns);
 }
 
 static struct dentry *proc_pid_instantiate(struct inode *dir,
--- 35-rc3/kernel/pid_namespace.c~PNS_5_MOVE_MNTPUT_TO_ZAP	2010-06-23 22:13:07.000000000 +0200
+++ 35-rc3/kernel/pid_namespace.c	2010-06-23 22:13:55.000000000 +0200
@@ -189,6 +189,8 @@ void zap_pid_ns_processes(struct pid_nam
 	} while (rc != -ECHILD);
 
 	acct_exit_ns(pid_ns);
+	pid_ns_release_proc(pid_ns);
+
 	return;
 }
 

