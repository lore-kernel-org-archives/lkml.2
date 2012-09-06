Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab2IFFTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 01:19:36 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39453 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2IFFTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 01:19:35 -0400
MIME-Version: 1.0
Date: Thu, 6 Sep 2012 13:19:34 +0800
Message-ID: <CAPgLHd8TFjTAns2tbmEh8+C5PEjO2E7K-hZww9Ewdq6v4Qpihw@mail.gmail.com>
Subject: [PATCH] clockevents: use list_move instead of list_del/list_add
From: Wei Yongjun <weiyj.lk@gmail.com>
To: tglx@linutronix.de
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move() instead of list_del() + list_add().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 kernel/time/clockevents.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 7e1ce01..8c4aac5 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -267,8 +267,7 @@ static void clockevents_notify_released(void)
 	while (!list_empty(&clockevents_released)) {
 		dev = list_entry(clockevents_released.next,
 				 struct clock_event_device, list);
-		list_del(&dev->list);
-		list_add(&dev->list, &clockevent_devices);
+		list_move(&dev->list, &clockevent_devices);
 		clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
 	}
 }
@@ -386,8 +385,7 @@ void clockevents_exchange_device(struct clock_event_device *old,
 	 */
 	if (old) {
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
-		list_del(&old->list);
-		list_add(&old->list, &clockevents_released);
+		list_move(&old->list, &clockevents_released);
 	}
 
 	if (new) {

