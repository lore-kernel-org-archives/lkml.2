Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0IWIuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 04:50:08 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53713 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0IWIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 04:50:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-kernel@vger.kernel.org>
Cc: Linux Containers <containers@lists.osdl.org>, <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, <linux-fsdevel@vger.kernel.org>,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
Date: Thu, 23 Sep 2010 01:49:59 -0700
In-Reply-To: <m1ocborgq7.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Thu, 23 Sep 2010 01:45:04 -0700")
Message-ID: <m1sk10q1xk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 5/8] ns proc: Add support for the ipc namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/namespaces.c    |    3 +++
 include/linux/proc_fs.h |    1 +
 ipc/namespace.c         |   31 +++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 902443e..2f503b5 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -22,6 +22,9 @@ static const struct proc_ns_operations *ns_entries[] = {
 #ifdef CONFIG_UTS_NS
 	&utsns_operations,
 #endif
+#ifdef CONFIG_IPC_NS
+	&ipcns_operations,
+#endif
 };
 
 static const struct file_operations ns_file_operations = {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 28b4ffd..9a9ef31 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -264,6 +264,7 @@ struct proc_ns_operations {
 #define PROC_NSNAME(NAME) { .name = (NAME), .len = (sizeof(NAME) - 1), }
 extern const struct proc_ns_operations netns_operations;
 extern const struct proc_ns_operations utsns_operations;
+extern const struct proc_ns_operations ipcns_operations;
 extern struct file *proc_ns_fget(int fd);
 
 union proc_op {
diff --git a/ipc/namespace.c b/ipc/namespace.c
index a1094ff..2c5947f 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/proc_fs.h>
 
 #include "util.h"
 
@@ -132,3 +133,33 @@ void put_ipc_ns(struct ipc_namespace *ns)
 		free_ipc_ns(ns);
 	}
 }
+
+static void *ipcns_get(struct task_struct *task)
+{
+	struct ipc_namespace *ns;
+	rcu_read_lock();
+	ns = get_ipc_ns(task->nsproxy->ipc_ns);
+	rcu_read_unlock();
+	return ns;
+}
+
+static void ipcns_put(void *ns)
+{
+	return put_ipc_ns(ns);
+}
+
+static int ipcns_install(struct nsproxy *nsproxy, void *ns)
+{
+	/* Ditch state from the old ipc namespace */
+	exit_sem(current);
+	put_ipc_ns(nsproxy->ipc_ns);
+	nsproxy->ipc_ns = get_ipc_ns(ns);
+	return 0;
+}
+
+const struct proc_ns_operations ipcns_operations = {
+	.name		= PROC_NSNAME("ipc"),
+	.get		= ipcns_get,
+	.put		= ipcns_put,
+	.install	= ipcns_install,
+};
-- 
1.6.5.2.143.g8cc62

