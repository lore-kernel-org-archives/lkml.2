Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0C2POQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:14:16 -0400
Received: from mail.openrapids.net ([64.15.138.104]:36060 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752987Ab0C2POP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:14:15 -0400
Date: Mon, 29 Mar 2010 11:14:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] rcu head debug consider on stack fixup
Message-ID: <20100329151413.GA26979@Krystal>
References: <20100329143405.252313609@efficios.com> <20100329143702.845838001@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329143702.845838001@efficios.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:09:55 up 65 days, 17:47,  8 users,  load average: 0.07, 0.07,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complain if activation receives a non-initialized object on the stack.

[This patch applies after "tree/tiny rcu: Add debug RCU head objects (v5)"]

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: David S. Miller <davem@davemloft.net>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org
CC: mingo@elte.hu
CC: laijs@cn.fujitsu.com
CC: dipankar@in.ibm.com
CC: josh@joshtriplett.org
CC: dvhltc@us.ibm.com
CC: niv@us.ibm.com
CC: tglx@linutronix.de
CC: peterz@infradead.org
CC: rostedt@goodmis.org
CC: Valdis.Kletnieks@vt.edu
CC: dhowells@redhat.com
CC: eric.dumazet@gmail.com
CC: Alexey Dobriyan <adobriyan@gmail.com>
---
 kernel/rcupdate.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux.trees.git/kernel/rcupdate.c
===================================================================
--- linux.trees.git.orig/kernel/rcupdate.c	2010-03-29 11:05:35.000000000 -0400
+++ linux.trees.git/kernel/rcupdate.c	2010-03-29 11:06:23.000000000 -0400
@@ -179,8 +179,12 @@ static int rcuhead_fixup_activate(void *
 		 * This is not really a fixup. We just make sure that it is
 		 * tracked in the object tracker.
 		 */
-		debug_object_init(head, &rcuhead_debug_descr);
-		debug_object_activate(head, &rcuhead_debug_descr);
+		if (!object_is_on_stack(head)) {
+			debug_object_init(head, &rcuhead_debug_descr);
+			debug_object_activate(head, &rcuhead_debug_descr);
+			return 0;
+		}
+		WARN_ON_ONCE(1);
 		return 0;
 
 	case ODEBUG_STATE_ACTIVE:
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
