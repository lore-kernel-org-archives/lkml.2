Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab2GWBtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:49:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54424 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546Ab2GWBng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:36 -0400
Message-Id: <20120723010658.288545679@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Todd Poynor <toddpoynor@google.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 045/108] ARM: SAMSUNG: fix race in s3c_adc_start for ADC
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Todd Poynor <toddpoynor@google.com>

commit 8265981bb439f3ecc5356fb877a6c2a6636ac88a upstream.

Checking for adc->ts_pend already claimed should be done with the
lock held.

Signed-off-by: Todd Poynor <toddpoynor@google.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/plat-samsung/adc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-samsung/adc.c b/arch/arm/plat-samsung/adc.c
index 33ecd0c..b1e05cc 100644
--- a/arch/arm/plat-samsung/adc.c
+++ b/arch/arm/plat-samsung/adc.c
@@ -157,11 +157,13 @@ int s3c_adc_start(struct s3c_adc_client *client,
 		return -EINVAL;
 	}
 
-	if (client->is_ts && adc->ts_pend)
-		return -EAGAIN;
-
 	spin_lock_irqsave(&adc->lock, flags);
 
+	if (client->is_ts && adc->ts_pend) {
+		spin_unlock_irqrestore(&adc->lock, flags);
+		return -EAGAIN;
+	}
+
 	client->channel = channel;
 	client->nr_samples = nr_samples;
 


