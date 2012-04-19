Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2DSK5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 06:57:31 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:42906 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab2DSK5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 06:57:30 -0400
Subject: [PATCH] SUNRPC: skip dead but not buried clients on PipeFS events
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Thu, 19 Apr 2012 14:57:18 +0400
Message-ID: <20120419105707.32131.79719.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These clients can't be safely dereferenced if their counter in 0.

Signee-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 net/sunrpc/clnt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 6797246..591994d 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -218,7 +218,8 @@ static struct rpc_clnt *rpc_get_client_for_event(struct net *net, int event)
 		if (((event == RPC_PIPEFS_MOUNT) && clnt->cl_dentry) ||
 		    ((event == RPC_PIPEFS_UMOUNT) && !clnt->cl_dentry))
 			continue;
-		atomic_inc(&clnt->cl_count);
+		if (atomic_inc_return(&clnt->cl_count) == 1)
+			continue;
 		spin_unlock(&sn->rpc_client_lock);
 		return clnt;
 	}

