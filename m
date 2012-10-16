Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab2JPEgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:36:11 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44651 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab2JPEgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:36:08 -0400
Date: Mon, 15 Oct 2012 21:35:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: cernekee@gmail.com, torbenh@gmx.de, torvalds@linux-foundation.org,
        tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH] Fix scheduling-while-atomic problem in
 console_cpu_notify()
Message-ID: <20121016043559.GA32179@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121016003128.GA5879@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016003128.GA5879@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101604-5518-0000-0000-000008784164
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 05:31:28PM -0700, Paul E. McKenney wrote:
> The console_cpu_notify( function runs with interrupts disabled in
> the CPU_DEAD case.  It therefore cannot block, for example, as will
> happen when it calls console_lock().  Therefore, remove the CPU_DEAD
> leg of the switch statement to avoid this problem.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>

s/CPU_DEAD/CPU_DYING/

Apparently it is a bad idea to compose and send a patch while in a
C++ standards committee meeting where people are arguing about async
futures...  Fixed patch below.

							Thanx, Paul

------------------------------------------------------------------------

printk: Fix scheduling-while-atomic problem in console_cpu_notify()

The console_cpu_notify( function runs with interrupts disabled in
the CPU_DYING case.  It therefore cannot block, for example, as will
happen when it calls console_lock().  Therefore, remove the CPU_DYING
leg of the switch statement to avoid this problem.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/printk.c b/kernel/printk.c
index 66a2ea3..2d607f4 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1890,7 +1890,6 @@ static int __cpuinit console_cpu_notify(struct notifier_block *self,
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DEAD:
-	case CPU_DYING:
 	case CPU_DOWN_FAILED:
 	case CPU_UP_CANCELED:
 		console_lock();

