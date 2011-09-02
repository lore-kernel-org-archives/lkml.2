Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab1IBT7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:59:48 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:39505 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755227Ab1IBTz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:55:59 -0400
From: Serge Hallyn <serge@hallyn.com>
To: akpm@osdl.org, segooon@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        dhowells@redhat.com, ebiederm@xmission.com, rdunlap@xenotime.net
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [PATCH 05/15] userns: clamp down users of cap_raised
Date: Fri,  2 Sep 2011 19:56:30 +0000
Message-Id: <1314993400-6910-8-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314993400-6910-1-git-send-email-serge@hallyn.com>
References: <1314993400-6910-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Serge E. Hallyn" <serge.hallyn@canonical.com>

A few modules are using cap_raised(current_cap(), cap) to authorize
actions, but the privilege should be applicable against the initial
user namespace.  Refuse privilege if the caller is not in init_user_ns.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/block/drbd/drbd_nl.c           |    5 +++++
 drivers/md/dm-log-userspace-transfer.c |    3 +++
 drivers/staging/pohmelfs/config.c      |    3 +++
 drivers/video/uvesafb.c                |    3 +++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0feab26..9a87a14 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2297,6 +2297,11 @@ static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms
 		return;
 	}
 
+	if (current_user_ns() != &init_user_ns) {
+		retcode = ERR_PERM;
+		goto fail;
+	}
+
 	if (!cap_raised(current_cap(), CAP_SYS_ADMIN)) {
 		retcode = ERR_PERM;
 		goto fail;
diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index 1f23e04..140ca81 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -134,6 +134,9 @@ static void cn_ulog_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
 	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
 
+	if (current_user_ns() != &init_user_ns)
+		return;
+
 	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
 		return;
 
diff --git a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
index b6c42cb..cd259d0 100644
--- a/drivers/staging/pohmelfs/config.c
+++ b/drivers/staging/pohmelfs/config.c
@@ -525,6 +525,9 @@ static void pohmelfs_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *n
 {
 	int err;
 
+	if (current_user_ns() != &init_user_ns)
+		return;
+
 	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
 		return;
 
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 7f8472c..71dab8e 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -73,6 +73,9 @@ static void uvesafb_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *ns
 	struct uvesafb_task *utask;
 	struct uvesafb_ktask *task;
 
+	if (current_user_ns() != &init_user_ns)
+		return;
+
 	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
 		return;
 
-- 
1.7.5.4

