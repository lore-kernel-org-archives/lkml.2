Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab1EQJyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:54:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44909 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab1EQJyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ojs2r/xuelp6w18m911/UbGjTm4JOxYrp3/G4SIUY4gagn3Wat7Rr1oKNC0hkLGadl
         eVgAWuLBgDYukLd8De6EeSMciieQvSbJFU53pGYCoCqcn0Dt+KVVG/OVcOuAKEmEOHpc
         6OIypKR73Q04X5U++dqDAYT2nZmrSF5n+OonI=
Subject: Re: linux-next: Tree for May 16 (net/ipv4/ping)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        segoon@openwall.com
In-Reply-To: <20110516.153844.1072050131335197211.davem@davemloft.net>
References: <20110516151019.be338f1c.sfr@canb.auug.org.au>
	 <20110516123534.5d3a51b9.randy.dunlap@oracle.com>
	 <20110516.153844.1072050131335197211.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 11:54:07 +0200
Message-ID: <1305626047.2850.35.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 mai 2011 à 15:38 -0400, David Miller a écrit :
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Mon, 16 May 2011 12:35:34 -0700
> 
> > On Mon, 16 May 2011 15:10:19 +1000 Stephen Rothwell wrote:
> > 
> >> Hi all,
> >> 
> >> Changes since 20110513:
> > 
> > 
> > when CONFIG_PROC_SYSCTL is not enabled:
> > 
> > ping.c:(.text+0x52af3): undefined reference to `inet_get_ping_group_range_net'
> 
> Vasiliy, please fix this.

Vasily seems busy, here is a fix for this problem.

I tested new ping was working even if we could not set the group range
anymore.

Thanks

[PATCH net-next-2.6] net: ping: fix build error

Randy Dunlap reported following build error if CONFIG_PROC_SYSCTL is not
enabled:

ping.c:(.text+0x52af3): undefined reference to
`inet_get_ping_group_range_net'

Also made inet_get_ping_group_range_table() static

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Vasiliy Kulikov <segoon@openwall.com>
---
 net/ipv4/inet_connection_sock.c |   14 ++++++++++++++
 net/ipv4/sysctl_net_ipv4.c      |   14 +-------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 3a2ba56..e5c0729 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -23,6 +23,7 @@
 #include <net/route.h>
 #include <net/tcp_states.h>
 #include <net/xfrm.h>
+#include <net/ping.h>
 
 #ifdef INET_CSK_DEBUG
 const char inet_csk_timer_bug_msg[] = "inet_csk BUG: unknown timer value\n";
@@ -52,6 +53,19 @@ void inet_get_local_port_range(int *low, int *high)
 }
 EXPORT_SYMBOL(inet_get_local_port_range);
 
+void inet_get_ping_group_range_net(struct net *net, gid_t *low, gid_t *high)
+{
+	const gid_t *data = net->ipv4.sysctl_ping_group_range;
+	unsigned int seq;
+
+	do {
+		seq = read_seqbegin(&sysctl_local_ports.lock);
+
+		*low = data[0];
+		*high = data[1];
+	} while (read_seqretry(&sysctl_local_ports.lock, seq));
+}
+
 int inet_csk_bind_conflict(const struct sock *sk,
 			   const struct inet_bind_bucket *tb)
 {
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 28e8273..dc5d2a0 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -73,19 +73,7 @@ static int ipv4_local_port_range(ctl_table *table, int write,
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
-void inet_get_ping_group_range_table(struct ctl_table *table, gid_t *low, gid_t *high)
+static void inet_get_ping_group_range_table(struct ctl_table *table, gid_t *low, gid_t *high)
 {
 	gid_t *data = table->data;
 	unsigned seq;


