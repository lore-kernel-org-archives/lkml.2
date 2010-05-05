Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934669Ab0EEAiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:38:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46815 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934614Ab0EEAhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:37:05 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>, <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue,  4 May 2010 17:36:44 -0700
Message-Id: <1273019809-16472-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1fx3hk6gw.fsf@fess.ebiederm.org>
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: gregkh@suse.de, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, eric.dumazet@gmail.com, bcrl@lhnet.ca, serue@us.ibm.com, netdev@vger.kernel.org, davem@davemloft.net, ebiederm@xmission.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 1/6] kobject: Send hotplug events in all network namespaces
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Open a copy of the uevent kernel socket in each network
namespace so we can send uevents in all network namespaces.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 lib/kobject_uevent.c |   68 ++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index c9d3a3e..3f5f17b 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -23,13 +23,19 @@
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
 #include <net/sock.h>
+#include <net/net_namespace.h>
 
 
 u64 uevent_seqnum;
 char uevent_helper[UEVENT_HELPER_PATH_LEN] = CONFIG_UEVENT_HELPER_PATH;
 static DEFINE_SPINLOCK(sequence_lock);
-#if defined(CONFIG_NET)
-static struct sock *uevent_sock;
+#ifdef CONFIG_NET
+struct uevent_sock {
+	struct list_head list;
+	struct sock *sk;
+};
+static LIST_HEAD(uevent_sock_list);
+static DEFINE_MUTEX(uevent_sock_mutex);
 #endif
 
 /* the strings here must match the enum in include/linux/kobject.h */
@@ -99,6 +105,9 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	u64 seq;
 	int i = 0;
 	int retval = 0;
+#ifdef CONFIG_NET
+	struct uevent_sock *ue_sk;
+#endif
 
 	pr_debug("kobject: '%s' (%p): %s\n",
 		 kobject_name(kobj), kobj, __func__);
@@ -210,7 +219,9 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 
 #if defined(CONFIG_NET)
 	/* send netlink message */
-	if (uevent_sock) {
+	mutex_lock(&uevent_sock_mutex);
+	list_for_each_entry(ue_sk, &uevent_sock_list, list) {
+		struct sock *uevent_sock = ue_sk->sk;
 		struct sk_buff *skb;
 		size_t len;
 
@@ -240,6 +251,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 		} else
 			retval = -ENOMEM;
 	}
+	mutex_unlock(&uevent_sock_mutex);
 #endif
 
 	/* call uevent_helper, usually only enabled during early boot */
@@ -319,18 +331,58 @@ int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
 EXPORT_SYMBOL_GPL(add_uevent_var);
 
 #if defined(CONFIG_NET)
-static int __init kobject_uevent_init(void)
+static int uevent_net_init(struct net *net)
 {
-	uevent_sock = netlink_kernel_create(&init_net, NETLINK_KOBJECT_UEVENT,
-					    1, NULL, NULL, THIS_MODULE);
-	if (!uevent_sock) {
+	struct uevent_sock *ue_sk;
+
+	ue_sk = kzalloc(sizeof(*ue_sk), GFP_KERNEL);
+	if (!ue_sk)
+		return -ENOMEM;
+
+	ue_sk->sk = netlink_kernel_create(net, NETLINK_KOBJECT_UEVENT,
+					  1, NULL, NULL, THIS_MODULE);
+	if (!ue_sk->sk) {
 		printk(KERN_ERR
 		       "kobject_uevent: unable to create netlink socket!\n");
 		return -ENODEV;
 	}
-	netlink_set_nonroot(NETLINK_KOBJECT_UEVENT, NL_NONROOT_RECV);
+	mutex_lock(&uevent_sock_mutex);
+	list_add_tail(&ue_sk->list, &uevent_sock_list);
+	mutex_unlock(&uevent_sock_mutex);
 	return 0;
 }
 
+static void uevent_net_exit(struct net *net)
+{
+	struct uevent_sock *ue_sk;
+
+	mutex_lock(&uevent_sock_mutex);
+	list_for_each_entry(ue_sk, &uevent_sock_list, list) {
+		if (sock_net(ue_sk->sk) == net)
+			goto found;
+	}
+	mutex_unlock(&uevent_sock_mutex);
+	return;
+
+found:
+	list_del(&ue_sk->list);
+	mutex_unlock(&uevent_sock_mutex);
+
+	netlink_kernel_release(ue_sk->sk);
+	kfree(ue_sk);
+}
+
+static struct pernet_operations uevent_net_ops = {
+	.init	= uevent_net_init,
+	.exit	= uevent_net_exit,
+};
+
+static int __init kobject_uevent_init(void)
+{
+	netlink_set_nonroot(NETLINK_KOBJECT_UEVENT, NL_NONROOT_RECV);
+	return register_pernet_subsys(&uevent_net_ops);
+}
+
+
 postcore_initcall(kobject_uevent_init);
 #endif
-- 
1.6.5.2.143.g8cc62

