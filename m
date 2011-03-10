Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1CJSNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:13:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57678 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1CJSNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:13:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=NYYVoVTGs3R8occbUJx40wl2aFxfz+5YjKZVaajntLLcGE8QlVSVd1H/O89SiqVorh
         d1FapZBR/T/uxrgjSNsMuEarmk9cB3udYbzUUjf7+MyqDmHfayJ1Chb/og2195roYeXx
         w6HeOzLv9wMdbWULPkwWz+LZATfaWuXDBwPP0=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH] ipv6: netfilter: ip6_tables: fix infoleak to userspace
Date: Thu, 10 Mar 2011 21:13:46 +0300
Message-Id: <1299780827-344-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 Compile tested.

 net/ipv6/netfilter/ip6_tables.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 47b7b8d..c9598a9 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1275,6 +1275,7 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 	/* overflow check */
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -1822,6 +1823,7 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -2051,6 +2053,7 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 			ret = -EFAULT;
 			break;
 		}
+		rev.name[sizeof(rev.name)-1] = 0;
 
 		if (cmd == IP6T_SO_GET_REVISION_TARGET)
 			target = 1;
-- 
1.7.0.4

