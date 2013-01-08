Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab3AHX6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:58:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:63443 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab3AHXhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:15 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Benjamin Poirier <bpoirier@suse.de>, Jesse Gross <jesse@nicira.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 12/77] gro: reset vlan_tci on reuse
Date: Tue, 8 Jan 2013 18:34:51 -0500
Message-ID: <1357688156-25387-13-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

This one liner is part of upstream
commit 3701e51382a026cba10c60b03efabe534fba4ca4
Author: Jesse Gross <jesse@nicira.com>

    vlan: Centralize handling of hardware acceleration.

The bulk of that commit is a rework of the hardware assisted vlan tagging
driver interface, and as such doesn't classify for -stable inclusion. The fix
that is needed is a part of that commit but can work independently of the
rest.

This patch can avoid panics on the 2.6.32.y -stable kernels and is in the same
spirit as mainline commits
66c46d7 gro: Reset dev pointer on reuse
6d152e2 gro: reset skb_iif on reuse
which are already in -stable.

For drivers using the vlan_gro_frags() interface, a packet with an invalid tci
leads to GRO_DROP and napi_reuse_skb(). The skb has to be sanitized before
being reused or we may send an skb with an invalid vlan_tci field up the stack
where it is not expected.

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
Cc: Jesse Gross <jesse@nicira.com>
Acked-by: David S. Miller <davem@davemloft.net>
[PG: taken from v2.6.32.y stable, commit 5aff28abc7e]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7daff00..2aaf2e6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2823,6 +2823,7 @@ void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 {
 	__skb_pull(skb, skb_headlen(skb));
 	skb_reserve(skb, NET_IP_ALIGN - skb_headroom(skb));
+	skb->vlan_tci = 0;
 	skb->dev = napi->dev;
 	skb->skb_iif = 0;
 
-- 
1.7.12.1

