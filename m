Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab0ELXSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:18:17 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:47899 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab0ELXQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:in-reply-to
	:references; q=dns; s=drama; b=sTzNrjdRd+5KqoA+nuEny1QVzMWPJNU4y
	JmacjnK4K3ajHFje6by562uBX9K271CAsTwes7DBJz41cys7eVEWyPKTnArDxtIi
	7DUfStT2EvN2iwIVzV5Rnc7PZRtdWBALPQSptng2YfbSxuaBKn22yqbHR7n+/ec+
	I5OEAxxeBI=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, sage@newdream.net,
       Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH 4/8] ceph: enable creation of clients that don't need mds
Date: Wed, 12 May 2010 16:23:36 -0700
Message-Id: <83824e77a2ffe898b8b784c8f8f2f09f5a3d7914.1273705398.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273706621-12822-1-git-send-email-yehuda@hq.newdream.net>
References: <1273706621-12822-1-git-send-email-yehuda@hq.newdream.net>
In-Reply-To: <ccf96c67246e67d3d9bd73d47777411cbfbb5cf0.1273705398.git.yehuda@hq.newdream.net>
References: <ccf96c67246e67d3d9bd73d47777411cbfbb5cf0.1273705398.git.yehuda@hq.newdream.net>
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
index 39a2bda..6bad024 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -439,9 +439,14 @@ int ceph_debugfs_client_init(struct ceph_client *client)
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
index a52d68c..9b56613 100644
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
index 30fa891..56fe97b 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -565,7 +565,8 @@ static void destroy_mount_args(struct ceph_mount_args *args)
 /*
  * create a fresh client instance
  */
-static struct ceph_client *ceph_create_client(struct ceph_mount_args *args)
+struct ceph_client *ceph_create_client(struct ceph_mount_args *args,
+				       int need_mdsc)
 {
 	struct ceph_client *client;
 	int err = -ENOMEM;
@@ -620,9 +621,13 @@ static struct ceph_client *ceph_create_client(struct ceph_mount_args *args)
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
@@ -934,7 +939,7 @@ static int ceph_get_sb(struct file_system_type *fs_type,
 	}
 
 	/* create client (which we may/may not use) */
-	client = ceph_create_client(args);
+	client = ceph_create_client(args, 1);
 	if (IS_ERR(client)) {
 		err = PTR_ERR(client);
 		goto out_final;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 01b640d..429f6b7 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -137,6 +137,8 @@ struct ceph_client {
 
 	int min_caps;                  /* min caps i added */
 
+	int have_mdsc;
+
 	struct ceph_messenger *msgr;   /* messenger instance */
 	struct ceph_mon_client monc;
 	struct ceph_mds_client mdsc;
-- 
1.5.6.5

