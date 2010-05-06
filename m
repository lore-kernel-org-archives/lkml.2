Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0EFSm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:42:57 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39315 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab0EFSm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:42:56 -0400
Date: Thu, 6 May 2010 11:42:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Josh Triplett <josh@freedesktop.org>, Oleg Nesterov <oleg@redhat.com>,
       Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 3/4 UPDATED] scheduler: replace migration_thread with
 cpu_stop
Message-ID: <20100506184252.GC2325@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1272980864-27235-1-git-send-email-tj@kernel.org>
 <1272980864-27235-4-git-send-email-tj@kernel.org>
 <20100505013351.GN2639@linux.vnet.ibm.com>
 <4BE11E29.6040106@kernel.org>
 <20100505174725.GA6783@linux.vnet.ibm.com>
 <4BE1B49F.2020404@kernel.org>
 <20100505203149.GA2439@linux.vnet.ibm.com>
 <4BE2EEB0.6020402@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE2EEB0.6020402@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 06:30:40PM +0200, Tejun Heo wrote:
> On 05/05/2010 10:31 PM, Paul E. McKenney wrote:
> > Almost.  With the following patch, I am good with it.
> 
> Ah, right.  What was I thinking?  I'll include your patch and push it
> to Ingo.  Thanks.

And of course, I overdid it in my patch when I removed smp_mb() from
the !SMP version of synchronize_sched_expedited().  :-/

If synchronize_sched_expedited() is ever to be invoked from within
kernel/sched.c in a UP kernel, there needs to be a "barrier()" in the
!SMP version.  So please see the following patch.

							Thanx, Paul

commit 0eab52c0eeeb8507a83bdb37cc8f690b1c4f4a2c
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Thu May 6 11:40:17 2010 -0700

    rcu: need barrier() in UP synchronize_sched_expedited()
    
    If synchronize_sched_expedited() is ever to be called from within
    kernel/sched.c in a !SMP PREEMPT kernel, the !SMP implementation needs
    a barrier().
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index 155a16d..fbaf312 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8932,6 +8932,7 @@ struct cgroup_subsys cpuacct_subsys = {
 
 void synchronize_sched_expedited(void)
 {
+	barrier();
 }
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
 
