Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0ETSRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:17:51 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:48852 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab0ETSRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:17:49 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [2.6.34 PATCH] kernel: fix exit message for dead process
In-reply-to: Your message of "Thu, 20 May 2010 08:55:20 EDT."
             <20100520085520.5176d13c.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org> <4637.1274370470@localhost>
            <20100520085520.5176d13c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 20 May 2010 14:17:40 -0400
Message-ID: <10672.1274379460@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4BF57CC5.0161,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a process is exiting with a non-zero preempt_count, it's in fact almost
certainly going to fail to do so because it is exiting due to a BUG or OOPS
while it held a lock, at which point it will never actually exit.  So change
the message to say it attempted to do so, rather than implying it succeeded.
Problem spotted when a process BUG'ed, the kernel reported the 'exited' status,
and then proceeded to BUG twice more dealing with the now-zombied process:

> [   35.357018] note: keymap[2481] exited with preempt_count 1
> [   35.360503] BUG: scheduling while atomic: keymap/2481/0x10000002

Yes, one line is 83 characters. It's still more readable than a split printk.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- linux-2.6.34-mmotm0519/kernel/exit.c.dist	2010-05-20 10:59:11.646870592 -0400
+++ linux-2.6.34-mmotm0519/kernel/exit.c	2010-05-20 14:05:16.068800223 -0400
@@ -936,7 +936,7 @@ NORET_TYPE void do_exit(long code)
 	raw_spin_unlock_wait(&tsk->pi_lock);
 
 	if (unlikely(in_atomic()))
-		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
+		printk(KERN_INFO "note: %s[%d] tried to exit with preempt_count %d\n",
 				current->comm, task_pid_nr(current),
 				preempt_count());
 

