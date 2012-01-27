Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab2A0Ezm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:55:42 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56524 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab2A0Ete (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:49:34 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 15/29] sysctl: Initial support for auto-unregistering sysctl tables.
Date: Thu, 26 Jan 2012 20:51:51 -0800
Message-Id: <1327639925-12920-15-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/w5wB0RiYlQHcRVK3vwU6T/nPS62Cxzro=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nreg to ctl_table_header.  When nreg drops to 0 the ctl_table_header
will be unregistered.

Factor out drop_sysctl_table from unregister_sysctl_table, and add
the logic for decrementing nreg.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c  |   28 +++++++++++++++++++---------
 include/linux/sysctl.h |    1 +
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 1544485..13faa48 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -29,8 +29,9 @@ static struct ctl_table root_table[1];
 static struct ctl_table_root sysctl_table_root;
 static struct ctl_table_header root_table_header = {
 	{{.count = 1,
-	.ctl_table = root_table,
-	.ctl_entry = LIST_HEAD_INIT(sysctl_table_root.default_set.list),}},
+	  .nreg = 1,
+	  .ctl_table = root_table,
+	  .ctl_entry = LIST_HEAD_INIT(sysctl_table_root.default_set.list),}},
 	.root = &sysctl_table_root,
 	.set = &sysctl_table_root.default_set,
 };
@@ -938,6 +939,7 @@ struct ctl_table_header *__register_sysctl_table(
 	header->unregistering = NULL;
 	header->root = root;
 	header->count = 1;
+	header->nreg = 1;
 	if (sysctl_check_table(path, table))
 		goto fail;
 
@@ -1192,6 +1194,20 @@ struct ctl_table_header *register_sysctl_table(struct ctl_table *table)
 }
 EXPORT_SYMBOL(register_sysctl_table);
 
+static void drop_sysctl_table(struct ctl_table_header *header)
+{
+	if (--header->nreg)
+		return;
+
+	start_unregistering(header);
+	if (!--header->parent->count) {
+		WARN_ON(1);
+		kfree_rcu(header->parent, rcu);
+	}
+	if (!--header->count)
+		kfree_rcu(header, rcu);
+}
+
 /**
  * unregister_sysctl_table - unregister a sysctl table hierarchy
  * @header: the header returned from register_sysctl_table
@@ -1224,13 +1240,7 @@ void unregister_sysctl_table(struct ctl_table_header * header)
 	}
 
 	spin_lock(&sysctl_lock);
-	start_unregistering(header);
-	if (!--header->parent->count) {
-		WARN_ON(1);
-		kfree_rcu(header->parent, rcu);
-	}
-	if (!--header->count)
-		kfree_rcu(header, rcu);
+	drop_sysctl_table(header);
 	spin_unlock(&sysctl_lock);
 }
 EXPORT_SYMBOL(unregister_sysctl_table);
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 094bc5c..e40b8f6 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1032,6 +1032,7 @@ struct ctl_table_header
 			struct list_head ctl_entry;
 			int used;
 			int count;
+			int nreg;
 		};
 		struct rcu_head rcu;
 	};
-- 
1.7.2.5

