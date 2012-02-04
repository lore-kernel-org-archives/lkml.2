Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab2BDBqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 20:46:07 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34252 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab2BDBqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 20:46:03 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jiri Kosina <jkosina@suse.cz>, Jesper Juhl <jj@chaosbits.net>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH tip/core/rcu 08/47] tcm_fc: Convert call_rcu() to kfree_rcu(), drop ft_tport_rcu_free()
Date: Fri,  3 Feb 2012 17:44:43 -0800
Message-Id: <1328319922-30828-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120204014452.GA29811@linux.vnet.ibm.com>
 <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020401-1780-0000-0000-000002DC301C
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00110708; UDB=6.00027489; UTC=2012-02-04
 01:46:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The call_rcu() in ft_tport_delete() invokes ft_tport_rcu_free(),
which just does a kfree().  So convert the call_rcu() to kfree_rcu(),
allowing ft_tport_rcu_free() to be eliminated.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
---
 drivers/target/tcm_fc/tfc_sess.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 4c0507c..eff512b 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -86,16 +86,6 @@ static struct ft_tport *ft_tport_create(struct fc_lport *lport)
 }
 
 /*
- * Free tport via RCU.
- */
-static void ft_tport_rcu_free(struct rcu_head *rcu)
-{
-	struct ft_tport *tport = container_of(rcu, struct ft_tport, rcu);
-
-	kfree(tport);
-}
-
-/*
  * Delete a target local port.
  * Caller holds ft_lport_lock.
  */
@@ -114,7 +104,7 @@ static void ft_tport_delete(struct ft_tport *tport)
 		tpg->tport = NULL;
 		tport->tpg = NULL;
 	}
-	call_rcu(&tport->rcu, ft_tport_rcu_free);
+	kfree_rcu(tport, rcu);
 }
 
 /*
-- 
1.7.8

