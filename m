Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0IWIrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 04:47:51 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53550 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab0IWIrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 04:47:49 -0400
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
Date: Thu, 23 Sep 2010 01:47:42 -0700
In-Reply-To: <m1ocborgq7.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Thu, 23 Sep 2010 01:45:04 -0700")
Message-ID: <m17hicrglt.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 3/8] ns proc: Add support for the network namespace.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Implementing file descriptors for the network namespace is simple and
straight forward.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/namespaces.c     |    3 +++
 include/linux/proc_fs.h  |    1 +
 net/core/net_namespace.c |   30 ++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index f33537f..31e32f3 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -16,6 +16,9 @@
 
 
 static const struct proc_ns_operations *ns_entries[] = {
+#ifdef CONFIG_NET_NS
+	&netns_operations,
+#endif
 };
 
 static const struct file_operations ns_file_operations = {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index a6c26f0..9cd3fae 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -262,6 +262,7 @@ struct proc_ns_operations {
 	int (*install)(struct nsproxy *nsproxy, void *ns);
 };
 #define PROC_NSNAME(NAME) { .name = (NAME), .len = (sizeof(NAME) - 1), }
+extern const struct proc_ns_operations netns_operations;
 extern struct file *proc_ns_fget(int fd);
 
 union proc_op {
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index c988e68..581a088 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -571,3 +571,33 @@ void unregister_pernet_device(struct pernet_operations *ops)
 	mutex_unlock(&net_mutex);
 }
 EXPORT_SYMBOL_GPL(unregister_pernet_device);
+
+#ifdef CONFIG_NET_NS
+static void *netns_get(struct task_struct *task)
+{
+	struct net *net;
+	rcu_read_lock();
+	net = get_net(task->nsproxy->net_ns);
+	rcu_read_unlock();
+	return net;
+}
+
+static void netns_put(void *ns)
+{
+	put_net(ns);
+}
+
+static int netns_install(struct nsproxy *nsproxy, void *ns)
+{
+	put_net(nsproxy->net_ns);
+	nsproxy->net_ns = get_net(ns);
+	return 0;
+}
+
+const struct proc_ns_operations netns_operations = {
+	.name		= PROC_NSNAME("net"),
+	.get		= netns_get,
+	.put		= netns_put,
+	.install	= netns_install,
+};
+#endif
-- 
1.6.5.2.143.g8cc62

