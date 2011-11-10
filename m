Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412Ab1KJH2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 02:28:25 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40846 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1KJH2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 02:28:23 -0500
Message-ID: <1320910091.7431.1.camel@phoenix>
Subject: [PATCH 1/2] devfreq: fix use after free in devfreq_remove_device
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mike Turquette <mturquette@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Thu, 10 Nov 2011 15:28:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In devfreq_remove_device, calling _remove_devfreq will also free devfreq.
Don't dereference devfreq->governor->no_central_polling after _remove_devfreq.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/devfreq/devfreq.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index d065925..59d24e9 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -418,10 +418,14 @@ out:
  */
 int devfreq_remove_device(struct devfreq *devfreq)
 {
+	bool central_polling;
+
 	if (!devfreq)
 		return -EINVAL;
 
-	if (!devfreq->governor->no_central_polling) {
+	central_polling = !devfreq->governor->no_central_polling;
+
+	if (central_polling) {
 		mutex_lock(&devfreq_list_lock);
 		while (wait_remove_device == devfreq) {
 			mutex_unlock(&devfreq_list_lock);
@@ -433,7 +437,7 @@ int devfreq_remove_device(struct devfreq *devfreq)
 	mutex_lock(&devfreq->lock);
 	_remove_devfreq(devfreq, false); /* it unlocks devfreq->lock */
 
-	if (!devfreq->governor->no_central_polling)
+	if (central_polling)
 		mutex_unlock(&devfreq_list_lock);
 
 	return 0;
-- 
1.7.5.4



