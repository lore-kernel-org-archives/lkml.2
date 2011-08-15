Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab1HOAL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 20:11:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1HOAL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 20:11:56 -0400
Date: Mon, 15 Aug 2011 10:11:44 +1000
From: NeilBrown <neilb@suse.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Menage <menage@google.com>, Ben Blum <bblum@andrew.cmu.edu>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Possible race between cgroup_attach_proc and de_thread, and
 questionable code in de_thread.
Message-ID: <20110815101144.39812e9f@notabene.brown>
In-Reply-To: <20110814174000.GA2381@redhat.com>
References: <20110727171101.5e32d8eb@notabene.brown>
	<20110814174000.GA2381@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Aug 2011 19:40:00 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> Sorry for delay, just noticed this thread...
> 
> On 07/27, NeilBrown wrote:
> >
> >  The race as I understand it is with this code:
> >
> >
> > 		list_replace_rcu(&leader->tasks, &tsk->tasks);
> > 		list_replace_init(&leader->sibling, &tsk->sibling);
> >
> > 		tsk->group_leader = tsk;
> > 		leader->group_leader = tsk;
> >
> >
> >  which seems to be called with only tasklist_lock held, which doesn't seem to
> >  be held in the cgroup code.
> >
> >  If the "thread_group_leader(leader)" call in cgroup_attach_proc() runs before
> >  this chunk is run with the same value for 'leader', but the
> >  while_each_thread is run after, then the while_read_thread() might loop
> >  forever.  rcu_read_lock doesn't prevent this from happening.
> 
> Yes. This was already discussed. See http://marc.info/?t=127688987300002
> 
> Damn. I forgot about this completely.
> 
> >  The code in de_thread() is actually questionable by itself.
> >  "list_replace_rcu" cannot really be used on the head of a list - it is only
> >  meant to be used on a member of a list.
> >  To move a list from one head to another you should be using
> >  list_splice_init_rcu().
> 
> Hmm... can't understand this part.
> 
> And just in case... list_replace_rcu() looks fine afaics. The real problem
> is release_task(old_leader) which does list_del_rcu(old_leader->thread_group),
> this is what breaks while_each_thread().
> 
> >  The ->tasks list doesn't seem to have a clearly distinguished 'head'
> 
> Exactly. This is the problem.
> 
> But: you seem to confused ->tasks and ->thread_group ;)
> 

That last point is certainly correct.  I caught myself confusing the two
several time and wouldn't be at all surprised if I did it without catching
myself.

de_thread can change the group_leader of a thread_group, and release_task can
remove a non-leader while leaving the rest of the thread_group intact.  So
any while_each_thread() loop needs some extra care to ensure that it doesn't
loop infinitely, because the "head" that it is looking for might not be there
any more.
Maybe there are other rules that ensure this can never happen, but they sure
aren't obvious to me (i.e. if you know them - please tell ;-)

NeilBrown
