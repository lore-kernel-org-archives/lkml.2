Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1I0GET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:04:19 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47385 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab1I0GEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:04:15 -0400
Date: Tue, 27 Sep 2011 16:04:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: manual merge of the rcu tree with Linus' tree
Message-Id: <20110927160411.7bcec0906847959fb6e88a81@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the rcu tree got a conflict in
arch/x86/kernel/process_64.c between commit a0bfa1373859 ("cpuidle: stop
depending on pm_idle") from Linus' tree and commit 18349ca4b42e ("x86:
Enter rcu extended qs after idle notifier call") from the rcu tree.

I fixed it up (see below) and can carry the fix as necessary.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/process_64.c
index f693e44,dee2e6c..0000000
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@@ -137,8 -136,12 +137,14 @@@ void cpu_idle(void
  			enter_idle();
  			/* Don't trace irqs off for idle */
  			stop_critical_timings();
- 			if (cpuidle_idle_call())
+ 
 -			/* enter_idle() needs rcu for notifiers */
 -			rcu_enter_nohz();
 -			pm_idle();
 -			rcu_exit_nohz();
++			if (cpuidle_idle_call()) {
++				/* enter_idle() needs rcu for notifiers */
++				rcu_enter_nohz();
 +				pm_idle();
++				rcu_exit_nohz();
++			}
+ 
  			start_critical_timings();
  
  			/* In many cases the interrupt that ended idle
