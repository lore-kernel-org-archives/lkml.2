Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab0KPPqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:46:42 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39537 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0KPPqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:46:39 -0500
Subject: tty: add 'active' sysfs attribute to tty0 and console device
From: Kay Sievers <kay.sievers@vrfy.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Lennart Poettering <lennart@poettering.net>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 16:46:40 +0100
Message-ID: <1289922400.1253.3.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit be0d5f02c9194fe41c1aad11d7282db117bda938
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Tue Nov 9 18:53:59 2010 +0100

    tty: add 'active' sysfs attribute to tty0 and console device
    
    Userspace can query the actual virtual console, and the configured
    console devices behind /dev/tt0 and /dev/console.
    
    The last entry in the list of devices is the active device, analog
    to the console= kernel command line option.
    
    The attribute supports poll(), which is raised when the virtual
    console is changed or /dev/console is reconfigured.
    
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

diff --git a/Documentation/ABI/testing/sysfs-tty b/Documentation/ABI/testing/sysfs-tty
new file mode 100644
index 0000000..b138b66
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-tty
@@ -0,0 +1,19 @@
+What:		/sys/class/tty/console/active
+Date:		Nov 2010
+Contact:	Kay Sievers <kay.sievers@vrfy.org>
+Description:
+		 Shows the list of currently configured
+		 console devices, like 'tty1 ttyS0'.
+		 The last entry in the file is the active
+		 device connected to /dev/console.
+		 The file supports poll() to detect virtual
+		 console switches.
+
+What:		/sys/class/tty/tty0/active
+Date:		Nov 2010
+Contact:	Kay Sievers <kay.sievers@vrfy.org>
+Description:
+		 Shows the currently active virtual console
+		 device, like 'tty1'.
+		 The file supports poll() to detect virtual
+		 console switches.
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c05c5af..be5ab4a 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3232,9 +3232,45 @@ static int __init tty_class_init(void)
 postcore_initcall(tty_class_init);
 
 /* 3/2004 jmc: why do these devices exist? */
-
 static struct cdev tty_cdev, console_cdev;
 
+static ssize_t show_cons_active(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct console *cs[16];
+	int i = 0;
+	struct console *c;
+	ssize_t count = 0;
+
+	acquire_console_sem();
+	for (c = console_drivers; c; c = c->next) {
+		if (!c->device)
+			continue;
+		if (!c->write)
+			continue;
+		if ((c->flags & CON_ENABLED) == 0)
+			continue;
+		cs[i++] = c;
+		if (i >= ARRAY_SIZE(cs))
+			break;
+	}
+	while (i--)
+		count += sprintf(buf + count, "%s%d%c",
+				 cs[i]->name, cs[i]->index, i ? ' ':'\n');
+	release_console_sem();
+
+	return count;
+}
+static DEVICE_ATTR(active, S_IRUGO, show_cons_active, NULL);
+
+static struct device *consdev;
+
+void console_sysfs_notify(void)
+{
+	if (consdev)
+		sysfs_notify(&consdev->kobj, NULL, "active");
+}
+
 /*
  * Ok, now we can initialize the rest of the tty devices and can count
  * on memory allocations, interrupts etc..
@@ -3245,15 +3281,18 @@ int __init tty_init(void)
 	if (cdev_add(&tty_cdev, MKDEV(TTYAUX_MAJOR, 0), 1) ||
 	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 0), 1, "/dev/tty") < 0)
 		panic("Couldn't register /dev/tty driver\n");
-	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 0), NULL,
-			      "tty");
+	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 0), NULL, "tty");
 
 	cdev_init(&console_cdev, &console_fops);
 	if (cdev_add(&console_cdev, MKDEV(TTYAUX_MAJOR, 1), 1) ||
 	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 1), 1, "/dev/console") < 0)
 		panic("Couldn't register /dev/console driver\n");
-	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 1), NULL,
+	consdev = device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 1), NULL,
 			      "console");
+	if (IS_ERR(consdev))
+		consdev = NULL;
+	else
+		device_create_file(consdev, &dev_attr_active);
 
 #ifdef CONFIG_VT
 	vty_init(&console_fops);
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index a8ec48e..76407ec 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -236,6 +236,14 @@ enum {
 };
 
 /*
+ * /sys/class/tty/tty0/
+ *
+ * the attribute 'active' contains the name of the current vc
+ * console and it supports poll() to detect vc switches
+ */
+static struct device *tty0dev;
+
+/*
  * Notifier list for console events.
  */
 static ATOMIC_NOTIFIER_HEAD(vt_notifier_list);
@@ -688,6 +696,8 @@ void redraw_screen(struct vc_data *vc, int is_switch)
 			save_screen(old_vc);
 			set_origin(old_vc);
 		}
+		if (tty0dev)
+			sysfs_notify(&tty0dev->kobj, NULL, "active");
 	} else {
 		hide_cursor(vc);
 		redraw = 1;
@@ -2967,13 +2977,24 @@ static const struct tty_operations con_ops = {
 
 static struct cdev vc0_cdev;
 
+static ssize_t show_tty_active(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "tty%d\n", fg_console + 1);
+}
+static DEVICE_ATTR(active, S_IRUGO, show_tty_active, NULL);
+
 int __init vty_init(const struct file_operations *console_fops)
 {
 	cdev_init(&vc0_cdev, console_fops);
 	if (cdev_add(&vc0_cdev, MKDEV(TTY_MAJOR, 0), 1) ||
 	    register_chrdev_region(MKDEV(TTY_MAJOR, 0), 1, "/dev/vc/0") < 0)
 		panic("Couldn't register /dev/tty0 driver\n");
-	device_create(tty_class, NULL, MKDEV(TTY_MAJOR, 0), NULL, "tty0");
+	tty0dev = device_create(tty_class, NULL, MKDEV(TTY_MAJOR, 0), NULL, "tty0");
+	if (IS_ERR(tty0dev))
+		tty0dev = NULL;
+	else
+		device_create_file(tty0dev, &dev_attr_active);
 
 	vcs_init();
 
diff --git a/include/linux/console.h b/include/linux/console.h
index 95cf6f0..0752d92 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -145,7 +145,7 @@ extern int is_console_locked(void);
 extern int braille_register_console(struct console *, int index,
 		char *console_options, char *braille_options);
 extern int braille_unregister_console(struct console *);
-
+extern void console_sysfs_notify(void);
 extern int console_suspend_enabled;
 
 /* Suspend and resume console messages over PM events */
diff --git a/kernel/printk.c b/kernel/printk.c
index 9a2264f..16f2084 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1357,6 +1357,7 @@ void register_console(struct console *newcon)
 		spin_unlock_irqrestore(&logbuf_lock, flags);
 	}
 	release_console_sem();
+	console_sysfs_notify();
 
 	/*
 	 * By unregistering the bootconsoles after we enable the real console
@@ -1415,6 +1416,7 @@ int unregister_console(struct console *console)
 		console_drivers->flags |= CON_CONSDEV;
 
 	release_console_sem();
+	console_sysfs_notify();
 	return res;
 }
 EXPORT_SYMBOL(unregister_console);


