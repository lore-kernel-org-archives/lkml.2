Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab2HMUrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:47:18 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:54773 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab2HMUUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:15 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Date: Mon, 13 Aug 2012 13:18:21 -0700
Message-Id: <1344889115-21610-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+5Lt6/SAoeqRvxhEET5pfKUcGeS99/CEo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4985]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 07/21] userns: Use kgids for sysctl_ping_group_range
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Store sysctl_ping_group_range as a paire of kgid_t values
  instead of a pair of gid_t values.
- Move the kgid conversion work from ping_init_sock into ipv4_ping_group_range
- For invalid cases reset to the default disabled state.

With the kgid_t conversion made part of the original value sanitation
from userspace understand how the code will react becomes clearer
and it becomes possible to set the sysctl ping group range from
something other than the initial user namespace.

Cc: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/net/netns/ipv4.h   |    3 ++-
 init/Kconfig               |    1 -
 net/ipv4/ping.c            |   18 ++++++------------
 net/ipv4/sysctl_net_ipv4.c |   42 +++++++++++++++++++++++++++---------------
 4 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 1474dd6..3516dc0 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -5,6 +5,7 @@
 #ifndef __NETNS_IPV4_H__
 #define __NETNS_IPV4_H__
 
+#include <linux/uidgid.h>
 #include <net/inet_frag.h>
 
 struct tcpm_hash_bucket;
@@ -62,7 +63,7 @@ struct netns_ipv4 {
 	int sysctl_icmp_ratemask;
 	int sysctl_icmp_errors_use_inbound_ifaddr;
 
-	unsigned int sysctl_ping_group_range[2];
+	kgid_t sysctl_ping_group_range[2];
 	long sysctl_tcp_mem[3];
 
 	atomic_t rt_genid;
diff --git a/init/Kconfig b/init/Kconfig
index 25a6ebb..f857f97 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -948,7 +948,6 @@ config UIDGID_CONVERTED
 	depends on NETFILTER_XT_MATCH_RECENT = n
 	depends on NETFILTER_XT_TARGET_LOG = n
 	depends on NETFILTER_NETLINK_LOG = n
-	depends on INET = n
 	depends on IPV6 = n
 	depends on AF_RXRPC = n
 	depends on NET_KEY = n
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index bee5eeb..8f3d054 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -185,10 +185,10 @@ exit:
 	return sk;
 }
 
-static void inet_get_ping_group_range_net(struct net *net, gid_t *low,
-					  gid_t *high)
+static void inet_get_ping_group_range_net(struct net *net, kgid_t *low,
+					  kgid_t *high)
 {
-	gid_t *data = net->ipv4.sysctl_ping_group_range;
+	kgid_t *data = net->ipv4.sysctl_ping_group_range;
 	unsigned int seq;
 
 	do {
@@ -203,19 +203,13 @@ static void inet_get_ping_group_range_net(struct net *net, gid_t *low,
 static int ping_init_sock(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
-	gid_t group = current_egid();
-	gid_t range[2];
+	kgid_t group = current_egid();
 	struct group_info *group_info = get_current_groups();
 	int i, j, count = group_info->ngroups;
 	kgid_t low, high;
 
-	inet_get_ping_group_range_net(net, range, range+1);
-	low = make_kgid(&init_user_ns, range[0]);
-	high = make_kgid(&init_user_ns, range[1]);
-	if (!gid_valid(low) || !gid_valid(high) || gid_lt(high, low))
-		return -EACCES;
-
-	if (range[0] <= group && group <= range[1])
+	inet_get_ping_group_range_net(net, &low, &high);
+	if (gid_lte(low, group) && gid_lte(group, high))
 		return 0;
 
 	for (i = 0; i < group_info->nblocks; i++) {
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 1b5ce96..3e78c79 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -76,9 +76,9 @@ static int ipv4_local_port_range(ctl_table *table, int write,
 }
 
 
-static void inet_get_ping_group_range_table(struct ctl_table *table, gid_t *low, gid_t *high)
+static void inet_get_ping_group_range_table(struct ctl_table *table, kgid_t *low, kgid_t *high)
 {
-	gid_t *data = table->data;
+	kgid_t *data = table->data;
 	unsigned int seq;
 	do {
 		seq = read_seqbegin(&sysctl_local_ports.lock);
@@ -89,12 +89,12 @@ static void inet_get_ping_group_range_table(struct ctl_table *table, gid_t *low,
 }
 
 /* Update system visible IP port range */
-static void set_ping_group_range(struct ctl_table *table, gid_t range[2])
+static void set_ping_group_range(struct ctl_table *table, kgid_t low, kgid_t high)
 {
-	gid_t *data = table->data;
+	kgid_t *data = table->data;
 	write_seqlock(&sysctl_local_ports.lock);
-	data[0] = range[0];
-	data[1] = range[1];
+	data[0] = low;
+	data[1] = high;
 	write_sequnlock(&sysctl_local_ports.lock);
 }
 
@@ -103,21 +103,33 @@ static int ipv4_ping_group_range(ctl_table *table, int write,
 				 void __user *buffer,
 				 size_t *lenp, loff_t *ppos)
 {
+	struct user_namespace *user_ns = current_user_ns();
 	int ret;
-	gid_t range[2];
+	gid_t urange[2];
+	kgid_t low, high;
 	ctl_table tmp = {
-		.data = &range,
-		.maxlen = sizeof(range),
+		.data = &urange,
+		.maxlen = sizeof(urange),
 		.mode = table->mode,
 		.extra1 = &ip_ping_group_range_min,
 		.extra2 = &ip_ping_group_range_max,
 	};
 
-	inet_get_ping_group_range_table(table, range, range + 1);
+	inet_get_ping_group_range_table(table, &low, &high);
+	urange[0] = from_kgid_munged(user_ns, low);
+	urange[1] = from_kgid_munged(user_ns, high);
 	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 
-	if (write && ret == 0)
-		set_ping_group_range(table, range);
+	if (write && ret == 0) {
+		low = make_kgid(user_ns, urange[0]);
+		high = make_kgid(user_ns, urange[1]);
+		if (!gid_valid(low) || !gid_valid(high) ||
+		    (urange[1] < urange[0]) || gid_lt(high, low)) {
+			low = make_kgid(&init_user_ns, 1);
+			high = make_kgid(&init_user_ns, 0);
+		}
+		set_ping_group_range(table, low, high);
+	}
 
 	return ret;
 }
@@ -786,7 +798,7 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "ping_group_range",
 		.data		= &init_net.ipv4.sysctl_ping_group_range,
-		.maxlen		= sizeof(init_net.ipv4.sysctl_ping_group_range),
+		.maxlen		= sizeof(gid_t)*2,
 		.mode		= 0644,
 		.proc_handler	= ipv4_ping_group_range,
 	},
@@ -830,8 +842,8 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
 	 * Sane defaults - nobody may create ping sockets.
 	 * Boot scripts should set this to distro-specific group.
 	 */
-	net->ipv4.sysctl_ping_group_range[0] = 1;
-	net->ipv4.sysctl_ping_group_range[1] = 0;
+	net->ipv4.sysctl_ping_group_range[0] = make_kgid(&init_user_ns, 1);
+	net->ipv4.sysctl_ping_group_range[1] = make_kgid(&init_user_ns, 0);
 
 	tcp_init_mem(net);
 
-- 
1.7.5.4

