Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab0G3SIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:08:05 -0400
Received: from kroah.org ([198.145.64.141]:59226 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798Ab0G3R5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:44 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:50 2010
Message-Id: <20100730175150.640151422@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shanyu Zhao <shanyu.zhao@intel.com>,
        Pradeep Kulkarni <pradeepx.kulkarni@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: [184/205] iwlagn: verify flow id in compressed BA packet
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shanyu Zhao <shanyu.zhao@intel.com>

commit b561e8274f75831ee87e4ea378cbb1f9f050a51a upstream.

The flow id (scd_flow) in a compressed BA packet should match the txq_id
of the queue from which the aggregated packets were sent. However, in
some hardware like the 1000 series, sometimes the flow id is 0 for the
txq_id (10 to 19). This can cause the annoying message:
[ 2213.306191] iwlagn 0000:01:00.0: Received BA when not expected
[ 2213.310178] iwlagn 0000:01:00.0: Read index for DMA queue txq id (0),
index 5, is out of range [0-256] 7 7.

And even worse, if agg->wait_for_ba is true when the bad BA is arriving,
this can cause system hang due to NULL pointer dereference because the
code is operating in a wrong tx queue!

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Pradeep Kulkarni <pradeepx.kulkarni@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1635,6 +1635,11 @@ void iwl_rx_reply_compressed_ba(struct i
 	sta_id = ba_resp->sta_id;
 	tid = ba_resp->tid;
 	agg = &priv->stations[sta_id].tid[tid].agg;
+	if (unlikely(agg->txq_id != scd_flow)) {
+		IWL_ERR(priv, "BA scd_flow %d does not match txq_id %d\n",
+			scd_flow, agg->txq_id);
+		return;
+	}
 
 	/* Find index just before block-ack window */
 	index = iwl_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);


