Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949Ab1LPATC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:19:02 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60514 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759904Ab1LPARy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:17:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [Update][PATCH 4/5] PM / input / touchscreen: Make st1232 use device PM QoS constraints
Date: Fri, 16 Dec 2011 01:13:35 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <201112100042.45168.rjw@sisk.pl> <201112160110.09124.rjw@sisk.pl>
In-Reply-To: <201112160110.09124.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112160113.36166.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the st1232 driver use dev_pm_qos_add_ancestor_request() to
add a device PM QoS latency constraint for the controller it
depends on, so that the controller won't go into an overly deep
low-power state when the touchscreen has to be particularly
responsive (e.g. when the user moves his or her finger on it).

This change is based on a prototype patch from Guennadi Liakhovetski.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/input/touchscreen/st1232.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux/drivers/input/touchscreen/st1232.c
===================================================================
--- linux.orig/drivers/input/touchscreen/st1232.c
+++ linux/drivers/input/touchscreen/st1232.c
@@ -23,6 +23,7 @@
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/pm_qos.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 
@@ -46,6 +47,7 @@ struct st1232_ts_data {
 	struct i2c_client *client;
 	struct input_dev *input_dev;
 	struct st1232_ts_finger finger[MAX_FINGERS];
+	struct dev_pm_qos_request low_latency_req;
 };
 
 static int st1232_ts_read_data(struct st1232_ts_data *ts)
@@ -118,8 +120,17 @@ static irqreturn_t st1232_ts_irq_handler
 	}
 
 	/* SYN_MT_REPORT only if no contact */
-	if (!count)
+	if (!count) {
 		input_mt_sync(input_dev);
+		if (ts->low_latency_req.dev) {
+			dev_pm_qos_remove_request(&ts->low_latency_req);
+			ts->low_latency_req.dev = NULL;
+		}
+	} else if (!ts->low_latency_req.dev) {
+		/* First contact, request 100 us latency. */
+		dev_pm_qos_add_ancestor_request(&ts->client->dev,
+						&ts->low_latency_req, 100);
+	}
 
 	/* SYN_REPORT */
 	input_sync(input_dev);

