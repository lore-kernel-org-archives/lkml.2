Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab1I2NCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:02:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab1I2NCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:02:07 -0400
Date: Thu, 29 Sep 2011 15:02:04 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] oom: thaw threads if oom killed thread is frozen before
 deferring
Message-ID: <20110929130204.GG21113@tiehlicka.suse.cz>
References: <cover.1317110948.git.mhocko@suse.cz>
 <65d9dff7ff78fad1f146e71d32f9f92741281b46.1317110948.git.mhocko@suse.cz>
 <alpine.DEB.2.00.1109271133590.17876@chino.kir.corp.google.com>
 <20110928104445.GB15062@tiehlicka.suse.cz>
 <20110929115105.GE21113@tiehlicka.suse.cz>
 <20110929120517.GA10587@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929120517.GA10587@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 29-09-11 14:05:17, Oleg Nesterov wrote:
> On 09/29, Michal Hocko wrote:
> >
> > --- a/kernel/freezer.c
> > +++ b/kernel/freezer.c
> > @@ -48,6 +48,10 @@ void refrigerator(void)
> >  	current->flags |= PF_FREEZING;
> >  
> >  	for (;;) {
> > +		if (fatal_signal_pending(current)) {
> > +			current->flags &= ~PF_FROZEN;
> 
> We can't do this.
> 
> If PF_FROZEN was set, we must not modify current->flags, this can
> race with, say, thaw_process().

OK, I see.

> 
> OK, we can take task_lock(), but this doesn't close other races.
> Say, a SIGKILL'ed task can do try_to_freeze(). Perhaps we should
> simply call thaw_process() unconditionally, this also clears
> TIF_FREEZE. 
> Or check freezing() || frozen(). Afacis this solves
> the race you described.

Sounds reasonable.

> 
> But of course this can't help if freeze_task() is called later.
> May be freezable() should check TIF_MEMDIE...

Wouldn't it be easier to ignore try_to_freeze when fatal signals are
pending in get_signal_to_deliver? This would mean that we wouldn't get
back to refrigerator just to get out of it.
What about the patch bellow?

> 
> Oleg.

Thanks!

---
>From 3c6c4b4f1a21c34ea1db76b765ce671ca97d9c3e Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 29 Sep 2011 13:45:22 +0200
Subject: [PATCH] freezer: Get out of refrigerator if fatal signals are
 pending

We should make sure that the current task doesn't enter refrigerator if
it has fatal signals pending because it should get to the signals
processing as soon as possible. Thaw the process if it is either
freezing or still frozen to prevent from races with thaw_process.

This closes a possible race when OOM killer selects a task which is
about to enter the fridge but it is not set as frozen yet. This will
lead to a livelock because select_bad_process would skip that task due
to TIF_MEMDIE set for the process but there is no chance for further
process.
oom_kill_task                           refrigerator
  set_tsk_thread_flag(p, TIF_MEMDIE);
  force_sig(SIGKILL, p);
  if (frozen(p))
        thaw_process(p)
                                          frozen_process();
                                          [...]
                                          if (!frozen(current))
                                                break;
                                          schedule();

select_bad_process
  [...]
  if (test_tsk_thread_flag(p, TIF_MEMDIE))
          return ERR_PTR(-1UL);

Let's skip try_to_freeze in get_signal_to_deliver if fatal signals are
pending to make sure that we will not somebody will keep us looping
between refrigerator and get_signal_to_deliver for ever.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/freezer.c |    5 +++++
 kernel/signal.c  |    4 +++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index 7b01de9..0531661 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -48,6 +48,11 @@ void refrigerator(void)
 	current->flags |= PF_FREEZING;
 
 	for (;;) {
+		if (fatal_signal_pending(current)) {
+			if (freezing(current) || frozen(current))
+				thaw_process(current);
+			break;
+		}
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!frozen(current))
 			break;
diff --git a/kernel/signal.c b/kernel/signal.c
index 291c970..bc97a6a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2147,8 +2147,10 @@ relock:
 	 * While in TASK_STOPPED, we were considered "frozen enough".
 	 * Now that we woke up, it's crucial if we're supposed to be
 	 * frozen that we freeze now before running anything substantial.
+	 * Let's ignore the freezing request if we are about to die anyway.
 	 */
-	try_to_freeze();
+	if (!fatal_signal_pending(curret))
+		try_to_freeze();
 
 	spin_lock_irq(&sighand->siglock);
 	/*
-- 
1.7.6.3

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
