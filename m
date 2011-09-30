Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab1I3SCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:02:48 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43432 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626Ab1I3SCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:02:47 -0400
Subject: [RFC][PATCH 1/4] break up string_get_size()
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 30 Sep 2011 11:02:41 -0700
Message-Id: <20110930180241.D69D5E9C@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I started to break up string_get_size() in to some pieces
so that I could pick and choose which bits I wanted.  I
ended up not re-using this function.  But, I think this
still stands by itself since it makes the code much more
self-explanatory.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/lib/string_helpers.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN lib/string_helpers.c~break-up-string_get_size lib/string_helpers.c
--- linux-2.6.git/lib/string_helpers.c~break-up-string_get_size	2011-09-30 10:58:32.909418688 -0700
+++ linux-2.6.git-dave/lib/string_helpers.c	2011-09-30 10:58:32.953418603 -0700
@@ -8,6 +8,18 @@
 #include <linux/module.h>
 #include <linux/string_helpers.h>
 
+static int calc_sf_digit_room(u64 size)
+{
+	u64 sf_cap;
+	int digits;
+
+	sf_cap = size;
+	for (digits = 0; sf_cap*10 < 1000; digits++)
+		sf_cap *= 10;
+
+	return digits;
+}
+
 /**
  * string_get_size - get the size in the specified units
  * @size:	The size to be converted
@@ -36,7 +48,7 @@ int string_get_size(u64 size, const enum
 		[STRING_UNITS_2] = 1024,
 	};
 	int i, j;
-	u64 remainder = 0, sf_cap;
+	u64 remainder = 0;
 	char tmp[8];
 
 	tmp[0] = '\0';
@@ -47,10 +59,7 @@ int string_get_size(u64 size, const enum
 			i++;
 		}
 
-		sf_cap = size;
-		for (j = 0; sf_cap*10 < 1000; j++)
-			sf_cap *= 10;
-
+		j = calc_sf_digit_room(size);
 		if (j) {
 			remainder *= 1000;
 			do_div(remainder, divisor[units]);
_
