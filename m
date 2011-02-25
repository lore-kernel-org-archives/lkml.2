Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1BYSxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:53:15 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36182 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab1BYSxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:53:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=E8yv1aemNM0ho6Hwv2tYFcwqz83CknW9FVbKIU0Q77urT/MeoQuwSnPqRZ779HTX9H
         wA2f7jv+Bq5J/3hrq5nqPfzne6wVrSlq83GUjNKMYyQNM+rajUe92kc/KfztrBP7AfwC
         PfQu6ZyLgkk/NshUYHv2X9jPijIYRbqwnj1Wg=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Octavian Purdila <tavi@cs.pub.ro>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 3/9] sysctl: add netns_proc_dointvec and similar handlers
Date: Fri, 25 Feb 2011 20:52:35 +0200
Message-Id: <1298659961-23863-4-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.4.rc1.7.g2cf08.dirty
In-Reply-To: <1298659961-23863-1-git-send-email-lucian.grijincu@gmail.com>
References: <1298659961-23863-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 include/net/net_namespace.h |   26 ++++++++++++++++++++++++++
 net/sysctl_net.c            |   31 +++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 1bf812b..0b7d37d 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -276,4 +276,30 @@ extern struct ctl_table_header *register_net_sysctl_rotable(
 	const struct ctl_path *path, struct ctl_table *table);
 extern void unregister_net_sysctl_table(struct ctl_table_header *header);
 
+/* similar to the versions without 'netns', with these remarks:
+ * - these handlers receive as cookie a 'struct net*'
+ * - the data field of ctl_table* must be of the form
+ *    &init_net.member1.member2..memberN
+ * - these handlers will call their equivalent handler with a
+ *   ctl_table with data of the form: net->member1.member2..memberN
+ */
+extern int netns_proc_dostring(struct ctl_table *,
+		int, void __user *, size_t *, loff_t *, void *net);
+extern int netns_proc_dointvec(struct ctl_table *, int,
+		void __user *, size_t *, loff_t *, void *net);
+extern int netns_proc_dointvec_minmax(struct ctl_table *, int,
+		void __user *, size_t *, loff_t *, void *net);
+extern int netns_proc_dointvec_jiffies(struct ctl_table *, int,
+		void __user *, size_t *, loff_t *, void *net);
+extern int netns_proc_dointvec_userhz_jiffies(struct ctl_table *, int,
+		void __user *, size_t *, loff_t *, void *net);
+extern int netns_proc_dointvec_ms_jiffies(struct ctl_table *, int,
+		void __user *, size_t *, loff_t *, void *net);
+extern int netns_proc_doulongvec_minmax(struct ctl_table *, int,
+		void __user *, size_t *, loff_t *, void *net);
+extern int netns_proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
+		void __user *, size_t *, loff_t *, void *net);
+extern int netns_proc_do_large_bitmap(struct ctl_table *, int,
+		void __user *, size_t *, loff_t *, void *net);
+
 #endif /* __NET_NET_NAMESPACE_H */
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index 9dadd17..60b36ad 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -127,3 +127,34 @@ void unregister_net_sysctl_table(struct ctl_table_header *header)
 	unregister_sysctl_table(header);
 }
 EXPORT_SYMBOL_GPL(unregister_net_sysctl_table);
+
+
+
+static int netns_proc_wrapper(struct ctl_table *table, int write,
+			      void __user *buffer, size_t *lenp,
+			      loff_t *ppos, void *net, proc_handler proc_handler)
+{
+	struct ctl_table tmp = *table;
+	tmp.data += (char *)net - (char *)&init_net;
+	return ((proc_handler_cookie*) proc_handler)(&tmp, write, buffer, lenp, ppos, NULL);
+}
+
+
+#define NETNS_PROC_WRAP(handler_name)					\
+	int netns_##handler_name(struct ctl_table *table, int write,	\
+				 void __user *buffer, size_t *lenp,	\
+				 loff_t *ppos, void *net)		\
+	{								\
+		return netns_proc_wrapper(table, write, buffer, lenp,	\
+					  ppos, net, handler_name);	\
+	}								\
+	EXPORT_SYMBOL_GPL(netns_##handler_name);
+
+NETNS_PROC_WRAP(proc_dointvec);
+NETNS_PROC_WRAP(proc_dointvec_minmax);
+NETNS_PROC_WRAP(proc_dointvec_jiffies);
+NETNS_PROC_WRAP(proc_dointvec_userhz_jiffies);
+NETNS_PROC_WRAP(proc_dointvec_ms_jiffies);
+NETNS_PROC_WRAP(proc_doulongvec_minmax)
+NETNS_PROC_WRAP(proc_doulongvec_ms_jiffies_minmax);
+NETNS_PROC_WRAP(proc_do_large_bitmap);
-- 
1.7.4.rc1.7.g2cf08.dirty

