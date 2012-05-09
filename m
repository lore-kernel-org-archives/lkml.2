Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab2EIGSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:18:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38917 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756188Ab2EIFx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:26 -0400
Message-Id: <20120509055041.696906518@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 086/167] [PATCH 25/26] net ax25: Reorder ax25_exit to remove races.
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 3adadc08cc1e2cbcc15a640d639297ef5fcb17f5 ]

While reviewing the sysctl code in ax25 I spotted races in ax25_exit
where it is possible to receive notifications and packets after already
freeing up some of the data structures needed to process those
notifications and updates.

Call unregister_netdevice_notifier early so that the rest of the cleanup
code does not need to deal with network devices.  This takes advantage
of my recent enhancement to unregister_netdevice_notifier to send
unregister notifications of all network devices that are current
registered.

Move the unregistration for packet types, socket types and protocol
types before we cleanup any of the ax25 data structures to remove the
possibilities of other races.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ax25/af_ax25.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index e7c69f4..b04a6ef 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -2006,16 +2006,17 @@ static void __exit ax25_exit(void)
 	proc_net_remove(&init_net, "ax25_route");
 	proc_net_remove(&init_net, "ax25");
 	proc_net_remove(&init_net, "ax25_calls");
-	ax25_rt_free();
-	ax25_uid_free();
-	ax25_dev_free();
 
-	ax25_unregister_sysctl();
 	unregister_netdevice_notifier(&ax25_dev_notifier);
+	ax25_unregister_sysctl();
 
 	dev_remove_pack(&ax25_packet_type);
 
 	sock_unregister(PF_AX25);
 	proto_unregister(&ax25_proto);
+
+	ax25_rt_free();
+	ax25_uid_free();
+	ax25_dev_free();
 }
 module_exit(ax25_exit);
-- 
1.7.10



