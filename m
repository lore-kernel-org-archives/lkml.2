Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390Ab2JKAZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:25:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60498 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933337Ab2JKAY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:24:56 -0400
X-Sasl-enc: KJE5C5BmXhvtIguJw6EefXL5u/a4JBscmxKmzbrYJ9eK 1349915094
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Cree <mcree@orcon.net.nz>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [ 094/122] alpha: Add missing RCU idle APIs on idle loop
Date: Thu, 11 Oct 2012 07:54:20 +0900
Message-Id: <20121010225354.969129613@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 4c94cada48f7c660eca582be6032427a5e367117 upstream.

In the old times, the whole idle task was considered
as an RCU quiescent state. But as RCU became more and
more successful overtime, some RCU read side critical
section have been added even in the code of some
architectures idle tasks, for tracing for example.

So nowadays, rcu_idle_enter() and rcu_idle_exit() must
be called by the architecture to tell RCU about the part
in the idle loop that doesn't make use of rcu read side
critical sections, typically the part that puts the CPU
in low power mode.

This is necessary for RCU to find the quiescent states in
idle in order to complete grace periods.

Add this missing pair of calls in the Alpha's idle loop.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Michael Cree <mcree@orcon.net.nz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: alpha <linux-alpha@vger.kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/alpha/kernel/process.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -28,6 +28,7 @@
 #include <linux/tty.h>
 #include <linux/console.h>
 #include <linux/slab.h>
+#include <linux/rcupdate.h>
 
 #include <asm/reg.h>
 #include <asm/uaccess.h>
@@ -54,8 +55,10 @@ cpu_idle(void)
 		/* FIXME -- EV6 and LCA45 know how to power down
 		   the CPU.  */
 
+		rcu_idle_enter();
 		while (!need_resched())
 			cpu_relax();
+		rcu_idle_exit();
 		schedule();
 	}
 }


