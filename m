Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab1ELEmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 00:42:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57211 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab1ELEmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 00:42:50 -0400
Date: Thu, 12 May 2011 14:10:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Cardona <javier@cozybit.com>
Subject: linux-next: build failure after merge of the final tree (wireless
 tree related)
Message-Id: <20110512141019.72ccb7a7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

net/mac80211/cfg.c: In function 'sta_apply_parameters':
net/mac80211/cfg.c:746: error: 'struct sta_info' has no member named 'plink_state'

Cause by commit 9c3990aaec0a ("nl80211: Let userspace drive the peer link
management states").  plink_state is only available in sta_info if
CONFIG_MAC80211_MESH is set.

I applied the following patch for today (which my not be correct).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 12 May 2011 14:06:31 +1000
Subject: [PATCH] nl80211: fix for reference to sta_info -> plink_state

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/mac80211/cfg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a2ff474..e090012 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -743,7 +743,9 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 			case PLINK_LISTEN:
 			case PLINK_ESTAB:
 			case PLINK_BLOCKED:
+#ifdef CONFIG_MAC80211_MESH
 				sta->plink_state = params->plink_state;
+#endif
 				break;
 			default:
 				/*  nothing  */
-- 
1.7.5.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
