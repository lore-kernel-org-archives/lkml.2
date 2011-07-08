Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1GHFGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:06:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab1GHFGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:06:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:03 2011
Message-Id: <20110708001703.095764879@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans Schillstrom <hans.schillstrom@ericsson.com>,
        Simon Horman <horms@verge.net.au>
Subject: [107/107] IPVS netns exit causes crash in conntrack
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hans Schillstrom <hans.schillstrom@ericsson.com>

commit 8f4e0a18682d91abfad72ede3d3cb5f3ebdf54b4 upstream.

Quote from Patric Mc Hardy
"This looks like nfnetlink.c excited and destroyed the nfnl socket, but
ip_vs was still holding a reference to a conntrack. When the conntrack
got destroyed it created a ctnetlink event, causing an oops in
netlink_has_listeners when trying to use the destroyed nfnetlink
socket."

If nf_conntrack_netlink is loaded before ip_vs this is not a problem.

This patch simply avoids calling ip_vs_conn_drop_conntrack()
when netns is dying as suggested by Julian.

Signed-off-by: Hans Schillstrom <hans.schillstrom@ericsson.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/ipvs/ip_vs_conn.c |   10 +++++++++-
 net/netfilter/ipvs/ip_vs_core.c |    1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -776,8 +776,16 @@ static void ip_vs_conn_expire(unsigned l
 		if (cp->control)
 			ip_vs_control_del(cp);
 
-		if (cp->flags & IP_VS_CONN_F_NFCT)
+		if (cp->flags & IP_VS_CONN_F_NFCT) {
 			ip_vs_conn_drop_conntrack(cp);
+			/* Do not access conntracks during subsys cleanup
+			 * because nf_conntrack_find_get can not be used after
+			 * conntrack cleanup for the net.
+			 */
+			smp_rmb();
+			if (ipvs->enable)
+				ip_vs_conn_drop_conntrack(cp);
+		}
 
 		ip_vs_pe_put(cp->pe);
 		kfree(cp->pe_data);
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1965,6 +1965,7 @@ static void __net_exit __ip_vs_dev_clean
 {
 	EnterFunction(2);
 	net_ipvs(net)->enable = 0;	/* Disable packet reception */
+	smp_wmb();
 	__ip_vs_sync_cleanup(net);
 	LeaveFunction(2);
 }


