Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0JKWgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:36:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54988 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab0JKWgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:36:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i4rM6mAZs1nFtI5sOYYBvY3oc3NPIR8fDlMsuvVPZzq2RRiiIdloLGCerGgE1CtLiD
         v1V624dXa+qWLYGKuOjeO1KXHsL7qnX5ZYycwMNHQphaCs1ToHmZAk+yyZy3e1e0JRZR
         oqTd4LgbpnAusx1jiYJeLRpi6gU7bu02HWgvg=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@braille.uwo.ca,
        samuel.thibault@ens-lyon.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [RFC PATCH] Staging: speakup: Added EXPORT_SYMBOL_GPL() markings.
Date: Mon, 11 Oct 2010 18:36:30 -0400
Message-Id: <1286836590-6708-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed drivers/char/selection.c so that drivers/staging/speakup/selections.c
could export. Also delete some lines that were unessary since I used
EXPORT_SYMBOL_GPL().

Greg can you review this and tell me if I did it right.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/char/selection.c            |    7 +++++++
 drivers/staging/speakup/selection.c |   29 +++++++----------------------
 2 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/char/selection.c b/drivers/char/selection.c
index ebae344..a17aa42 100644
--- a/drivers/char/selection.c
+++ b/drivers/char/selection.c
@@ -64,6 +64,8 @@ sel_pos(int n)
 				use_unicode);
 }
 
+EXPORT_SYMBOL_GPL(sel_pos);
+
 /* remove the current selection highlight, if any,
    from the console holding the selection. */
 void
@@ -75,6 +77,8 @@ clear_selection(void) {
 	}
 }
 
+EXPORT_SYMBOL_GPL(clear_selection);
+
 /*
  * User settable table: what characters are to be considered alphabetic?
  * 256 bits
@@ -106,12 +110,15 @@ static inline int atedge(const int p, int size_row)
 	return (!(p % size_row)	|| !((p + 2) % size_row));
 }
 
+EXPORT_SYMBOL_GPL(atedge);
+
 /* constrain v such that v <= u */
 static inline unsigned short limit(const unsigned short v, const unsigned short u)
 {
 	return (v > u) ? u : v;
 }
 
+EXPORT_SYMBOL_GPL(limit);
 /* stores the char in UTF8 and returns the number of bytes used (1-3) */
 static int store_utf8(u16 c, char *p)
 {
diff --git a/drivers/staging/speakup/selection.c b/drivers/staging/speakup/selection.c
index 1b865ff..9195709 100644
--- a/drivers/staging/speakup/selection.c
+++ b/drivers/staging/speakup/selection.c
@@ -3,6 +3,7 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/selection.h>
+#include <linux/module.h>
 
 #include "speakup.h"
 
@@ -21,27 +22,11 @@ static int sel_end;
 static int sel_buffer_lth;
 static char *sel_buffer;
 
-static unsigned char sel_pos(int n)
-{
-	return inverse_translate(spk_sel_cons, screen_glyph(spk_sel_cons, n), 0);
-}
-
-void speakup_clear_selection(void)
-{
-	sel_start = -1;
-}
+extern u16 sel_pos(int n);
+extern void clear_selection(void);
+extern inline int atedge(const int p, int size_row);
+extern inline unsigned short limit(const unsigned short v, const unsigned short u);
 
-/* does screen address p correspond to character at LH/RH edge of screen? */
-static int atedge(const int p, int size_row)
-{
-	return (!(p % size_row) || !((p + 2) % size_row));
-}
-
-/* constrain v such that v <= u */
-static unsigned short limit(const unsigned short v, const unsigned short u)
-{
-	return (v > u) ? u : v;
-}
 
 int speakup_set_selection(struct tty_struct *tty)
 {
@@ -65,7 +50,7 @@ int speakup_set_selection(struct tty_struct *tty)
 	}
 
 	if (spk_sel_cons != vc_cons[fg_console].d) {
-		speakup_clear_selection();
+		clear_selection();
 		spk_sel_cons = vc_cons[fg_console].d;
 		printk(KERN_WARNING
 			"Selection: mark console not the same as cut\n");
@@ -95,7 +80,7 @@ int speakup_set_selection(struct tty_struct *tty)
 	bp = kmalloc((sel_end-sel_start)/2+1, GFP_ATOMIC);
 	if (!bp) {
 		printk(KERN_WARNING "selection: kmalloc() failed\n");
-		speakup_clear_selection();
+		clear_selection();
 		return -ENOMEM;
 	}
 	kfree(sel_buffer);
-- 
1.7.3.1.104.gc752e

