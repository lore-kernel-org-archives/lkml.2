Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab1DLOpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:45:04 -0400
Received: from kroah.org ([198.145.64.141]:57743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373Ab1DLOik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:56 2011
Message-Id: <20110412143556.534215116@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
Subject: [080/105] netfilter: xtables: fix reentrancy
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit db856674ac69e31946e56085239757cca3f7655f upstream.

commit f3c5c1bfd4308 (make ip_tables reentrant) introduced a race in
handling the stackptr restore, at the end of ipt_do_table()

We should do it before the call to xt_info_rdunlock_bh(), or we allow
cpu preemption and another cpu overwrites stackptr of original one.

A second fix is to change the underflow test to check the origptr value
instead of 0 to detect underflow, or else we allow a jump from different
hooks.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/netfilter/ip_tables.c  |    4 ++--
 net/ipv6/netfilter/ip6_tables.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -387,7 +387,7 @@ ipt_do_table(struct sk_buff *skb,
 					verdict = (unsigned)(-v) - 1;
 					break;
 				}
-				if (*stackptr == 0) {
+				if (*stackptr <= origptr) {
 					e = get_entry(table_base,
 					    private->underflow[hook]);
 					pr_debug("Underflow (this is normal) "
@@ -427,10 +427,10 @@ ipt_do_table(struct sk_buff *skb,
 			/* Verdict */
 			break;
 	} while (!acpar.hotdrop);
-	xt_info_rdunlock_bh();
 	pr_debug("Exiting %s; resetting sp from %u to %u\n",
 		 __func__, *stackptr, origptr);
 	*stackptr = origptr;
+	xt_info_rdunlock_bh();
 #ifdef DEBUG_ALLOW_ALL
 	return NF_ACCEPT;
 #else
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -410,7 +410,7 @@ ip6t_do_table(struct sk_buff *skb,
 					verdict = (unsigned)(-v) - 1;
 					break;
 				}
-				if (*stackptr == 0)
+				if (*stackptr <= origptr)
 					e = get_entry(table_base,
 					    private->underflow[hook]);
 				else
@@ -441,8 +441,8 @@ ip6t_do_table(struct sk_buff *skb,
 			break;
 	} while (!acpar.hotdrop);
 
-	xt_info_rdunlock_bh();
 	*stackptr = origptr;
+	xt_info_rdunlock_bh();
 
 #ifdef DEBUG_ALLOW_ALL
 	return NF_ACCEPT;


