Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab2EEJ61 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 05:58:27 -0400
Received: from nm25-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.156]:25669 "HELO
	nm25-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752170Ab2EEJ60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 05:58:26 -0400
X-Yahoo-Newman-Id: 382639.75457.bm@omp1007.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: oPDDZaQVM1mqe4yQTtJF4WsvRCFTichrLG9eNl5Mgv7rSz2
 CVeKe7WwMg6sdgpMuo9LWOYQlxRCEjphkmliry2phthBvXjvVTY0P8hZ3N8g
 xDix_kutpHycdmSU2HOJUL_M1cFgqg8TZpctb.PpcN46C3NuLe1lKvFWS4cx
 GS57ltPxADWr4BPDk.OTwDcInxGsilPYCfTtX3Ue_H2XPWdlOg4se9g7ExV1
 4bRGI0CWXdi7Tcy0110i.LCSnkNVDvsmH4b6GqeBwID6MES1G3SMl_Qqr6SP
 oHTqogAjEyIRIkPQNFk_Ziqqc6kDI6qWXgYQMY81JUHvnVAIo0dtYvYPxaZ4
 59oG7x2RUq5BD1lE8FkNX6PkBscDlbXLBUKnSj6TAxR4wJFHYkCyg_gah_NI
 UZ.s5tg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FA4F842.2080601@att.net>
Date: Sat, 05 May 2012 04:52:02 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] mm/slab.c: Fix build breakage when compiling -O0
X-Enigmail-Version: 1.3.5
Content-Type: multipart/mixed;
 boundary="------------060607080109090801050700"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060607080109090801050700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------060607080109090801050700
Content-Type: text/x-patch;
 name="0001-mm-slab.c-Fix-build-breakage-when-compiling-O0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-mm-slab.c-Fix-build-breakage-when-compiling-O0.patch"

>From 64aa1504fe4838b9a9fe6dca151e23330e41b543 Mon Sep 17 00:00:00 2001
From: Daniel Santos <daniel.santos@pobox.com>
Date: Fri, 4 May 2012 19:36:24 -0500
Subject: mm/slab.c: Fix build breakage when compiling -O0

BUILD_BUG_ON is more robust, detecting when we're not optimizing and,
thus, when __builtin_constant_p will always return zero and produce a
false-positive.  Further, this distinguishes between the errors of size
not being a compile-time constant and size just not being an accepted
value.
---
 mm/slab.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index e901a36..1a618b2 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -308,10 +308,9 @@ static void cache_reap(struct work_struct *unused);
  */
 static __always_inline int index_of(const size_t size)
 {
-	extern void __bad_size(void);
+	int i = 0;
 
-	if (__builtin_constant_p(size)) {
-		int i = 0;
+	BUILD_BUG_ON(!__builtin_constant_p(size));
 
 #define CACHE(x) \
 	if (size <=x) \
@@ -320,9 +319,8 @@ static __always_inline int index_of(const size_t size)
 		i++;
 #include <linux/kmalloc_sizes.h>
 #undef CACHE
-		__bad_size();
-	} else
-		__bad_size();
+
+	BUILD_BUG(); /* bad size */
 	return 0;
 }
 
-- 
1.7.3.4


--------------060607080109090801050700--
