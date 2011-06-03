Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab1FCXpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:45:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:47390 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab1FCXoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:44:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,317,1304319600"; 
   d="scan'208";a="13344059"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Russ Gorby <russ.gorby@intel.com>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com, russ.gorby@intel.com
Subject: [PATCHv2 4/7] tty: n_gsm: initiate close of all DLCIs during mux shutdown
Date: Fri,  3 Jun 2011 16:43:59 -0700
Message-Id: <1307144642-5915-5-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2>
References: <[PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although DLCI-0 is closed during ldisc close, we found the
applications were better served when open DLCI shutdowns where
initiated at that time as well.

initiated shutdown of all DLCI during ldisc close.

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/n_gsm.c |   30 +++++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index c8a43de..22c844d 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -43,6 +43,8 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
+#include <linux/timer.h>
+#include <linux/wait.h>
 #include <linux/ctype.h>
 #include <linux/mm.h>
 #include <linux/string.h>
@@ -1979,6 +1981,7 @@ static void gsm_error(struct gsm_mux *gsm,
 void gsm_cleanup_mux(struct gsm_mux *gsm)
 {
 	int i;
+	int t;
 	struct gsm_dlci *dlci = gsm->dlci[0];
 	struct gsm_msg *txq;
 
@@ -1996,14 +1999,27 @@ void gsm_cleanup_mux(struct gsm_mux *gsm)
 
 	del_timer_sync(&gsm->t2_timer);
 	/* Now we are sure T2 has stopped */
-	if (dlci) {
-		dlci->dead = 1;
-		gsm_dlci_begin_close(dlci);
-		wait_event_interruptible(gsm->event,
-					dlci->state == DLCI_CLOSED);
-	}
 	/* Free up any link layer users */
-	for (i = 0; i < NUM_DLCI; i++)
+	for (i = NUM_DLCI-1; i >= 0; i--) {
+		dlci = gsm->dlci[i];
+		if (dlci) {
+			if (i != 0)
+				gsm_dlci_begin_close(dlci);
+			else {
+				dlci->dead = 1;
+				gsm_dlci_begin_close(dlci);
+				t = wait_event_timeout(gsm->event,
+					   dlci->state == DLCI_CLOSED,
+					   gsm->t2 * HZ / 100);
+				if (!t) {
+					pr_info("%s: timeout dlci0 close",
+						__func__);
+					gsm_dlci_close(dlci);
+				}
+			}
+		}
+	}
+	for (i = NUM_DLCI-1; i >= 0; i--)
 		if (gsm->dlci[i])
 			gsm_dlci_release(gsm->dlci[i]);
 	/* Now wipe the queues */
-- 
1.7.0.4

