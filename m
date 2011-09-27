Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab1I0HDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 03:03:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab1I0HDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 03:03:31 -0400
Date: Tue, 27 Sep 2011 09:03:26 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] lguest: move process freezing before pending signals check
Message-ID: <20110927070326.GA24377@tiehlicka.suse.cz>
References: <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com>
 <20110826070946.GA7280@tiehlicka.suse.cz>
 <20110826085610.GA9083@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108260218050.14732@chino.kir.corp.google.com>
 <20110826095356.GB9083@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108261110020.13943@chino.kir.corp.google.com>
 <20110926082837.GC10156@tiehlicka.suse.cz>
 <87sjnjk36l.fsf@rustcorp.com.au>
 <20110926110559.GH10156@tiehlicka.suse.cz>
 <87k48uk9o3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k48uk9o3.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-09-11 11:51:00, Rusty Russell wrote:
> On Mon, 26 Sep 2011 13:05:59 +0200, Michal Hocko <mhocko@suse.cz> wrote:
> > On Mon 26-09-11 19:58:50, Rusty Russell wrote:
> > > On Mon, 26 Sep 2011 10:28:37 +0200, Michal Hocko <mhocko@suse.cz> wrote:
> > > > On Fri 26-08-11 11:13:40, David Rientjes wrote:
> > > > > I'd love to be able to do a thaw on a PF_FROZEN task in the oom killer 
> > > > > followed by a SIGKILL if that task is selected for oom kill without an 
> > > > > heuristic change.  Not sure if that's possible, so we'll wait for Rafael 
> > > > > to chime in.
> > > > 
> > > > We have discussed that with Rafael and it should be safe to do that. See
> > > > the patch bellow.
> > > > The only place I am not entirely sure about is run_guest
> > > > (drivers/lguest/core.c). It seems that the code is able to cope with
> > > > signals but it also calls lguest_arch_run_guest after try_to_freeze.
> > > 
> > > Yes; if you want to kill things in the refrigerator(), then will a
> > > 
> > > 		if (cpu->lg->dead || task_is_dead(current))
> > >                         break;
> > > 
> > > Work?  
> > 
> > The task is not dead yet. We should rather check for pending signals.
> > Can we just move try_to_freeze up before the pending signals check?
> 
> Yep, that works.
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks.
The full patch bellow:
---
>From c8b4f49ad85948b7362c50964d6c09f0e35a6537 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 27 Sep 2011 08:56:03 +0200
Subject: [PATCH] lguest: move process freezing before pending signals check

run_guest tries to freeze the current process after it has handled
pending interrupts and before it calls lguest_arch_run_guest.
This doesn't work nicely if the task has been killed while being frozen
and when we want to handle that signal as soon as possible.
Let's move try_to_freeze before we check for pending signal so that we
can get out of the loop as soon as possible.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/core.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index 2535933..e7dda91 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -232,6 +232,13 @@ int run_guest(struct lg_cpu *cpu, unsigned long __user *user)
 			}
 		}
 
+		/*
+		 * All long-lived kernel loops need to check with this horrible
+		 * thing called the freezer.  If the Host is trying to suspend,
+		 * it stops us.
+		 */
+		try_to_freeze();
+
 		/* Check for signals */
 		if (signal_pending(current))
 			return -ERESTARTSYS;
@@ -246,13 +253,6 @@ int run_guest(struct lg_cpu *cpu, unsigned long __user *user)
 			try_deliver_interrupt(cpu, irq, more);
 
 		/*
-		 * All long-lived kernel loops need to check with this horrible
-		 * thing called the freezer.  If the Host is trying to suspend,
-		 * it stops us.
-		 */
-		try_to_freeze();
-
-		/*
 		 * Just make absolutely sure the Guest is still alive.  One of
 		 * those hypercalls could have been fatal, for example.
 		 */
-- 
1.7.5.4

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
