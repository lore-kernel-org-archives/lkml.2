Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab2KVWhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:37:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:49022 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab2KVSdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Julian Anastasov <ja@ssi.bg>, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 72/83] netfilter: nf_conntrack: fix rt_gateway checks for H.323 helper
Date: Wed, 21 Nov 2012 16:42:34 -0800
Message-Id: <20121122004220.412839231@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

commit bbb5823cf742a7e955f35c7d891e4e936944c33a upstream.

After the change "Adjust semantics of rt->rt_gateway"
(commit f8126f1d51) we should properly match the nexthop when
destinations are directly connected because rt_gateway can be 0.

The rt_gateway checks in H.323 helper try to avoid the creation
of an unnecessary expectation in this call-forwarding case:

http://people.netfilter.org/zhaojingmin/h323_conntrack_nat_helper/#_Toc133598073

However, the existing code fails to avoid that in many cases,
see this thread:

http://marc.info/?l=linux-netdev&m=135043175028620&w=2

It seems it is not trivial to know from the kernel if two hosts
have to go through the firewall to communicate each other, which
is the main point of the call-forwarding filter code to avoid
creating unnecessary expectations.

So this patch just gets things the way they were as before
commit f8126f1d51.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_h323_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -733,7 +733,8 @@ static int callforward_do_filter(const u
 				   flowi4_to_flowi(&fl1), false)) {
 			if (!afinfo->route(&init_net, (struct dst_entry **)&rt2,
 					   flowi4_to_flowi(&fl2), false)) {
-				if (rt1->rt_gateway == rt2->rt_gateway &&
+				if (rt_nexthop(rt1, fl1.daddr) ==
+				    rt_nexthop(rt2, fl2.daddr) &&
 				    rt1->dst.dev  == rt2->dst.dev)
 					ret = 1;
 				dst_release(&rt2->dst);


