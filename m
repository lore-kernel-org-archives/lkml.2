Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab1KAWIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 18:08:42 -0400
Received: from tex.lwn.net ([70.33.254.29]:43726 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab1KAWIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 18:08:39 -0400
Date: Tue, 1 Nov 2011 16:08:37 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: Fix rwsem leak in crypto_user
Message-ID: <20111101160837.7da3ef6d@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list_empty case in crypto_alg_match() will return without calling
up_read() on crypto_alg_sem.  We could do the "goto out" routine, but the
function will clearly do the right thing with that test simply removed.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 2abca78..0605a2b 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -44,9 +44,6 @@ static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
 
 	down_read(&crypto_alg_sem);
 
-	if (list_empty(&crypto_alg_list))
-		return NULL;
-
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
 		int match = 0;
 
