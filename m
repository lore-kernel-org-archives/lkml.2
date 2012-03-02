Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475Ab2CBOpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:45:47 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56941 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2CBOpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:45:44 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 5/6] vt: tackle the main part of the selection logic
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 02 Mar 2012 15:00:02 +0000
Message-ID: <20120302150000.32320.34342.stgit@bob.linux.org.uk>
In-Reply-To: <20120302145628.32320.53944.stgit@bob.linux.org.uk>
References: <20120302145628.32320.53944.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We leave the existing paste mess alone and just fix up the vt side of
things.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/vt/selection.c |   39 +++++++++++++++++++++++++++++++--------
 drivers/tty/vt/vt.c        |    2 ++
 2 files changed, 33 insertions(+), 8 deletions(-)


diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index 2a50916..8e9b4be 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -62,10 +62,14 @@ sel_pos(int n)
 				use_unicode);
 }
 
-/* remove the current selection highlight, if any,
-   from the console holding the selection. */
-void
-clear_selection(void) {
+/**
+ *	clear_selection		-	remove current selection
+ *
+ *	Remove the current selection highlight, if any from the console
+ *	holding the selection. The caller must hold the console lock.
+ */
+void clear_selection(void)
+{
 	highlight_pointer(-1); /* hide the pointer */
 	if (sel_start != -1) {
 		highlight(sel_start, sel_end);
@@ -75,7 +79,7 @@ clear_selection(void) {
 
 /*
  * User settable table: what characters are to be considered alphabetic?
- * 256 bits. FIXME: Needs a locking model.
+ * 256 bits. Locked by the console lock.
  */
 static u32 inwordLut[8]={
   0x00000000, /* control chars     */
@@ -92,10 +96,20 @@ static inline int inword(const u16 c) {
 	return c > 0xff || (( inwordLut[c>>5] >> (c & 0x1F) ) & 1);
 }
 
-/* set inwordLut contents. Invoked by ioctl(). */
+/**
+ *	set loadlut		-	load the LUT table
+ *	@p: user table
+ *
+ *	Load the LUT table from user space. The caller must hold the console
+ *	lock. Make a temporary copy so a partial update doesn't make a mess.
+ */
 int sel_loadlut(char __user *p)
 {
-	return copy_from_user(inwordLut, (u32 __user *)(p+4), 32) ? -EFAULT : 0;
+	u32 tmplut[8];
+	if (copy_from_user(tmplut, (u32 __user *)(p+4), 32))
+		return -EFAULT;
+	memcpy(inwordLut, tmplut, 32);
+	return 0;
 }
 
 /* does screen address p correspond to character at LH/RH edge of screen? */
@@ -131,7 +145,16 @@ static int store_utf8(u16 c, char *p)
     	}
 }
 
-/* set the current selection. Invoked by ioctl() or by kernel code. */
+/**
+ *	set_selection		- 	set the current selection.
+ *	@sel: user selection info
+ *	@tty: the console tty
+ *
+ *	Invoked by the ioctl handle for the vt layer.
+ *
+ *	The entire selection process is managed under the console_lock. It's
+ *	 a lot under the lock but its hardly a performance path
+ */
 int set_selection(const struct tiocl_selection __user *sel, struct tty_struct *tty)
 {
 	struct vc_data *vc = vc_cons[fg_console].d;
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 280a4c4..7d79ca8 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2623,7 +2623,9 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 			console_unlock();
 			break;
 		case TIOCL_SELLOADLUT:
+			console_lock();
 			ret = sel_loadlut(p);
+			console_unlock();
 			break;
 		case TIOCL_GETSHIFTSTATE:
 

