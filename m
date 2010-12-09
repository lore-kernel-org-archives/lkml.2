Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0LIJj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:39:58 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38566 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab0LIJj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:39:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=V1apiNaXoCeNJimJ/lxhrX3mAbTKcONWwJdIImV22uMSRsxLtWBIgU67KW58WGAI+D
         0GVpExo7z7pxK5lxUeWv8tBEo4a8IYaDRT39ib/qZT84oY8LluWdXVnh4jKamVmOeaOX
         cquXm6vVk5DSoCmrNBrWhqWuFJNUANW0e5Yjc=
Date: Thu, 9 Dec 2010 01:39:48 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linux Input <linux-input@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Jarod Wilson <jarod@redhat.com>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [RFC] Input: define separate EVIOCGKEYCODE_V2/EVIOCSKEYCODE_V2
Message-ID: <20101209093948.GD8821@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The desire to keep old names for the EVIOCGKEYCODE/EVIOCSKEYCODE while
extending them to support large scancodes was a mistake. While we tried
to keep ABI intact (and we succeeded in doing that, programs compiled
on older kernels will work on newer ones) there is still a problem with
recompiling existing software with newer kernel headers.

New kernel headers will supply updated ioctl numbers and kernel will
expect that userspace will use struct input_keymap_entry to set and
retrieve keymap data. But since the names of ioctls are still the same
userspace will happily compile even if not adjusted to make use of the
new structure and will start miraculously fail in the field.

To avoid this issue let's revert EVIOCGKEYCODE/EVIOCSKEYCODE definitions
and add EVIOCGKEYCODE_V2/EVIOCSKEYCODE_V2 so that userspace can explicitly
select the style of ioctls it wants to employ.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/evdev.c |  113 +++++++++++++++++++++++++------------------------
 include/linux/input.h |    6 ++-
 2 files changed, 62 insertions(+), 57 deletions(-)


diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 17660b1..915287e 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -535,76 +535,73 @@ static int handle_eviocgbit(struct input_dev *dev,
 }
 #undef OLD_KEY_MAX
 
-static int evdev_handle_get_keycode(struct input_dev *dev,
-				    void __user *p, size_t size)
+static int evdev_handle_get_keycode(struct input_dev *dev, void __user *p)
 {
-	struct input_keymap_entry ke;
+	struct input_keymap_entry ke = {
+		.len	= sizeof(unsigned int),
+		.flags	= 0,
+	};
+	int __user *ip = (int __user *)p;
 	int error;
 
-	memset(&ke, 0, sizeof(ke));
-
-	if (size == sizeof(unsigned int[2])) {
-		/* legacy case */
-		int __user *ip = (int __user *)p;
+	/* legacy case */
+	if (copy_from_user(ke.scancode, p, sizeof(unsigned int)))
+		return -EFAULT;
 
-		if (copy_from_user(ke.scancode, p, sizeof(unsigned int)))
-			return -EFAULT;
+	error = input_get_keycode(dev, &ke);
+	if (error)
+		return error;
 
-		ke.len = sizeof(unsigned int);
-		ke.flags = 0;
+	if (put_user(ke.keycode, ip + 1))
+		return -EFAULT;
 
-		error = input_get_keycode(dev, &ke);
-		if (error)
-			return error;
+	return 0;
+}
 
-		if (put_user(ke.keycode, ip + 1))
-			return -EFAULT;
+static int evdev_handle_get_keycode_v2(struct input_dev *dev, void __user *p)
+{
+	struct input_keymap_entry ke;
+	int error;
 
-	} else {
-		size = min(size, sizeof(ke));
+	if (copy_from_user(&ke, p, sizeof(ke)))
+		return -EFAULT;
 
-		if (copy_from_user(&ke, p, size))
-			return -EFAULT;
+	error = input_get_keycode(dev, &ke);
+	if (error)
+		return error;
 
-		error = input_get_keycode(dev, &ke);
-		if (error)
-			return error;
+	if (copy_to_user(p, &ke, sizeof(ke)))
+		return -EFAULT;
 
-		if (copy_to_user(p, &ke, size))
-			return -EFAULT;
-	}
 	return 0;
 }
 
-static int evdev_handle_set_keycode(struct input_dev *dev,
-				    void __user *p, size_t size)
+static int evdev_handle_set_keycode(struct input_dev *dev, void __user *p)
 {
-	struct input_keymap_entry ke;
-
-	memset(&ke, 0, sizeof(ke));
+	struct input_keymap_entry ke = {
+		.len	= sizeof(unsigned int),
+		.flags	= 0,
+	};
+	int __user *ip = (int __user *)p;
 
-	if (size == sizeof(unsigned int[2])) {
-		/* legacy case */
-		int __user *ip = (int __user *)p;
+	if (copy_from_user(ke.scancode, p, sizeof(unsigned int)))
+		return -EFAULT;
 
-		if (copy_from_user(ke.scancode, p, sizeof(unsigned int)))
-			return -EFAULT;
+	if (get_user(ke.keycode, ip + 1))
+		return -EFAULT;
 
-		if (get_user(ke.keycode, ip + 1))
-			return -EFAULT;
+	return input_set_keycode(dev, &ke);
+}
 
-		ke.len = sizeof(unsigned int);
-		ke.flags = 0;
+static int evdev_handle_set_keycode_v2(struct input_dev *dev, void __user *p)
+{
+	struct input_keymap_entry ke;
 
-	} else {
-		size = min(size, sizeof(ke));
+	if (copy_from_user(&ke, p, sizeof(ke)))
+		return -EFAULT;
 
-		if (copy_from_user(&ke, p, size))
-			return -EFAULT;
-
-		if (ke.len > sizeof(ke.scancode))
-			return -EINVAL;
-	}
+	if (ke.len > sizeof(ke.scancode))
+		return -EINVAL;
 
 	return input_set_keycode(dev, &ke);
 }
@@ -670,6 +667,18 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			return evdev_grab(evdev, client);
 		else
 			return evdev_ungrab(evdev, client);
+
+	case EVIOCGKEYCODE:
+		return evdev_handle_get_keycode(dev, p);
+
+	case EVIOCSKEYCODE:
+		return evdev_handle_set_keycode(dev, p);
+
+	case EVIOCGKEYCODE_V2:
+		return evdev_handle_get_keycode_v2(dev, p);
+
+	case EVIOCSKEYCODE_V2:
+		return evdev_handle_set_keycode_v2(dev, p);
 	}
 
 	size = _IOC_SIZE(cmd);
@@ -709,12 +718,6 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 
 		return error;
-
-	case EVIOC_MASK_SIZE(EVIOCGKEYCODE):
-		return evdev_handle_get_keycode(dev, p, size);
-
-	case EVIOC_MASK_SIZE(EVIOCSKEYCODE):
-		return evdev_handle_set_keycode(dev, p, size);
 	}
 
 	/* Multi-number variable-length handlers */
diff --git a/include/linux/input.h b/include/linux/input.h
index 5e92384..ddd719d 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -104,8 +104,10 @@ struct input_keymap_entry {
 #define EVIOCGREP		_IOR('E', 0x03, unsigned int[2])	/* get repeat settings */
 #define EVIOCSREP		_IOW('E', 0x03, unsigned int[2])	/* set repeat settings */
 
-#define EVIOCGKEYCODE		_IOR('E', 0x04, struct input_keymap_entry)	/* get keycode */
-#define EVIOCSKEYCODE		_IOW('E', 0x04, struct input_keymap_entry)	/* set keycode */
+#define EVIOCGKEYCODE		_IOR('E', 0x04, unsigned int[2])        /* get keycode */
+#define EVIOCGKEYCODE_V2	_IOR('E', 0x04, struct input_keymap_entry)
+#define EVIOCSKEYCODE		_IOW('E', 0x04, unsigned int[2])        /* set keycode */
+#define EVIOCSKEYCODE_V2	_IOW('E', 0x04, struct input_keymap_entry)
 
 #define EVIOCGNAME(len)		_IOC(_IOC_READ, 'E', 0x06, len)		/* get device name */
 #define EVIOCGPHYS(len)		_IOC(_IOC_READ, 'E', 0x07, len)		/* get physical location */
