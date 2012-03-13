Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab2CMBJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:09:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:46515 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab2CMAR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 008/196] myri10ge: fix rmmod crash
Date: Mon, 12 Mar 2012 20:12:16 -0400
Message-Id: <1331597724-31358-9-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cda6587c21a887254c8ed4b58da8fcc4040ab557 upstream.

Rmmod myri10ge crash at free_netdev() -> netif_napi_del(), because napi
structures are already deallocated. To fix call netif_napi_del() before
kfree() at myri10ge_free_slices().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/myri10ge/myri10ge.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index ecde087..649b8db6 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -3600,6 +3600,7 @@ static void myri10ge_free_slices(struct myri10ge_priv *mgp)
 			dma_free_coherent(&pdev->dev, bytes,
 					  ss->fw_stats, ss->fw_stats_bus);
 			ss->fw_stats = NULL;
+			netif_napi_del(&ss->napi);
 		}
 	}
 	kfree(mgp->ss);
-- 
1.7.9.3

