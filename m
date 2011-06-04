Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab1FDNDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 09:03:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab1FDNDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 09:03:24 -0400
Subject: Re: [patch] sched, cgroups: fix MIN_SHARES on 64 bit boxen
From: Mike Galbraith <mgalbraith@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Nikhil Rao <ncrao@google.com>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1307186689.2353.4648.camel@twins>
References: <1307179796.25172.3.camel@marge.simson.net>
	 <1307186689.2353.4648.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Jun 2011 15:03:20 +0200
Message-ID: <1307192600.8618.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-06-04 at 13:24 +0200, Peter Zijlstra wrote:
> On Sat, 2011-06-04 at 11:29 +0200, Mike Galbraith wrote:
> > c8b28116 claimed to have no user-visible effect, but allows setting cpu.shares
> > to < MIN_SHARES, which the user then indeed sees.
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > ---
> >  kernel/sched.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -292,7 +292,7 @@ static DEFINE_SPINLOCK(task_group_lock);
> >   * (The default weight is 1024 - so there's no practical
> >   *  limitation from this.)
> >   */
> > -#define MIN_SHARES	2
> > +#define MIN_SHARES	(scale_load(2))
> >  #define MAX_SHARES	(1UL << (18 + SCHED_LOAD_RESOLUTION))
> >  
> >  static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
> 
> Hurm, but that destroys most of the gains from that patch, the whole
> point was being able to have finer graunlarities, but now
> calc_cfs_shares() and effective_load() are clipped the coarse
> granularity.

Oh well, drink one, spill one, give one away :)

> So maybe explicitly change the MIN_SHARES usage in
> sched_group_set_shares(). That wants to become a clamp user anyway,
> something like:
> 
> shares = clamp(shares, scale_load(MIN_SHARES), scale_load(MAX_SHARES));
> 
> That way MAX_SHARES can also loose its SCHED_LOAD_RESOLUTION factor and
> bring is back in line with MIN_SHARES.

sched, cgroups: fix sched_group_set_shares() on 64 bit boxen

c8b28116 claimed to have no user-visible effect, but allows setting cpu.shares
to < MIN_SHARES, which the user then sees.

Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 kernel/sched.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -292,8 +292,8 @@ static DEFINE_SPINLOCK(task_group_lock);
  * (The default weight is 1024 - so there's no practical
  *  limitation from this.)
  */
-#define MIN_SHARES	2
-#define MAX_SHARES	(1UL << (18 + SCHED_LOAD_RESOLUTION))
+#define MIN_SHARES	(1UL <<  1)
+#define MAX_SHARES	(1UL << 18)
 
 static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
 #endif
@@ -8439,10 +8439,7 @@ int sched_group_set_shares(struct task_g
 	if (!tg->se[0])
 		return -EINVAL;
 
-	if (shares < MIN_SHARES)
-		shares = MIN_SHARES;
-	else if (shares > MAX_SHARES)
-		shares = MAX_SHARES;
+	shares = clamp(shares, scale_load(MIN_SHARES), scale_load(MAX_SHARES));
 
 	mutex_lock(&shares_mutex);
 	if (tg->shares == shares)


