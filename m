Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1FOJzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 05:55:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47658 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab1FOJzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 05:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UzvguiJOvUZ7FhrrVwAN9RJ4cYiqExpDN7oYhwvraLFh8M0kA/jv6Er7GiWeR5erM5
         TGgGbAAJ2t7qXRc9Fiiz9l7mGvJEdoef03hk2Os50Y766bKJaxa2z8sxv32rYoDC9Fh+
         KVla9u7Ir/+sfNOuwJhfus5LGeOB8CaEonInA=
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH for 3.0-rc4 2/2] dp83640: drop PHY status frames in the driver.
Date: Wed, 15 Jun 2011 11:55:20 +0200
Message-Id: <c09567e3debd1b20c091e294ab06e071c0654e67.1308129342.git.richard.cochran@omicron.at>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1308129342.git.richard.cochran@omicron.at>
References: <cover.1308129342.git.richard.cochran@omicron.at>
In-Reply-To: <cover.1308129342.git.richard.cochran@omicron.at>
References: <cover.1308129342.git.richard.cochran@omicron.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dp83640 PHY provides time stamp and other information via special
PHY status frames. Previously, the driver decoded the frames and then
let the network stack drop them. This works fine when the PTP messages
come over UDP.

However, when receiving PTP messages via L2 packets, this creates a
problem. The status frames use the official PTP destination MAC address,
and so they are delivered to user space along with the "real" frames,
causing confusion for applications.

This commit fixes the issue by simply dropping the PHY status frames
in the driver.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 drivers/net/phy/dp83640.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index ead323e..2cd8dc5 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -1044,8 +1044,8 @@ static bool dp83640_rxtstamp(struct phy_device *phydev,
 
 	if (is_status_frame(skb, type)) {
 		decode_status_frame(dp83640, skb);
-		/* Let the stack drop this frame. */
-		return false;
+		kfree_skb(skb);
+		return true;
 	}
 
 	SKB_PTP_TYPE(skb) = type;
-- 
1.7.0.4

