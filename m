Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2E0Bvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:51:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab2E0BGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:06:08 -0400
Message-Id: <20120527010424.635810856@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:29 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Helge Deller <deller@gmx.de>,
        John David Anglin <dave.anglin@bell.net>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 06/94] PARISC: fix crash in flush_icache_page_asm on PA1.1
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit 207f583d7179f707f402c36a7bda5ca1fd03ad5b upstream.

As pointed out by serveral people, PA1.1 only has a type 26 instruction
meaning that the space register must be explicitly encoded.  Not giving an
explicit space means that the compiler uses the type 24 version which is PA2.0
only resulting in an illegal instruction crash.

This regression was caused by

    commit f311847c2fcebd81912e2f0caf8a461dec28db41
    Author: James Bottomley <James.Bottomley@HansenPartnership.com>
    Date:   Wed Dec 22 10:22:11 2010 -0600

        parisc: flush pages through tmpalias space

Reported-by: Helge Deller <deller@gmx.de>
Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/pacache.S |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/arch/parisc/kernel/pacache.S
+++ b/arch/parisc/kernel/pacache.S
@@ -692,7 +692,7 @@ ENTRY(flush_icache_page_asm)
 
 	/* Purge any old translation */
 
-	pitlb		(%sr0,%r28)
+	pitlb		(%sr4,%r28)
 
 	ldil		L%icache_stride, %r1
 	ldw		R%icache_stride(%r1), %r1
@@ -706,27 +706,29 @@ ENTRY(flush_icache_page_asm)
 	sub		%r25, %r1, %r25
 
 
-1:      fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
+	/* fic only has the type 26 form on PA1.1, requiring an
+	 * explicit space specification, so use %sr4 */
+1:      fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
 	cmpb,COND(<<)		%r28, %r25,1b
-	fic,m		%r1(%r28)
+	fic,m		%r1(%sr4,%r28)
 
 	sync
 	bv		%r0(%r2)
-	pitlb		(%sr0,%r25)
+	pitlb		(%sr4,%r25)
 	.exit
 
 	.procend


