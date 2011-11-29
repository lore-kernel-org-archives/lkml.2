Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1K2IMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 03:12:21 -0500
Received: from mga14.intel.com ([143.182.124.37]:47418 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab1K2IMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 03:12:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,590,1315206000"; 
   d="scan'208";a="42019266"
From: Feng Tang <feng.tang@intel.com>
To: dtor@mail.ru, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwlee@mtekvision.com
Cc: joel.clark@intel.com, Feng Tang <feng.tang@intel.com>
Subject: [PATCH 2/2] Input: tsc2007 - Add a z1_low_threshhold platform data parameter
Date: Tue, 29 Nov 2011 16:12:58 +0800
Message-Id: <1322554378-348-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1322554378-348-1-git-send-email-feng.tang@intel.com>
References: <1322554378-348-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This originates from a patch in Meego IVI kernel with the name
	linux-2.6.37-connext-0027-tsc2007.patch
There is no author info excepte a line "From  MeeGo <kernel@meego.com>"

When integrating tsc2007 on Intel IVI platform, there are a lot of noise
data whose z1 value is around 10 which is not a sane "z1". So add
a "z1_low_threshhold" to filter those nosie data, to make the device work
properly.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/input/touchscreen/tsc2007.c |    4 +++-
 include/linux/i2c/tsc2007.h         |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
index 789f216..1bf3503 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -72,6 +72,7 @@ struct tsc2007 {
 	u16			model;
 	u16			x_plate_ohms;
 	u16			max_rt;
+	u16			z1_low_threshhold;
 	unsigned long		poll_delay;
 	unsigned long		poll_period;
 
@@ -130,7 +131,7 @@ static u32 tsc2007_calculate_pressure(struct tsc2007 *tsc, struct ts_event *tc)
 	if (tc->x == MAX_12BIT)
 		tc->x = 0;
 
-	if (likely(tc->x && tc->z1)) {
+	if (likely(tc->x && tc->z1 > tsc->z1_low_threshhold)) {
 		/* compute touch pressure resistance using equation #1 */
 		rt = tc->z2 - tc->z1;
 		rt *= tc->x;
@@ -313,6 +314,7 @@ static int __devinit tsc2007_probe(struct i2c_client *client,
 	ts->model             = pdata->model;
 	ts->x_plate_ohms      = pdata->x_plate_ohms;
 	ts->max_rt            = pdata->max_rt ? : MAX_12BIT;
+	ts->z1_low_threshhold = pdata->z1_low_threshhold ? : 1;
 	ts->poll_delay        = pdata->poll_delay ? : 1;
 	ts->poll_period       = pdata->poll_period ? : 1;
 	ts->get_pendown_state = pdata->get_pendown_state;
diff --git a/include/linux/i2c/tsc2007.h b/include/linux/i2c/tsc2007.h
index 506a9f7..638c6c7 100644
--- a/include/linux/i2c/tsc2007.h
+++ b/include/linux/i2c/tsc2007.h
@@ -7,6 +7,7 @@ struct tsc2007_platform_data {
 	u16	model;				/* 2007. */
 	u16	x_plate_ohms;	/* must be non-zero value */
 	u16	max_rt; /* max. resistance above which samples are ignored */
+	u16	z1_low_threshhold; /* threshhold to prevent some noise data */
 	unsigned long poll_delay; /* delay (in ms) after pen-down event
 				     before polling starts */
 	unsigned long poll_period; /* time (in ms) between samples */
-- 
1.7.1

