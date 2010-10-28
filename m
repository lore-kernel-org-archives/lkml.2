Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab0J1EmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 00:42:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49513 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0J1EmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 00:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=hmhsDBPYl1oTAI841ips9vTgzr/KDLK4r1c25gQufm+ae1s5Vrmd4Y2Ac/Qbsv9rQ+
         vv2MHrcAhfAIxpOdXYhdNfBouxfcnyNVkXabNkSPTXjtMrZc98reBkQySAuMXIxop+dl
         vMrbO11Wv7tgqRt/4TzFFK/DWs0XOQGQhCcIY=
Date: Thu, 28 Oct 2010 06:41:49 +0200
From: Dan Carpenter <error27@gmail.com>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] misc/bh1770glc: error handling in
	bh1770_power_state_store()
Message-ID: <20101028044149.GU6062@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Samu Onkalo <samu.p.onkalo@nokia.com>,
	Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a signedness bug so "ret" was never less than zero and that
breaks the error handling.  Also in the original code it would overwrite
ret and the result is still negative but it's bogus number instead of
the correct error code.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index cee632e..d79a972 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -649,7 +649,7 @@ static ssize_t bh1770_power_state_store(struct device *dev,
 {
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
-	size_t ret;
+	ssize_t ret;
 
 	if (strict_strtoul(buf, 0, &value))
 		return -EINVAL;
@@ -659,8 +659,12 @@ static ssize_t bh1770_power_state_store(struct device *dev,
 		pm_runtime_get_sync(dev);
 
 		ret = bh1770_lux_rate(chip, chip->lux_rate_index);
-		ret |= bh1770_lux_interrupt_control(chip, BH1770_ENABLE);
+		if (ret < 0) {
+			pm_runtime_put(dev);
+			goto leave;
+		}
 
+		ret = bh1770_lux_interrupt_control(chip, BH1770_ENABLE);
 		if (ret < 0) {
 			pm_runtime_put(dev);
 			goto leave;
