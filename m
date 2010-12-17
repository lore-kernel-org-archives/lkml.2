Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0LQW2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 17:28:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab0LQW2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 17:28:07 -0500
From: Matthew Garrett <mjg@redhat.com>
To: guenter.roeck@ericsson.com
Cc: rydberg@euromail.se, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/2 V3] applesmc: Perform some more sanity checking on temperatures
Date: Fri, 17 Dec 2010 17:24:21 -0500
Message-Id: <1292624661-32474-2-git-send-email-mjg@redhat.com>
In-Reply-To: <20101217221618.GA13207@ericsson.com>
References: <20101217221618.GA13207@ericsson.com>
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
index 851a685..411a627 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -744,6 +744,10 @@ static ssize_t applesmc_show_temperature(struct device *dev,
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

