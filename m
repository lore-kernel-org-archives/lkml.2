Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab2F0Igd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:36:33 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:1094 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345Ab2F0Iga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:36:30 -0400
Message-ID: <1340786187.1911.24.camel@x61.thuisdomein>
Subject: [PATCH] iwlegacy: print how long queue was actually stuck
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Jun 2012 10:36:27 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 27 Jun 2012 08:36:28.0663 (UTC) FILETIME=[F231B870:01CD543F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every now and then, after resuming from suspend, the iwlegacy driver
prints
    iwl4965 0000:03:00.0: Queue 2 stuck for 2000 ms.
    iwl4965 0000:03:00.0: On demand firmware reload

I have no idea what causes these errors. But the code currently uses
wd_timeout in the first error. wd_timeout will generally be set at
IL_DEF_WD_TIMEOUT (ie, 2000). Perhaps printing for how long the queue
was actually stuck can clarify the cause of these errors.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested on v3.5-rc4. Tested on Fedora 's current v3.4.2 based
kernel (ie, on F16). That required an edit to this commit because of
trivial context changes.

1) Please note that testing here involved waiting until I again
triggered this error (which now of course printed how long the queue was
actually stuck).

 drivers/net/wireless/iwlegacy/common.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index cbf2dc1..763c752 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4717,10 +4717,11 @@ il_check_stuck_queue(struct il_priv *il, int cnt)
 	struct il_tx_queue *txq = &il->txq[cnt];
 	struct il_queue *q = &txq->q;
 	unsigned long timeout;
+	unsigned long now = jiffies;
 	int ret;
 
 	if (q->read_ptr == q->write_ptr) {
-		txq->time_stamp = jiffies;
+		txq->time_stamp = now;
 		return 0;
 	}
 
@@ -4728,9 +4729,9 @@ il_check_stuck_queue(struct il_priv *il, int cnt)
 	    txq->time_stamp +
 	    msecs_to_jiffies(il->cfg->wd_timeout);
 
-	if (time_after(jiffies, timeout)) {
+	if (time_after(now, timeout)) {
 		IL_ERR("Queue %d stuck for %u ms.\n", q->id,
-		       il->cfg->wd_timeout);
+		       jiffies_to_msecs(now - txq->time_stamp));
 		ret = il_force_reset(il, false);
 		return (ret == -EAGAIN) ? 0 : 1;
 	}
-- 
1.7.7.6

