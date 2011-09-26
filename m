Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab1IZLGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:06:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab1IZLGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:06:02 -0400
Date: Mon, 26 Sep 2011 13:05:59 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] oom: do not live lock on frozen tasks
Message-ID: <20110926110559.GH10156@tiehlicka.suse.cz>
References: <20110825151818.GA4003@redhat.com>
 <20110825164758.GB22564@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com>
 <20110826070946.GA7280@tiehlicka.suse.cz>
 <20110826085610.GA9083@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108260218050.14732@chino.kir.corp.google.com>
 <20110826095356.GB9083@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108261110020.13943@chino.kir.corp.google.com>
 <20110926082837.GC10156@tiehlicka.suse.cz>
 <87sjnjk36l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjnjk36l.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 26-09-11 19:58:50, Rusty Russell wrote:
> On Mon, 26 Sep 2011 10:28:37 +0200, Michal Hocko <mhocko@suse.cz> wrote:
> > On Fri 26-08-11 11:13:40, David Rientjes wrote:
> > > I'd love to be able to do a thaw on a PF_FROZEN task in the oom killer 
> > > followed by a SIGKILL if that task is selected for oom kill without an 
> > > heuristic change.  Not sure if that's possible, so we'll wait for Rafael 
> > > to chime in.
> > 
> > We have discussed that with Rafael and it should be safe to do that. See
> > the patch bellow.
> > The only place I am not entirely sure about is run_guest
> > (drivers/lguest/core.c). It seems that the code is able to cope with
> > signals but it also calls lguest_arch_run_guest after try_to_freeze.
> 
> Yes; if you want to kill things in the refrigerator(), then will a
> 
> 		if (cpu->lg->dead || task_is_dead(current))
>                         break;
> 
> Work?  

The task is not dead yet. We should rather check for pending signals.
Can we just move try_to_freeze up before the pending signals check?

diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index 2535933..a513509 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -232,6 +232,12 @@ int run_guest(struct lg_cpu *cpu, unsigned long __user *user)
 			}
 		}
 
+		/*
+		 * All long-lived kernel loops need to check with this horrible
+		 * thing called the freezer.  If the Host is trying to suspend,
+		 * it stops us.
+		 */
+		try_to_freeze();
 		/* Check for signals */
 		if (signal_pending(current))
 			return -ERESTARTSYS;
@@ -246,13 +252,6 @@ int run_guest(struct lg_cpu *cpu, unsigned long __user *user)
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

> That break means we return to the read() syscall pretty much
> immediately.
> 
> Thanks for the CC,
> Rusty.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
