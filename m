Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab1ARRfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:35:52 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44428 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647Ab1ARRfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:35:51 -0500
Subject: [GIT PULL] parisc fixes for 2.6.38-rc1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 11:35:48 -0600
Message-ID: <1295372148.9752.174.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a couple of minor parisc specific fixes.  One for a console
line wrap issue and the other for the transparent hugepages compile
failure.  We've run these through our usual build and boot checks.

The patches are here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/parisc-2.6.git#fixes

The short changelog is:

Guy Martin (1):
      parisc : Remove broken line wrapping handling pdc_iodc_print()

James Bottomley (1):
      parisc: fix compile breakage caused by inlining maybe_mkwrite

And the diffstat:

 arch/parisc/include/asm/pgtable.h |    4 +++-
 arch/parisc/kernel/firmware.c     |   13 +------------
 2 files changed, 4 insertions(+), 13 deletions(-)

Full diffs are below.

James

---

diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index 865f37a..6f1f65d 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -10,11 +10,13 @@
  * we simulate an x86-style page table for the linux mm code
  */
 
-#include <linux/mm.h>		/* for vm_area_struct */
 #include <linux/bitops.h>
+#include <linux/spinlock.h>
 #include <asm/processor.h>
 #include <asm/cache.h>
 
+struct vm_area_struct;
+
 /*
  * kern_addr_valid(ADDR) tests if ADDR is pointing to valid kernel
  * memory.  For the return value to be meaningful, ADDR must be >=
diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
index df971fa..4896ed0 100644
--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -1126,15 +1126,13 @@ int pdc_iodc_print(const unsigned char *str, unsigned count)
 	unsigned int i;
 	unsigned long flags;
 
-	for (i = 0; i < count && i < 79;) {
+	for (i = 0; i < count;) {
 		switch(str[i]) {
 		case '\n':
 			iodc_dbuf[i+0] = '\r';
 			iodc_dbuf[i+1] = '\n';
 			i += 2;
 			goto print;
-		case '\b':	/* BS */
-			i--; /* overwrite last */
 		default:
 			iodc_dbuf[i] = str[i];
 			i++;
@@ -1142,15 +1140,6 @@ int pdc_iodc_print(const unsigned char *str, unsigned count)
 		}
 	}
 
-	/* if we're at the end of line, and not already inserting a newline,
-	 * insert one anyway. iodc console doesn't claim to support >79 char
-	 * lines. don't account for this in the return value.
-	 */
-	if (i == 79 && iodc_dbuf[i-1] != '\n') {
-		iodc_dbuf[i+0] = '\r';
-		iodc_dbuf[i+1] = '\n';
-	}
-
 print:
         spin_lock_irqsave(&pdc_lock, flags);
         real32_call(PAGE0->mem_cons.iodc_io,


