Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab2FGEpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:45:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab2FGEQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:16:39 -0400
Message-Id: <20120607040338.568588242@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:03:51 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Helge Deller <deller@gmx.de>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 15/82] PARISC: fix TLB fault path on PA2.0 narrow systems
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit 2f649c1f6f0fef445ce79a19b79e5ce8fe9d7f19 upstream.

commit 5e185581d7c46ddd33cd9c01106d1fc86efb9376
Author: James Bottomley <JBottomley@Parallels.com>

    [PARISC] fix PA1.1 oops on boot

Didn't quite fix the crash on boot.  It moved it from PA1.1 processors to
PA2.0 narrow kernels.  The final fix is to make sure the [id]tlb_miss_20 paths
also work.  Even on narrow systems, these paths require using the wide
instructions becuase the tlb insertion format is wide.  Fix this by
conditioning the dep[wd],z on whether we're being called from _11 or _20[w]
paths.

Tested-by: Helge Deller <deller@gmx.de>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/entry.S |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -552,7 +552,7 @@
 	 * entry (identifying the physical page) and %r23 up with
 	 * the from tlb entry (or nothing if only a to entry---for
 	 * clear_user_page_asm) */
-	.macro		do_alias	spc,tmp,tmp1,va,pte,prot,fault
+	.macro		do_alias	spc,tmp,tmp1,va,pte,prot,fault,patype
 	cmpib,COND(<>),n 0,\spc,\fault
 	ldil		L%(TMPALIAS_MAP_START),\tmp
 #if defined(CONFIG_64BIT) && (TMPALIAS_MAP_START >= 0x80000000)
@@ -581,11 +581,15 @@
 	 */
 	cmpiclr,=	0x01,\tmp,%r0
 	ldi		(_PAGE_DIRTY|_PAGE_READ|_PAGE_WRITE),\prot
-#ifdef CONFIG_64BIT
+.ifc \patype,20
 	depd,z		\prot,8,7,\prot
-#else
+.else
+.ifc \patype,11
 	depw,z		\prot,8,7,\prot
-#endif
+.else
+	.error "undefined PA type to do_alias"
+.endif
+.endif
 	/*
 	 * OK, it is in the temp alias region, check whether "from" or "to".
 	 * Check "subtle" note in pacache.S re: r23/r26.
@@ -1189,7 +1193,7 @@ dtlb_miss_20w:
 	nop
 
 dtlb_check_alias_20w:
-	do_alias	spc,t0,t1,va,pte,prot,dtlb_fault
+	do_alias	spc,t0,t1,va,pte,prot,dtlb_fault,20
 
 	idtlbt          pte,prot
 
@@ -1213,7 +1217,7 @@ nadtlb_miss_20w:
 	nop
 
 nadtlb_check_alias_20w:
-	do_alias	spc,t0,t1,va,pte,prot,nadtlb_emulate
+	do_alias	spc,t0,t1,va,pte,prot,nadtlb_emulate,20
 
 	idtlbt          pte,prot
 
@@ -1245,7 +1249,7 @@ dtlb_miss_11:
 	nop
 
 dtlb_check_alias_11:
-	do_alias	spc,t0,t1,va,pte,prot,dtlb_fault
+	do_alias	spc,t0,t1,va,pte,prot,dtlb_fault,11
 
 	idtlba          pte,(va)
 	idtlbp          prot,(va)
@@ -1277,7 +1281,7 @@ nadtlb_miss_11:
 	nop
 
 nadtlb_check_alias_11:
-	do_alias	spc,t0,t1,va,pte,prot,nadtlb_emulate
+	do_alias	spc,t0,t1,va,pte,prot,nadtlb_emulate,11
 
 	idtlba          pte,(va)
 	idtlbp          prot,(va)
@@ -1304,7 +1308,7 @@ dtlb_miss_20:
 	nop
 
 dtlb_check_alias_20:
-	do_alias	spc,t0,t1,va,pte,prot,dtlb_fault
+	do_alias	spc,t0,t1,va,pte,prot,dtlb_fault,20
 	
 	idtlbt          pte,prot
 
@@ -1330,7 +1334,7 @@ nadtlb_miss_20:
 	nop
 
 nadtlb_check_alias_20:
-	do_alias	spc,t0,t1,va,pte,prot,nadtlb_emulate
+	do_alias	spc,t0,t1,va,pte,prot,nadtlb_emulate,20
 
 	idtlbt          pte,prot
 
@@ -1457,7 +1461,7 @@ naitlb_miss_20w:
 	nop
 
 naitlb_check_alias_20w:
-	do_alias	spc,t0,t1,va,pte,prot,naitlb_fault
+	do_alias	spc,t0,t1,va,pte,prot,naitlb_fault,20
 
 	iitlbt		pte,prot
 
@@ -1511,7 +1515,7 @@ naitlb_miss_11:
 	nop
 
 naitlb_check_alias_11:
-	do_alias	spc,t0,t1,va,pte,prot,itlb_fault
+	do_alias	spc,t0,t1,va,pte,prot,itlb_fault,11
 
 	iitlba          pte,(%sr0, va)
 	iitlbp          prot,(%sr0, va)
@@ -1557,7 +1561,7 @@ naitlb_miss_20:
 	nop
 
 naitlb_check_alias_20:
-	do_alias	spc,t0,t1,va,pte,prot,naitlb_fault
+	do_alias	spc,t0,t1,va,pte,prot,naitlb_fault,20
 
 	iitlbt          pte,prot
 


