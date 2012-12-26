Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab2LZMcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 07:32:50 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52067 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab2LZMcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 07:32:46 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Antonio Quartulli <ordex@autistici.org>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] batman-adv: fix random jitter calculation
Date: Wed, 26 Dec 2012 21:32:10 +0900
Message-Id: <1356525130-2688-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

batadv_iv_ogm_emit_send_time() attempts to calculates a random integer
in the range of 'orig_interval +- BATADV_JITTER' by the below lines.

        msecs = atomic_read(&bat_priv->orig_interval) - BATADV_JITTER;
        msecs += (random32() % 2 * BATADV_JITTER);

But it actually gets 'orig_interval' or 'orig_interval - BATADV_JITTER'
because '%' and '*' have same precedence and associativity is
left-to-right.

This adds the parentheses at the appropriate position so that it matches
original intension.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Antonio Quartulli <ordex@autistici.org>
Cc: Marek Lindner <lindner_marek@yahoo.de>
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Cc: Antonio Quartulli <ordex@autistici.org>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---

This patch is extracted from the patch series "rename random32 and
net_random to prandom" since it is a fix.

 net/batman-adv/bat_iv_ogm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 9f3925a..7d02ebd 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -123,7 +123,7 @@ batadv_iv_ogm_emit_send_time(const struct batadv_priv *bat_priv)
 	unsigned int msecs;
 
 	msecs = atomic_read(&bat_priv->orig_interval) - BATADV_JITTER;
-	msecs += (random32() % 2 * BATADV_JITTER);
+	msecs += random32() % (2 * BATADV_JITTER);
 
 	return jiffies + msecs_to_jiffies(msecs);
 }
-- 
1.7.11.7

