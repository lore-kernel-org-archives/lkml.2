Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805Ab2CATiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:38:14 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46318 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab2CATiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:38:11 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 6/6] vt: push the tty_lock down into the map handling
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Thu, 01 Mar 2012 19:52:28 +0000
Message-ID: <20120301195226.11322.27221.stgit@bob.linux.org.uk>
In-Reply-To: <20120301194831.11322.38295.stgit@bob.linux.org.uk>
References: <20120301194831.11322.38295.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

When we do this it becomes clear the lock we should be holding is the vc
lock, and in fact many of our other helpers are properly invoked this way.

We don't at this point guarantee not to race the keyboard code but the results
of that appear harmless and that was true before we started as well.

We now have no users of tty_lock in the console driver...

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/vt/consolemap.c |  119 ++++++++++++++++++++++++++++++++-----------
 drivers/tty/vt/vt_ioctl.c   |   25 ++-------
 include/linux/vt_kern.h     |    1 
 3 files changed, 93 insertions(+), 52 deletions(-)


diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index a0f3d6c..299fa08 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -312,6 +312,7 @@ int con_set_trans_old(unsigned char __user * arg)
 	if (!access_ok(VERIFY_READ, arg, E_TABSZ))
 		return -EFAULT;
 
+	console_lock();
 	for (i=0; i<E_TABSZ ; i++) {
 		unsigned char uc;
 		__get_user(uc, arg+i);
@@ -319,6 +320,7 @@ int con_set_trans_old(unsigned char __user * arg)
 	}
 
 	update_user_maps();
+	console_unlock();
 	return 0;
 }
 
@@ -330,11 +332,13 @@ int con_get_trans_old(unsigned char __user * arg)
 	if (!access_ok(VERIFY_WRITE, arg, E_TABSZ))
 		return -EFAULT;
 
+	console_lock();
 	for (i=0; i<E_TABSZ ; i++)
-	  {
-	    ch = conv_uni_to_pc(vc_cons[fg_console].d, p[i]);
-	    __put_user((ch & ~0xff) ? 0 : ch, arg+i);
-	  }
+	{
+		ch = conv_uni_to_pc(vc_cons[fg_console].d, p[i]);
+		__put_user((ch & ~0xff) ? 0 : ch, arg+i);
+	}
+	console_unlock();
 	return 0;
 }
 
@@ -346,6 +350,7 @@ int con_set_trans_new(ushort __user * arg)
 	if (!access_ok(VERIFY_READ, arg, E_TABSZ*sizeof(unsigned short)))
 		return -EFAULT;
 
+	console_lock();
 	for (i=0; i<E_TABSZ ; i++) {
 		unsigned short us;
 		__get_user(us, arg+i);
@@ -353,6 +358,7 @@ int con_set_trans_new(ushort __user * arg)
 	}
 
 	update_user_maps();
+	console_unlock();
 	return 0;
 }
 
@@ -364,8 +370,10 @@ int con_get_trans_new(ushort __user * arg)
 	if (!access_ok(VERIFY_WRITE, arg, E_TABSZ*sizeof(unsigned short)))
 		return -EFAULT;
 
+	console_lock();
 	for (i=0; i<E_TABSZ ; i++)
 	  __put_user(p[i], arg+i);
+	console_unlock();
 	
 	return 0;
 }
@@ -407,6 +415,7 @@ static void con_release_unimap(struct uni_pagedir *p)
 	}
 }
 
+/* Caller must hold the console lock */
 void con_free_unimap(struct vc_data *vc)
 {
 	struct uni_pagedir *p;
@@ -487,17 +496,21 @@ con_insert_unipair(struct uni_pagedir *p, u_short unicode, u_short fontpos)
 	return 0;
 }
 
-/* ui is a leftover from using a hashtable, but might be used again */
-int con_clear_unimap(struct vc_data *vc, struct unimapinit *ui)
+/* ui is a leftover from using a hashtable, but might be used again
+   Caller must hold the lock */
+static int con_do_clear_unimap(struct vc_data *vc, struct unimapinit *ui)
 {
 	struct uni_pagedir *p, *q;
-  
+
 	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
-	if (p && p->readonly) return -EIO;
+	if (p && p->readonly)
+		return -EIO;
+
 	if (!p || --p->refcount) {
 		q = kzalloc(sizeof(*p), GFP_KERNEL);
 		if (!q) {
-			if (p) p->refcount++;
+			if (p)
+				p->refcount++;
 			return -ENOMEM;
 		}
 		q->refcount=1;
@@ -511,22 +524,41 @@ int con_clear_unimap(struct vc_data *vc, struct unimapinit *ui)
 	return 0;
 }
 
+int con_clear_unimap(struct vc_data *vc, struct unimapinit *ui)
+{
+	int ret;
+	console_lock();
+	ret = con_do_clear_unimap(vc, ui);
+	console_unlock();
+	return ret;
+}
+	
 int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 {
 	int err = 0, err1, i;
 	struct uni_pagedir *p, *q;
 
+	console_lock();
 	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
-	if (p->readonly) return -EIO;
+	if (p->readonly) {
+		console_unlock();
+		return -EIO;
+	}
 	
-	if (!ct) return 0;
+	if (!ct) {
+		console_unlock();
+		return 0;
+	}
 	
 	if (p->refcount > 1) {
 		int j, k;
 		u16 **p1, *p2, l;
 		
-		err1 = con_clear_unimap(vc, NULL);
-		if (err1) return err1;
+		err1 = con_do_clear_unimap(vc, NULL);
+		if (err1) {
+			console_unlock();
+			return err1;
+		}
 		
 		q = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
 		for (i = 0, l = 0; i < 32; i++)
@@ -541,6 +573,7 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 						*vc->vc_uni_pagedir_loc = (unsigned long)p;
 						con_release_unimap(q);
 						kfree(q);
+						console_unlock();
 						return err1; 
 					}
               			}
@@ -557,21 +590,30 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 		list++;
 	}
 	
-	if (con_unify_unimap(vc, p))
+	if (con_unify_unimap(vc, p)) {
+		console_unlock();
 		return err;
+	}
 
 	for (i = 0; i <= 3; i++)
 		set_inverse_transl(vc, p, i); /* Update all inverse translations */
 	set_inverse_trans_unicode(vc, p);
-  
+
+	console_unlock();
 	return err;
 }
 
-/* Loads the unimap for the hardware font, as defined in uni_hash.tbl.
-   The representation used was the most compact I could come up
-   with.  This routine is executed at sys_setup time, and when the
-   PIO_FONTRESET ioctl is called. */
-
+/**
+ *	con_set_default_unimap	-	set default unicode map
+ *	@vc: the console we are updating
+ *
+ *	Loads the unimap for the hardware font, as defined in uni_hash.tbl.
+ *	The representation used was the most compact I could come up
+ *	with.  This routine is executed at video setup, and when the
+ *	PIO_FONTRESET ioctl is called. 
+ *
+ *	The caller must hold the console lock
+ */
 int con_set_default_unimap(struct vc_data *vc)
 {
 	int i, j, err = 0, err1;
@@ -582,6 +624,7 @@ int con_set_default_unimap(struct vc_data *vc)
 		p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
 		if (p == dflt)
 			return 0;
+
 		dflt->refcount++;
 		*vc->vc_uni_pagedir_loc = (unsigned long)dflt;
 		if (p && !--p->refcount) {
@@ -593,8 +636,9 @@ int con_set_default_unimap(struct vc_data *vc)
 	
 	/* The default font is always 256 characters */
 
-	err = con_clear_unimap(vc, NULL);
-	if (err) return err;
+	err = con_do_clear_unimap(vc, NULL);
+	if (err)
+		return err;
     
 	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
 	q = dfont_unitable;
@@ -619,6 +663,13 @@ int con_set_default_unimap(struct vc_data *vc)
 }
 EXPORT_SYMBOL(con_set_default_unimap);
 
+/**
+ *	con_copy_unimap		-	copy unimap between two vts
+ *	@dst_vc: target
+ *	@src_vt: source
+ *
+ *	The caller must hold the console lock when invoking this method
+ */
 int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc)
 {
 	struct uni_pagedir *q;
@@ -633,13 +684,23 @@ int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc)
 	*dst_vc->vc_uni_pagedir_loc = (long)q;
 	return 0;
 }
+EXPORT_SYMBOL(con_copy_unimap);
 
+/**
+ *	con_get_unimap		-	get the unicode map
+ *	@vc: the console to read from
+ *
+ *	Read the console unicode data for this console. Called from the ioctl
+ *	handlers.
+ */
 int con_get_unimap(struct vc_data *vc, ushort ct, ushort __user *uct, struct unipair __user *list)
 {
 	int i, j, k, ect;
 	u16 **p1, *p2;
 	struct uni_pagedir *p;
 
+	console_lock();
+
 	ect = 0;
 	if (*vc->vc_uni_pagedir_loc) {
 		p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
@@ -659,22 +720,19 @@ int con_get_unimap(struct vc_data *vc, ushort ct, ushort __user *uct, struct uni
 				}
 	}
 	__put_user(ect, uct);
+	console_unlock();
 	return ((ect <= ct) ? 0 : -ENOMEM);
 }
 
-void con_protect_unimap(struct vc_data *vc, int rdonly)
-{
-	struct uni_pagedir *p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
-	
-	if (p)
-		p->readonly = rdonly;
-}
-
 /*
  * Always use USER_MAP. These functions are used by the keyboard,
  * which shouldn't be affected by G0/G1 switching, etc.
  * If the user map still contains default values, i.e. the
  * direct-to-font mapping, then assume user is using Latin1.
+ *
+ * FIXME: at some point we need to decide if we want to lock the table
+ * update element itself via the keyboard_event_lock for consistency with the
+ * keyboard driver as well as the consoles
  */
 /* may be called during an interrupt */
 u32 conv_8bit_to_uni(unsigned char c)
@@ -742,4 +800,3 @@ console_map_init(void)
 			con_set_default_unimap(vc_cons[i].d);
 }
 
-EXPORT_SYMBOL(con_copy_unimap);
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index ede2ef1..6461854 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -910,7 +910,9 @@ int vt_ioctl(struct tty_struct *tty,
 		ret = con_font_op(vc_cons[fg_console].d, &op);
 		if (ret)
 			break;
+		console_lock();
 		con_set_default_unimap(vc_cons[fg_console].d);
+		console_unlock();
 		break;
 		}
 #endif
@@ -934,33 +936,23 @@ int vt_ioctl(struct tty_struct *tty,
 	case PIO_SCRNMAP:
 		if (!perm)
 			ret = -EPERM;
-		else {
-			tty_lock();
+		else
 			ret = con_set_trans_old(up);
-			tty_unlock();
-		}
 		break;
 
 	case GIO_SCRNMAP:
-		tty_lock();
 		ret = con_get_trans_old(up);
-		tty_unlock();
 		break;
 
 	case PIO_UNISCRNMAP:
 		if (!perm)
 			ret = -EPERM;
-		else {
-			tty_lock();
+		else
 			ret = con_set_trans_new(up);
-			tty_unlock();
-		}
 		break;
 
 	case GIO_UNISCRNMAP:
-		tty_lock();
 		ret = con_get_trans_new(up);
-		tty_unlock();
 		break;
 
 	case PIO_UNIMAPCLR:
@@ -970,19 +962,14 @@ int vt_ioctl(struct tty_struct *tty,
 		ret = copy_from_user(&ui, up, sizeof(struct unimapinit));
 		if (ret)
 			ret = -EFAULT;
-		else {
-			tty_lock();
+		else
 			con_clear_unimap(vc, &ui);
-			tty_unlock();
-		}
 		break;
 	      }
 
 	case PIO_UNIMAP:
 	case GIO_UNIMAP:
-		tty_lock();
 		ret = do_unimap_ioctl(cmd, up, perm, vc);
-		tty_unlock();
 		break;
 
 	case VT_LOCKSWITCH:
@@ -1196,9 +1183,7 @@ long vt_compat_ioctl(struct tty_struct *tty,
 
 	case PIO_UNIMAP:
 	case GIO_UNIMAP:
-		tty_lock();
 		ret = compat_unimap_ioctl(cmd, up, perm, vc);
-		tty_unlock();
 		break;
 
 	/*
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index e33d77f..50ae7d0 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -70,7 +70,6 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list);
 int con_get_unimap(struct vc_data *vc, ushort ct, ushort __user *uct, struct unipair __user *list);
 int con_set_default_unimap(struct vc_data *vc);
 void con_free_unimap(struct vc_data *vc);
-void con_protect_unimap(struct vc_data *vc, int rdonly);
 int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc);
 
 #define vc_translate(vc, c) ((vc)->vc_translate[(c) |			\

