Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab0KPVzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:55:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710Ab0KPVzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:55:46 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/3] SELinux: return -ECONNREFUSED from ip_postroute to signal
	fatal error
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, netfilter-devel@vger.kernel.org
Cc: eparis@redhat.com, equinox@diac24.net, eric.dumazet@gmail.com,
        davem@davemloft.net, hzhong@gmail.com, jmorris@namei.org,
        kaber@trash.net, kuznet@ms2.inr.ac.ru, paul.moore@hp.com,
        pekkas@netcore.fi, sds@tycho.nsa.gov, yoshfuji@linux-ipv6.org
Date: Tue, 16 Nov 2010 16:52:57 -0500
Message-ID: <20101116215257.6727.12163.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101116215238.6727.39248.stgit@paris.rdu.redhat.com>
References: <20101116215238.6727.39248.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SELinux netfilter hooks just return NF_DROP if they drop a packet.  We
want to signal that a drop in this hook is a permanant fatal error and is not
transient.  If we do this the error will be passed back up the stack in some
places and applications will get a faster interaction that something went
wrong.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/selinux/hooks.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 8ba5001..b1104f9 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4594,11 +4594,11 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 				secmark_perm = PACKET__SEND;
 			break;
 		default:
-			return NF_DROP;
+			return NF_DROP_ERR(-ECONNREFUSED);
 		}
 		if (secmark_perm == PACKET__FORWARD_OUT) {
 			if (selinux_skb_peerlbl_sid(skb, family, &peer_sid))
-				return NF_DROP;
+				return NF_DROP_ERR(-ECONNREFUSED);
 		} else
 			peer_sid = SECINITSID_KERNEL;
 	} else {
@@ -4611,28 +4611,28 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 	ad.u.net.netif = ifindex;
 	ad.u.net.family = family;
 	if (selinux_parse_skb(skb, &ad, &addrp, 0, NULL))
-		return NF_DROP;
+		return NF_DROP_ERR(-ECONNREFUSED);
 
 	if (secmark_active)
 		if (avc_has_perm(peer_sid, skb->secmark,
 				 SECCLASS_PACKET, secmark_perm, &ad))
-			return NF_DROP;
+			return NF_DROP_ERR(-ECONNREFUSED);
 
 	if (peerlbl_active) {
 		u32 if_sid;
 		u32 node_sid;
 
 		if (sel_netif_sid(ifindex, &if_sid))
-			return NF_DROP;
+			return NF_DROP_ERR(-ECONNREFUSED);
 		if (avc_has_perm(peer_sid, if_sid,
 				 SECCLASS_NETIF, NETIF__EGRESS, &ad))
-			return NF_DROP;
+			return NF_DROP_ERR(-ECONNREFUSED);
 
 		if (sel_netnode_sid(addrp, family, &node_sid))
-			return NF_DROP;
+			return NF_DROP_ERR(-ECONNREFUSED);
 		if (avc_has_perm(peer_sid, node_sid,
 				 SECCLASS_NODE, NODE__SENDTO, &ad))
-			return NF_DROP;
+			return NF_DROP_ERR(-ECONNREFUSED);
 	}
 
 	return NF_ACCEPT;

