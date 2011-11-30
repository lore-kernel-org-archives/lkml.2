Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1K3V3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 16:29:12 -0500
Received: from mail-fx0-f74.google.com ([209.85.161.74]:56529 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1K3V3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 16:29:09 -0500
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] cdc-acm: Fix potential deadlock (lockdep warning)
Date: Wed, 30 Nov 2011 13:28:14 -0800
Message-Id: <1322688494-8060-1-git-send-email-hskinnemoen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the locking and lifecycle management in the cdc-acm driver.
Instead of using a global mutex to prevent the 'acm' object from being
freed, use the tty_port kref to keep the device alive when either the
USB side or TTY side is still active.

This allows us to use the global mutex purely for protecting the
acm_table, while use acm->mutex to guard against disconnect during
TTY port activation and shutdown.

The USB-side kref is taken during port initialization in probe(), and
released at the end of disconnect(). The TTY-side kref is taken in
install() and released in cleanup(). On disconnect, tty_vhangup() is
called instead of tty_hangup() to ensure the TTY hangup processing is
completed before the USB device is taken down.

The TTY open and close handlers have been gutted and replaced with
tty_port_open() and tty_port_close() respectively. The driver-specific
code which used to be there was spread across install(), activate() and
shutdown().

Reported-by: Dave Jones <davej@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
---
After fixing my stupid mistake in setting the control signal on open, the
driver seems to behave well, with or without lockdep enabled.

 drivers/usb/class/cdc-acm.c |  326 +++++++++++++++++++++++++------------------
 drivers/usb/class/cdc-acm.h |    1 +
 2 files changed, 189 insertions(+), 138 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index e8c564a..3027ada 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -58,12 +58,64 @@ static struct usb_driver acm_driver;
 static struct tty_driver *acm_tty_driver;
 static struct acm *acm_table[ACM_TTY_MINORS];
 
-static DEFINE_MUTEX(open_mutex);
+static DEFINE_MUTEX(acm_table_lock);
 
 #define ACM_READY(acm)	(acm && acm->dev && acm->port.count)
 
-static const struct tty_port_operations acm_port_ops = {
-};
+/*
+ * acm_table accessors
+ */
+
+/*
+ * Look up an ACM structure by index. If found and not disconnected, increment
+ * its refcount and return it with its mutex held.
+ */
+static struct acm *acm_get_by_index(unsigned index)
+{
+	struct acm *acm;
+
+	mutex_lock(&acm_table_lock);
+	acm = acm_table[index];
+	if (acm) {
+		mutex_lock(&acm->mutex);
+		if (acm->disconnected) {
+			mutex_unlock(&acm->mutex);
+			acm = NULL;
+		} else {
+			tty_port_get(&acm->port);
+			mutex_unlock(&acm->mutex);
+		}
+	}
+	mutex_unlock(&acm_table_lock);
+	return acm;
+}
+
+/*
+ * Try to find an available minor number and if found, associate it with 'acm'.
+ */
+static int acm_alloc_minor(struct acm *acm)
+{
+	int minor;
+
+	mutex_lock(&acm_table_lock);
+	for (minor = 0; minor < ACM_TTY_MINORS; minor++) {
+		if (!acm_table[minor]) {
+			acm_table[minor] = acm;
+			break;
+		}
+	}
+	mutex_unlock(&acm_table_lock);
+
+	return minor;
+}
+
+/* Release the minor number associated with 'acm'.  */
+static void acm_release_minor(struct acm *acm)
+{
+	mutex_lock(&acm_table_lock);
+	acm_table[acm->minor] = NULL;
+	mutex_unlock(&acm_table_lock);
+}
 
 /*
  * Functions for ACM control messages.
@@ -453,93 +505,122 @@ static void acm_softint(struct work_struct *work)
  * TTY handlers
  */
 
-static int acm_tty_open(struct tty_struct *tty, struct file *filp)
+static int acm_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	struct acm *acm;
-	int rv = -ENODEV;
-
-	mutex_lock(&open_mutex);
+	int retval;
 
-	acm = acm_table[tty->index];
-	if (!acm || !acm->dev)
-		goto out;
-	else
-		rv = 0;
+	dev_dbg(tty->dev, "%s\n", __func__);
 
-	dev_dbg(&acm->control->dev, "%s\n", __func__);
+	acm = acm_get_by_index(tty->index);
+	if (!acm)
+		return -ENODEV;
 
-	set_bit(TTY_NO_WRITE_SPLIT, &tty->flags);
+	retval = tty_init_termios(tty);
+	if (retval)
+		goto error_init_termios;
 
 	tty->driver_data = acm;
-	tty_port_tty_set(&acm->port, tty);
 
-	if (usb_autopm_get_interface(acm->control) < 0)
-		goto early_bail;
-	else
-		acm->control->needs_remote_wakeup = 1;
+	/* Final install (we use the default method) */
+	tty_driver_kref_get(driver);
+	tty->count++;
+	driver->ttys[tty->index] = tty;
+
+	return 0;
+
+error_init_termios:
+	tty_port_put(&acm->port);
+	return retval;
+}
+
+static int acm_tty_open(struct tty_struct *tty, struct file *filp)
+{
+	struct acm *acm = tty->driver_data;
+
+	dev_dbg(tty->dev, "%s\n", __func__);
+
+	return tty_port_open(&acm->port, tty, filp);
+}
+
+static int acm_port_activate(struct tty_port *port, struct tty_struct *tty)
+{
+	struct acm *acm = container_of(port, struct acm, port);
+	int retval = -ENODEV;
+
+	dev_dbg(&acm->control->dev, "%s\n", __func__);
 
 	mutex_lock(&acm->mutex);
-	if (acm->port.count++) {
-		mutex_unlock(&acm->mutex);
-		usb_autopm_put_interface(acm->control);
-		goto out;
-	}
+	if (acm->disconnected)
+		goto disconnected;
+
+	retval = usb_autopm_get_interface(acm->control);
+	if (retval)
+		goto error_get_interface;
+
+	/*
+	 * FIXME: Why do we need this? Allocating 64K of physically contiguous
+	 * memory is really nasty...
+	 */
+	set_bit(TTY_NO_WRITE_SPLIT, &tty->flags);
+	acm->control->needs_remote_wakeup = 1;
 
 	acm->ctrlurb->dev = acm->dev;
 	if (usb_submit_urb(acm->ctrlurb, GFP_KERNEL)) {
 		dev_err(&acm->control->dev,
 			"%s - usb_submit_urb(ctrl irq) failed\n", __func__);
-		goto bail_out;
+		goto error_submit_urb;
 	}
 
-	if (0 > acm_set_control(acm, acm->ctrlout = ACM_CTRL_DTR | ACM_CTRL_RTS) &&
+	acm->ctrlout = ACM_CTRL_DTR | ACM_CTRL_RTS;
+	if (acm_set_control(acm, acm->ctrlout) < 0 &&
 	    (acm->ctrl_caps & USB_CDC_CAP_LINE))
-		goto bail_out;
+		goto error_set_control;
 
 	usb_autopm_put_interface(acm->control);
 
 	if (acm_submit_read_urbs(acm, GFP_KERNEL))
-		goto bail_out;
-
-	set_bit(ASYNCB_INITIALIZED, &acm->port.flags);
-	rv = tty_port_block_til_ready(&acm->port, tty, filp);
+		goto error_submit_read_urbs;
 
 	mutex_unlock(&acm->mutex);
-out:
-	mutex_unlock(&open_mutex);
-	return rv;
 
-bail_out:
-	acm->port.count--;
-	mutex_unlock(&acm->mutex);
+	return 0;
+
+error_submit_read_urbs:
+	acm->ctrlout = 0;
+	acm_set_control(acm, acm->ctrlout);
+error_set_control:
+	usb_kill_urb(acm->ctrlurb);
+error_submit_urb:
 	usb_autopm_put_interface(acm->control);
-early_bail:
-	mutex_unlock(&open_mutex);
-	tty_port_tty_set(&acm->port, NULL);
-	return -EIO;
+error_get_interface:
+disconnected:
+	mutex_unlock(&acm->mutex);
+	return retval;
 }
 
-static void acm_tty_unregister(struct acm *acm)
+static void acm_port_destruct(struct tty_port *port)
 {
-	int i;
+	struct acm *acm = container_of(port, struct acm, port);
+
+	dev_dbg(&acm->control->dev, "%s\n", __func__);
 
 	tty_unregister_device(acm_tty_driver, acm->minor);
+	acm_release_minor(acm);
 	usb_put_intf(acm->control);
-	acm_table[acm->minor] = NULL;
-	usb_free_urb(acm->ctrlurb);
-	for (i = 0; i < ACM_NW; i++)
-		usb_free_urb(acm->wb[i].urb);
-	for (i = 0; i < acm->rx_buflimit; i++)
-		usb_free_urb(acm->read_urbs[i]);
 	kfree(acm->country_codes);
 	kfree(acm);
 }
 
-static void acm_port_down(struct acm *acm)
+static void acm_port_shutdown(struct tty_port *port)
 {
+	struct acm *acm = container_of(port, struct acm, port);
 	int i;
 
-	if (acm->dev) {
+	dev_dbg(&acm->control->dev, "%s\n", __func__);
+
+	mutex_lock(&acm->mutex);
+	if (!acm->disconnected) {
 		usb_autopm_get_interface(acm->control);
 		acm_set_control(acm, acm->ctrlout = 0);
 		usb_kill_urb(acm->ctrlurb);
@@ -550,40 +631,28 @@ static void acm_port_down(struct acm *acm)
 		acm->control->needs_remote_wakeup = 0;
 		usb_autopm_put_interface(acm->control);
 	}
+	mutex_unlock(&acm->mutex);
+}
+
+static void acm_tty_cleanup(struct tty_struct *tty)
+{
+	struct acm *acm = tty->driver_data;
+	dev_dbg(&acm->control->dev, "%s\n", __func__);
+	tty_port_put(&acm->port);
 }
 
 static void acm_tty_hangup(struct tty_struct *tty)
 {
 	struct acm *acm = tty->driver_data;
+	dev_dbg(&acm->control->dev, "%s\n", __func__);
 	tty_port_hangup(&acm->port);
-	mutex_lock(&open_mutex);
-	acm_port_down(acm);
-	mutex_unlock(&open_mutex);
 }
 
 static void acm_tty_close(struct tty_struct *tty, struct file *filp)
 {
 	struct acm *acm = tty->driver_data;
-
-	/* Perform the closing process and see if we need to do the hardware
-	   shutdown */
-	if (!acm)
-		return;
-
-	mutex_lock(&open_mutex);
-	if (tty_port_close_start(&acm->port, tty, filp) == 0) {
-		if (!acm->dev) {
-			tty_port_tty_set(&acm->port, NULL);
-			acm_tty_unregister(acm);
-			tty->driver_data = NULL;
-		}
-		mutex_unlock(&open_mutex);
-		return;
-	}
-	acm_port_down(acm);
-	tty_port_close_end(&acm->port, tty);
-	tty_port_tty_set(&acm->port, NULL);
-	mutex_unlock(&open_mutex);
+	dev_dbg(&acm->control->dev, "%s\n", __func__);
+	tty_port_close(&acm->port, tty, filp);
 }
 
 static int acm_tty_write(struct tty_struct *tty,
@@ -595,8 +664,6 @@ static int acm_tty_write(struct tty_struct *tty,
 	int wbn;
 	struct acm_wb *wb;
 
-	if (!ACM_READY(acm))
-		return -EINVAL;
 	if (!count)
 		return 0;
 
@@ -625,8 +692,6 @@ static int acm_tty_write(struct tty_struct *tty,
 static int acm_tty_write_room(struct tty_struct *tty)
 {
 	struct acm *acm = tty->driver_data;
-	if (!ACM_READY(acm))
-		return -EINVAL;
 	/*
 	 * Do not let the line discipline to know that we have a reserve,
 	 * or it might get too enthusiastic.
@@ -637,7 +702,11 @@ static int acm_tty_write_room(struct tty_struct *tty)
 static int acm_tty_chars_in_buffer(struct tty_struct *tty)
 {
 	struct acm *acm = tty->driver_data;
-	if (!ACM_READY(acm))
+	/*
+	 * if the device was unplugged then any remaining characters fell out
+	 * of the connector ;)
+	 */
+	if (acm->disconnected)
 		return 0;
 	/*
 	 * This is inaccurate (overcounts), but it works.
@@ -649,9 +718,6 @@ static void acm_tty_throttle(struct tty_struct *tty)
 {
 	struct acm *acm = tty->driver_data;
 
-	if (!ACM_READY(acm))
-		return;
-
 	spin_lock_irq(&acm->read_lock);
 	acm->throttle_req = 1;
 	spin_unlock_irq(&acm->read_lock);
@@ -662,9 +728,6 @@ static void acm_tty_unthrottle(struct tty_struct *tty)
 	struct acm *acm = tty->driver_data;
 	unsigned int was_throttled;
 
-	if (!ACM_READY(acm))
-		return;
-
 	spin_lock_irq(&acm->read_lock);
 	was_throttled = acm->throttled;
 	acm->throttled = 0;
@@ -679,8 +742,7 @@ static int acm_tty_break_ctl(struct tty_struct *tty, int state)
 {
 	struct acm *acm = tty->driver_data;
 	int retval;
-	if (!ACM_READY(acm))
-		return -EINVAL;
+
 	retval = acm_send_break(acm, state ? 0xffff : 0);
 	if (retval < 0)
 		dev_dbg(&acm->control->dev, "%s - send break failed\n",
@@ -692,9 +754,6 @@ static int acm_tty_tiocmget(struct tty_struct *tty)
 {
 	struct acm *acm = tty->driver_data;
 
-	if (!ACM_READY(acm))
-		return -EINVAL;
-
 	return (acm->ctrlout & ACM_CTRL_DTR ? TIOCM_DTR : 0) |
 	       (acm->ctrlout & ACM_CTRL_RTS ? TIOCM_RTS : 0) |
 	       (acm->ctrlin  & ACM_CTRL_DSR ? TIOCM_DSR : 0) |
@@ -709,9 +768,6 @@ static int acm_tty_tiocmset(struct tty_struct *tty,
 	struct acm *acm = tty->driver_data;
 	unsigned int newctrl;
 
-	if (!ACM_READY(acm))
-		return -EINVAL;
-
 	newctrl = acm->ctrlout;
 	set = (set & TIOCM_DTR ? ACM_CTRL_DTR : 0) |
 					(set & TIOCM_RTS ? ACM_CTRL_RTS : 0);
@@ -728,11 +784,6 @@ static int acm_tty_tiocmset(struct tty_struct *tty,
 static int acm_tty_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
-	struct acm *acm = tty->driver_data;
-
-	if (!ACM_READY(acm))
-		return -EINVAL;
-
 	return -ENOIOCTLCMD;
 }
 
@@ -756,9 +807,6 @@ static void acm_tty_set_termios(struct tty_struct *tty,
 	struct usb_cdc_line_coding newline;
 	int newctrl = acm->ctrlout;
 
-	if (!ACM_READY(acm))
-		return;
-
 	newline.dwDTERate = cpu_to_le32(tty_get_baud_rate(tty));
 	newline.bCharFormat = termios->c_cflag & CSTOPB ? 2 : 0;
 	newline.bParityType = termios->c_cflag & PARENB ?
@@ -788,6 +836,12 @@ static void acm_tty_set_termios(struct tty_struct *tty,
 	}
 }
 
+static const struct tty_port_operations acm_port_ops = {
+	.shutdown = acm_port_shutdown,
+	.activate = acm_port_activate,
+	.destruct = acm_port_destruct,
+};
+
 /*
  * USB probe and disconnect routines.
  */
@@ -1047,12 +1101,6 @@ skip_normal_probe:
 	}
 made_compressed_probe:
 	dev_dbg(&intf->dev, "interfaces are valid\n");
-	for (minor = 0; minor < ACM_TTY_MINORS && acm_table[minor]; minor++);
-
-	if (minor == ACM_TTY_MINORS) {
-		dev_err(&intf->dev, "no more free acm devices\n");
-		return -ENODEV;
-	}
 
 	acm = kzalloc(sizeof(struct acm), GFP_KERNEL);
 	if (acm == NULL) {
@@ -1060,6 +1108,13 @@ made_compressed_probe:
 		goto alloc_fail;
 	}
 
+	minor = acm_alloc_minor(acm);
+	if (minor == ACM_TTY_MINORS) {
+		dev_err(&intf->dev, "no more free acm devices\n");
+		kfree(acm);
+		return -ENODEV;
+	}
+
 	ctrlsize = usb_endpoint_maxp(epctrl);
 	readsize = usb_endpoint_maxp(epread) *
 				(quirks == SINGLE_RX_URB ? 1 : 2);
@@ -1218,8 +1273,6 @@ skip_countries:
 	usb_get_intf(control_interface);
 	tty_register_device(acm_tty_driver, minor, &control_interface->dev);
 
-	acm_table[minor] = acm;
-
 	return 0;
 alloc_fail7:
 	for (i = 0; i < ACM_NW; i++)
@@ -1234,6 +1287,7 @@ alloc_fail5:
 alloc_fail4:
 	usb_free_coherent(usb_dev, ctrlsize, acm->ctrl_buffer, acm->ctrl_dma);
 alloc_fail2:
+	acm_release_minor(acm);
 	kfree(acm);
 alloc_fail:
 	return -ENOMEM;
@@ -1259,12 +1313,16 @@ static void acm_disconnect(struct usb_interface *intf)
 	struct acm *acm = usb_get_intfdata(intf);
 	struct usb_device *usb_dev = interface_to_usbdev(intf);
 	struct tty_struct *tty;
+	int i;
+
+	dev_dbg(&intf->dev, "%s\n", __func__);
 
 	/* sibling interface is already cleaning up */
 	if (!acm)
 		return;
 
-	mutex_lock(&open_mutex);
+	mutex_lock(&acm->mutex);
+	acm->disconnected = true;
 	if (acm->country_codes) {
 		device_remove_file(&acm->control->dev,
 				&dev_attr_wCountryCodes);
@@ -1272,33 +1330,32 @@ static void acm_disconnect(struct usb_interface *intf)
 				&dev_attr_iCountryCodeRelDate);
 	}
 	device_remove_file(&acm->control->dev, &dev_attr_bmCapabilities);
-	acm->dev = NULL;
 	usb_set_intfdata(acm->control, NULL);
 	usb_set_intfdata(acm->data, NULL);
+	mutex_unlock(&acm->mutex);
+
+	tty = tty_port_tty_get(&acm->port);
+	if (tty) {
+		tty_vhangup(tty);
+		tty_kref_put(tty);
+	}
 
 	stop_data_traffic(acm);
 
+	usb_free_urb(acm->ctrlurb);
+	for (i = 0; i < ACM_NW; i++)
+		usb_free_urb(acm->wb[i].urb);
+	for (i = 0; i < acm->rx_buflimit; i++)
+		usb_free_urb(acm->read_urbs[i]);
 	acm_write_buffers_free(acm);
-	usb_free_coherent(usb_dev, acm->ctrlsize, acm->ctrl_buffer,
-			  acm->ctrl_dma);
+	usb_free_coherent(usb_dev, acm->ctrlsize, acm->ctrl_buffer, acm->ctrl_dma);
 	acm_read_buffers_free(acm);
 
 	if (!acm->combined_interfaces)
 		usb_driver_release_interface(&acm_driver, intf == acm->control ?
 					acm->data : acm->control);
 
-	if (acm->port.count == 0) {
-		acm_tty_unregister(acm);
-		mutex_unlock(&open_mutex);
-		return;
-	}
-
-	mutex_unlock(&open_mutex);
-	tty = tty_port_tty_get(&acm->port);
-	if (tty) {
-		tty_hangup(tty);
-		tty_kref_put(tty);
-	}
+	tty_port_put(&acm->port);
 }
 
 #ifdef CONFIG_PM
@@ -1325,16 +1382,10 @@ static int acm_suspend(struct usb_interface *intf, pm_message_t message)
 
 	if (cnt)
 		return 0;
-	/*
-	we treat opened interfaces differently,
-	we must guard against open
-	*/
-	mutex_lock(&acm->mutex);
 
-	if (acm->port.count)
+	if (test_bit(ASYNCB_INITIALIZED, &acm->port.flags))
 		stop_data_traffic(acm);
 
-	mutex_unlock(&acm->mutex);
 	return 0;
 }
 
@@ -1353,8 +1404,7 @@ static int acm_resume(struct usb_interface *intf)
 	if (cnt)
 		return 0;
 
-	mutex_lock(&acm->mutex);
-	if (acm->port.count) {
+	if (test_bit(ASYNCB_INITIALIZED, &acm->port.flags)) {
 		rv = usb_submit_urb(acm->ctrlurb, GFP_NOIO);
 
 		spin_lock_irq(&acm->write_lock);
@@ -1378,7 +1428,6 @@ static int acm_resume(struct usb_interface *intf)
 	}
 
 err_out:
-	mutex_unlock(&acm->mutex);
 	return rv;
 }
 
@@ -1387,15 +1436,14 @@ static int acm_reset_resume(struct usb_interface *intf)
 	struct acm *acm = usb_get_intfdata(intf);
 	struct tty_struct *tty;
 
-	mutex_lock(&acm->mutex);
-	if (acm->port.count) {
+	if (test_bit(ASYNCB_INITIALIZED, &acm->port.flags)) {
 		tty = tty_port_tty_get(&acm->port);
 		if (tty) {
 			tty_hangup(tty);
 			tty_kref_put(tty);
 		}
 	}
-	mutex_unlock(&acm->mutex);
+
 	return acm_resume(intf);
 }
 
@@ -1594,8 +1642,10 @@ static struct usb_driver acm_driver = {
  */
 
 static const struct tty_operations acm_ops = {
+	.install =		acm_tty_install,
 	.open =			acm_tty_open,
 	.close =		acm_tty_close,
+	.cleanup =		acm_tty_cleanup,
 	.hangup =		acm_tty_hangup,
 	.write =		acm_tty_write,
 	.write_room =		acm_tty_write_room,
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index ca7937f..35ef887 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -101,6 +101,7 @@ struct acm {
 	int transmitting;
 	spinlock_t write_lock;
 	struct mutex mutex;
+	bool disconnected;
 	struct usb_cdc_line_coding line;		/* bits, stop, parity */
 	struct work_struct work;			/* work queue entry for line discipline waking up */
 	unsigned int ctrlin;				/* input control lines (DCD, DSR, RI, break, overruns) */
-- 
1.7.3.1

