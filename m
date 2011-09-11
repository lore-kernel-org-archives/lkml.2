Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab1IKHMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 03:12:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57260 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab1IKHMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 03:12:41 -0400
Subject: Re: [PATCH] fib:fix BUG_ON in fib_nl_newrule when add new fib rule
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        omarapazanadi@gmail.com, Gao feng <gaofeng@cn.fujitsu.com>
In-Reply-To: <1315675150-3012-1-git-send-email-wanlong.gao@gmail.com>
References: <1315675150-3012-1-git-send-email-wanlong.gao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Sep 2011 09:12:35 +0200
Message-ID: <1315725155.2606.33.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 11 septembre 2011 à 01:19 +0800, Wanlong Gao a écrit :
> From: Gao feng <gaofeng@cn.fujitsu.com>
> 
> add new fib rule can cause BUG_ON
> the reproduce shell is
> 
> #ip rule add pref 38
> #ip rule add pref 38
> #ip rule add to 192.168.3.0/24 goto 38
> #ip rule del pref 38
> #ip rule add to 192.168.3.0/24 goto 38
> #ip rule add pref 38
> 
> then the BUG_ON will happen
> add a var unresolved in struct fib_rule
> and use it to identify whether this rule is unresolved
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  include/net/fib_rules.h |    1 +
>  net/core/fib_rules.c    |    5 ++++-
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
> index 075f1e3..e4bae01 100644
> --- a/include/net/fib_rules.h
> +++ b/include/net/fib_rules.h
> @@ -19,6 +19,7 @@ struct fib_rule {
>  	u32			flags;
>  	u32			table;
>  	u8			action;
> +	u8			unresolved;
>  	u32			target;
>  	struct fib_rule __rcu	*ctarget;
>  	char			iifname[IFNAMSIZ];
> diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
> index e7ab0c0..aa20560 100644
> --- a/net/core/fib_rules.c
> +++ b/net/core/fib_rules.c
> @@ -384,9 +384,11 @@ static int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr* nlh, void *arg)
>  		 */
>  		list_for_each_entry(r, &ops->rules_list, list) {
>  			if (r->action == FR_ACT_GOTO &&
> -			    r->target == rule->pref) {
> +			    r->target == rule->pref &&
> +			    r->unresolved) {
>  				BUG_ON(rtnl_dereference(r->ctarget) != NULL);
>  				rcu_assign_pointer(r->ctarget, rule);
> +				r->unresolved = 0;
>  				if (--ops->unresolved_rules == 0)
>  					break;
>  			}
> @@ -488,6 +490,7 @@ static int fib_nl_delrule(struct sk_buff *skb, struct nlmsghdr* nlh, void *arg)
>  			list_for_each_entry(tmp, &ops->rules_list, list) {
>  				if (rtnl_dereference(tmp->ctarget) == rule) {
>  					rcu_assign_pointer(tmp->ctarget, NULL);
> +					tmp->unresolved = 1;
>  					ops->unresolved_rules++;
>  				}
>  			}

Hmm, good catch, but you add 'unresolved' field but dont init it
correctly to 1 in all cases.

Following will break :

ip rule add pref 100
ip rule add to 192.168.3.0/24 goto 200
ip rule add pref 200

Normally, we should have 

unresolved = (ctarget == NULL);

What about following patch instead ?

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


