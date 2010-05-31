Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab0EaLHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 07:07:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab0EaLHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 07:07:38 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
       coreteam@netfilter.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Xiaotian Feng <dfeng@redhat.com>, Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Jan Engelhardt <jengelh@medozas.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] netfilter: don't xt_jumpstack_alloc twice in xt_register_table
Date: Mon, 31 May 2010 19:06:38 +0800
Message-Id: <1275303998-2435-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In xt_register_table, xt_jumpstack_alloc is called first, later
xt_replace_table is used. But in xt_replace_table, xt_jumpstack_alloc
will be used again. Then the memory allocated by previous xt_jumpstack_alloc
will be leaked. We can simply remove the previous xt_jumpstack_alloc because
there aren't any users of newinfo between xt_jumpstack_alloc and
xt_replace_table.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 net/netfilter/x_tables.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 445de70..47b1e79 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -844,10 +844,6 @@ struct xt_table *xt_register_table(struct net *net,
 	struct xt_table_info *private;
 	struct xt_table *t, *table;
 
-	ret = xt_jumpstack_alloc(newinfo);
-	if (ret < 0)
-		return ERR_PTR(ret);
-
 	/* Don't add one object to multiple lists. */
 	table = kmemdup(input_table, sizeof(struct xt_table), GFP_KERNEL);
 	if (!table) {
-- 
1.7.0.1

