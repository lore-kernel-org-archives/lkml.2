Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933961Ab1FWRjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:39:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:35856 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933947Ab1FWRjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:39:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vasiliy Kulikov <segoon@openwall.com>,
        Patrick McHardy <kaber@trash.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 244/247] ipv6: netfilter: ip6_tables: fix infoleak to userspace
Date: Thu, 23 Jun 2011 13:35:12 -0400
Message-Id: <1308850515-15242-185-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv6/netfilter/ip6_tables.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 9210e31..542edbf 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1325,6 +1325,7 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 	/* overflow check */
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -1871,6 +1872,7 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -2100,6 +2102,7 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 			ret = -EFAULT;
 			break;
 		}
+		rev.name[sizeof(rev.name)-1] = 0;
 
 		if (cmd == IP6T_SO_GET_REVISION_TARGET)
 			target = 1;
-- 
1.7.4.4

