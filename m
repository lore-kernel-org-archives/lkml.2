Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1BVW0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:26:50 -0500
Received: from kroah.org ([198.145.64.141]:32948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab1BVWWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:42 2011
Message-Id: <20110222221842.321409794@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Hemminger <stephen.hemminger@vyatta.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Patrick McHardy <kaber@trash.net>
Subject: [53/70] netfilter: ctnetlink: fix missing refcount increment during dumps
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit c71caf4114a0e1da3451cc92fba6a152929cd4c2 upstream.

In 13ee6ac netfilter: fix race in conntrack between dump_table and
destroy, we recovered spinlocks to protect the dump of the conntrack
table according to reports from Stephen and acknowledgments on the
issue from Eric.

In that patch, the refcount bump that allows to keep a reference
to the current ct object was removed. However, we still decrement
the refcount for that object in the output path of
ctnetlink_dump_table():

        if (last)
                nf_ct_put(last)

Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nf_conntrack_netlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -664,6 +664,7 @@ restart:
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
 						cb->nlh->nlmsg_seq,
 						IPCTNL_MSG_CT_NEW, ct) < 0) {
+				nf_conntrack_get(&ct->ct_general);
 				cb->args[1] = (unsigned long)ct;
 				goto out;
 			}


