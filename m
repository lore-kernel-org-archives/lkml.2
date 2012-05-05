Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab2EEJ5Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 05:57:25 -0400
Received: from nm20-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.165]:23171 "HELO
	nm20-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751971Ab2EEJ5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 05:57:23 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 May 2012 05:57:23 EDT
X-Yahoo-Newman-Id: 344643.39898.bm@omp1007.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: C9INt48VM1lOU1qd7D2xjXwxdqKytTQC7F2tyRH6rerVTsN
 2DuWR0AbG51eLFDP9fQIXLvWX8PSpaokzJmjb2MEwGq1gzZumw6EYyXhZPjr
 kPmy5V_PMKKqUGnPJF2Q1O1Ea62fWIaMB_1pRz9j.UYzozqx9WJ2PTV7jOQ0
 _jYFViStzDkxvNuz4iphnaP4C8Gez1.QPQqYJrXhMcFe1PgsKhdWHIlkunny
 mqXG.B2f4R7rGfh8BR8AIe7pn_vM6DMJEt3VcCQ3aqkY5TQwEmNAkysCArlT
 6ILPflxdCeGrnhy_mXNeZA9Ru6yIVWmXUglhFIhu68ZYfdx__O2KNyeCcjaN
 CWYLWNljWPZ3GxVqOTN4sStYTDofNIiZyYTb_ecXhAERazrm5xG43nkK6xkK
 n.T9ZBqg-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FA4F8D5.6030804@att.net>
Date: Sat, 05 May 2012 04:54:29 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] mm/slab.c: Always check redzone after ctor is called
X-Enigmail-Version: 1.3.5
Content-Type: multipart/mixed;
 boundary="------------040400020105070103000504"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040400020105070103000504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------040400020105070103000504
Content-Type: text/x-patch;
 name="0002-mm-slab.c-Always-redzone-after-constructor-is-called.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-mm-slab.c-Always-redzone-after-constructor-is-called.pa";
 filename*1="tch"

>From 1d21218309249ab6a28f931898a12bbb39fa512e Mon Sep 17 00:00:00 2001
From: Daniel Santos <daniel.santos@pobox.com>
Date: Fri, 10 Feb 2012 18:16:22 -0600
Subject: mm/slab.c: Always redzone after constructor is called.

If a cache is created with (SLAB_POISON | SLAB_RED_ZONE) and a
constructor, the redzone is not checked immediately after the
constructor is called (if SLAB_POISON is not specified, it is).
Although it does appear that an overwritten red zone will get detected
when the object is freed, it wont isolate the buffer overrun to the
constructor.
---
 mm/slab.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 1a618b2..9baa287 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3265,8 +3265,18 @@ static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
 	}
 #endif
 	objp += obj_offset(cachep);
-	if (cachep->ctor && cachep->flags & SLAB_POISON)
+	if (cachep->ctor && cachep->flags & SLAB_POISON) {
 		cachep->ctor(objp);
+		if (cachep->flags & SLAB_RED_ZONE) {
+			void * origp = objp - obj_offset(cachep);
+			if (*dbg_redzone2(cachep, origp) != RED_ACTIVE)
+				slab_error(cachep, "constructor overwrote the"
+						" end of an object");
+			if (*dbg_redzone1(cachep, origp) != RED_ACTIVE)
+				slab_error(cachep, "constructor overwrote the"
+						" start of an object");
+		}
+	}
 	if (ARCH_SLAB_MINALIGN &&
 	    ((unsigned long)objp & (ARCH_SLAB_MINALIGN-1))) {
 		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
-- 
1.7.3.4


--------------040400020105070103000504--
