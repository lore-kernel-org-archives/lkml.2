Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2KFQGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 11:06:13 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41411 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2KFQGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 11:06:11 -0500
Date: Tue, 6 Nov 2012 16:11:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, linux-fbdev@vger.kernel.org,
        florianSchandinat@gmx.de
Subject: Re: tty, vt: lockdep warnings
Message-ID: <20121106161100.216c6d79@pyramind.ukuu.org.uk>
In-Reply-To: <alpine.LNX.2.00.1211051231070.21645@eggly.anvils>
References: <50899507.1040900@oracle.com>
	<20121026143754.50277bd8@pyramind.ukuu.org.uk>
	<CA+1xoqdEesjh1EZvR_r7Hn0GUc7741EDWn59qagngcxg4=9bjQ@mail.gmail.com>
	<20121105175937.26f31d2a@pyramind.ukuu.org.uk>
	<5097FEA9.2090603@oracle.com>
	<alpine.LNX.2.00.1211051106590.1709@eggly.anvils>
	<20121105201507.79fe47d7@pyramind.ukuu.org.uk>
	<alpine.LNX.2.00.1211051231070.21645@eggly.anvils>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012 12:34:44 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> On Mon, 5 Nov 2012, Alan Cox wrote:
> > > The fbdev potential for deadlock may be years old, but the warning
> > > (and consequent disabling of lockdep from that point on - making it
> > > useless to everybody else in need of it) is new, and comes from the
> > > commit below in linux-next.
> > > 
> > > I revert it in my own testing: if there is no quick fix to the
> > > fbdev issue on the way, Daniel, please revert it from your tree.
> > 
> > If you revert it you swap it for a different deadlock - and one that
> > happens more often I would expect. Not very useful.
> 
> But a deadlock we have lived with for years.  Without reverting,
> we're prevented from discovering all the new deadlocks we're adding.

We lived with it locking boxes up on users but not knowing why. The root
cause is loading two different framebuffers with one taking over from
another - that should be an obscure corner case and once the fuzz testing
can avoid.
 
> That would be ideal - thanks.


I had a semi-informed poke at this and came up with a possible patch (not very tested)


commit f4fa6c739ecc367dbb98f5be1ff626d9b2750878
Author: Alan Cox <alan@linux.intel.com>
Date:   Tue Nov 6 15:33:18 2012 +0000

    fb: Rework locking to fix lock ordering on takeover
    
    Adjust the console layer to allow a take over call where the caller already
    holds the locks. Make the fb layer lock in order.
    
    This s partly a band aid, the fb layer is terminally confused about the
    locking rules it uses for its notifiers it seems.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index f87d7e8..ea57f27 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2984,7 +2984,7 @@ int __init vty_init(const struct file_operations *console_fops)
 
 static struct class *vtconsole_class;
 
-static int bind_con_driver(const struct consw *csw, int first, int last,
+static int do_bind_con_driver(const struct consw *csw, int first, int last,
 			   int deflt)
 {
 	struct module *owner = csw->owner;
@@ -2995,7 +2995,7 @@ static int bind_con_driver(const struct consw *csw, int first, int last,
 	if (!try_module_get(owner))
 		return -ENODEV;
 
-	console_lock();
+	WARN_CONSOLE_UNLOCKED();
 
 	/* check if driver is registered */
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
@@ -3080,11 +3080,22 @@ static int bind_con_driver(const struct consw *csw, int first, int last,
 
 	retval = 0;
 err:
-	console_unlock();
 	module_put(owner);
 	return retval;
 };
 
+
+static int bind_con_driver(const struct consw *csw, int first, int last,
+			   int deflt)
+{
+	int ret;
+	
+	console_unlock();
+	ret = do_bind_con_driver(csw, first, last, deflt);
+	console_unlock();
+	return ret;
+}
+	
 #ifdef CONFIG_VT_HW_CONSOLE_BINDING
 static int con_is_graphics(const struct consw *csw, int first, int last)
 {
@@ -3196,9 +3207,9 @@ int unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
 	if (!con_is_bound(csw))
 		con_driver->flag &= ~CON_DRIVER_FLAG_INIT;
 
-	console_unlock();
 	/* ignore return value, binding should not fail */
-	bind_con_driver(defcsw, first, last, deflt);
+	do_bind_con_driver(defcsw, first, last, deflt);
+	console_unlock();
 err:
 	module_put(owner);
 	return retval;
@@ -3489,28 +3500,18 @@ int con_debug_leave(void)
 }
 EXPORT_SYMBOL_GPL(con_debug_leave);
 
-/**
- * register_con_driver - register console driver to console layer
- * @csw: console driver
- * @first: the first console to take over, minimum value is 0
- * @last: the last console to take over, maximum value is MAX_NR_CONSOLES -1
- *
- * DESCRIPTION: This function registers a console driver which can later
- * bind to a range of consoles specified by @first and @last. It will
- * also initialize the console driver by calling con_startup().
- */
-int register_con_driver(const struct consw *csw, int first, int last)
+static int do_register_con_driver(const struct consw *csw, int first, int last)
 {
 	struct module *owner = csw->owner;
 	struct con_driver *con_driver;
 	const char *desc;
 	int i, retval = 0;
 
+	WARN_CONSOLE_UNLOCKED();
+
 	if (!try_module_get(owner))
 		return -ENODEV;
 
-	console_lock();
-
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
 		con_driver = &registered_con_driver[i];
 
@@ -3563,10 +3564,29 @@ int register_con_driver(const struct consw *csw, int first, int last)
 	}
 
 err:
-	console_unlock();
 	module_put(owner);
 	return retval;
 }
+
+/**
+ * register_con_driver - register console driver to console layer
+ * @csw: console driver
+ * @first: the first console to take over, minimum value is 0
+ * @last: the last console to take over, maximum value is MAX_NR_CONSOLES -1
+ *
+ * DESCRIPTION: This function registers a console driver which can later
+ * bind to a range of consoles specified by @first and @last. It will
+ * also initialize the console driver by calling con_startup().
+ */
+int register_con_driver(const struct consw *csw, int first, int last)
+{
+	int retval;
+	
+	console_lock();
+	retval = do_register_con_driver(csw, first, last);
+	console_unlock();
+	return retval;
+}
 EXPORT_SYMBOL(register_con_driver);
 
 /**
@@ -3622,6 +3642,29 @@ EXPORT_SYMBOL(unregister_con_driver);
  *
  *      take_over_console is basically a register followed by unbind
  */
+int do_take_over_console(const struct consw *csw, int first, int last, int deflt)
+{
+	int err;
+
+	err = do_register_con_driver(csw, first, last);
+	/* if we get an busy error we still want to bind the console driver
+	 * and return success, as we may have unbound the console driver
+	 * but not unregistered it.
+	*/
+	if (err == -EBUSY)
+		err = 0;
+	if (!err)
+		do_bind_con_driver(csw, first, last, deflt);
+
+	return err;
+}
+/*
+ *	If we support more console drivers, this function is used
+ *	when a driver wants to take over some existing consoles
+ *	and become default driver for newly opened ones.
+ *
+ *      take_over_console is basically a register followed by unbind
+ */
 int take_over_console(const struct consw *csw, int first, int last, int deflt)
 {
 	int err;
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index fdefa8f..c75f8ce 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -529,6 +529,34 @@ static int search_for_mapped_con(void)
 	return retval;
 }
 
+static int do_fbcon_takeover(int show_logo)
+{
+	int err, i;
+
+	if (!num_registered_fb)
+		return -ENODEV;
+
+	if (!show_logo)
+		logo_shown = FBCON_LOGO_DONTSHOW;
+
+	for (i = first_fb_vc; i <= last_fb_vc; i++)
+		con2fb_map[i] = info_idx;
+
+	err = do_take_over_console(&fb_con, first_fb_vc, last_fb_vc,
+				fbcon_is_default);
+
+	if (err) {
+		for (i = first_fb_vc; i <= last_fb_vc; i++) {
+			con2fb_map[i] = -1;
+		}
+		info_idx = -1;
+	} else {
+		fbcon_has_console_bind = 1;
+	}
+
+	return err;
+}
+
 static int fbcon_takeover(int show_logo)
 {
 	int err, i;
@@ -3115,7 +3143,7 @@ static int fbcon_fb_registered(struct fb_info *info)
 		}
 
 		if (info_idx != -1)
-			ret = fbcon_takeover(1);
+			ret = do_fbcon_takeover(1);
 	} else {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
 			if (con2fb_map_boot[i] == idx)
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 3ff0105..588bdab 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1650,7 +1650,9 @@ static int do_register_framebuffer(struct fb_info *fb_info)
 	event.info = fb_info;
 	if (!lock_fb_info(fb_info))
 		return -ENODEV;
+        console_lock();
 	fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
+        console_unlock();
 	unlock_fb_info(fb_info);
 	return 0;
 }
diff --git a/include/linux/console.h b/include/linux/console.h
index dedb082..4ef4307 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -78,6 +78,7 @@ int con_is_bound(const struct consw *csw);
 int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
 int take_over_console(const struct consw *sw, int first, int last, int deflt);
+int do_take_over_console(const struct consw *sw, int first, int last, int deflt);
 void give_up_console(const struct consw *sw);
 #ifdef CONFIG_HW_CONSOLE
 int con_debug_enter(struct vc_data *vc);
