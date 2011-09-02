Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445Ab1IBKCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:02:04 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33273 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352Ab1IBKA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:00:57 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 14/16] drbd: conn_khelper() for user mode callbacks for connections
Date: Fri,  2 Sep 2011 12:00:46 +0200
Message-Id: <1314957648-13242-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
References: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   87 ++++++++++++++++++++++++++++++++---------
 1 files changed, 68 insertions(+), 19 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 7389e37..8f427a1 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -285,43 +285,49 @@ static int drbd_adm_finish(struct genl_info *info, int retcode)
 	return 0;
 }
 
-int drbd_khelper(struct drbd_conf *mdev, char *cmd)
+static void setup_khelper_env(struct drbd_tconn *tconn, char **envp)
 {
-	char *envp[] = { "HOME=/",
-			"TERM=linux",
-			"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
-			NULL, /* Will be set to address family */
-			NULL, /* Will be set to address */
-			NULL };
-	char mb[12], af[20], ad[60], *afs;
-	char *argv[] = {usermode_helper, cmd, mb, NULL };
-	struct sib_info sib;
-	int ret;
+	char af[20], ad[60], *afs;
 
-	snprintf(mb, 12, "minor-%d", mdev_to_minor(mdev));
-
-	if (get_net_conf(mdev->tconn)) {
-		switch (((struct sockaddr *)mdev->tconn->net_conf->peer_addr)->sa_family) {
+	if (get_net_conf(tconn)) {
+		switch (((struct sockaddr *)tconn->net_conf->peer_addr)->sa_family) {
 		case AF_INET6:
 			afs = "ipv6";
 			snprintf(ad, 60, "DRBD_PEER_ADDRESS=%pI6",
-				 &((struct sockaddr_in6 *)mdev->tconn->net_conf->peer_addr)->sin6_addr);
+				 &((struct sockaddr_in6 *)tconn->net_conf->peer_addr)->sin6_addr);
 			break;
 		case AF_INET:
 			afs = "ipv4";
 			snprintf(ad, 60, "DRBD_PEER_ADDRESS=%pI4",
-				 &((struct sockaddr_in *)mdev->tconn->net_conf->peer_addr)->sin_addr);
+				 &((struct sockaddr_in *)tconn->net_conf->peer_addr)->sin_addr);
 			break;
 		default:
 			afs = "ssocks";
 			snprintf(ad, 60, "DRBD_PEER_ADDRESS=%pI4",
-				 &((struct sockaddr_in *)mdev->tconn->net_conf->peer_addr)->sin_addr);
+				 &((struct sockaddr_in *)tconn->net_conf->peer_addr)->sin_addr);
 		}
 		snprintf(af, 20, "DRBD_PEER_AF=%s", afs);
 		envp[3]=af;
 		envp[4]=ad;
-		put_net_conf(mdev->tconn);
+		put_net_conf(tconn);
 	}
+}
+
+int drbd_khelper(struct drbd_conf *mdev, char *cmd)
+{
+	char *envp[] = { "HOME=/",
+			"TERM=linux",
+			"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
+			NULL, /* Will be set to address family */
+			NULL, /* Will be set to address */
+			NULL };
+	char mb[12];
+	char *argv[] = {usermode_helper, cmd, mb, NULL };
+	struct sib_info sib;
+	int ret;
+
+	snprintf(mb, 12, "minor-%d", mdev_to_minor(mdev));
+	setup_khelper_env(mdev->tconn, envp);
 
 	/* The helper may take some time.
 	 * write out any unsynced meta data changes now */
@@ -350,6 +356,49 @@ int drbd_khelper(struct drbd_conf *mdev, char *cmd)
 	return ret;
 }
 
+static void conn_md_sync(struct drbd_tconn *tconn)
+{
+	struct drbd_conf *mdev;
+	int minor;
+
+	idr_for_each_entry(&tconn->volumes, mdev, minor)
+		drbd_md_sync(mdev);
+}
+
+int conn_khelper(struct drbd_tconn *tconn, char *cmd)
+{
+	char *envp[] = { "HOME=/",
+			"TERM=linux",
+			"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
+			NULL, /* Will be set to address family */
+			NULL, /* Will be set to address */
+			NULL };
+	char *argv[] = {usermode_helper, cmd, tconn->name, NULL };
+	int ret;
+
+	setup_khelper_env(tconn, envp);
+	conn_md_sync(tconn);
+
+	conn_info(tconn, "helper command: %s %s %s\n", usermode_helper, cmd, tconn->name);
+	/* TODO: conn_bcast_event() ?? */
+
+	ret = call_usermodehelper(usermode_helper, argv, envp, 1);
+	if (ret)
+		conn_warn(tconn, "helper command: %s %s %s exit code %u (0x%x)\n",
+			  usermode_helper, cmd, tconn->name,
+			  (ret >> 8) & 0xff, ret);
+	else
+		conn_info(tconn, "helper command: %s %s %s exit code %u (0x%x)\n",
+			  usermode_helper, cmd, tconn->name,
+			  (ret >> 8) & 0xff, ret);
+	/* TODO: conn_bcast_event() ?? */
+
+	if (ret < 0) /* Ignore any ERRNOs we got. */
+		ret = 0;
+
+	return ret;
+}
+
 enum drbd_disk_state drbd_try_outdate_peer(struct drbd_conf *mdev)
 {
 	char *ex_to_string;
-- 
1.7.4.1

