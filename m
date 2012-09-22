Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2IVSGp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 14:06:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49710 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2IVSGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 14:06:43 -0400
Date: Sat, 22 Sep 2012 22:06:39 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120922180639.GC11610@moon>
References: <20120913095623.GB28508@moon>
 <20120913135131.5b251797@pyramind.ukuu.org.uk>
 <20120913125401.GK19956@moon>
 <20120913172507.5039e3c6@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913172507.5039e3c6@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 05:25:07PM +0100, Alan Cox wrote:
> On Thu, 13 Sep 2012 16:54:01 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > On Thu, Sep 13, 2012 at 01:51:31PM +0100, Alan Cox wrote:
> > > > +static int pty_get_lock(struct tty_struct *tty, int __user *arg)
> > > > +{
> > > > +	int locked = test_bit(TTY_PTY_LOCK, &tty->flags);
> > > > +	if (put_user(locked, arg))
> > > > +		return -EFAULT;
> > > 
> > > Now explain exactly how this doesn't race with another thread chanigng
> > > the lock setting ?
> > 
> > It's the same as to set/clear this bit, isn't it? Please correct me
> > if I'm wrong.
> 
> So by the time you've finished the test bit and returned it to user space
> the answer may have changed ?
> 
> > > The other comment I have is that it might be better put these in now
> > > there are sysfs patches for the tty layer bouncing about to provide the
> > > needed infrastructure ?
> > 
> > Alan, could you please point me where these patches are living, so I would
> > take a look and check them out
> 
> linux-serial or check tty-next as I think Greg has now merged the test
> patch.

Guys, you mean something like below? Look, I must admit I'm not really
sure if I've done all locking right, and there is no need for additional
kref counting on tty_struct. Could you please check if it looks more-less
sane (I've tested it but still...)

---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: tty, pty: Add pty_state attribute to fetch tty flags

For checkpoint/restore we need to know if tty has
exclusive or packet mode set, as well as if pty
is currently locked (just to be able to restore
this characteristics).

To serve this the pty_state attribute is introduced
for pty devices. A typical output looks like

 | [root@neptune ~]# cat /sys/devices/virtual/tty/ptmp0/pty_state
 | locked: 0 exclusive: 0 packet: 0

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Jiri Slaby <jslaby@suse.cz>
CC: Pavel Emelyanov <xemul@parallels.com>
---
 drivers/tty/pty.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

Index: tty.git/drivers/tty/pty.c
===================================================================
--- tty.git.orig/drivers/tty/pty.c
+++ tty.git/drivers/tty/pty.c
@@ -283,6 +283,46 @@ done:
 	return 0;
 }
 
+static ssize_t pty_show_state(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct tty_struct *tty = dev_get_drvdata(dev);
+	int locked, exclusive, packet;
+
+	tty_lock(tty);
+	locked = test_bit(TTY_PTY_LOCK, &tty->flags);
+	exclusive = test_bit(TTY_EXCLUSIVE, &tty->flags);
+	packet = tty->packet;
+	tty_unlock(tty);
+
+	return snprintf(buf, PAGE_SIZE, "locked: %d exclusive: %d packet: %d\n",
+			locked, exclusive, packet);
+}
+
+static DEVICE_ATTR(pty_state, S_IRUSR | S_IRGRP, pty_show_state, NULL);
+
+static struct attribute *pty_state_dev_attrs[] = {
+	&dev_attr_pty_state.attr,
+	NULL,
+};
+
+static const struct attribute_group pty_dev_attr_group = {
+	.attrs = pty_state_dev_attrs,
+};
+
+static const struct attribute_group *pty_dev_attr_groups[] = {
+	&pty_dev_attr_group,
+	NULL,
+};
+
+static int pty_register_attr(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct device *dev = tty_register_device_attr(driver, tty->index, tty->dev,
+						      (void *)tty, pty_dev_attr_groups);
+	return PTR_RET(dev);
+}
+
 /**
  *	pty_common_install		-	set up the pty pair
  *	@driver: the pty driver
@@ -351,7 +391,9 @@ static int pty_common_install(struct tty
 
 	tty_driver_kref_get(driver);
 	tty->count++;
-	return 0;
+
+	return pty_register_attr(driver, tty);
+
 err_free_termios:
 	if (legacy)
 		tty_free_termios(tty);
@@ -368,6 +410,7 @@ err:
 
 static void pty_cleanup(struct tty_struct *tty)
 {
+	tty_unregister_device(tty->driver, tty->index);
 	kfree(tty->port);
 }
 
