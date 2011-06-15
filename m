Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1FOJzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 05:55:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35452 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1FOJzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 05:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FdINPPViriaUCvREChlA427O3/JOWwyHyaFJz+7ffdu4aNdCk6VIvXomZqF3pzzs9S
         EqgJ6ixcgc+3LgLKuWWb/5bCmRrwviUKLZdO/dVi4ROicuuMJWNTf7e5dCqSjHC4F4YQ
         1f/ZquZrCdFDQtMAuUsTctYjKHhblMWX3c2PM=
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH for 3.0-rc4 1/2] dp83640: fix phy status frame event parsing
Date: Wed, 15 Jun 2011 11:55:19 +0200
Message-Id: <66636408c37d95142c47014424ec4341c45cf547.1308129342.git.richard.cochran@omicron.at>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1308129342.git.richard.cochran@omicron.at>
References: <cover.1308129342.git.richard.cochran@omicron.at>
In-Reply-To: <cover.1308129342.git.richard.cochran@omicron.at>
References: <cover.1308129342.git.richard.cochran@omicron.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If two eternal time stamp events occur at nearly the same time, the
phyter will add an extra word into the status frame. This commit fixes
the parsing code to recognize and skip over the extra word.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 drivers/net/phy/dp83640.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index b0c9522..ead323e 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -543,11 +543,20 @@ static void recalibrate(struct dp83640_clock *clock)
 
 /* time stamping methods */
 
-static void decode_evnt(struct dp83640_private *dp83640,
-			struct phy_txts *phy_txts, u16 ests)
+static int decode_evnt(struct dp83640_private *dp83640,
+		       void *data, u16 ests)
 {
+	struct phy_txts *phy_txts;
 	struct ptp_clock_event event;
 	int words = (ests >> EVNT_TS_LEN_SHIFT) & EVNT_TS_LEN_MASK;
+	u16 ext_status = 0;
+
+	if (ests & MULT_EVNT) {
+		ext_status = *(u16 *) data;
+		data += sizeof(ext_status);
+	}
+
+	phy_txts = data;
 
 	switch (words) { /* fall through in every case */
 	case 3:
@@ -565,6 +574,9 @@ static void decode_evnt(struct dp83640_private *dp83640,
 	event.timestamp = phy2txts(&dp83640->edata);
 
 	ptp_clock_event(dp83640->clock->ptp_clock, &event);
+
+	words = ext_status ? words + 2 : words + 1;
+	return words * sizeof(u16);
 }
 
 static void decode_rxts(struct dp83640_private *dp83640,
@@ -643,9 +655,7 @@ static void decode_status_frame(struct dp83640_private *dp83640,
 
 		} else if (PSF_EVNT == type && len >= sizeof(*phy_txts)) {
 
-			phy_txts = (struct phy_txts *) ptr;
-			decode_evnt(dp83640, phy_txts, ests);
-			size = sizeof(*phy_txts);
+			size = decode_evnt(dp83640, ptr, ests);
 
 		} else {
 			size = 0;
-- 
1.7.0.4

