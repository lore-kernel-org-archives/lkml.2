Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761187Ab2J2Vgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:36:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:47222 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761132Ab2J2Vgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 020/101] LOCKD: Clear ln->nsm_clnt only when ln->nsm_users is zero
Date: Mon, 29 Oct 2012 14:34:33 -0700
Message-Id: <20121029213242.422393150@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit e498daa81295d02f7359af313c2b7f87e1062207 upstream.

The current code is clearing it in all cases _except_ when zero.

Reported-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/lockd/mon.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -124,18 +124,16 @@ out:
 static void nsm_client_put(struct net *net)
 {
 	struct lockd_net *ln = net_generic(net, lockd_net_id);
-	struct rpc_clnt	*clnt = ln->nsm_clnt;
-	int shutdown = 0;
+	struct rpc_clnt	*clnt = NULL;
 
 	spin_lock(&ln->nsm_clnt_lock);
-	if (ln->nsm_users) {
-		if (--ln->nsm_users)
-			ln->nsm_clnt = NULL;
-		shutdown = !ln->nsm_users;
+	ln->nsm_users--;
+	if (ln->nsm_users == 0) {
+		clnt = ln->nsm_clnt;
+		ln->nsm_clnt = NULL;
 	}
 	spin_unlock(&ln->nsm_clnt_lock);
-
-	if (shutdown)
+	if (clnt != NULL)
 		rpc_shutdown_client(clnt);
 }
 


