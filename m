Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314Ab0EUQ4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:56:43 -0400
Received: from kroah.org ([198.145.64.141]:39179 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934281Ab0EUQyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/38] kobj: Send hotplug events in the proper namespace.
Date: Fri, 21 May 2010 09:54:06 -0700
Message-Id: <1274460848-11377-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Utilize netlink_broacast_filtered to allow sending hotplug events
in the proper namespace.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject_uevent.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 9084f25..239c8e8 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -83,6 +83,22 @@ out:
 	return ret;
 }
 
+static int kobj_bcast_filter(struct sock *dsk, struct sk_buff *skb, void *data)
+{
+	struct kobject *kobj = data;
+	const struct kobj_ns_type_operations *ops;
+
+	ops = kobj_ns_ops(kobj);
+	if (ops) {
+		const void *sock_ns, *ns;
+		ns = kobj->ktype->namespace(kobj);
+		sock_ns = ops->netlink_ns(dsk);
+		return sock_ns != ns;
+	}
+
+	return 0;
+}
+
 /**
  * kobject_uevent_env - send an uevent with environmental data
  *
@@ -244,8 +260,10 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 			}
 
 			NETLINK_CB(skb).dst_group = 1;
-			retval = netlink_broadcast(uevent_sock, skb, 0, 1,
-						   GFP_KERNEL);
+			retval = netlink_broadcast_filtered(uevent_sock, skb,
+							    0, 1, GFP_KERNEL,
+							    kobj_bcast_filter,
+							    kobj);
 			/* ENOBUFS should be handled in userspace */
 			if (retval == -ENOBUFS)
 				retval = 0;
-- 
1.7.0.3

