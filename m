Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab1LBBpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:45:36 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55599 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab1LBBpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:45:35 -0500
From: Weiping Pan <panweiping3@gmail.com>
Cc: Weiping Pan <panweiping3@gmail.com>,
        "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING
	[IPv4/...),
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru> (maintainer:NETWORKING
	[IPv4/...),
        James Morris <jmorris@namei.org> (maintainer:NETWORKING [IPv4/...),
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org> (maintainer:NETWORKING
	[IPv4/...),
        Patrick McHardy <kaber@trash.net> (maintainer:NETWORKING [IPv4/...),
        netdev@vger.kernel.org (open list:NETWORKING [IPv4/...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ipv4: flush route cache after change accept_local
Date: Fri,  2 Dec 2011 09:47:06 +0800
Message-Id: <ea4d82977e7726dccd8e8f8e65c7fb523668100e.1322790334.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <20111201.125200.1219939487021672308.davem@davemloft.net>
References: <20111201.125200.1219939487021672308.davem@davemloft.net>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After reset ipv4_devconf->data[IPV4_DEVCONF_ACCEPT_LOCAL] to 0,
we should flush route cache, or it will continue receive packets with local
source address, which should be dropped.

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 net/ipv4/devinet.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index c6b5092..65f01dc 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1490,7 +1490,9 @@ static int devinet_conf_proc(ctl_table *ctl, int write,
 			     void __user *buffer,
 			     size_t *lenp, loff_t *ppos)
 {
+	int old_value = *(int *)ctl->data;
 	int ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
+	int new_value = *(int *)ctl->data;
 
 	if (write) {
 		struct ipv4_devconf *cnf = ctl->extra1;
@@ -1501,6 +1503,9 @@ static int devinet_conf_proc(ctl_table *ctl, int write,
 
 		if (cnf == net->ipv4.devconf_dflt)
 			devinet_copy_dflt_conf(net, i);
+		if (i == IPV4_DEVCONF_ACCEPT_LOCAL - 1)
+			if ((new_value == 0) && (old_value != 0))
+				rt_cache_flush(net, 0);
 	}
 
 	return ret;
-- 
1.7.4

