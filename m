Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab2BAVkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:40:11 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54768 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757205Ab2BAVJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:37 -0500
X-Sasl-enc: M8qOPmwbaGfoCnu5fUAkiq6Pb2mKk4PMSjSRKGfacIbF 1328130576
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:45 2012
Message-Id: <20120201210045.673805725@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [20/89] crypto: sha512 - make it work, undo percpu message schedule
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit 84e31fdb7c797a7303e0cc295cb9bc8b73fb872d upstream.

commit f9e2bca6c22d75a289a349f869701214d63b5060
aka "crypto: sha512 - Move message schedule W[80] to static percpu area"
created global message schedule area.

If sha512_update will ever be entered twice, hash will be silently
calculated incorrectly.

Probably the easiest way to notice incorrect hashes being calculated is
to run 2 ping floods over AH with hmac(sha512):

	#!/usr/sbin/setkey -f
	flush;
	spdflush;
	add IP1 IP2 ah 25 -A hmac-sha512 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000025;
	add IP2 IP1 ah 52 -A hmac-sha512 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000052;
	spdadd IP1 IP2 any -P out ipsec ah/transport//require;
	spdadd IP2 IP1 any -P in  ipsec ah/transport//require;

XfrmInStateProtoError will start ticking with -EBADMSG being returned
from ah_input(). This never happens with, say, hmac(sha1).

With patch applied (on BOTH sides), XfrmInStateProtoError does not tick
with multiple bidirectional ping flood streams like it doesn't tick
with SHA-1.

After this patch sha512_transform() will start using ~750 bytes of stack on x86_64.
This is OK for simple loads, for something more heavy, stack reduction will be done
separatedly.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/sha512_generic.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -21,8 +21,6 @@
 #include <linux/percpu.h>
 #include <asm/byteorder.h>
 
-static DEFINE_PER_CPU(u64[80], msg_schedule);
-
 static inline u64 Ch(u64 x, u64 y, u64 z)
 {
         return z ^ (x & (y ^ z));
@@ -89,7 +87,7 @@ sha512_transform(u64 *state, const u8 *i
 	u64 a, b, c, d, e, f, g, h, t1, t2;
 
 	int i;
-	u64 *W = get_cpu_var(msg_schedule);
+	u64 W[80];
 
 	/* load the input */
         for (i = 0; i < 16; i++)
@@ -128,8 +126,6 @@ sha512_transform(u64 *state, const u8 *i
 
 	/* erase our data */
 	a = b = c = d = e = f = g = h = t1 = t2 = 0;
-	memset(W, 0, sizeof(__get_cpu_var(msg_schedule)));
-	put_cpu_var(msg_schedule);
 }
 
 static int


