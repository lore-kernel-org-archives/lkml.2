Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1C1V6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 17:58:04 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63681 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab1C1V6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 17:58:03 -0400
X-Nat-Received: from [202.181.97.72]:64045 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1301349461.16350
To: rostedt@goodmis.org
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] seqlock,lockdep: Add lock primitives to read_seqbegin().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201103261312.AEJ01293.OVFJFSLtHOFOMQ@I-love.SAKURA.ne.jp>
	<20110328171217.GA8529@home.goodmis.org>
In-Reply-To: <20110328171217.GA8529@home.goodmis.org>
Message-Id: <201103290657.JEG17111.VOtOFJFLSQFMOH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 29 Mar 2011 06:57:41 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 28032011 #5158815, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> This is where you confused me. Why would a pattern that was previously
> checked, suddenly break?  If we found A->B and then come across B->A,
> lockdep should surely catch it.

I don't know. This bug can be triggered by simply running

  while :; do newns /sbin/pivot_root /proc/ /proc/sys/; done

and

  while :; do /bin/ls -l /proc/*/exe; done

in parallel. However, lockdep can't catch it even after applying

--- linux-2.6.38.1.orig/include/linux/seqlock.h
+++ linux-2.6.38.1/include/linux/seqlock.h
@@ -86,6 +86,11 @@ static inline int write_tryseqlock(seqlo
 static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 {
 	unsigned ret;
+#ifdef CONFIG_PROVE_LOCKING
+	unsigned long flags;
+	spin_lock_irqsave(&((seqlock_t *) sl)->lock, flags);
+	spin_unlock_irqrestore(&((seqlock_t *) sl)->lock, flags);
+#endif
 
 repeat:
 	ret = sl->sequence;

. Maybe usage of spin_lock_irqsave()/spin_unlock_irqrestore() is bad.

> Maybe I don't understand exactly whay you are trying to say.

Just apply the patch and run the 2 loops above in parallel using 2.6.38.1
will show you. Source code for newns is shown below.

---------- newns.c start ----------
#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <sched.h>
#include <errno.h>
#include <stdlib.h>

static int child(void *arg)
{
	char **argv = (char **) arg;
	argv++;
	execvp(argv[0], argv);
	_exit(1);
}

int main(int argc, char *argv[])
{
	char c = 0;
	char *stack = malloc(8192);
	const pid_t pid = clone(child, stack + (8192 / 2), CLONE_NEWNS,
				(void *) argv);
	while (waitpid(pid, NULL, __WALL) == EOF && errno == EINTR)
		c++; /* Dummy. */
	return 0;
}
---------- newns.c end ----------

Regards.
