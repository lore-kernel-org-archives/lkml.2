Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1FZVdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:33:08 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15549 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab1FZVcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:32:10 -0400
Date: Sun, 26 Jun 2011 23:23:06 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-crypto@vger.kernel.org
cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH] Crypto: Don't use err uninitialized in
 algif_hash.c:hash_sendmsg()
Message-ID: <alpine.LNX.2.00.1106262320530.26572@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If af_alg_make_sg() returns <0 in hash_sendmsg() we'll jump to the
'unlock' label without having set 'err' to anything. At the 'unlock'
label the value of 'err' is tested to determine return value of the
function - not good to base that on a uninitialized variable.

This patch sets 'err' to the return value of hash_sendmsg() before the
'goto' when the value is less than zero, which seems to me to be the
proper thing to do.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 crypto/algif_hash.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 62122a1..1847544 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -68,9 +68,10 @@ static int hash_sendmsg(struct kiocb *unused, struct socket *sock,
 			int newlen;
 
 			newlen = af_alg_make_sg(&ctx->sgl, from, len, 0);
-			if (newlen < 0)
+			if (newlen < 0) {
+				err = newlen;
 				goto unlock;
-
+			}
 			ahash_request_set_crypt(&ctx->req, ctx->sgl.sg, NULL,
 						newlen);
 
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

