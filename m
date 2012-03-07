Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab2CGJzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:55:55 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:4928 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab2CGJzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 04:55:53 -0500
From: Andrew Vagin <avagin@openvz.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Cc: avagin@openvz.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] uevent: send events in correct order according to seqnum (v2)
Date: Wed,  7 Mar 2012 13:59:02 +0400
Message-Id: <1331114342-6187-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The queue handling in the udev daemon assumes that the events are
ordered.

Before this patch uevent_seqnum is incremented under sequence_lock,
than an event is send uner uevent_sock_mutex. I want to say that code
contained a window between incrementing seqnum and sending an event.

This patch locks uevent_sock_mutex before incrementing uevent_seqnum.

v2: delete sequence_lock, uevent_seqnum is protected by uevent_sock_mutex

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 lib/kobject_uevent.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index e66e9b6..15a7ab9 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -29,16 +29,17 @@
 
 u64 uevent_seqnum;
 char uevent_helper[UEVENT_HELPER_PATH_LEN] = CONFIG_UEVENT_HELPER_PATH;
-static DEFINE_SPINLOCK(sequence_lock);
 #ifdef CONFIG_NET
 struct uevent_sock {
 	struct list_head list;
 	struct sock *sk;
 };
 static LIST_HEAD(uevent_sock_list);
-static DEFINE_MUTEX(uevent_sock_mutex);
 #endif
 
+/* This lock protects uevent_seqnum and uevent_sock_list */
+static DEFINE_MUTEX(uevent_sock_mutex);
+
 /* the strings here must match the enum in include/linux/kobject.h */
 static const char *kobject_actions[] = {
 	[KOBJ_ADD] =		"add",
@@ -136,7 +137,6 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	struct kobject *top_kobj;
 	struct kset *kset;
 	const struct kset_uevent_ops *uevent_ops;
-	u64 seq;
 	int i = 0;
 	int retval = 0;
 #ifdef CONFIG_NET
@@ -243,17 +243,14 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	else if (action == KOBJ_REMOVE)
 		kobj->state_remove_uevent_sent = 1;
 
+	mutex_lock(&uevent_sock_mutex);
 	/* we will send an event, so request a new sequence number */
-	spin_lock(&sequence_lock);
-	seq = ++uevent_seqnum;
-	spin_unlock(&sequence_lock);
-	retval = add_uevent_var(env, "SEQNUM=%llu", (unsigned long long)seq);
+	retval = add_uevent_var(env, "SEQNUM=%llu", (unsigned long long)++uevent_seqnum);
 	if (retval)
 		goto exit;
 
 #if defined(CONFIG_NET)
 	/* send netlink message */
-	mutex_lock(&uevent_sock_mutex);
 	list_for_each_entry(ue_sk, &uevent_sock_list, list) {
 		struct sock *uevent_sock = ue_sk->sk;
 		struct sk_buff *skb;
@@ -290,8 +287,8 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 		} else
 			retval = -ENOMEM;
 	}
-	mutex_unlock(&uevent_sock_mutex);
 #endif
+	mutex_unlock(&uevent_sock_mutex);
 
 	/* call uevent_helper, usually only enabled during early boot */
 	if (uevent_helper[0] && !kobj_usermode_filter(kobj)) {
-- 
1.7.1

