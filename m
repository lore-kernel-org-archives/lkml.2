Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1CEMnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 07:43:08 -0500
Received: from smtp-out.google.com ([74.125.121.67]:41853 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1CEMnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 07:43:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=Ld4hVN0xLIEhDWmGuHCDZtbeY585q/NtzQZyGK7L3JF1SHjmheZRRDFEbeWepU22d7
         xGzeacc1yER8QyMohJKQ==
Date: Sat, 5 Mar 2011 04:42:30 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michal Nazarewicz <mina86@mina86.com>,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Denis Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH mmotm] fix broken bootup on 32-bit
Message-ID: <alpine.LSU.2.00.1103050436010.4098@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmotm 2011-03-02-16-52 is utterly broken on 32-bit: panics at boot
with "Couldn't register console driver", and preceding warnings don't
even print their line numbers... which leads to the vsprintf changes.

Comparing the 32-bit version of put_dec() against mod7_put_dec()
in tools/put-dec/put-dec-test.c (ah, it is useful after all!) shows
that someone has decided to invert the ordering of pairs of lines
in the kernel version of the algorithm, making a nonsense of it.

Switch them back, and put in the conditionals from mod7_put_dec()
(absent from mod6_put_dec??): my guess is that less work is better.

My testing has gone no further than booting up, and checking that
the numbers in /proc/partitions come out right (which they didn't
at my first attempt, when I thought just a one-liner was needed).

Signed-off-by: Hugh Dickins <hughd@google.com>
---
Diffed to go on the top of mmotm, but can be applied after
lib-vsprintf-optimised-put_dec-function-fix.patch

 lib/vsprintf.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

--- mmotm/lib/vsprintf.c	2011-03-03 15:43:57.000000000 -0800
+++ linux/lib/vsprintf.c	2011-03-05 03:37:14.000000000 -0800
@@ -310,22 +310,29 @@ char *put_dec(char *buf, unsigned long l
 
 	q  = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
 
-	q  = q / 10000;
 	buf = put_dec_full4(buf, q % 10000);
+	q  = q / 10000;
 
 	d1 = q + 7671 * d3 + 9496 * d2 + 6 * d1;
-	q  = d1 / 10000;
-	buf = put_dec_full4(buf, d1 % 10000);
-
-	d2 = q + 4749 * d3 + 42 * d2;
-	q  = d2 / 10000;
-	buf = put_dec_full4(buf, d2 % 10000);
-
-	d3 = q + 281 * d3;
-	q  = d3 / 10000;
-	buf = put_dec_full4(buf, d3 % 10000);
-
-	buf = put_dec_full4(buf, q);
+	if (d1) {
+		buf = put_dec_full4(buf, d1 % 10000);
+		q  = d1 / 10000;
+
+		d2 = q + 4749 * d3 + 42 * d2;
+		if (d2) {
+			buf = put_dec_full4(buf, d2 % 10000);
+			q  = d2 / 10000;
+
+			d3 = q + 281 * d3;
+			if (d3) {
+				buf = put_dec_full4(buf, d3 % 10000);
+				q  = d3 / 10000;
+
+				if (q)
+					buf = put_dec_full4(buf, q);
+			}
+		}
+	}
 
 	while (buf[-1] == '0')
 		--buf;
