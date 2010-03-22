Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab0CVSm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:42:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab0CVSmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:42:54 -0400
Date: Mon, 22 Mar 2010 19:41:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/3] proc: task->signal can't be NULL
Message-ID: <20100322184127.GA3952@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent changes in -mm it is always safe to dereference
task->signal. It can't be NULL and it is pinned to task_struct.

fs/proc becomes the only valid user of signal->count which should
either die or become "int nr_threads".


Alexey, Eric.

Can't we kill this counter? Afaics, get_nr_threads() doesn't need to
be "precise", we probably can estimate the number of threads using
signal->live (yes sure, we can't use ->live as nr_threads).

Except: first_tid() uses get_nr_threads() for optimization. Is this
optimization really important? Afaics, it only helps in the unlikely
case, probably in that case the extra lockless while_each_thread()
doesn't hurt.

IOW, how about

	--- a/fs/proc/base.c
	+++ b/fs/proc/base.c
	@@ -3071,11 +3071,6 @@ static struct task_struct *first_tid(str
				goto found;
		}
	 
	-	/* If nr exceeds the number of threads there is nothing todo */
	-	pos = NULL;
	-	if (nr && nr >= get_nr_threads(leader))
	-		goto out;
	-
		/* If we haven't found our starting place yet start
		 * with the leader and walk nr threads forward.
		 */

?

Not that I think it is terribly important to kill this counter, and
probably signal->nr_threads can make sense anyway, so far I am just
curious.

Oleg.

