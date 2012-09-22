Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab2IVVwj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 17:52:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57687 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2IVVwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 17:52:38 -0400
Date: Sun, 23 Sep 2012 01:52:32 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120922215232.GA25778@moon>
References: <20120913095623.GB28508@moon>
 <20120913135131.5b251797@pyramind.ukuu.org.uk>
 <20120913125401.GK19956@moon>
 <20120913172507.5039e3c6@pyramind.ukuu.org.uk>
 <20120922180639.GC11610@moon>
 <20120922200731.GD14004@kroah.com>
 <20120922201144.GD11610@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120922201144.GD11610@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2012 at 12:11:44AM +0400, Cyrill Gorcunov wrote:
>
> > Sysfs is one value per file, you have three values here, please make 3
> > files.
> > 
> > And document them in Documentation/ABI/.
> 
> Hmm, sure Greg, I'll update. Thanks!

Something like below I suppose? Look, if there will be no complains
on tech aspects on the patch (locking and tty refs) -- I'll update
Documentation. Just want be sure I've made no mistakes here.

Another question -- would not it be worth to wrap code with
CONFIG_CHECKPOINT_RESTORE?
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: tty, pty: Add sysfs attributes for pty device to fetch flags

For checkpoint/restore we need to know if pty has exclusive or packet
mode set, as well as if pty is currently locked (just to be able
to restore this characteristics).

To serve this the following attrubutes: lock, exclusive, packet,
are introduced for pty devices.

For example

 | cat /sys/devices/virtual/tty/ptmp1/lock
 | 1
 | cat /sys/devices/virtual/tty/ptmp1/exclusive
 | 0
 | cat /sys/devices/virtual/tty/ptmp1/packet
 | 0

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Jiri Slaby <jslaby@suse.cz>
CC: Pavel Emelyanov <xemul@parallels.com>
---
 drivers/tty/pty.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

Index: tty.git/drivers/tty/pty.c
===================================================================
--- tty.git.orig/drivers/tty/pty.c
+++ tty.git/drivers/tty/pty.c
@@ -283,6 +283,72 @@ done:
 	return 0;
 }
 
+static ssize_t pty_show_lock(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct tty_struct *tty = dev_get_drvdata(dev);
+	int lock;
+
+	tty_lock(tty);
+	lock = test_bit(TTY_PTY_LOCK, &tty->flags);
+	tty_unlock(tty);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", lock);
+}
+
+static ssize_t pty_show_exclusive(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct tty_struct *tty = dev_get_drvdata(dev);
+	int exclusive;
+
+	tty_lock(tty);
+	exclusive = test_bit(TTY_EXCLUSIVE, &tty->flags);
+	tty_unlock(tty);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", exclusive);
+}
+
+static ssize_t pty_show_packet(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct tty_struct *tty = dev_get_drvdata(dev);
+	int packet;
+
+	tty_lock(tty);
+	packet = tty->packet;
+	tty_unlock(tty);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", packet);
+}
+
+static DEVICE_ATTR(lock, S_IRUSR | S_IRGRP, pty_show_lock, NULL);
+static DEVICE_ATTR(exclusive, S_IRUSR | S_IRGRP, pty_show_exclusive, NULL);
+static DEVICE_ATTR(packet, S_IRUSR | S_IRGRP, pty_show_packet, NULL);
+
+static struct attribute *pty_attrs[] = {
+	&dev_attr_lock.attr,
+	&dev_attr_exclusive.attr,
+	&dev_attr_packet.attr,
+	NULL,
+};
+
+static const struct attribute_group pty_attrs_group = {
+	.attrs = pty_attrs,
+};
+
+static const struct attribute_group *pty_attr_groups[] = {
+	&pty_attrs_group,
+	NULL,
+};
+
+static int pty_register_attr(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct device *dev = tty_register_device_attr(driver, tty->index, tty->dev,
+						      (void *)tty, pty_attr_groups);
+	return PTR_RET(dev);
+}
+
 /**
  *	pty_common_install		-	set up the pty pair
  *	@driver: the pty driver
@@ -351,7 +417,9 @@ static int pty_common_install(struct tty
 
 	tty_driver_kref_get(driver);
 	tty->count++;
-	return 0;
+
+	return pty_register_attr(driver, tty);
+
 err_free_termios:
 	if (legacy)
 		tty_free_termios(tty);
@@ -368,6 +436,7 @@ err:
 
 static void pty_cleanup(struct tty_struct *tty)
 {
+	tty_unregister_device(tty->driver, tty->index);
 	kfree(tty->port);
 }
 
