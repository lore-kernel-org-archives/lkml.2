Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1FZTlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 15:41:06 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:61861 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1FZTjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 15:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fxoJLZLeC/iBoryFU4m6uDV05S73Ty2fg5ONHq/kVnFp9/HwNrraMjvqOPBzx1jj0M
         Cyoup7Eg4GZEzj+iOTYR6q3/pSOfQxEvA+LBGsm1LrEEo+WGiXBthyn9NnQyFQ441iDG
         eJ5H5i+wWM/6yyGvHrttdq+xA3mHI5sG7Rp3I=
Date: Sun, 26 Jun 2011 21:39:18 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH] slub: reduce overhead of slub_debug
Message-ID: <20110626193918.GA3339@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slub checks for poison one byte by one, which is highly inefficient
and shows up frequently as a highest cpu-eater in perf top.

Joining reads gives nice speedup:

(Compiling some project with different options)
                                 make -j12    make clean
slub_debug disabled:             1m 27s       1.2 s
slub_debug enabled:              1m 46s       7.6 s
slub_debug enabled + this patch: 1m 33s       3.2 s

check_bytes still shows up high, but not always at the top.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: linux-mm@kvack.org
---
 mm/slub.c |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 35f351f..a40ef2d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -557,10 +557,10 @@ static void init_object(struct kmem_cache *s, void *object, u8 val)
 		memset(p + s->objsize, val, s->inuse - s->objsize);
 }
 
-static u8 *check_bytes(u8 *start, unsigned int value, unsigned int bytes)
+static u8 *check_bytes8(u8 *start, u8 value, unsigned int bytes)
 {
 	while (bytes) {
-		if (*start != (u8)value)
+		if (*start != value)
 			return start;
 		start++;
 		bytes--;
@@ -568,6 +568,38 @@ static u8 *check_bytes(u8 *start, unsigned int value, unsigned int bytes)
 	return NULL;
 }
 
+static u8 *check_bytes(u8 *start, u8 value, unsigned int bytes)
+{
+	u64 value64;
+	unsigned int words, prefix;
+
+	if (bytes <= 16)
+		return check_bytes8(start, value, bytes);
+
+	value64 = value | value << 8 | value << 16 | value << 24;
+	value64 = value64 | value64 << 32;
+	prefix = 8 - ((unsigned long)start) % 8;
+
+	if (prefix) {
+		u8 *r = check_bytes8(start, value, prefix);
+		if (r)
+			return r;
+		start += prefix;
+		bytes -= prefix;
+	}
+
+	words = bytes / 8;
+
+	while (words) {
+		if (*(u64 *)start != value64)
+			return check_bytes8(start, value, 8);
+		start += 8;
+		words--;
+	}
+
+	return check_bytes8(start, value, bytes % 8);
+}
+
 static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
 						void *from, void *to)
 {
-- 
1.7.5.3

