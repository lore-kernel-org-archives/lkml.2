Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1EEPuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:50:09 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:45221 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362Ab1EEPuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:50:07 -0400
Subject: [PATCH] RCU: remove alignment padding from rcu_data on 64 bit
 builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Dipankar Sarma <dipankar@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 16:50:04 +0100
Message-ID: <1304610604.1984.6.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder rcu_data to remove 8 bytes of alignment padding on 64 bit builds
so saving a total of 16 bytes per cpu, (rcu_sched_data & rcu_bh_data).
    
When CONFIG_NO_HZ is set, it shrinks the size of this structure from 264
to 256 bytes allowing it to fit into one fewer cache lines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---

patch against v2.6.39-rc6
compiled & tested on x86_64

I've been running with this patch for some weeks and have not seen any
issues.

regards
Richard



diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index e8f057e..fcced0f 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -176,6 +176,9 @@ struct rcu_data {
 	bool		qs_pending;	/* Core waits for quiesc state. */
 	bool		beenonline;	/* CPU online at least once. */
 	bool		preemptable;	/* Preemptable RCU? */
+
+	int cpu;
+
 	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
 	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
 
@@ -238,8 +241,6 @@ struct rcu_data {
 	unsigned long n_rp_gp_started;
 	unsigned long n_rp_need_fqs;
 	unsigned long n_rp_need_nothing;
-
-	int cpu;
 };
 
 /* Values for signaled field in struct rcu_state. */


