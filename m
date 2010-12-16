Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0LPPeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:34:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167Ab0LPPeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:34:00 -0500
From: Matthew Garrett <mjg@redhat.com>
To: rydberg@euromail.se
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/2] applesmc: Perform some more sanity checking on temperatures
Date: Thu, 16 Dec 2010 10:33:09 -0500
Message-Id: <1292513589-14651-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1292513589-14651-1-git-send-email-mjg@redhat.com>
References: <1292513589-14651-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that the two-byte temperature format is intended to be signed
("sp78" appears to mean "signed, decimal point, 7 bits before, 8 bits
after") and it doesn't seem terribly plausible that we'll get any of these
machines below freezing. It's probably more reasonable to assume that
negative values indicate errors and drop them.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/hwmon/applesmc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index dbe3fa6..d7ec678 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -739,6 +739,10 @@ static ssize_t applesmc_show_temperature(struct device *dev,
 		return ret;
 
 	if (entry->len == 2) {
+		if (buffer[0] >= 0x80) {
+			/* The two byte format is signed - ignore negative */
+			return -EINVAL;
+		}
 		temp = buffer[0] * 1000;
 		temp += (buffer[1] >> 6) * 250;
 	} else {
-- 
1.7.3.3

