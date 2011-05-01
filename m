Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151Ab1EAN1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:27:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48549 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757404Ab1EANWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>
Subject: [PATCH tip/core/rcu 76/86] scsi,rcu: convert call_rcu(fc_rport_free_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:56 -0700
Message-Id: <1304256126-26015-76-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback fc_rport_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(fc_rport_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
---
 drivers/scsi/libfc/fc_rport.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 49e1ccc..01e13a2 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -153,18 +153,6 @@ static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
 }
 
 /**
- * fc_rport_free_rcu() - Free a remote port
- * @rcu: The rcu_head structure inside the remote port
- */
-static void fc_rport_free_rcu(struct rcu_head *rcu)
-{
-	struct fc_rport_priv *rdata;
-
-	rdata = container_of(rcu, struct fc_rport_priv, rcu);
-	kfree(rdata);
-}
-
-/**
  * fc_rport_destroy() - Free a remote port after last reference is released
  * @kref: The remote port's kref
  */
@@ -173,7 +161,7 @@ static void fc_rport_destroy(struct kref *kref)
 	struct fc_rport_priv *rdata;
 
 	rdata = container_of(kref, struct fc_rport_priv, kref);
-	call_rcu(&rdata->rcu, fc_rport_free_rcu);
+	kfree_rcu(rdata, rcu);
 }
 
 /**
-- 
1.7.3.2

