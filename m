Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2JRXW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:22:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61940 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab2JRXT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:19:58 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Len Brown <lenb@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>, Tejun Heo <tj@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH 2/2] timer: use new setup_timer_deferrable() macro
Date: Fri, 19 Oct 2012 08:18:28 +0900
Message-Id: <1350602308-2120-3-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350602308-2120-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1350602308-2120-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we have a handy macro for initializing deferrable timer.
Using it makes code clean and easy to understand.

Additionally, in some driver codes, use setup_timer() instead of init_timer().

This patch doesn't make any functional difference.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
Cc: Ron Mercer <ron.mercer@qlogic.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 1599566..1707f9a 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -944,9 +944,8 @@ static int __devinit ghes_probe(struct platform_device *ghes_dev)
 	}
 	switch (generic->notify.type) {
 	case ACPI_HEST_NOTIFY_POLLED:
-		ghes->timer.function = ghes_poll_func;
-		ghes->timer.data = (unsigned long)ghes;
-		init_timer_deferrable(&ghes->timer);
+		setup_timer_deferrable(&ghes->timer, ghes_poll_func,
+							(unsigned long)ghes);
 		ghes_add_timer(ghes);
 		break;
 	case ACPI_HEST_NOTIFY_EXTERNAL:
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3cc7096..a811e6f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5616,9 +5616,8 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	INIT_LIST_HEAD(&ap->eh_done_q);
 	init_waitqueue_head(&ap->eh_wait_q);
 	init_completion(&ap->park_req_pending);
-	init_timer_deferrable(&ap->fastdrain_timer);
-	ap->fastdrain_timer.function = ata_eh_fastdrain_timerfn;
-	ap->fastdrain_timer.data = (unsigned long)ap;
+	setup_timer_deferrable(&ap->fastdrain_timer, ata_eh_fastdrain_timerfn,
+							(unsigned long)ap);
 
 	ap->cbl = ATA_CBL_NONE;
 
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 876bece..987e2cf 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -5548,15 +5548,10 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 	spin_lock_init(&np->hwstats_lock);
 	SET_NETDEV_DEV(dev, &pci_dev->dev);
 
-	init_timer(&np->oom_kick);
-	np->oom_kick.data = (unsigned long) dev;
-	np->oom_kick.function = nv_do_rx_refill;	/* timer handler */
-	init_timer(&np->nic_poll);
-	np->nic_poll.data = (unsigned long) dev;
-	np->nic_poll.function = nv_do_nic_poll;	/* timer handler */
-	init_timer_deferrable(&np->stats_poll);
-	np->stats_poll.data = (unsigned long) dev;
-	np->stats_poll.function = nv_do_stats_poll;	/* timer handler */
+	setup_timer(&np->oom_kick, nv_do_rx_refill, (unsigned long)dev);
+	setup_timer(&np->nic_poll, nv_do_nic_poll, (unsigned long)dev);
+	setup_timer_deferrable(&np->stats_poll, nv_do_stats_poll,
+						(unsigned long)dev);
 
 	err = pci_enable_device(pci_dev);
 	if (err)
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index b262d61..1687883 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -4707,9 +4707,7 @@ static int __devinit qlge_probe(struct pci_dev *pdev,
 	/* Start up the timer to trigger EEH if
 	 * the bus goes dead
 	 */
-	init_timer_deferrable(&qdev->timer);
-	qdev->timer.data = (unsigned long)qdev;
-	qdev->timer.function = ql_timer;
+	setup_timer_deferrable(&qdev->timer, ql_timer, (unsigned long)qdev);
 	qdev->timer.expires = jiffies + (5*HZ);
 	add_timer(&qdev->timer);
 	ql_link_off(qdev);
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 607976c..743c7d7 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -995,9 +995,8 @@ static void vxlan_setup(struct net_device *dev)
 
 	spin_lock_init(&vxlan->hash_lock);
 
-	init_timer_deferrable(&vxlan->age_timer);
-	vxlan->age_timer.function = vxlan_cleanup;
-	vxlan->age_timer.data = (unsigned long) vxlan;
+	setup_timer_deferrable(&vxlan->age_timer, vxlan_cleanup,
+						(unsigned long)vxlan);
 
 	inet_get_local_port_range(&low, &high);
 	vxlan->port_min = low;
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d951daa..77d6f62 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3845,10 +3845,8 @@ static int __init init_workqueues(void)
 			INIT_LIST_HEAD(&pool->worklist);
 			INIT_LIST_HEAD(&pool->idle_list);
 
-			init_timer_deferrable(&pool->idle_timer);
-			pool->idle_timer.function = idle_worker_timeout;
-			pool->idle_timer.data = (unsigned long)pool;
-
+			setup_timer_deferrable(&pool->idle_timer,
+				    idle_worker_timeout, (unsigned long)pool);
 			setup_timer(&pool->mayday_timer, gcwq_mayday_timeout,
 				    (unsigned long)pool);
 
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 186d991..c8985c1 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -294,14 +294,14 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 	spin_lock_init(&tid_agg_rx->reorder_lock);
 
 	/* rx timer */
-	tid_agg_rx->session_timer.function = sta_rx_agg_session_timer_expired;
-	tid_agg_rx->session_timer.data = (unsigned long)&sta->timer_to_tid[tid];
-	init_timer_deferrable(&tid_agg_rx->session_timer);
+	setup_timer_deferrable(&tid_agg_rx->session_timer,
+				sta_rx_agg_session_timer_expired,
+				(unsigned long)&sta->timer_to_tid[tid]);
 
 	/* rx reorder timer */
-	tid_agg_rx->reorder_timer.function = sta_rx_agg_reorder_timer_expired;
-	tid_agg_rx->reorder_timer.data = (unsigned long)&sta->timer_to_tid[tid];
-	init_timer(&tid_agg_rx->reorder_timer);
+	setup_timer(&tid_agg_rx->reorder_timer,
+				sta_rx_agg_reorder_timer_expired,
+				(unsigned long)&sta->timer_to_tid[tid]);
 
 	/* prepare reordering buffer */
 	tid_agg_rx->reorder_buf =
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 3195a63..cacd75d 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -535,14 +535,14 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	tid_tx->timeout = timeout;
 
 	/* response timer */
-	tid_tx->addba_resp_timer.function = sta_addba_resp_timer_expired;
-	tid_tx->addba_resp_timer.data = (unsigned long)&sta->timer_to_tid[tid];
-	init_timer(&tid_tx->addba_resp_timer);
+	setup_timer(&tid_tx->addba_resp_timer,
+				sta_addba_resp_timer_expired,
+				(unsigned long)&sta->timer_to_tid[tid]);
 
 	/* tx timer */
-	tid_tx->session_timer.function = sta_tx_agg_session_timer_expired;
-	tid_tx->session_timer.data = (unsigned long)&sta->timer_to_tid[tid];
-	init_timer_deferrable(&tid_tx->session_timer);
+	setup_timer_deferrable(&tid_tx->session_timer,
+				sta_tx_agg_session_timer_expired,
+				(unsigned long)&sta->timer_to_tid[tid]);
 
 	/* assign a dialog token */
 	sta->ampdu_mlme.dialog_token_allocator++;
diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index ce82d0c..ff1afc5 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -457,9 +457,8 @@ static int flow_change(struct sk_buff *in_skb,
 		f->mask	  = ~0U;
 
 		get_random_bytes(&f->hashrnd, 4);
-		f->perturb_timer.function = flow_perturbation;
-		f->perturb_timer.data = (unsigned long)f;
-		init_timer_deferrable(&f->perturb_timer);
+		setup_timer_deferrable(&f->perturb_timer, flow_perturbation,
+							(unsigned long)f);
 	}
 
 	tcf_exts_change(tp, &f->exts, &e);
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index d3a1bc2..93ff569 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -739,9 +739,8 @@ static int sfq_init(struct Qdisc *sch, struct nlattr *opt)
 	struct sfq_sched_data *q = qdisc_priv(sch);
 	int i;
 
-	q->perturb_timer.function = sfq_perturbation;
-	q->perturb_timer.data = (unsigned long)sch;
-	init_timer_deferrable(&q->perturb_timer);
+	setup_timer_deferrable(&q->perturb_timer, sfq_perturbation,
+						(unsigned long)sch);
 
 	for (i = 0; i < SFQ_MAX_DEPTH + 1; i++) {
 		q->dep[i].next = i + SFQ_MAX_FLOWS;
-- 
1.7.9.5

