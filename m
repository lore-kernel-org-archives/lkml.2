Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab2KZRAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:00:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47054 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab2KZRAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:00:43 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Engelhardt <jengelh@inai.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 014/270] netfilter: xt_limit: have r->cost != 0 case work
Date: Mon, 26 Nov 2012 14:55:04 -0200
Message-Id: <1353949160-26803-15-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Engelhardt <jengelh@inai.de>

commit 82e6bfe2fbc4d48852114c4f979137cd5bf1d1a8 upstream.

Commit v2.6.19-rc1~1272^2~41 tells us that r->cost != 0 can happen when
a running state is saved to userspace and then reinstated from there.

Make sure that private xt_limit area is initialized with correct values.
Otherwise, random matchings due to use of uninitialized memory.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/netfilter/xt_limit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 5c22ce8..a4c1e45 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -117,11 +117,11 @@ static int limit_mt_check(const struct xt_mtchk_param *par)
 
 	/* For SMP, we only want to use one set of state. */
 	r->master = priv;
+	/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
+	   128. */
+	priv->prev = jiffies;
+	priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
 	if (r->cost == 0) {
-		/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
-		   128. */
-		priv->prev = jiffies;
-		priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
 		r->credit_cap = priv->credit; /* Credits full. */
 		r->cost = user2credits(r->avg);
 	}
-- 
1.7.9.5

