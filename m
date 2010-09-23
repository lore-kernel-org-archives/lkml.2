Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0IWIvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 04:51:38 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57542 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab0IWIvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 04:51:35 -0400
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
Date: Thu, 23 Sep 2010 01:51:30 -0700
In-Reply-To: <m1ocborgq7.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Thu, 23 Sep 2010 01:45:04 -0700")
Message-ID: <m1hbhgq1v1.fsf@fess.ebiederm.org>
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
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 7/8] net: Allow setting the network namespace by fd
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Take advantage of the new abstraction and allow network devices
to be placed in any network namespace that we have a fd to talk
about.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/if_link.h     |    1 +
 include/net/net_namespace.h |    1 +
 net/core/net_namespace.c    |   26 ++++++++++++++++++++++++++
 net/core/rtnetlink.c        |    4 +++-
 4 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/include/linux/if_link.h b/include/linux/if_link.h
index 2fc66dd..ae73d5e 100644
--- a/include/linux/if_link.h
+++ b/include/linux/if_link.h
@@ -116,6 +116,7 @@ enum {
 	IFLA_STATS64,
 	IFLA_VF_PORTS,
 	IFLA_PORT_SELF,
+	IFLA_NET_NS_FD,
 	__IFLA_MAX
 };
 
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index bd10a79..68672ce 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -114,6 +114,7 @@ static inline struct net *copy_net_ns(unsigned long flags, struct net *net_ns)
 extern struct list_head net_namespace_list;
 
 extern struct net *get_net_ns_by_pid(pid_t pid);
+extern struct net *get_net_ns_by_fd(int pid);
 
 #ifdef CONFIG_NET_NS
 extern void __put_net(struct net *net);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 581a088..a9b54a7 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -8,6 +8,8 @@
 #include <linux/idr.h>
 #include <linux/rculist.h>
 #include <linux/nsproxy.h>
+#include <linux/proc_fs.h>
+#include <linux/file.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 
@@ -341,6 +343,30 @@ struct net *get_net_ns_by_pid(pid_t pid)
 }
 EXPORT_SYMBOL_GPL(get_net_ns_by_pid);
 
+struct net *get_net_ns_by_fd(int fd)
+{
+	struct proc_inode *ei;
+	struct file *file;
+	struct net *net;
+
+	file = NULL;
+	net = ERR_PTR(-EINVAL);
+	file = proc_ns_fget(fd);
+	if (!fd)
+		goto out;
+		return ERR_PTR(-EINVAL);
+
+	ei = PROC_I(file->f_dentry->d_inode);
+	if (ei->ns_ops != &netns_operations)
+		goto out;
+
+	net = get_net(ei->ns);
+out:
+	if (file)
+		fput(file);
+	return net;
+}
+
 static int __init net_ns_init(void)
 {
 	struct net_generic *ng;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f78d821..771d8be 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1003,6 +1003,8 @@ struct net *rtnl_link_get_net(struct net *src_net, struct nlattr *tb[])
 	 */
 	if (tb[IFLA_NET_NS_PID])
 		net = get_net_ns_by_pid(nla_get_u32(tb[IFLA_NET_NS_PID]));
+	else if (tb[IFLA_NET_NS_FD])
+		net = get_net_ns_by_fd(nla_get_u32(tb[IFLA_NET_NS_FD]));
 	else
 		net = get_net(src_net);
 	return net;
@@ -1077,7 +1079,7 @@ static int do_setlink(struct net_device *dev, struct ifinfomsg *ifm,
 	int send_addr_notify = 0;
 	int err;
 
-	if (tb[IFLA_NET_NS_PID]) {
+	if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD]) {
 		struct net *net = rtnl_link_get_net(dev_net(dev), tb);
 		if (IS_ERR(net)) {
 			err = PTR_ERR(net);
-- 
1.6.5.2.143.g8cc62

