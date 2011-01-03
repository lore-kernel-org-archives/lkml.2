Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab1ACNzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:55:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab1ACNuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=xX13Yax1Cv40fDOWGjMKJpQf37kfZXJgpaPHoykAfPXfuuMhrjI2IlHTRddRr6iTHi
         XKp5l8TkrEAvIkRx0PgsnmpWkOYZWzw919x/Zibsa4Jh6Ts8v5sXlaQSL8FxmgVG82gA
         8sqAJ7kLDUUJ2QNMk1tKUYF+9CWM09koHy66Y=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
        Todd Fischer <todd.fischer@ridgerun.com>
Subject: [PATCH 10/32] input/tps6507x-ts: use system_wq instead of dedicated workqueue
Date: Mon,  3 Jan 2011 14:49:33 +0100
Message-Id: <1294062595-30097-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cmwq, there's no reason to use a separate workqueue.  Drop
tps6507x_ts->wq and use system_wq instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>
Cc: Todd Fischer <todd.fischer@ridgerun.com>
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 drivers/input/touchscreen/tps6507x-ts.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
index c8c136c..4303149 100644
--- a/drivers/input/touchscreen/tps6507x-ts.c
+++ b/drivers/input/touchscreen/tps6507x-ts.c
@@ -43,7 +43,6 @@ struct tps6507x_ts {
 	struct input_dev	*input_dev;
 	struct device		*dev;
 	char			phys[32];
-	struct workqueue_struct *wq;
 	struct delayed_work	work;
 	unsigned		polling;	/* polling is active */
 	struct ts_event		tc;
@@ -220,8 +219,8 @@ done:
 	poll = 1;
 
 	if (poll) {
-		schd = queue_delayed_work(tsc->wq, &tsc->work,
-					  msecs_to_jiffies(tsc->poll_period));
+		schd = schedule_delayed_work(&tsc->work,
+					msecs_to_jiffies(tsc->poll_period));
 		if (schd)
 			tsc->polling = 1;
 		else {
@@ -303,7 +302,6 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
 	tsc->input_dev = input_dev;
 
 	INIT_DELAYED_WORK(&tsc->work, tps6507x_ts_handler);
-	tsc->wq = create_workqueue("TPS6507x Touchscreen");
 
 	if (init_data) {
 		tsc->poll_period = init_data->poll_period;
@@ -325,8 +323,8 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
 	if (error)
 		goto err2;
 
-	schd = queue_delayed_work(tsc->wq, &tsc->work,
-				  msecs_to_jiffies(tsc->poll_period));
+	schd = schedule_delayed_work(&tsc->work,
+				     msecs_to_jiffies(tsc->poll_period));
 
 	if (schd)
 		tsc->polling = 1;
@@ -341,7 +339,6 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
 
 err2:
 	cancel_delayed_work_sync(&tsc->work);
-	destroy_workqueue(tsc->wq);
 	input_free_device(input_dev);
 err1:
 	kfree(tsc);
@@ -357,7 +354,6 @@ static int __devexit tps6507x_ts_remove(struct platform_device *pdev)
 	struct input_dev *input_dev = tsc->input_dev;
 
 	cancel_delayed_work_sync(&tsc->work);
-	destroy_workqueue(tsc->wq);
 
 	input_unregister_device(input_dev);
 
-- 
1.7.1

