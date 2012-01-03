Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab2ACWdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:33:31 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49130 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2ACWd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:33:27 -0500
Date: Tue, 3 Jan 2012 14:33:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: INFO: task rcuc/0:7 blocked for more than 120 seconds.
Message-ID: <20120103223313.GA20137@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1324901803.31721.4.camel@lappy>
 <20111226163148.GC2435@linux.vnet.ibm.com>
 <1324977203.28904.1.camel@lappy>
 <20111228042959.GA2477@linux.vnet.ibm.com>
 <20120103202716.GA8384@linux.vnet.ibm.com>
 <20120103203717.GA6701@suse.de>
 <20120103213830.GG2376@linux.vnet.ibm.com>
 <20120103215036.GA1347@suse.de>
 <20120103222605.GH2376@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103222605.GH2376@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12010322-2398-0000-0000-00000325B712
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 02:26:05PM -0800, Paul E. McKenney wrote:
> On Tue, Jan 03, 2012 at 01:50:36PM -0800, Greg KH wrote:
> > On Tue, Jan 03, 2012 at 01:38:30PM -0800, Paul E. McKenney wrote:
> 
> [ . . . ]
> 
> > > > > Greg, would it be possible to pull in the current Android code?  There
> > > > > have been a few fixes.  ;-)
> > > > 
> > > > I did base the stuff in staging on the common.git tree, but for some
> > > > reason this patch wasn't applied, odd, I'll go apply it now...
> > > > 
> > > > Ah, I see, it didn't apply for various reasons:
> > > > 
> > > > patching file drivers/staging/android/lowmemorykiller.c
> > > > Hunk #1 FAILED at 71.
> > > > Hunk #2 FAILED at 168.
> > > > Hunk #3 succeeded at 196 (offset 11 lines).
> > > > Hunk #4 succeeded at 204 (offset 11 lines).
> > > > 
> > > > Care to rebase this patch and send it to me so that I can apply it?  I
> > > > don't have the time to do it myself at the moment, sorry, lots of higher
> > > > priority items to get done this week, sorry.
> > > 
> > > I will give it a shot.  Working with linux-next -- if some other tree
> > > would be better for you, please let me know.
> > 
> > linux-next is great, thanks.
> 
> Sasha, does the following patch against -next fix this problem for you?

Sigh!  This time with the full patch...  :-/

							Thanx, Paul

------------------------------------------------------------------------

lowmemorykiller: don't unregister notifier from atomic context

The lowmemorykiller registers an atomic notifier for notfication of when
the task is freed.  From this atomic notifier callback, it removes the
atomic notifier via task_free_unregister().  This is incorrect because
atomic_notifier_chain_unregister() calls syncronize_rcu(), which can
sleep, which shouldn't be done from an atomic notifier.

Fix this by registering the notifier during init, and only unregister it
if the lowmemorykiller is unloaded.

Rebased to -next by Paul E. McKenney.

Change-Id: I1577b04e617bc2b2e39dcb490fcfc9ce660eb7ec
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Christian Bejram <christian.bejram@stericsson.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 2d8d2b7..edb2d09 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -72,10 +72,9 @@ static int
 task_notify_func(struct notifier_block *self, unsigned long val, void *data)
 {
 	struct task_struct *task = data;
-	if (task == lowmem_deathpending) {
+	if (task == lowmem_deathpending)
 		lowmem_deathpending = NULL;
-		task_handoff_unregister(&task_nb);
-	}
+
 	return NOTIFY_OK;
 }
 
@@ -172,13 +171,11 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 			     selected->pid, selected->comm,
 			     selected_oom_adj, selected_tasksize);
 		/*
-		 * If CONFIG_PROFILING is off, then task_handoff_register()
-		 * is a nop. In that case we don't want to stall the killer
-		 * by setting lowmem_deathpending.
+		 * If CONFIG_PROFILING is off, then we don't want to stall
+		 * the killer by setting lowmem_deathpending.
 		 */
 #ifdef CONFIG_PROFILING
 		lowmem_deathpending = selected;
-		task_handoff_register(&task_nb);
 #endif
 		force_sig(SIGKILL, selected);
 		rem -= selected_tasksize;
@@ -196,6 +193,7 @@ static struct shrinker lowmem_shrinker = {
 
 static int __init lowmem_init(void)
 {
+	task_handoff_register(&task_nb);
 	register_shrinker(&lowmem_shrinker);
 	return 0;
 }
@@ -203,6 +201,7 @@ static int __init lowmem_init(void)
 static void __exit lowmem_exit(void)
 {
 	unregister_shrinker(&lowmem_shrinker);
+	task_handoff_unregister(&task_nb);
 }
 
 module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);

