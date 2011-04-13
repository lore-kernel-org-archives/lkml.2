Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab1DMPzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:55:49 -0400
Received: from kroah.org ([198.145.64.141]:54424 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758137Ab1DMPzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:47 2011
Message-Id: <20110413155147.447736395@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Patrick McHardy <kaber@trash.net>
Subject: [42/74] netfilter: arp_tables: fix infoleak to userspace
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 42eab94fff18cb1091d3501cd284d6bd6cc9c143 upstream.

Structures ipt_replace, compat_ipt_replace, and xt_get_revision are
copied from userspace.  Fields of these structs that are
zero-terminated strings are not checked.  When they are used as argument
to a format string containing "%s" in request_module(), some sensitive
information is leaked to userspace via argument of spawned modprobe
process.

The first bug was introduced before the git epoch;  the second is
introduced by 6b7d31fc (v2.6.15-rc1);  the third is introduced by
6b7d31fc (v2.6.15-rc1).  To trigger the bug one should have
CAP_NET_ADMIN.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/netfilter/arp_tables.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1086,6 +1086,7 @@ static int do_replace(struct net *net, v
 	/* overflow check */
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -1508,6 +1509,7 @@ static int compat_do_replace(struct net
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -1763,6 +1765,7 @@ static int do_arpt_get_ctl(struct sock *
 			ret = -EFAULT;
 			break;
 		}
+		rev.name[sizeof(rev.name)-1] = 0;
 
 		try_then_request_module(xt_find_revision(NFPROTO_ARP, rev.name,
 							 rev.revision, 1, &ret),


