Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab0CWCSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 22:18:45 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55843 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab0CWCSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 22:18:44 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] proc: task->signal can't be NULL
References: <20100322184127.GA3952@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 22 Mar 2010 19:18:38 -0700
In-Reply-To: <20100322184127.GA3952@redhat.com> (Oleg Nesterov's message of "Mon\, 22 Mar 2010 19\:41\:27 +0100")
Message-ID: <m1ocifvkzl.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: oleg@redhat.com, linux-kernel@vger.kernel.org, roland@redhat.com, adobriyan@gmail.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> With the recent changes in -mm it is always safe to dereference
> task->signal. It can't be NULL and it is pinned to task_struct.
>
> fs/proc becomes the only valid user of signal->count which should
> either die or become "int nr_threads".
>
>
> Alexey, Eric.
>
> Can't we kill this counter? Afaics, get_nr_threads() doesn't need to
> be "precise", we probably can estimate the number of threads using
> signal->live (yes sure, we can't use ->live as nr_threads).
>
> Except: first_tid() uses get_nr_threads() for optimization. Is this
> optimization really important? Afaics, it only helps in the unlikely
> case, probably in that case the extra lockless while_each_thread()
> doesn't hurt.
>
> IOW, how about
>
> 	--- a/fs/proc/base.c
> 	+++ b/fs/proc/base.c
> 	@@ -3071,11 +3071,6 @@ static struct task_struct *first_tid(str
> 				goto found;
> 		}
> 	 
> 	-	/* If nr exceeds the number of threads there is nothing todo */
> 	-	pos = NULL;
> 	-	if (nr && nr >= get_nr_threads(leader))
> 	-		goto out;
> 	-
> 		/* If we haven't found our starting place yet start
> 		 * with the leader and walk nr threads forward.
> 		 */
>
> ?
>
> Not that I think it is terribly important to kill this counter, and
> probably signal->nr_threads can make sense anyway, so far I am just
> curious.

I think that was just a sanity check since it was easy.  I want to say
it prevents a DOS attack with user space passing unreasonably large
file position but that DOS attack is handled by ensuring we don't walk
through the list if threads more than once.

However:
proc_task_getattr uses get_nr_threads to get it's nlink count correct.

Not walking the thread list to get the number of threads seems like an
important cpu time saving measure.

Eric

