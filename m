Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab0DTHZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 03:25:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:49900 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab0DTHZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 03:25:32 -0400
Subject: Re: INFO: suspicious rcu_dereference_check() usage -
 include/linux/cgroup.h:492 invoked rcu_dereference_check() without
 protection!
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Eric Paris <eparis@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100420030452.GB2905@linux.vnet.ibm.com>
References: <a44ae5cd1003071726u1f94336h7ab6c7b80d16723b@mail.gmail.com>
	 <20100311032843.GE6767@linux.vnet.ibm.com>
	 <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com>
	 <1271098032.4807.137.camel@twins> <1271242058.32749.19.camel@laptop>
	 <1271701612.2972.5.camel@dhcp231-113.rdu.redhat.com>
	 <20100419230136.GA16856@linux.vnet.ibm.com>
	 <1271726729.2972.13.camel@dhcp231-113.rdu.redhat.com>
	 <20100420030452.GB2905@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 09:21:47 +0200
Message-ID: <1271748107.1676.392.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 20:04 -0700, Paul E. McKenney wrote:
> On Mon, Apr 19, 2010 at 09:25:29PM -0400, Eric Paris wrote:

> > That one is also fixed so feel free to add a tested or something from
> > me.  But we've got another, weeeee!  If there some way I could get all
> > of these at once?
> 
> Sure!  I -think- that if you remove the first "if" statement in
> lockdep_rcu_dereference() in kernel/lockdep.c, you will get lots of them
> all at once.  Maybe more than your console log is able to hold...
> 
> So another approach would be to print only the first 100 or some such.
> 
> It -looks- to me that you could make __debug_locks_off() atomically
> decrement a counter rather than just setting it to zero, see
> include/linux/debug_locks.h.  I suspect that atomic_dec_not_zero()
> would work very well for you here.
> 
> Peter probably knows a better approach, but those would work.

Right, so because the RCU checking stuff doesn't poke at the lockdep
class chains, but simply validates the current task state we can delay
or altogether not disable lockdep.

So something like the below, or simply remove that debug_locks_off()
thing alltogether.

---
 kernel/lockdep.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 78325f8..31c8738 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3784,12 +3784,16 @@ void lockdep_sys_exit(void)
 	}
 }
 
+static atomic_t rcu_warns = ATOMIC_INIT(100);
+
 void lockdep_rcu_dereference(const char *file, const int line)
 {
 	struct task_struct *curr = current;
 
-	if (!debug_locks_off())
-		return;
+	if (!debug_locks || atomic_dec_and_test(&rcu_warns)) {
+		if (!debug_locks_off())
+			return;
+	}
 	printk("\n===================================================\n");
 	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
 	printk(  "---------------------------------------------------\n");


