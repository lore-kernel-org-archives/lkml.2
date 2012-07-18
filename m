Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab2GRASJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:18:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42955 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab2GRAMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:12:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Todd Poynor <toddpoynor@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 05/23] ARM: SAMSUNG: fix race in s3c_adc_start for ADC
Date: Tue, 17 Jul 2012 17:11:58 -0700
Message-Id: <20120717232329.640308232@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232329.276003806@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232329.276003806@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Todd Poynor <toddpoynor@google.com>

commit 8265981bb439f3ecc5356fb877a6c2a6636ac88a upstream.

Checking for adc->ts_pend already claimed should be done with the
lock held.

Signed-off-by: Todd Poynor <toddpoynor@google.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/plat-samsung/adc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/arm/plat-samsung/adc.c
+++ b/arch/arm/plat-samsung/adc.c
@@ -143,11 +143,13 @@ int s3c_adc_start(struct s3c_adc_client
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
 


