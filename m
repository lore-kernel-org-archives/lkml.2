Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2HMUUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:20:19 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:54680 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab2HMUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:04 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 13 Aug 2012 13:18:19 -0700
Message-Id: <1344889115-21610-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+wEFz/bAWPgVDJoF1kfPdaqv0svM/zFnQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 05/21] userns: Make seq_file's user namespace accessible
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

struct file already has a user namespace associated with it
in file->f_cred->user_ns, unfortunately because struct
seq_file has no struct file backpointer associated with
it, it is difficult to get at the user namespace in seq_file
context.  Therefore add a helper function seq_user_ns to return
the associated user namespace and a user_ns field to struct
seq_file to be used in implementing seq_user_ns.

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/seq_file.c            |    4 ++++
 include/linux/seq_file.h |   14 ++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 14cf9de..99dffab 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -9,6 +9,7 @@
 #include <linux/export.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/cred.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -56,6 +57,9 @@ int seq_open(struct file *file, const struct seq_operations *op)
 	memset(p, 0, sizeof(*p));
 	mutex_init(&p->lock);
 	p->op = op;
+#ifdef CONFIG_USER_NS
+	p->user_ns = file->f_cred->user_ns;
+#endif
 
 	/*
 	 * Wrappers around seq_open(e.g. swaps_open) need to be
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 83c44ee..68a04a3 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -13,6 +13,7 @@ struct file;
 struct path;
 struct inode;
 struct dentry;
+struct user_namespace;
 
 struct seq_file {
 	char *buf;
@@ -25,6 +26,9 @@ struct seq_file {
 	struct mutex lock;
 	const struct seq_operations *op;
 	int poll_event;
+#ifdef CONFIG_USER_NS
+	struct user_namespace *user_ns;
+#endif
 	void *private;
 };
 
@@ -128,6 +132,16 @@ int seq_put_decimal_ull(struct seq_file *m, char delimiter,
 int seq_put_decimal_ll(struct seq_file *m, char delimiter,
 			long long num);
 
+static inline struct user_namespace *seq_user_ns(struct seq_file *seq)
+{
+#ifdef CONFIG_USER_NS
+	return seq->user_ns;
+#else
+	extern struct user_namespace init_user_ns;
+	return &init_user_ns;
+#endif
+}
+
 #define SEQ_START_TOKEN ((void *)1)
 /*
  * Helpers for iteration over list_head-s in seq_files
-- 
1.7.5.4

