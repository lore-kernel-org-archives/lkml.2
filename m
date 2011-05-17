Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab1EQKRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 06:17:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58971 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab1EQKRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 06:17:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PDoGfRkH3sNW1Tn2VN+YvfAiQmoAcsRHf+bgZ/R77Xd1hZvQ05epPW6y+FuNXP0P4U
         VUKhDSg06MheQAn0m7lND4FFYiPclqN7caE4prnDrC9L/yn1wKTpA5Bfq9AHmjLol4pr
         ekbgqF52cS8k1n9Ln7DKYaO2ZS7p6W+D2rnu0=
Date: Tue, 17 May 2011 14:16:56 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ping: fix build failure
Message-ID: <20110517101656.GA28685@albatros>
References: <20110516151019.be338f1c.sfr@canb.auug.org.au>
 <20110516123534.5d3a51b9.randy.dunlap@oracle.com>
 <20110516.153844.1072050131335197211.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516.153844.1072050131335197211.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 15:38 -0400, David Miller wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Mon, 16 May 2011 12:35:34 -0700
> 
> > On Mon, 16 May 2011 15:10:19 +1000 Stephen Rothwell wrote:
> > when CONFIG_PROC_SYSCTL is not enabled:
> > 
> > ping.c:(.text+0x52af3): undefined reference to `inet_get_ping_group_range_net'
> 
> Vasiliy, please fix this.

I wonder whether there is any way to test such unusual configurations?
Only randconfig or are there any (partly-)automated tools for it?


[PATCH] net: ping: fix build failure

If CONFIG_PROC_SYSCTL=n the building process fails:

    ping.c:(.text+0x52af3): undefined reference to `inet_get_ping_group_range_net'

Moved inet_get_ping_group_range_net() to ping.c.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 include/net/ping.h         |    2 --
 net/ipv4/ping.c            |   13 +++++++++++++
 net/ipv4/sysctl_net_ipv4.c |   12 ------------
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/net/ping.h b/include/net/ping.h
index 23062c3..682b5ae 100644
--- a/include/net/ping.h
+++ b/include/net/ping.h
@@ -44,8 +44,6 @@ extern struct proto ping_prot;
 extern void ping_rcv(struct sk_buff *);
 extern void ping_err(struct sk_buff *, u32 info);
 
-extern void inet_get_ping_group_range_net(struct net *net, unsigned int *low, unsigned int *high);
-
 #ifdef CONFIG_PROC_FS
 extern int __init ping_proc_init(void);
 extern void ping_proc_exit(void);
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 7041d09..3635975 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -188,6 +188,19 @@ exit:
 	return sk;
 }
 
+static void inet_get_ping_group_range_net(struct net *net, gid_t *low, gid_t *high)
+{
+	gid_t *data = net->ipv4.sysctl_ping_group_range;
+	unsigned seq;
+	do {
+		seq = read_seqbegin(&sysctl_local_ports.lock);
+
+		*low = data[0];
+		*high = data[1];
+	} while (read_seqretry(&sysctl_local_ports.lock, seq));
+}
+
+
 static int ping_init_sock(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 28e8273..57d0752 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -73,18 +73,6 @@ static int ipv4_local_port_range(ctl_table *table, int write,
 }
 
 
-void inet_get_ping_group_range_net(struct net *net, gid_t *low, gid_t *high)
-{
-	gid_t *data = net->ipv4.sysctl_ping_group_range;
-	unsigned seq;
-	do {
-		seq = read_seqbegin(&sysctl_local_ports.lock);
-
-		*low = data[0];
-		*high = data[1];
-	} while (read_seqretry(&sysctl_local_ports.lock, seq));
-}
-
 void inet_get_ping_group_range_table(struct ctl_table *table, gid_t *low, gid_t *high)
 {
 	gid_t *data = table->data;
-- 
1.7.0.4
