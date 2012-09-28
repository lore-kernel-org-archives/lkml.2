Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033036Ab2I1VRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:17:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57878 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759327Ab2I1Uil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:38:41 -0400
X-Sasl-enc: dpTBbe/Vp6Q09RP6aqfgCtbc+2VPZTxZDyh1rrpRe2pu 1348864720
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [ 210/218] LockD: pass service to per-net up and down functions
Date: Fri, 28 Sep 2012 13:17:07 -0700
Message-Id: <20120928201525.676972448@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit 4db77695bf5738bdafa83d1b58b64cbecc6f55e7 upstream.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/lockd/svc.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -251,10 +251,9 @@ out_err:
 	return err;
 }
 
-static int lockd_up_net(struct net *net)
+static int lockd_up_net(struct svc_serv *serv, struct net *net)
 {
 	struct lockd_net *ln = net_generic(net, lockd_net_id);
-	struct svc_serv *serv = nlmsvc_rqst->rq_server;
 	int error;
 
 	if (ln->nlmsvc_users++)
@@ -276,10 +275,9 @@ err_rpcb:
 	return error;
 }
 
-static void lockd_down_net(struct net *net)
+static void lockd_down_net(struct svc_serv *serv, struct net *net)
 {
 	struct lockd_net *ln = net_generic(net, lockd_net_id);
-	struct svc_serv *serv = nlmsvc_rqst->rq_server;
 
 	if (ln->nlmsvc_users) {
 		if (--ln->nlmsvc_users == 0) {
@@ -307,7 +305,7 @@ int lockd_up(struct net *net)
 	 * Check whether we're already up and running.
 	 */
 	if (nlmsvc_rqst) {
-		error = lockd_up_net(net);
+		error = lockd_up_net(nlmsvc_rqst->rq_server, net);
 		goto out;
 	}
 
@@ -378,7 +376,7 @@ out:
 	return error;
 
 err_start:
-	lockd_down_net(net);
+	lockd_down_net(serv, net);
 	goto destroy_and_out;
 }
 EXPORT_SYMBOL_GPL(lockd_up);
@@ -390,7 +388,7 @@ void
 lockd_down(struct net *net)
 {
 	mutex_lock(&nlmsvc_mutex);
-	lockd_down_net(net);
+	lockd_down_net(nlmsvc_rqst->rq_server, net);
 	if (nlmsvc_users) {
 		if (--nlmsvc_users)
 			goto out;


