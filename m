Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab1DLOo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:44:26 -0400
Received: from kroah.org ([198.145.64.141]:57761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393Ab1DLOin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:56 2011
Message-Id: <20110412143556.831463676@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Patrick McHardy <kaber@trash.net>
Subject: [083/105] ipv6: netfilter: ip6_tables: fix infoleak to userspace
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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

---
 net/ipv6/netfilter/ip6_tables.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1274,6 +1274,7 @@ do_replace(struct net *net, const void _
 	/* overflow check */
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -1820,6 +1821,7 @@ compat_do_replace(struct net *net, void
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -2049,6 +2051,7 @@ do_ip6t_get_ctl(struct sock *sk, int cmd
 			ret = -EFAULT;
 			break;
 		}
+		rev.name[sizeof(rev.name)-1] = 0;
 
 		if (cmd == IP6T_SO_GET_REVISION_TARGET)
 			target = 1;


