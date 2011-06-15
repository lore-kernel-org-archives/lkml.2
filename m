Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab1FOSv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 14:51:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63060 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1FOSvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 14:51:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=SZiehBp1aVu0vCV1+JpkETnIYskH3PiNGBNtS5hELLLju1nLvXz4SR2ftmjIDqTiSN
         bWMEpVYae+zcPI8jxF4vveyZXQuQtJl1Si7JYhtvwrTqRpp2Uqub2zqLS3t4NCy4C+bW
         1YIsjkg9M0b3FMBAuVdM/CTRSj+CEU6zBYpqA=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org
Subject: [RFC 3/5 v4] net: restore net_create and make it globally visible
Date: Wed, 15 Jun 2011 22:51:50 +0400
Message-Id: <1308163910-6104-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 911cb193f3eb0370f20fbba712211e55ffede4de and
makes net_create() globally visible.  net_create() will be needed
for fake_net in fs/proc/proc_net.c. 

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 include/net/net_namespace.h |    2 ++
 net/core/net_namespace.c    |   12 ++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 2bf9ed9..5d5328c 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -116,6 +116,8 @@ static inline struct net *copy_net_ns(unsigned long flags, struct net *net_ns)
 }
 #endif /* CONFIG_NET */
 
+extern struct net *net_create(void);
+
 
 extern struct list_head net_namespace_list;
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 6c6b86d..c90f0db 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -210,14 +210,11 @@ static void net_free(struct net *net)
 	kmem_cache_free(net_cachep, net);
 }
 
-struct net *copy_net_ns(unsigned long flags, struct net *old_net)
+struct net *net_create(void)
 {
 	struct net *net;
 	int rv;
 
-	if (!(flags & CLONE_NEWNET))
-		return get_net(old_net);
-
 	net = net_alloc();
 	if (!net)
 		return ERR_PTR(-ENOMEM);
@@ -236,6 +233,13 @@ struct net *copy_net_ns(unsigned long flags, struct net *old_net)
 	return net;
 }
 
+struct net *copy_net_ns(unsigned long flags, struct net *old_net)
+{
+	if (!(flags & CLONE_NEWNET))
+		return get_net(old_net);
+	return net_create();
+}
+
 static DEFINE_SPINLOCK(cleanup_list_lock);
 static LIST_HEAD(cleanup_list);  /* Must hold cleanup_list_lock to touch */
 
-- 
1.7.0.4

