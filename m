Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab0GGVvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:51:39 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:34452 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838Ab0GGVu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:in-reply-to
	:references; q=dns; s=drama; b=ih9ddB8AqcCEQzs/ppGJpuHsgqS90eLUb
	Kipmclo2Ws1ouqnsvWj5f2/Ipe+8T5DqeqdsMzQA6t7sf4rHNBj0BQw+mwMcJ4SD
	KXOfU4naRnRAUIALl+RlmoGDNo2LIY4ZWGRfyI1SnH0nySiKgXtF7Tz2B0PLW17o
	ZyJbEdPJz0=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       sage@newdream.net, Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH v3 07/10] ceph-rbd: some super.c changes for rbd
Date: Wed,  7 Jul 2010 15:11:29 -0700
Message-Id: <c9e952a6a2df81af04c902562e0fafc6afa43d23.1278539315.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1278539315.git.yehuda@hq.newdream.net>
References: <cover.1278539315.git.yehuda@hq.newdream.net>
In-Reply-To: <cover.1278539315.git.yehuda@hq.newdream.net>
References: <cover.1278539315.git.yehuda@hq.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - add 'snap' mount option
 - add ceph_client_id helper

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/super.c |   19 ++++++++++++++++++-
 fs/ceph/super.h |    2 ++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 43b1589..acff12f 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -342,6 +342,7 @@ enum {
 	Opt_snapdirname,
 	Opt_name,
 	Opt_secret,
+	Opt_snap,
 	Opt_last_string,
 	/* string args above */
 	Opt_ip,
@@ -374,6 +375,7 @@ static match_table_t arg_tokens = {
 	{Opt_snapdirname, "snapdirname=%s"},
 	{Opt_name, "name=%s"},
 	{Opt_secret, "secret=%s"},
+	{Opt_snap, "snap=%s"},
 	/* string args above */
 	{Opt_ip, "ip=%s"},
 	{Opt_noshare, "noshare"},
@@ -508,6 +510,11 @@ struct ceph_mount_args *parse_mount_args(int flags, char *options,
 						argstr[0].to-argstr[0].from,
 						GFP_KERNEL);
 			break;
+		case Opt_snap:
+			args->snap = kstrndup(argstr[0].from,
+					      argstr[0].to-argstr[0].from,
+					      GFP_KERNEL);
+			break;
 
 			/* misc */
 		case Opt_wsize:
@@ -582,6 +589,7 @@ void ceph_destroy_mount_args(struct ceph_mount_args *args)
 	kfree(args->snapdir_name);
 	kfree(args->name);
 	kfree(args->secret);
+	kfree(args->snap);
 	kfree(args);
 }
 
@@ -621,6 +629,10 @@ int ceph_compare_mount_args(struct ceph_mount_args *new_args,
 	if (ret)
 		return ret;
 
+	ret = strcmp_null(args1->snap, args2->snap);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < args1->num_mon; i++) {
 		if (ceph_monmap_contains(client->monc.monmap,
 				 &args1->mon_addr[i]))
@@ -717,6 +729,11 @@ fail:
 	return ERR_PTR(err);
 }
 
+u64 ceph_client_id(struct ceph_client *client)
+{
+	return client->monc.auth->global_id;
+}
+
 void ceph_destroy_client(struct ceph_client *client)
 {
 	dout("destroy_client %p\n", client);
@@ -767,7 +784,7 @@ int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid)
 		}
 	} else {
 		pr_info("client%lld fsid " FSID_FORMAT "\n",
-			client->monc.auth->global_id, PR_FSID(fsid));
+			ceph_client_id(client), PR_FSID(fsid));
 		memcpy(&client->fsid, fsid, sizeof(*fsid));
 		ceph_debugfs_client_init(client);
 		client->have_fsid = true;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ee67b81..67d5b75 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -74,6 +74,7 @@ struct ceph_mount_args {
 	char *snapdir_name;   /* default ".snap" */
 	char *name;
 	char *secret;
+	char *snap;	/* rbd snapshot */
 };
 
 /*
@@ -751,6 +752,7 @@ extern int ceph_compare_mount_args(struct ceph_mount_args *new_args,
 			    struct ceph_client *client);
 extern struct ceph_client *ceph_create_client(struct ceph_mount_args *args,
 					      int need_mdsc);
+extern u64 ceph_client_id(struct ceph_client *client);
 extern void ceph_destroy_client(struct ceph_client *client);
 extern int ceph_open_session(struct ceph_client *client);
 
-- 
1.5.6.5

