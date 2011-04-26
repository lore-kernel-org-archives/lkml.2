Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1DZVOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:14:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:65464 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584Ab1DZVOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327101"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: segoon@openwall.com, kaber@trash.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [33/106] ipv6: netfilter: ip6_tables: fix infoleak to userspace
Message-Id: <20110426211312.767883E1887@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

commit 6a8ab060779779de8aea92ce3337ca348f973f54 upstream.

Structures ip6t_replace, compat_ip6t_replace, and xt_get_revision are
copied from userspace.  Fields of these structs that are
zero-terminated strings are not checked.  When they are used as argument
to a format string containing "%s" in request_module(), some sensitive
information is leaked to userspace via argument of spawned modprobe
process.

The first bug was introduced before the git epoch;  the second was
introduced in 3bc3fe5e (v2.6.25-rc1);  the third is introduced by
6b7d31fc (v2.6.15-rc1).  To trigger the bug one should have
CAP_NET_ADMIN.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/ipv6/netfilter/ip6_tables.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.35.y/net/ipv6/netfilter/ip6_tables.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv6/netfilter/ip6_tables.c
+++ linux-2.6.35.y/net/ipv6/netfilter/ip6_tables.c
@@ -1289,6 +1289,7 @@ do_replace(struct net *net, const void _
 	/* overflow check */
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -1835,6 +1836,7 @@ compat_do_replace(struct net *net, void 
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -2064,6 +2066,7 @@ do_ip6t_get_ctl(struct sock *sk, int cmd
 			ret = -EFAULT;
 			break;
 		}
+		rev.name[sizeof(rev.name)-1] = 0;
 
 		if (cmd == IP6T_SO_GET_REVISION_TARGET)
 			target = 1;
