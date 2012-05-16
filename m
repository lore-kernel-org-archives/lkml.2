Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab2EPTgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:36:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab2EPTgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:36:13 -0400
Date: Wed, 16 May 2012 21:34:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/3] pidns: Guarantee that the pidns init will be the
	last pidns process reaped.
Message-ID: <20120516193450.GA22859@redhat.com>
References: <1335604790.5995.22.camel@marge.simpson.net> <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org> <20120429165846.GA19054@redhat.com> <1335754867.17899.4.camel@marge.simpson.net> <m1zk9rmyh4.fsf@fess.ebiederm.org> <20120501134214.f6b44f4a.akpm@linux-foundation.org> <87havs7rvv.fsf_-_@xmission.com> <8762c87rrd.fsf_-_@xmission.com> <20120516183920.GA19975@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516183920.GA19975@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Oleg Nesterov wrote:
>
> Hmm. I don't think the patch is 100% correct. Afaics, this needs more
> delay_pidns_leader() checks.

Anyway, if we rely on ->children, can't we make a simpler fix?

Something like below. It can be simplified even more, just to explain
the idea. Perhaps we don't even need the new PF_ flag and we can
re-use ->wait_chldexit.

Oleg.

--- x/kernel/pid_namespace.c
+++ x/kernel/pid_namespace.c
@@ -184,6 +184,22 @@ void zap_pid_ns_processes(struct pid_nam
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
+	current->flags |= PF_DEAD_INIT;
+	for (;;) {
+		bool need_wait;
+
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		read_lock(&tasklist_lock);
+		need_wait = !list_empty(current->children);
+		read_unlock(&tasklist_lock);
+
+		if (!need_wait)
+			break;
+		schedule();
+	}
+	__set_current_state(TASK_RUNNING);
+	current->flags &= ~PF_DEAD_INIT;
+
 	if (pid_ns->reboot)
 		current->signal->group_exit_code = pid_ns->reboot;
 
--- x/kernel/exit.c
+++ x/kernel/exit.c
@@ -71,6 +71,11 @@ static void __unhash_process(struct task
 
 		list_del_rcu(&p->tasks);
 		list_del_init(&p->sibling);
+
+		if (unlikely(p->real_parent->flags & PF_DEAD_INIT)
+			if (list_empty(&p->real_parent->children))
+				wake_up_process(p->real_parent);
+
 		__this_cpu_dec(process_counts);
 	}
 	list_del_rcu(&p->thread_group);

