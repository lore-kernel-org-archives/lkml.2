Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab0CXPCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:02:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab0CXPCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:02:11 -0400
Date: Wed, 24 Mar 2010 16:00:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/3] proc: make task_sig() lockless
Message-ID: <20100324150027.GA8417@redhat.com>
References: <20100323105707.GA8634@redhat.com> <20100322184136.GA3967@redhat.com> <15829.1269333449@redhat.com> <11571.1269419842@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11571.1269419842@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Yes. From the changelog:
> >
> > 	Of course, this means we read pending/blocked/etc nonatomically,
> > 	but I hope this is OK for fs/proc.
>
> Ah, yes.  I read that as you meant how procfs accessed the actual data
> structures, not how the user accessed procfs.  It might be worth clarifying
> that.

OK, agreed.

> Acked-by: David Howells <dhowells@redhat.com>

Thanks,

> > > Probably we can change do_task_stat() to avod ->siglock too, except
>
> Btw, avoid has an 'i' in it... :-)

Another reason to update the changelog ;)


Andrew, please find the updated changelog for proc-make-task_sig-lockless.patch
If this is not convenient, please ignore or tell me what is the "right" way
to fix the changelog when the patch is already in -mm.

------------------------------------------------------------------------------
Now that task->signal can't go away and collect_sigign_sigcatch() is
rcu-safe, task_sig() doesn't need ->siglock.

Remove lock_task_sighand() and unnecessary sigemptyset's, move
collect_sigign_sigcatch() under rcu_read_lock().

Of course, this means we read pending/blocked/etc nonatomically and we
can report this info in some intermediate state. Say, a signal can be
reported as both pending and ignored, or we can report ->sigpending != 0
while pending/shpending are empty, etc. Hopefully this is OK for proc,
we never promised this info should be atomic.

Probably we can change do_task_stat() to avoid ->siglock too, except we
can't get tty_nr lockless.

Also, remove the "is this correct?" comment.  I think it is safe to
dereference __task_cred(p)->user under rcu lock.  In any case, ->siglock
can't help to protect cred->user.

