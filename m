Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab0DLSf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 14:35:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab0DLSf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 14:35:26 -0400
Date: Mon, 12 Apr 2010 20:32:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-04-05 - another RCU whinge (not network this time)
Message-ID: <20100412183251.GA13391@redhat.com>
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org> <6417.1270771048@localhost> <20100409231614.GE2421@linux.vnet.ibm.com> <10875.1270869752@localhost> <20100410051504.GA2414@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100410051504.GA2414@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Paul E. McKenney wrote:
>
> > Oleg, looks like proc-make-collect_sigign_sigcatch-rcu-safe.patch is the
> > offender here, it added the line that causes the whinge.
>
> If collect_sigign_sigcatch() is OK to call by updaters as well as
> readers, we need something like:
>
> 	struct sighand_struct *sighand;
> 	
> 	sighand = rcu_dereference_check(p->sighand,
> 					rcu_read_lock_held() ||
> 					lockdep_is_held(&???));
>
> Where the "???" is replaced with whichever of the two locks is protecting
> updates.  My guess would be the sighand lock, but I would not rely on
> my guesses in this case.  ;-)

Yes, it should be p->sighand->siglock.

Actually, I was going to change another caller, do_task_stat(), to call
collect_sigign_sigcatch() without ->siglock too, but now I am not sure
when/if this will happen.

OK, thanks, I'll send the patch to make rcu_dereference_check() happy.




While we are here... __exit_signal() does

	sighand = rcu_dereference_check(tsk->sighand,
					rcu_read_lock_held() ||
					lockdep_tasklist_lock_is_held());

What is the point? We know that the single caller must hold tasklist,
otherwise everything is broken. Perhaps it would be better to
use rcu_dereference_raw() ?

In fact, I don't really understand why __exit_signal() needs
rcu_dereference() at all.

Oleg.

