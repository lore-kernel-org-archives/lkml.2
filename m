Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1ILBgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 21:36:40 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46214 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab1ILBgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 21:36:39 -0400
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: davem@davemloft.net, Gao feng <omarapazanadi@gmail.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH resend] fib:fix BUG_ON in fib_nl_newrule when add new fib rule
Date: Mon, 12 Sep 2011 09:36:05 +0800
Message-Id: <1315791365-5324-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315675150-3012-1-git-send-email-wanlong.gao@gmail.com>
References: <1315675150-3012-1-git-send-email-wanlong.gao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gao feng <gaofeng@cn.fujitsu.com>

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
---
 net/core/fib_rules.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index e7ab0c0..3231b46 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -384,8 +384,8 @@ static int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr* nlh, void *arg)
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
-- 
1.7.6

