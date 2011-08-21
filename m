Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab1HUSBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 14:01:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55576 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab1HUSB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 14:01:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL pm-next] freezer: fix various bugs and simplify implementation
Date: Sun, 21 Aug 2011 20:03:14 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        arnd@arndb.de, oleg@redhat.com, lizf@cn.fujitsu.com,
        paul@paulmenage.org, Matt Helsley <matthltc@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20110820094434.GA24151@htj.dyndns.org> <201108201833.39089.rjw@sisk.pl> <20110821091200.GB24151@htj.dyndns.org>
In-Reply-To: <20110821091200.GB24151@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108212003.14722.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 21, 2011, Tejun Heo wrote:
> Hello, Rafafel.
> 
> On Sat, Aug 20, 2011 at 06:33:38PM +0200, Rafael J. Wysocki wrote:
> > >   ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git freezer
> > 
> > Pulled and stored in the pm-freezer branch in my tree, and merged into
> > the linux-next branch.
> 
> Cool.
> 
> > > FYI, this patchset will cause a conflict with s390 TIF flag fix patch.
> > > The conflict is trivial and Stephen should be able to handle it
> > > without any problem.  Also, I'm planning on doing some further work on
> > > cgroup freezer and then will try to bridge it with job control.  If
> > > that plan fans out, I might ask Oleg to pull from the pm tree.
> > 
> > I'm not sure if Linus likes it.  He generally doesn't want the trees
> > that he pulls from to be entangled this way.
> 
> The job control portion has to go through Linus anyway, so let's see
> how that flies.
> 
> > > This shouldn't matter too much either way but it *might* be a good idea to
> > > keep this line of patches in a separate branch.
> > 
> > I'm going to keep it in the pm-freezer branch anyway (there may be patches
> > on top of it, though)
> 
> Yeah, I'm pretty sure it will need some fix too.

Speaking of which, the addition of might_sleep() to try_to_freeze()
causes a badly looking backtrace to appear during reboot on ARM,
so I'd prefer it to go into __refrigerator().

Please tell me what you think of the patch below.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Freezer: Move might_sleep() from try_to_freeze()

There are some code paths that call try_to_freeze() from interrupt
context, but doing so they know that the current process cannot
possible be freezing (e.g. during reboot on ARM).  However, the
recently added might_sleep() annotation in try_to_freeze()
triggers in those cases, making it look like there were bugs in
those places, which really isn't the case.

Therefore move might_sleep() from try_to_freeze() to
__refrigerator() so that it doesn't produce false positives.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |    1 -
 kernel/freezer.c        |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux/include/linux/freezer.h
===================================================================
--- linux.orig/include/linux/freezer.h
+++ linux/include/linux/freezer.h
@@ -41,7 +41,6 @@ extern void thaw_processes(void);
 
 static inline bool try_to_freeze(void)
 {
-	might_sleep();
 	if (likely(!freezing(current)))
 		return false;
 	return __refrigerator(false);
Index: linux/kernel/freezer.c
===================================================================
--- linux.orig/kernel/freezer.c
+++ linux/kernel/freezer.c
@@ -54,6 +54,8 @@ bool __refrigerator(bool check_kthr_stop
 	bool was_frozen = false;
 	long save;
 
+	might_sleep();
+
 	/*
 	 * No point in checking freezing() again - the caller already did.
 	 * Proceed to enter FROZEN.
