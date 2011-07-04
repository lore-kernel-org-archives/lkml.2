Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab1GDQaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:30:18 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:41005 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757119Ab1GDQaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:30:17 -0400
From: James Nuss <jamesnuss@nanometrics.ca>
To: Rodolfo Giometti <rodolfo.giometti@enneenne.com>
Cc: Ricardo Martins <rasm@fe.up.pt>, Ben Gardiner <bengardiner@nanometrics.ca>,
        linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Igor Plyatov <plyatov@gmail.com>,
        James Nuss <jamesnuss@nanometrics.ca>
Subject: [PATCH v2 1/2] pps: default echo function
Date: Mon,  4 Jul 2011 12:29:28 -0400
Message-Id: <1309796969-31708-2-git-send-email-jamesnuss@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A default echo function has been provided so it is no longer an
error when you specify PPS_ECHOASSERT or PPS_ECHOCLEAR without an explicit
echo function. This allows some code re-use and also makes it easier
to write client drivers since the default echo function does not
normally need to change.

Signed-off-by: James Nuss <jamesnuss@nanometrics.ca>
Reviewed-by: Ben Gardiner <bengardiner@nanometrics.ca>
Acked-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/pps/clients/pps-ktimer.c  |   12 ------------
 drivers/pps/clients/pps_parport.c |    9 ---------
 drivers/pps/kapi.c                |   20 +++++++++++++-------
 3 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/pps/clients/pps-ktimer.c b/drivers/pps/clients/pps-ktimer.c
index 82583b0..436b4e4 100644
--- a/drivers/pps/clients/pps-ktimer.c
+++ b/drivers/pps/clients/pps-ktimer.c
@@ -52,17 +52,6 @@ static void pps_ktimer_event(unsigned long ptr)
 }
 
 /*
- * The echo function
- */
-
-static void pps_ktimer_echo(struct pps_device *pps, int event, void *data)
-{
-	dev_info(pps->dev, "echo %s %s\n",
-		event & PPS_CAPTUREASSERT ? "assert" : "",
-		event & PPS_CAPTURECLEAR ? "clear" : "");
-}
-
-/*
  * The PPS info struct
  */
 
@@ -72,7 +61,6 @@ static struct pps_source_info pps_ktimer_info = {
 	.mode		= PPS_CAPTUREASSERT | PPS_OFFSETASSERT |
 			  PPS_ECHOASSERT |
 			  PPS_CANWAIT | PPS_TSFMT_TSPEC,
-	.echo		= pps_ktimer_echo,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/drivers/pps/clients/pps_parport.c b/drivers/pps/clients/pps_parport.c
index c571d6d..e1b4705 100644
--- a/drivers/pps/clients/pps_parport.c
+++ b/drivers/pps/clients/pps_parport.c
@@ -133,14 +133,6 @@ out_both:
 	return;
 }
 
-/* the PPS echo function */
-static void pps_echo(struct pps_device *pps, int event, void *data)
-{
-	dev_info(pps->dev, "echo %s %s\n",
-		event & PPS_CAPTUREASSERT ? "assert" : "",
-		event & PPS_CAPTURECLEAR ? "clear" : "");
-}
-
 static void parport_attach(struct parport *port)
 {
 	struct pps_client_pp *device;
@@ -151,7 +143,6 @@ static void parport_attach(struct parport *port)
 				  PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
 				  PPS_ECHOASSERT | PPS_ECHOCLEAR | \
 				  PPS_CANWAIT | PPS_TSFMT_TSPEC,
-		.echo		= pps_echo,
 		.owner		= THIS_MODULE,
 		.dev		= NULL
 	};
diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index a4e8eb9..f197e8e 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -52,6 +52,14 @@ static void pps_add_offset(struct pps_ktime *ts, struct pps_ktime *offset)
 	ts->sec += offset->sec;
 }
 
+static void pps_echo_client_default(struct pps_device *pps, int event,
+		void *data)
+{
+	dev_info(pps->dev, "echo %s %s\n",
+		event & PPS_CAPTUREASSERT ? "assert" : "",
+		event & PPS_CAPTURECLEAR ? "clear" : "");
+}
+
 /*
  * Exported functions
  */
@@ -80,13 +88,6 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
 		err = -EINVAL;
 		goto pps_register_source_exit;
 	}
-	if ((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) != 0 &&
-			info->echo == NULL) {
-		pr_err("%s: echo function is not defined\n",
-					info->name);
-		err = -EINVAL;
-		goto pps_register_source_exit;
-	}
 	if ((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
 		pr_err("%s: unspecified time format\n",
 					info->name);
@@ -108,6 +109,11 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
 	pps->params.mode = default_params;
 	pps->info = *info;
 
+	/* check for default echo function */
+	if ((pps->info.mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) &&
+			pps->info.echo == NULL)
+		pps->info.echo = pps_echo_client_default;
+
 	init_waitqueue_head(&pps->queue);
 	spin_lock_init(&pps->lock);
 
-- 
1.7.1

