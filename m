Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab1EFAiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:38:25 -0400
Received: from kroah.org ([198.145.64.141]:37353 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507Ab1EFA0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:18 2011
Message-Id: <20110506002218.146106510@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [131/143] niu: Fix kernel buffer overflow for ETHTOOL_GRXCLSRLALL
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

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
[Adjusted to apply to 2.6.32 by dann frazier <dannf@debian.org>]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/niu.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -7315,33 +7315,28 @@ static int niu_get_ethtool_tcam_all(stru
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
-		pr_info(PFX "niu%d: %s In niu_get_ethtool_tcam_all, "
-			"n_entries[%d] != cnt[%d]!!!\n\n",
-			np->parent->index, np->dev->name, n_entries, cnt);
-	}
-
-	return 0;
+	return ret;
 }
 
 static int niu_get_nfc(struct net_device *dev, struct ethtool_rxnfc *cmd,


