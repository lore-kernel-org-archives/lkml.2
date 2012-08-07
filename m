Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab2HGR7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:59:38 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:29909 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2HGR7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:59:37 -0400
Date: Tue, 7 Aug 2012 19:59:35 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Balbir Singh <bsingharora@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] taskstats: cgroupstats_user_cmd() may leak on error
Message-ID: <alpine.LNX.2.00.1208071957040.3227@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If prepare_reply() succeeds we have allocated memory for 'rep_skb'. If
nla_reserve() then subsequently fails and returns NULL we fail to
release the memory we allocated, thus causing a leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 kernel/taskstats.c | 1 +
 1 file changed, 1 insertion(+)

 Compile tested only.

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index d0a3279..37708eb 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -437,6 +437,7 @@ static int cgroupstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 	na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
 				sizeof(struct cgroupstats));
 	if (na == NULL) {
+		nlmsg_free(rep_skb);
 		rc = -EMSGSIZE;
 		goto err;
 	}
-- 
1.7.11.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

