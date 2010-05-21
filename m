Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322Ab0EUQ43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:56:29 -0400
Received: from kroah.org ([198.145.64.141]:39181 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934285Ab0EUQym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/38] hotplug: netns aware uevent_helper
Date: Fri, 21 May 2010 09:54:07 -0700
Message-Id: <1274460848-11377-37-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

It only makes sense for uevent_helper to get events
in the intial namespaces.  It's invocation is not
per namespace and it is not clear how we could make
it's invocation namespace aware.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject_uevent.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 239c8e8..59c1551 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -19,7 +19,7 @@
 #include <linux/kobject.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-
+#include <linux/user_namespace.h>
 #include <linux/socket.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
@@ -99,6 +99,21 @@ static int kobj_bcast_filter(struct sock *dsk, struct sk_buff *skb, void *data)
 	return 0;
 }
 
+static int kobj_usermode_filter(struct kobject *kobj)
+{
+	const struct kobj_ns_type_operations *ops;
+
+	ops = kobj_ns_ops(kobj);
+	if (ops) {
+		const void *init_ns, *ns;
+		ns = kobj->ktype->namespace(kobj);
+		init_ns = ops->initial_ns();
+		return ns != init_ns;
+	}
+
+	return 0;
+}
+
 /**
  * kobject_uevent_env - send an uevent with environmental data
  *
@@ -274,7 +289,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 #endif
 
 	/* call uevent_helper, usually only enabled during early boot */
-	if (uevent_helper[0]) {
+	if (uevent_helper[0] && !kobj_usermode_filter(kobj)) {
 		char *argv [3];
 
 		argv [0] = uevent_helper;
-- 
1.7.0.3

