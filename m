Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab2D0GR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:17:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37519 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2D0GR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:17:27 -0400
X-AuditID: cbfee61a-b7b8eae00000534b-e9-4f9a39f543b1
Message-id: <4F9A39F8.7000302@samsung.com>
Date: Fri, 27 Apr 2012 15:17:28 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        gregkh@linuxfoundation.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Extcon: Notify changed state for only one cable to notifee
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch inform the state of only one cable instead of previous data
including the state of 32 cables to notifee which use
extcon_register_interest()
function to monitor whether the specific cable is attachd or detached.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/extcon/extcon_class.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index dbd3bfb..9cf3166 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -425,8 +425,15 @@ static int _call_per_cable(struct notifier_block
*nb, unsigned long val,

 	if ((val & (1 << obj->cable_index)) !=
 	    (edev->state & (1 << obj->cable_index))) {
+		bool cable_state = true;
+
 		obj->previous_value = val;
-		return obj->user_nb->notifier_call(obj->user_nb, val, ptr);
+
+		if (val & (1 << obj->cable_index))
+			cable_state = false;
+
+		return obj->user_nb->notifier_call(obj->user_nb,
+				cable_state, ptr);
 	}

 	return NOTIFY_OK;
-- 
1.7.0.4

