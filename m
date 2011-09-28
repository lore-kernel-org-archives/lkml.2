Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab1I1WrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:47:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037Ab1I1Wqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:46:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:44 2011
Message-Id: <20110928220143.990850804@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [177/244] fib:fix BUG_ON in fib_nl_newrule when add new fib rule
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Gao feng <gaofeng@cn.fujitsu.com>

[ Upstream commit 561dac2d410ffac0b57a23b85ae0a623c1a076ca ]

add new fib rule can cause BUG_ON happen
the reproduce shell is
ip rule add pref 38
ip rule add pref 38
ip rule add to 192.168.3.0/24 goto 38
ip rule del pref 38
ip rule add to 192.168.3.0/24 goto 38
ip rule add pref 38

then the BUG_ON will happen
del BUG_ON and use (ctarget == NULL) identify whether this rule is unresolved

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/fib_rules.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -384,8 +384,8 @@ static int fib_nl_newrule(struct sk_buff
 		 */
 		list_for_each_entry(r, &ops->rules_list, list) {
 			if (r->action == FR_ACT_GOTO &&
-			    r->target == rule->pref) {
-				BUG_ON(rtnl_dereference(r->ctarget) != NULL);
+			    r->target == rule->pref &&
+			    rtnl_dereference(r->ctarget) == NULL) {
 				rcu_assign_pointer(r->ctarget, rule);
 				if (--ops->unresolved_rules == 0)
 					break;


