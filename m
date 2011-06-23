Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971Ab1FWRji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:39:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:35863 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933937Ab1FWRjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:39:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vasiliy Kulikov <segoon@openwall.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 245/247] econet: 4 byte infoleak to the network
Date: Thu, 23 Jun 2011 13:35:13 -0400
Message-Id: <1308850515-15242-186-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 67c5c6cb8129c595f21e88254a3fc6b3b841ae8e upstream.

struct aunhdr has 4 padding bytes between 'pad' and 'handle' fields on
x86_64.  These bytes are not initialized in the variable 'ah' before
sending 'ah' to the network.  This leads to 4 bytes kernel stack
infoleak.

This bug was introduced before the git epoch.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Phil Blundell <philb@gnu.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/econet/af_econet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/econet/af_econet.c b/net/econet/af_econet.c
index 728d389..4a392c9 100644
--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -435,10 +435,10 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 		udpdest.sin_addr.s_addr = htonl(network | addr.station);
 	}
 
+	memset(&ah, 0, sizeof(ah));
 	ah.port = port;
 	ah.cb = cb & 0x7f;
 	ah.code = 2;		/* magic */
-	ah.pad = 0;
 
 	/* tack our header on the front of the iovec */
 	size = sizeof(struct aunhdr);
-- 
1.7.4.4

