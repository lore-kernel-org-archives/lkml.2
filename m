Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655Ab1AMUID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:08:03 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25586 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933642Ab1AMUH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:07:56 -0500
Date: Thu, 13 Jan 2011 21:07:55 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: David Howells <dhowells@redhat.com>
cc: David Safford <safford@us.ibm.com>, James Morris <jmorris@namei.org>,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Trusted and Encrypted Keys: fix up TSS_rawhmac() so we always
 kfree() and remember to call va_end()
Message-ID: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In security/keys/trusted_defined.c::TSS_rawhmac() we may leak the storage 
allocated to 'sdesc' if
  data = va_arg(argp, unsigned char *);
results in a NULL 'data' and we then leave the function by returning 
-EINVAL. We also neglect calling va_end(argp) in that case and furthermore 
we neglect va_end(argp) if
  ret = crypto_shash_update(&sdesc->shash, data, dlen);
results in ret being negative and we then jump to the 'out' label.

I believe this patch takes care of these issues. Please review and 
consider for inclusion.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 trusted_defined.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

  compile tested only.

diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
index 975e9f2..0ec7ab8 100644
--- a/security/keys/trusted_defined.c
+++ b/security/keys/trusted_defined.c
@@ -101,16 +101,18 @@ static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
 		if (dlen == 0)
 			break;
 		data = va_arg(argp, unsigned char *);
-		if (data == NULL)
-			return -EINVAL;
+		if (data == NULL) {
+			ret = -EINVAL;
+			goto out;
+		}
 		ret = crypto_shash_update(&sdesc->shash, data, dlen);
 		if (ret < 0)
 			goto out;
 	}
-	va_end(argp);
 	if (!ret)
 		ret = crypto_shash_final(&sdesc->shash, digest);
 out:
+	va_end(argp);
 	kfree(sdesc);
 	return ret;
 }



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

