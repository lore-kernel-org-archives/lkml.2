Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2JCT0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:26:44 -0400
Received: from mxout1.idt.com ([157.165.5.25]:40749 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab2JCTZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:25:40 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: [PATCH 3/5] rapidio: run discovery as an asynchronous process
Date: Wed,  3 Oct 2012 15:18:41 -0400
Message-Id: <1349291923-22860-4-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1349291923-22860-1-git-send-email-alexandre.bounine@idt.com>
References: <1349291923-22860-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify mport initialization routine to run the RapidIO discovery process
asynchronously. This allows to have an arbitrary order of enumerating and
discovering ports in systems with multiple RapidIO controllers without
creating a deadlock situation if enumerator port is registered after a
discovering one.

Making netID matching to mportID ensures consistent net ID assignment in
multiport RapidIO systems with asynchronous discovery process (global counter
implementation is affected by race between threads).

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
---
 drivers/rapidio/rio-scan.c |    3 +-
 drivers/rapidio/rio.c      |   51 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 8b7c4bc..745670f 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -44,7 +44,6 @@ static void rio_init_em(struct rio_dev *rdev);
 DEFINE_SPINLOCK(rio_global_list_lock);
 
 static int next_destid = 0;
-static int next_net = 0;
 static int next_comptag = 1;
 
 static int rio_mport_phys_table[] = {
@@ -1062,7 +1061,7 @@ static struct rio_net __devinit *rio_alloc_net(struct rio_mport *port)
 		INIT_LIST_HEAD(&net->mports);
 		list_add_tail(&port->nnode, &net->mports);
 		net->hport = port;
-		net->id = next_net++;
+		net->id = port->id;
 	}
 	return net;
 }
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index d7b68cc..7cdc3e6d 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -1260,15 +1260,62 @@ static int __devinit rio_init(void)
 	return 0;
 }
 
+static struct workqueue_struct *rio_wq;
+
+struct rio_disc_work {
+	struct work_struct	work;
+	struct rio_mport	*mport;
+};
+
+static void __devinit disc_work_handler(struct work_struct *_work)
+{
+	struct rio_disc_work *work = container_of(_work,
+						  struct rio_disc_work, work);
+
+	pr_debug("RIO: discovery work for mport %d %s\n",
+		 work->mport->id, work->mport->name);
+	rio_disc_mport(work->mport);
+
+	kfree(work);
+}
+
 int __devinit rio_init_mports(void)
 {
 	struct rio_mport *port;
+	struct rio_disc_work *work;
+	int no_disc = 0;
 
 	list_for_each_entry(port, &rio_mports, node) {
 		if (port->host_deviceid >= 0)
 			rio_enum_mport(port);
-		else
-			rio_disc_mport(port);
+		else if (!no_disc) {
+			if (!rio_wq) {
+				rio_wq = alloc_workqueue("riodisc", 0, 0);
+				if (!rio_wq) {
+					pr_err("RIO: unable allocate rio_wq\n");
+					no_disc = 1;
+					continue;
+				}
+			}
+
+			work = kzalloc(sizeof *work, GFP_KERNEL);
+			if (!work) {
+				pr_err("RIO: no memory for work struct\n");
+				no_disc = 1;
+				continue;
+			}
+
+			work->mport = port;
+			INIT_WORK(&work->work, disc_work_handler);
+			queue_work(rio_wq, &work->work);
+		}
+	}
+
+	if (rio_wq) {
+		pr_debug("RIO: flush discovery workqueue\n");
+		flush_workqueue(rio_wq);
+		pr_debug("RIO: flush discovery workqueue finished\n");
+		destroy_workqueue(rio_wq);
 	}
 
 	rio_init();
-- 
1.7.8.4

