Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1KFVoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 16:44:06 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16712 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1KFVoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 16:44:04 -0500
Date: Sun, 6 Nov 2011 22:49:22 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH] [staging] iio, adc: Do not leak memory in
 ad7280_event_handler()
Message-ID: <alpine.LNX.2.00.1111062246580.5763@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ad7280_read_all_channels() returns <0 then we'll leak the memory
allocated to 'channels' when we return and that variable goes out of
scope.
This patch fixes the leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/iio/adc/ad7280a.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

 note: I don't have the hardware, so patch is compile tested only.

diff --git a/drivers/staging/iio/adc/ad7280a.c b/drivers/staging/iio/adc/ad7280a.c
index 372d059..dddc03c 100644
--- a/drivers/staging/iio/adc/ad7280a.c
+++ b/drivers/staging/iio/adc/ad7280a.c
@@ -687,8 +687,10 @@ static irqreturn_t ad7280_event_handler(int irq, void *private)
 		return IRQ_HANDLED;
 
 	ret = ad7280_read_all_channels(st, st->scan_cnt, channels);
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(channels);
 		return IRQ_HANDLED;
+	}
 
 	for (i = 0; i < st->scan_cnt; i++) {
 		if (((channels[i] >> 23) & 0xF) <= AD7280A_CELL_VOLTAGE_6) {
-- 
1.7.7.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

