Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab1LTQbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 11:31:16 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52690 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab1LTQbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 11:31:09 -0500
Date: Tue, 20 Dec 2011 08:27:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: linux-next: build warning after merge of the tip and rcu trees
Message-ID: <20111220162753.GH2351@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111220182451.c08fa803f748f48101008661@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220182451.c08fa803f748f48101008661@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11122016-1976-0000-0000-000008C0A89F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 06:24:51PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> kernel/debug/kdb/kdb_support.c: In function 'kdb_task_state_char':
> kernel/debug/kdb/kdb_support.c:639:2: warning: passing argument 1 of 'is_idle_task' discards 'const' qualifier from pointer target type [enabled by default]
> include/linux/sched.h:2097:20: note: expected 'struct task_struct *' but argument is of type 'const struct task_struct *'
> 
> Introduced by commit 7fc20c5cbdd1 ("kdb: Make KDB use the new
> is_idle_task() API").
> 
> This begs the question: Why does is_idle_task() not take a "const struct task_struct *"?

No reason.  So I have pushed the following patch to -rcu.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

sched: Add "const" to is_idle_task() parameter

This patch fixes a build warning in -next due to a const pointer being
passed to is_idle_task().  Because is_idle_task() does not modify anything,
this commit adds the "const" to is_idle_task()'s argument declaration.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4a7e4d3..56fa25a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2074,7 +2074,7 @@ extern struct task_struct *idle_task(int cpu);
  * is_idle_task - is the specified task an idle task?
  * @tsk: the task in question.
  */
-static inline bool is_idle_task(struct task_struct *p)
+static inline bool is_idle_task(const struct task_struct *p)
 {
 	return p->pid == 0;
 }

