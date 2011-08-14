Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab1HNX6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 19:58:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab1HNX6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 19:58:36 -0400
Date: Mon, 15 Aug 2011 09:58:20 +1000
From: NeilBrown <neilb@suse.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ben Blum <bblum@andrew.cmu.edu>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Possible race between cgroup_attach_proc and de_thread, and
 questionable code in de_thread.
Message-ID: <20110815095820.33607862@notabene.brown>
In-Reply-To: <20110814175119.GC2381@redhat.com>
References: <20110727171101.5e32d8eb@notabene.brown>
	<20110727150710.GB5242@unix33.andrew.cmu.edu>
	<20110727234235.GA2318@linux.vnet.ibm.com>
	<20110728110813.7ff84b13@notabene.brown>
	<20110728121741.GB2427@linux.vnet.ibm.com>
	<20110814175119.GC2381@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Aug 2011 19:51:19 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> On 07/28, Paul E. McKenney wrote:
> >
> > On Thu, Jul 28, 2011 at 11:08:13AM +1000, NeilBrown wrote:
> > >
> > > I disagree.  It also requires - by virtue of the use of while_each_thread() -
> > > that 'g' remains on the list that 't' is walking along.
> >
> > Doesn't the following code in the loop body deal with this possibilty?
> >
> > 	/* Exit if t or g was unhashed during refresh. */
> > 	if (t->state == TASK_DEAD || g->state == TASK_DEAD)
> > 		goto unlock;
> 
> This code is completely wrong even if while_each_thread() was fine.
> 
> I sent the patch but it was ignored.
> 
> 	[PATCH] fix the racy check_hung_uninterruptible_tasks()->rcu_lock_break()
> 	http://marc.info/?l=linux-kernel&m=127688790019041
> 
> Oleg.


I agree with that patch.
RCU only protects a task_struct until release_task() is called (which
removes it from the task list).

So holding rcu_lock doesn't stop put_task_struct from freeing the memory
unless we *know* that release_task hasn't been called.  This is exactly that
pid_alive() tests.


I must say that handling of task_struct seems to violate the law of least
surprise a little to often for my taste.  Maybe it is just a difficult
problem and it needs a complex solution - but it would be really nice if it
were a bit simpler :-(

NeilBrown
