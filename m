Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab1HXSd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:33:59 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:43228 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab1HXSd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:33:57 -0400
Subject: [PATCH 2/5] SUNRPC: use reference count helpers
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, davem@davemloft.net
Date: Wed, 24 Aug 2011 22:33:52 +0400
Message-ID: <20110824183352.4924.51863.stgit@localhost6.localdomain6>
In-Reply-To: <20110824183304.4924.94670.stgit@localhost6.localdomain6>
References: <20110824183304.4924.94670.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All is simple: we just increase users conters if rpcbind clients are present
already. Otherwise we create new rpcbind clients and set users counter to 1.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 net/sunrpc/rpcb_clnt.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index c84e6a3..b4cc0f1 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -256,9 +256,7 @@ static int rpcb_create_local_unix(void)
 		clnt4 = NULL;
 	}
 
-	/* Protected by rpcb_create_local_mutex */
-	rpcb_local_clnt = clnt;
-	rpcb_local_clnt4 = clnt4;
+	rpcb_set_local(clnt, clnt4);
 
 out:
 	return result;
@@ -310,9 +308,7 @@ static int rpcb_create_local_net(void)
 		clnt4 = NULL;
 	}
 
-	/* Protected by rpcb_create_local_mutex */
-	rpcb_local_clnt = clnt;
-	rpcb_local_clnt4 = clnt4;
+	rpcb_set_local(clnt, clnt4);
 
 out:
 	return result;
@@ -327,11 +323,11 @@ static int rpcb_create_local(void)
 	static DEFINE_MUTEX(rpcb_create_local_mutex);
 	int result = 0;
 
-	if (rpcb_local_clnt)
+	if (rpcb_get_local())
 		return result;
 
 	mutex_lock(&rpcb_create_local_mutex);
-	if (rpcb_local_clnt)
+	if (rpcb_get_local())
 		goto out;
 
 	if (rpcb_create_local_unix() != 0)

