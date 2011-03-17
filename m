Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1CQLkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:40:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61367 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1CQLkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=tcInRMwf8wFMFqCLf8QQ1+xOJm6aP9KvNjuuPQSwxriHg87CJ24weogCafWCx4zRnx
         V3SacPtJ3YxxHBtw7AA5y2t25wEcwKPn19byBqL19vY1WfUT/zcmJ4E0uJfN4uO4elxp
         99P1IgDtO1MCM9I+RD3Hcq6mCAr4V44nx887U=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Phil Blundell <philb@gnu.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>, Nelson Elhage <nelhage@ksplice.com>,
        netdev@vger.kernel.org
Subject: [PATCH] econet: 4 byte infoleak to the network
Date: Thu, 17 Mar 2011 14:40:10 +0300
Message-Id: <1300362011-8653-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct aunhdr has 4 padding bytes between 'pad' and 'handle' fields on
x86_64.  These bytes are not initialized in the variable 'ah' before
sending 'ah' to the network.  This leads to 4 bytes kernel stack
infoleak.

This bug was introduced before the git epoch.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 net/econet/af_econet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/econet/af_econet.c b/net/econet/af_econet.c
index 0c28263..116d3fd 100644
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
1.7.0.4

