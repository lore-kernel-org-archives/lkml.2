Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1HNRnI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 13:43:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab1HNRnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 13:43:05 -0400
Date: Sun, 14 Aug 2011 19:40:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Paul Menage <menage@google.com>, Ben Blum <bblum@andrew.cmu.edu>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Possible race between cgroup_attach_proc and de_thread, and
	questionable code in de_thread.
Message-ID: <20110814174000.GA2381@redhat.com>
References: <20110727171101.5e32d8eb@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727171101.5e32d8eb@notabene.brown>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay, just noticed this thread...

On 07/27, NeilBrown wrote:
>
>  The race as I understand it is with this code:
>
>
> 		list_replace_rcu(&leader->tasks, &tsk->tasks);
> 		list_replace_init(&leader->sibling, &tsk->sibling);
>
> 		tsk->group_leader = tsk;
> 		leader->group_leader = tsk;
>
>
>  which seems to be called with only tasklist_lock held, which doesn't seem to
>  be held in the cgroup code.
>
>  If the "thread_group_leader(leader)" call in cgroup_attach_proc() runs before
>  this chunk is run with the same value for 'leader', but the
>  while_each_thread is run after, then the while_read_thread() might loop
>  forever.  rcu_read_lock doesn't prevent this from happening.

Yes. This was already discussed. See http://marc.info/?t=127688987300002

Damn. I forgot about this completely.

>  The code in de_thread() is actually questionable by itself.
>  "list_replace_rcu" cannot really be used on the head of a list - it is only
>  meant to be used on a member of a list.
>  To move a list from one head to another you should be using
>  list_splice_init_rcu().

Hmm... can't understand this part.

And just in case... list_replace_rcu() looks fine afaics. The real problem
is release_task(old_leader) which does list_del_rcu(old_leader->thread_group),
this is what breaks while_each_thread().

>  The ->tasks list doesn't seem to have a clearly distinguished 'head'

Exactly. This is the problem.

But: you seem to confused ->tasks and ->thread_group ;)

Oleg.

