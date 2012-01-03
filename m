Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab2ACWmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:42:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2ACWmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:42:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:26 2012
Message-Id: <20120103223326.534507407@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [65/75] sch_gred: should not use GFP_KERNEL while holding a spinlock
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 3f1e6d3fd37bd4f25e5b19f1c7ca21850426c33f ]

gred_change_vq() is called under sch_tree_lock(sch).

This means a spinlock is held, and we are not allowed to sleep in this
context.

We might pre-allocate memory using GFP_KERNEL before taking spinlock,
but this is not suitable for stable material.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sched/sch_gred.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -385,7 +385,7 @@ static inline int gred_change_vq(struct
 	struct gred_sched_data *q;
 
 	if (table->tab[dp] == NULL) {
-		table->tab[dp] = kzalloc(sizeof(*q), GFP_KERNEL);
+		table->tab[dp] = kzalloc(sizeof(*q), GFP_ATOMIC);
 		if (table->tab[dp] == NULL)
 			return -ENOMEM;
 	}


