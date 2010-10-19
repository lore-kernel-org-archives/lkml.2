Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0JSWSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:18:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314Ab0JSWSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:18:42 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] secmark: fix config problem when CONFIG_NF_CONNTRACK_SECMARK
	is not set
To: jmorris@namei.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.moore@hp.com, kaber@trash.net, sfr@canb.auug.org.au
Date: Tue, 19 Oct 2010 18:17:32 -0400
Message-ID: <20101019221732.11590.22215.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_NF_CONNTRACK_SECMARK is not set we accidentally attempt to use
the secmark fielf of struct nf_conn.  Problem is when that config isn't set
the field doesn't exist.  whoops.  Wrap the incorrect usage in the config.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 net/netfilter/nf_conntrack_netlink.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b3c6285..146476c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -582,9 +582,11 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 		    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 			goto nla_put_failure;
 
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
 		if ((events & (1 << IPCT_SECMARK) || ct->secmark)
 		    && ctnetlink_dump_secctx(skb, ct) < 0)
 			goto nla_put_failure;
+#endif
 
 		if (events & (1 << IPCT_RELATED) &&
 		    ctnetlink_dump_master(skb, ct) < 0)

