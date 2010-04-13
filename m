Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0DMXwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:52:25 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:59387 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab0DMXwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:52:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:in-reply-to
	:references; q=dns; s=drama; b=dNknF/hcxha/JbZcAqxHMsxqMDBBaT85y
	Bfetm0QEwlm2w5R7GXmY4Usm63pQDHDOp9phG9TGBAamTx4taEt24xVQ7XyjH3Dt
	kvF0boo+sAXhjqSqyMwMa3fXYXyG7WiA0Fpojs+Z3/mquNPdzntxDFvWVoOoOdpv
	BQbKMJ8MJo=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, yehudasa@gmail.com, sage@newdream.net,
       axboe@kernel.dk, Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH 4/6] ceph: enable creation of clients that don't need mds
Date: Tue, 13 Apr 2010 16:29:13 -0700
Message-Id: <61785ecd338c0f28826991d6d93feef130f6a6f4.1271198630.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1271201355-9346-1-git-send-email-yehuda@hq.newdream.net>
References: <1271201355-9346-1-git-send-email-yehuda@hq.newdream.net>
In-Reply-To: <6b8320ea22e059baaac6e4cdd3a0a687646de168.1271198630.git.yehuda@hq.newdream.net>
References: <6b8320ea22e059baaac6e4cdd3a0a687646de168.1271198630.git.yehuda@hq.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparing grounds for rbd that doesn't need mds client.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/ceph/debugfs.c    |   11 ++++++++---
 fs/ceph/mon_client.c |    3 ++-
 fs/ceph/super.c      |   15 ++++++++++-----
 fs/ceph/super.h      |    2 ++
 4 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index e159f14..0a60fa8 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -434,9 +434,14 @@ int ceph_debugfs_client_init(struct ceph_client *client)
 	if (!client->debugfs_congestion_kb)
 		goto out;
 
-	sprintf(name, "../../bdi/%s", dev_name(client->sb->s_bdi->dev));
-	client->debugfs_bdi = debugfs_create_symlink("bdi", client->debugfs_dir,
-						     name);
+	if (client->backing_dev_info.dev) {
+		sprintf(name, "../../bdi/%s",
+			dev_name(client->backing_dev_info.dev));
+		client->debugfs_bdi =
+			debugfs_create_symlink("bdi",
+					       client->debugfs_dir,
+					       name);
+	}
 
 	return 0;
 
diff --git a/fs/ceph/mon_client.c b/fs/ceph/mon_client.c
index 455c973..0419d42 100644
--- a/fs/ceph/mon_client.c
+++ b/fs/ceph/mon_client.c
@@ -776,7 +776,8 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 		break;
 
 	case CEPH_MSG_MDS_MAP:
-		ceph_mdsc_handle_map(&monc->client->mdsc, msg);
+		if (monc->client->have_mdsc)
+			ceph_mdsc_handle_map(&monc->client->mdsc, msg);
 		break;
 
 	case CEPH_MSG_OSD_MAP:
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 3ac0a90..4e7adf9 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -537,7 +537,8 @@ static void destroy_mount_args(struct ceph_mount_args *args)
 /*
  * create a fresh client instance
  */
-static struct ceph_client *ceph_create_client(struct ceph_mount_args *args)
+struct ceph_client *ceph_create_client(struct ceph_mount_args *args,
+				       int need_mdsc)
 {
 	struct ceph_client *client;
 	int err = -ENOMEM;
@@ -592,9 +593,13 @@ static struct ceph_client *ceph_create_client(struct ceph_mount_args *args)
 	err = ceph_osdc_init(&client->osdc, client);
 	if (err < 0)
 		goto fail_monc;
-	err = ceph_mdsc_init(&client->mdsc, client);
-	if (err < 0)
-		goto fail_osdc;
+	if (need_mdsc) {
+		err = ceph_mdsc_init(&client->mdsc, client);
+		if (err < 0)
+			goto fail_osdc;
+		client->have_mdsc = 1;
+	}
+
 	return client;
 
 fail_osdc:
@@ -903,7 +908,7 @@ static int ceph_get_sb(struct file_system_type *fs_type,
 	}
 
 	/* create client (which we may/may not use) */
-	client = ceph_create_client(args);
+	client = ceph_create_client(args, 1);
 	if (IS_ERR(client)) {
 		err = PTR_ERR(client);
 		goto out_final;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index b6c197d..78ee529 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -135,6 +135,8 @@ struct ceph_client {
 
 	int min_caps;                  /* min caps i added */
 
+	int have_mdsc;
+
 	struct ceph_messenger *msgr;   /* messenger instance */
 	struct ceph_mon_client monc;
 	struct ceph_mds_client mdsc;
-- 
1.5.6.5

