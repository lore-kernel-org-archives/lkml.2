Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab2ACU1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:27:54 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:40247 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2ACU1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:27:52 -0500
Date: Tue, 3 Jan 2012 12:27:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: Re: INFO: task rcuc/0:7 blocked for more than 120 seconds.
Message-ID: <20120103202716.GA8384@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1324901803.31721.4.camel@lappy>
 <20111226163148.GC2435@linux.vnet.ibm.com>
 <1324977203.28904.1.camel@lappy>
 <20111228042959.GA2477@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228042959.GA2477@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12010320-6148-0000-0000-000002602EA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 08:29:59PM -0800, Paul E. McKenney wrote:
> On Tue, Dec 27, 2011 at 11:13:23AM +0200, Sasha Levin wrote:
> > On Mon, 2011-12-26 at 08:31 -0800, Paul E. McKenney wrote:
> > > Except that when I try looking for task_notify_func() in current mainline,
> > > I get nothing.
> > > 
> > > Where is task_notify_func() coming from? 
> > 
> > I was testing linux-next, it actually comes from the android tree:
> > drivers/staging/android/lowmemorykiller.c
> 
> That does sound familiar...  I wonder if the stuff in staging is current
> Android or historical stuff.

And memory did serve for once.  ;-)

Current Android has the following for task_notify_func():

static int
task_notify_func(struct notifier_block *self, unsigned long val, void *data)
{
	struct task_struct *task = data;

	if (task == lowmem_deathpending)
		lowmem_deathpending = NULL;

	return NOTIFY_OK;
}

This is from https://android.googlesource.com/kernel/common.git.

Commit 5545554aac04918ece318270d63cbfcb015577a9 fixed this problem.
The commit is shown below, FYI.

Greg, would it be possible to pull in the current Android code?  There
have been a few fixes.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

commit 5545554aac04918ece318270d63cbfcb015577a9
Author: Rabin Vincent <rabin.vincent@stericsson.com>
Date:   Thu Sep 9 10:48:21 2010 +0530

    lowmemorykiller: don't unregister notifier from atomic context
    
    The lowmemorykiller registers an atomic notifier for notfication of when
    the task is freed.  From this atomic notifier callback, it removes the
    atomic notifier via task_free_unregister().  This is incorrect because
    atomic_notifier_chain_unregister() calls syncronize_rcu(), which can
    sleep, which shouldn't be done from an atomic notifier.
    
    Fix this by registering the notifier during init, and only unregister it
    if the lowmemorykiller is unloaded.
    
    Change-Id: I1577b04e617bc2b2e39dcb490fcfc9ce660eb7ec
    Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
    Signed-off-by: Christian Bejram <christian.bejram@stericsson.com>

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 8b67ac0..efbe556 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -71,10 +71,10 @@ static int
 task_notify_func(struct notifier_block *self, unsigned long val, void *data)
 {
 	struct task_struct *task = data;
-	if (task == lowmem_deathpending) {
+
+	if (task == lowmem_deathpending)
 		lowmem_deathpending = NULL;
-		task_free_unregister(&task_nb);
-	}
+
 	return NOTIFY_OK;
 }
 
@@ -168,7 +168,6 @@ static int lowmem_shrink(struct shrinker *s, int nr_to_scan, gfp_t gfp_mask)
 			     selected->pid, selected->comm,
 			     selected_oom_adj, selected_tasksize);
 		lowmem_deathpending = selected;
-		task_free_register(&task_nb);
 		force_sig(SIGKILL, selected);
 		rem -= selected_tasksize;
 	}
@@ -185,6 +184,7 @@ static struct shrinker lowmem_shrinker = {
 
 static int __init lowmem_init(void)
 {
+	task_free_register(&task_nb);
 	register_shrinker(&lowmem_shrinker);
 	return 0;
 }
@@ -192,6 +192,7 @@ static int __init lowmem_init(void)
 static void __exit lowmem_exit(void)
 {
 	unregister_shrinker(&lowmem_shrinker);
+	task_free_unregister(&task_nb);
 }
 
 module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);

