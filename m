Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2EIF7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:59:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39089 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756596Ab2EIFxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:46 -0400
Message-Id: <20120509055049.076406734@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Seth Forshee <seth.forshee@canonical.com>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 141/167] [PATCH] b43: only reload config after successful initialization
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Forshee <seth.forshee@canonical.com>

commit dbdedbdf4fbff3d4962a0786f37aa86dfdc48a7e upstream.

Commit 2a19032 (b43: reload phy and bss settings after core restarts)
introduced an unconditional call to b43_op_config() at the end of
b43_op_start(). When firmware fails to load this can wedge the system.
There's no need to reload the configuration after a failed
initialization anyway, so only make the call if initialization was
successful.

BugLink: http://bugs.launchpad.net/bugs/950295
Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/b43/main.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index c79e663..e4d6dc2 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4827,8 +4827,14 @@ static int b43_op_start(struct ieee80211_hw *hw)
  out_mutex_unlock:
 	mutex_unlock(&wl->mutex);
 
-	/* reload configuration */
-	b43_op_config(hw, ~0);
+	/*
+	 * Configuration may have been overwritten during initialization.
+	 * Reload the configuration, but only if initialization was
+	 * successful. Reloading the configuration after a failed init
+	 * may hang the system.
+	 */
+	if (!err)
+		b43_op_config(hw, ~0);
 
 	return err;
 }
-- 
1.7.10



