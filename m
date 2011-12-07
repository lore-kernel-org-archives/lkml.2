Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444Ab1LGQVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:21:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388Ab1LGQVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:21:41 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:15 2011
Message-Id: <20111207161215.186906935@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:07 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Phil Sutter <phil.sutter@viprinet.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [005/104] crypto: mv_cesa - fix hashing of chunks > 1920 bytes
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil.sutter@viprinet.com>

commit 274252862f386b7868f35bf5ceaa5391a8ccfdf3 upstream.

This was broken by commit 7759995c75ae0cbd4c861582908449f6b6208e7a (yes,
myself). The basic problem here is since the digest state is only saved
after the last chunk, the state array is only valid when handling the
first chunk of the next buffer. Broken since linux-3.0.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/crypto/mv_cesa.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -342,11 +342,13 @@ static void mv_process_hash_current(int
 		else
 			op.config |= CFG_MID_FRAG;
 
-		writel(req_ctx->state[0], cpg->reg + DIGEST_INITIAL_VAL_A);
-		writel(req_ctx->state[1], cpg->reg + DIGEST_INITIAL_VAL_B);
-		writel(req_ctx->state[2], cpg->reg + DIGEST_INITIAL_VAL_C);
-		writel(req_ctx->state[3], cpg->reg + DIGEST_INITIAL_VAL_D);
-		writel(req_ctx->state[4], cpg->reg + DIGEST_INITIAL_VAL_E);
+		if (first_block) {
+			writel(req_ctx->state[0], cpg->reg + DIGEST_INITIAL_VAL_A);
+			writel(req_ctx->state[1], cpg->reg + DIGEST_INITIAL_VAL_B);
+			writel(req_ctx->state[2], cpg->reg + DIGEST_INITIAL_VAL_C);
+			writel(req_ctx->state[3], cpg->reg + DIGEST_INITIAL_VAL_D);
+			writel(req_ctx->state[4], cpg->reg + DIGEST_INITIAL_VAL_E);
+		}
 	}
 
 	memcpy(cpg->sram + SRAM_CONFIG, &op, sizeof(struct sec_accel_config));


