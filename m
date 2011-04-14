Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965103Ab1DNR7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:59:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:42403 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965036Ab1DNR7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 209/209] niu: Fix kernel buffer overflow for ETHTOOL_GRXCLSRLALL
Date: Thu, 14 Apr 2011 13:56:07 -0400
Message-Id: <1302803767-9715-96-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit ee9c5cfad29c8a13199962614b9b16f1c4137ac9 upstream.

niu_get_ethtool_tcam_all() assumes that its output buffer is the right
size, and warns before returning if it is not.  However, the output
buffer size is under user control and ETHTOOL_GRXCLSRLALL is an
unprivileged ethtool command.  Therefore this is at least a local
denial-of-service vulnerability.

Change it to check before writing each entry and to return an error if
the buffer is already full.

Compile-tested only.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/niu.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index d5cd16b..408d10f 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -7263,32 +7263,28 @@ static int niu_get_ethtool_tcam_all(struct niu *np,
 	struct niu_parent *parent = np->parent;
 	struct niu_tcam_entry *tp;
 	int i, idx, cnt;
-	u16 n_entries;
 	unsigned long flags;
-
+	int ret = 0;
 
 	/* put the tcam size here */
 	nfc->data = tcam_get_size(np);
 
 	niu_lock_parent(np, flags);
-	n_entries = nfc->rule_cnt;
 	for (cnt = 0, i = 0; i < nfc->data; i++) {
 		idx = tcam_get_index(np, i);
 		tp = &parent->tcam[idx];
 		if (!tp->valid)
 			continue;
+		if (cnt == nfc->rule_cnt) {
+			ret = -EMSGSIZE;
+			break;
+		}
 		rule_locs[cnt] = i;
 		cnt++;
 	}
 	niu_unlock_parent(np, flags);
 
-	if (n_entries != cnt) {
-		/* print warning, this should not happen */
-		netdev_info(np->dev, "niu%d: In %s(): n_entries[%d] != cnt[%d]!!!\n",
-			    np->parent->index, __func__, n_entries, cnt);
-	}
-
-	return 0;
+	return ret;
 }
 
 static int niu_get_nfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
-- 
1.7.4.4

