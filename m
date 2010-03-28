Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0C1XXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 19:23:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab0C1XXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 19:23:35 -0400
Message-ID: <4BAFE4B7.2030204@redhat.com>
Date: Sun, 28 Mar 2010 20:22:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR system?
References: <20091215195859.GI24406@elf.ucw.cz> <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com> <20091215201933.GK24406@elf.ucw.cz> <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com> <20091215203300.GL24406@elf.ucw.cz> <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com> <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com> <4BAB7659.1040408@redhat.com> <20100326112755.GB5387@hardeman.nu> <4BACC769.6020906@redhat.com> <20100326160150.GA28804@core.coreip.homeip.net>
In-Reply-To: <20100326160150.GA28804@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Fri, Mar 26, 2010 at 11:40:41AM -0300, Mauro Carvalho Chehab wrote:
>> David Härdeman wrote:
>>> On Thu, Mar 25, 2010 at 11:42:33AM -0300, Mauro Carvalho Chehab wrote:
>>>>>        10) extend keycode table replacement to support big/variable 
>>>>>        sized scancodes;
>>>> Pending.
>>>>
>>>> The current limit here is the scancode ioctl's are defined as:
>>>>
>>>> #define EVIOCGKEYCODE           _IOR('E', 0x04, int[2])                 /* get keycode */
>>>> #define EVIOCSKEYCODE           _IOW('E', 0x04, int[2])                 /* set keycode */
>>>>
>>>> As int size is 32 bits, and we must pass both 64 (or even bigger) scancodes, associated
>>>> with a keycode, there's not enough bits there for IR.
>>>>
>>>> The better approach seems to create an struct with an arbitrary long size, like:
>>>>
>>>> struct keycode_table_entry {
>>>> 	unsigned keycode;
>>>> 	char scancode[32];	/* 32 is just an arbitrary long array - maybe shorter */
>>>> 	int len;
>>>> }
>>>>
>>>> and re-define the ioctls. For example we might be doing:
>>>>
>>>> #define EVIOCGKEYCODEBIG           _IOR('E', 0x04, struct keycode_table_entry)
>>>> #define EVIOCSKEYCODEBIG           _IOW('E', 0x04, struct keycode_table_entry)
>>>> #define EVIOCLEARKEYCODEBIG        _IOR('E', 0x04, void)
>>>>
>>>> Provided that the size for struct keycode_table_entry is different, _IO will generate
>>>> a different magic number for those.
>>>>
>>>> Or, instead of using 0x04, just use another sequential number at the 'E' namespace.
>>>>
>>>> An specific function to clear the table is needed with big scancode space,
>>>> as already discussed.
>>>>
>>> I'd suggest:
>>>
>>> struct keycode_table_entry {
>>> 	unsigned keycode;
>>> 	unsigned index;
>>> 	unsigned len;
>>> 	char scancode[];
>>> };
>>>
>>> Use index in EVIOCGKEYCODEBIG to look up a keycode (all other fields are 
>>> ignored), that way no special function to clear the table is necessary, 
>>> instead you do a loop with:
>>>
>>> EVIOCGKEYCODEBIG (with index 0)
>>> EVIOCSKEYCODEBIG (with the returned struct from EVIOCGKEYCODEBIG and
>>> 		  keycode = KEY_RESERVED)
>>>
>>> until EVIOCGKEYCODEBIG returns an error.
>> Makes sense.
> 
> Yes, I think so too. Just need a nice way to handle transition, I'd
> like in the end to have drivers implement only the improved methods and
> map legacy methods in evdev.

See the attached RFC barely tested patch. 

On this patch, I'm using the following definitions for the ioctl:

struct keycode_table_entry {
	__u32 keycode;		/* e.g. KEY_A */
	__u32 index;		/* Index for the given scan/key table */
	__u32 len;		/* Lenght of the scancode */
	__u32 reserved[2];	/* Reserved for future usage */
	char *scancode;		/* scancode, in machine-endian */
};

#define EVIOCGKEYCODEBIG	_IOR('E', 0x04, struct keycode_table_entry) /* get keycode */
#define EVIOCSKEYCODEBIG	_IOW('E', 0x04, struct keycode_table_entry) /* set keycode */


I tried to do the compat backport on a nice way, on both directions, e. g.:

1) an userspace app using EVIO[CS]GKEYCODEBIG to work with a legacy driver.
2) a driver implementing the new methods to accept the legacy EVIO[CS]GKEYCODE;

For the test of (1), I implemented the following clear keytable code:

	struct keycode_table_entry      kt;
        uint32_t                        scancode, i;

        memset(&kt, 0, sizeof(kt));
        kt.len = sizeof(scancode);
        kt.scancode = (char *)&scancode;

        for (i = 0; rc == 0; i++) {
        	kt.index = i;
        	kt.keycode = KEY_RESERVED;
                rc = ioctl(fd, EVIOCSKEYCODEBIG, &kt);
        }
        fprintf(stderr, "Cleaned %i keycode(s)\n", i - 1);

It worked properly. I didn't test (2) yet.

The read keytable would also be trivial. However, there are some troubles when
implementing the code to add/replace a value at the table, in a way that it
would allow the legacy drivers to work:

- With a real CODEBIG support, the index number will be different than the
scancode number. So, let's say that this is the driver table:

index	scancode keycode
------------------------
0	0x1e00	 KEY_0
1	0x1e01	 KEY_1
2	0x1e02	 KEY_2
3	0x1e03	 KEY_3
4	0x1e04	 KEY_4
5	0x1e05	 KEY_5
6	0x1e06	 KEY_6
7	0x1e07	 KEY_7
8	0x1e08	 KEY_8
9	0x1e09	 KEY_9

Let's suppose that the user wants to overwrite the entry 5, attributing a new scancode/keycode
to entry 5 (for example, associating 0x1e0a with KEY-A).

A valid EVIOCSKEYCODEBIG call to change this code would be:

	kt->index = 5;
	*(uint32_t *)kt->scancode = 0x1e0a;
	*(uint32_t *)kt->keycode = KEY_A;
	rc = ioctl(fd, EVIOCSKEYCODEBIG, &kt);

With EVIOCSKEYCODE, this requires two separate operations:

	int codes[2];
	code[0] = 0x1e05;
	code[1] = KEY_RESERVED;
	rc = ioctl(fd, EVIOCSKEYCODE, &codes];

	code[0] = 0x1e0a;
	code[1] = KEY_A;
	rc = ioctl(fd, EVIOCSKEYCODE, &codes];


In the case of EVIOCSKEYCODEBIG call, the driver will need to:

1) Check If the scancode is not being used yet on any entry different than index=5.
If it is in use, it should return an error. 
If not, replace the scancode/keycode.

2) Check if index is equal to the length of the array + 1. If so, create a new entry.

3) check if the index is bigger than length + 1 and return an error, if so.

For the EVIOSKEYCODE emulation by an EVIOCSKEYCODEBIG driver, index=5 won't work.
The driver will need to use the scancode. However, if we do this way, the
cleanup logic will break, as scancode is equal to zero.

So, I think that having an index here is not a good idea: it will just create some
implementation troubles. We can archive the same result without the index, and having
a fast clean_table code by just reading the used scancodes and associating them
with KEY_RESERVED.

So, I'll be working on another patch with this different implementation.

I also noticed another problem: kernel should have some way to report the expected
size of the scancode to userspace, especially if we want to have the compatibility
code (since, with compat, a scancode maximum size need to be 32 bits, otherwise
the code won't work).

I'll likely adding another control that returns the size of the scancode.

Comments?

Cheers,
Mauro


---


This is the RFC patch I wrote here for my tests.

commit 6bf412eedaa05f28d5ce50795d3ac64ec41c3031
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Sun Mar 28 04:02:36 2010 -0300

    input: Add support for EVIO[CS]GKEYCODEBIG
    
    Several devices use a high number of bits for scancodes. One important
    group is the Remote Controllers. Some new protocols like RC-6 define a
    scancode space of 64 bits.
    
    The current EVIO[CS]GKEYCODE ioctls allow replace the scancode/keycode
    translation tables, but it is limited to up to 32 bits for scancode.
    
    Also, if userspace wants to clean the existing table, replacing it by
    a new one, it needs to run a loop calling the old ioctls, over the
    entire sparsed scancode userspace.
    
    To solve those problems, this patch introduces two new ioctls:
    	EVIOCGKEYCODEBIG - reads a scancode from the translation table;
    	EVIOSGKEYCODEBIG - writes a scancode into the translation table.
    
    The EVIOSGKEYCODEBIG can also be used to cleanup the translation entries
    by associating KEY_RESERVED to a scancode.
    
    By default, kernel will implement a default handler that will work with
    both EVIO[CS]GKEYCODEBIG and the legacy EVIO[CS]GKEYCODE ioctls.
    
    Compatibility code were also added to allow drivers that implement
    only the ops handler for EVIO[CS]GKEYCODE to keep working.
    
    Userspace compatibility for EVIO[CS]GKEYCODE is also granted: the evdev/input
    ioctl handler will automatically map those ioctls with the new
    getkeycodebig()/setkeycodebig() operations to handle a request using the
    legacy API.
    
    So, new drivers should only implement the EVIO[CS]GKEYCODEBIG operation
    handlers: getkeycodebig()/setkeycodebig().
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 258c639..aed5acc 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -513,6 +513,7 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 	struct input_absinfo abs;
 	struct ff_effect effect;
 	int __user *ip = (int __user *)p;
+	struct keycode_table_entry __user *kt = p;
 	int i, t, u, v;
 	int error;
 
@@ -567,6 +568,25 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 		return input_set_keycode(dev, t, v);
 
+	case EVIOCGKEYCODEBIG:
+		if (copy_from_user(kt, &dev->id, _IOC_SIZE(cmd)))
+			return -EFAULT;
+
+		error = input_get_keycode_big(dev, kt);
+		if (error)
+			return error;
+
+		if (copy_to_user(kt, &dev->id, _IOC_SIZE(cmd)))
+			return -EFAULT;
+
+		return 0;
+
+	case EVIOCSKEYCODEBIG:
+		if (copy_from_user(p, &dev->id, _IOC_SIZE(cmd)))
+			return -EFAULT;
+
+		return input_set_keycode_big(dev, kt);
+
 	case EVIOCRMFF:
 		return input_ff_erase(dev, (int)(unsigned long) p, file);
 
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 86cb2d2..0437c75 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -551,6 +551,11 @@ static void input_disconnect_device(struct input_dev *dev)
 	spin_unlock_irq(&dev->event_lock);
 }
 
+/*
+ * Those routines handle the default case where no [gs]etkeycode() is
+ * defined. In this case, an array indexed by the scancode is used.
+ */
+
 static int input_fetch_keycode(struct input_dev *dev, int scancode)
 {
 	switch (dev->keycodesize) {
@@ -566,57 +571,88 @@ static int input_fetch_keycode(struct input_dev *dev, int scancode)
 }
 
 static int input_default_getkeycode(struct input_dev *dev,
-				    int scancode, int *keycode)
+				    struct keycode_table_entry *kt_entry)
 {
 	if (!dev->keycodesize)
 		return -EINVAL;
 
-	if (scancode >= dev->keycodemax)
+	if (kt_entry->index >= dev->keycodemax)
 		return -EINVAL;
 
-	*keycode = input_fetch_keycode(dev, scancode);
+	/*
+	 * Supports only 8, 16 and 32 bit scancodes. It wouldn't be that
+	 * hard to write some machine-endian logic to support 24 bit scancodes,
+	 * but it seemed overkill. It should also be noticed that, since there
+	 * are, in general, less than 256 scancodes sparsed into the scancode
+	 * space, even with 16 bits, the codespace is sparsed, with leads into
+	 * memory and code ineficiency, when retrieving the entire scancode
+	 * space.
+	 * So, it is highly recommended to implement getkeycodebig/setkeycodebig
+	 * instead of using a normal table approach, when more than 8 bits is
+	 * needed for the scancode.
+	 *
+	 */
+	switch (kt_entry->len) {
+	case 1:
+		if (kt_entry->index > ((1 << 8) - 1))
+			return -EINVAL;
+		*((u8 *)kt_entry->scancode) = (u8)kt_entry->index;
+		break;
+	case 2:
+		if (kt_entry->index > ((1 << 16) - 1))
+			return -EINVAL;
+		*((u16 *)kt_entry->scancode) = (u16)kt_entry->index;
+		break;
+	case 4:
+		*((u32 *)kt_entry->scancode) = kt_entry->index;
+		break;
+	default:
+		return -EINVAL;
+	}
+	kt_entry->keycode = input_fetch_keycode(dev, kt_entry->index);
 
 	return 0;
 }
 
 static int input_default_setkeycode(struct input_dev *dev,
-				    int scancode, int keycode)
+				    struct keycode_table_entry *kt_entry)
 {
 	int old_keycode;
 	int i;
 
-	if (scancode >= dev->keycodemax)
+	if (kt_entry->index >= dev->keycodemax)
 		return -EINVAL;
 
 	if (!dev->keycodesize)
 		return -EINVAL;
 
-	if (dev->keycodesize < sizeof(keycode) && (keycode >> (dev->keycodesize * 8)))
+	if (dev->keycodesize < sizeof(dev->keycode) &&
+	    (kt_entry->keycode >> (dev->keycodesize * 8)))
 		return -EINVAL;
 
 	switch (dev->keycodesize) {
 		case 1: {
 			u8 *k = (u8 *)dev->keycode;
-			old_keycode = k[scancode];
-			k[scancode] = keycode;
+			old_keycode = k[kt_entry->index];
+			k[kt_entry->index] = kt_entry->keycode;
 			break;
 		}
 		case 2: {
 			u16 *k = (u16 *)dev->keycode;
-			old_keycode = k[scancode];
-			k[scancode] = keycode;
+			old_keycode = k[kt_entry->index];
+			k[kt_entry->index] = kt_entry->keycode;
 			break;
 		}
 		default: {
 			u32 *k = (u32 *)dev->keycode;
-			old_keycode = k[scancode];
-			k[scancode] = keycode;
+			old_keycode = k[kt_entry->index];
+			k[kt_entry->index] = kt_entry->keycode;
 			break;
 		}
 	}
 
 	clear_bit(old_keycode, dev->keybit);
-	set_bit(keycode, dev->keybit);
+	set_bit(kt_entry->keycode, dev->keybit);
 
 	for (i = 0; i < dev->keycodemax; i++) {
 		if (input_fetch_keycode(dev, i) == old_keycode) {
@@ -629,6 +665,103 @@ static int input_default_setkeycode(struct input_dev *dev,
 }
 
 /**
+ * input_get_keycode_big - retrieve keycode currently mapped to a given scancode
+ * @dev: input device which keymap is being queried
+ * @kt_entry: keytable entry
+ *
+ * This function should be called by anyone interested in retrieving current
+ * keymap. Presently evdev handlers use it.
+ */
+int input_get_keycode_big(struct input_dev *dev,
+			  struct keycode_table_entry *kt_entry)
+{
+	if (dev->getkeycode) {
+		/*
+		 * Support for legacy drivers, that don't implement the new
+		 * ioctls: use index=scancode, just like the default methods
+		 */
+		return dev->getkeycode(dev, kt_entry->index,
+				       &kt_entry->keycode);
+	} else
+		return dev->getkeycodebig(dev, kt_entry);
+}
+EXPORT_SYMBOL(input_get_keycode_big);
+
+/**
+ * input_set_keycode_big - attribute a keycode to a given scancode
+ * @dev: input device which keymap is being queried
+ * @kt_entry: keytable entry
+ *
+ * This function should be called by anyone needing to update current
+ * keymap. Presently keyboard and evdev handlers use it.
+ */
+int input_set_keycode_big(struct input_dev *dev,
+			  struct keycode_table_entry *kt_entry)
+{
+	unsigned long flags;
+	int new_keycode, old_keycode;
+	int retval = -EINVAL;
+
+	if (kt_entry->keycode < 0 || kt_entry->keycode > KEY_MAX)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+
+	new_keycode = kt_entry->keycode;
+
+	/*
+	 * We need to know the old scancode, in order to generate a
+	 * keyup effect, if the set operation happens successfully
+	 */
+	if (dev->getkeycode) {
+		/*
+		 * Support for legacy drivers, that don't implement the new
+		 * ioctls: use index=scancode, just like the default methods
+		 * If setkeycode is not defined, just return.
+		 */
+		if (!dev->setkeycode)
+			goto out;
+
+		retval = dev->getkeycode(dev, kt_entry->index,
+					 &kt_entry->keycode);
+	} else
+		retval = dev->getkeycodebig(dev, kt_entry);
+
+	old_keycode = kt_entry->keycode;
+	kt_entry->keycode = new_keycode;
+
+	if (retval)
+		goto out;
+
+	if (dev->getkeycode)
+		retval = dev->setkeycode(dev, kt_entry->index,
+					 kt_entry->keycode);
+	else
+		retval = dev->setkeycodebig(dev, kt_entry);
+	if (retval)
+		goto out;
+
+	/*
+	 * Simulate keyup event if keycode is not present
+	 * in the keymap anymore
+	 */
+	if (test_bit(EV_KEY, dev->evbit) &&
+	    !is_event_supported(old_keycode, dev->keybit, KEY_MAX) &&
+	    __test_and_clear_bit(old_keycode, dev->key)) {
+
+		input_pass_event(dev, EV_KEY, old_keycode, 0);
+		if (dev->sync)
+			input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
+	}
+
+ out:
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+	return retval;
+}
+EXPORT_SYMBOL(input_set_keycode_big);
+
+/**
  * input_get_keycode - retrieve keycode currently mapped to a given scancode
  * @dev: input device which keymap is being queried
  * @scancode: scancode (or its equivalent for device in question) for which
@@ -640,10 +773,33 @@ static int input_default_setkeycode(struct input_dev *dev,
  */
 int input_get_keycode(struct input_dev *dev, int scancode, int *keycode)
 {
-	if (scancode < 0)
-		return -EINVAL;
+	if (dev->getkeycode) {
+		/*
+		 * Use the legacy calls
+		 */
+		return dev->getkeycode(dev, scancode, keycode);
+	} else {
+		int retval;
+		char char_scan[4];
+		struct keycode_table_entry kt_entry;
+
+		/*
+		 * Userspace is using a legacy call with a driver ported
+		 * to the new way. This is a bad idea with long sparsed
+		 * tables, since lots of the retrieved values will be in
+		 * blank. Also, it makes sense only if the table size is
+		 * lower than 2^32.
+		 */
+		memset(&kt_entry, 0, sizeof(kt_entry));
+		kt_entry.len = 32;
+		kt_entry.index = scancode;
+		kt_entry.scancode = char_scan;
+
+		retval = dev->getkeycodebig(dev, &kt_entry);
 
-	return dev->getkeycode(dev, scancode, keycode);
+		*keycode = kt_entry.keycode;
+		return retval;
+	}
 }
 EXPORT_SYMBOL(input_get_keycode);
 
@@ -662,21 +818,48 @@ int input_set_keycode(struct input_dev *dev, int scancode, int keycode)
 	int old_keycode;
 	int retval;
 
-	if (scancode < 0)
-		return -EINVAL;
-
 	if (keycode < 0 || keycode > KEY_MAX)
 		return -EINVAL;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
 
-	retval = dev->getkeycode(dev, scancode, &old_keycode);
-	if (retval)
-		goto out;
+	if (dev->getkeycode) {
+		/*
+		 * Use the legacy calls
+		 */
+		retval = dev->getkeycode(dev, scancode, &old_keycode);
+		if (retval)
+			goto out;
 
-	retval = dev->setkeycode(dev, scancode, keycode);
-	if (retval)
-		goto out;
+		retval = dev->setkeycode(dev, scancode, keycode);
+		if (retval)
+			goto out;
+	} else {
+		char char_scan[4];
+		struct keycode_table_entry kt_entry;
+
+		/*
+		 * Userspace is using a legacy call with a driver ported
+		 * to the new way. This is a bad idea with long sparsed
+		 * tables, since lots of the retrieved values will be in
+		 * blank. Also, it makes sense only if the table size is
+		 * lower than 2^32.
+		 */
+		memset(&kt_entry, 0, sizeof(kt_entry));
+		kt_entry.len = 32;
+		kt_entry.index = scancode;
+		kt_entry.scancode = char_scan;
+
+		retval = dev->getkeycodebig(dev, &kt_entry);
+		if (retval)
+			goto out;
+
+		kt_entry.keycode = keycode;
+
+		retval = dev->setkeycodebig(dev, &kt_entry);
+		if (retval)
+			goto out;
+	}
 
 	/*
 	 * Simulate keyup event if keycode is not present
@@ -1585,11 +1768,11 @@ int input_register_device(struct input_dev *dev)
 		dev->rep[REP_PERIOD] = 33;
 	}
 
-	if (!dev->getkeycode)
-		dev->getkeycode = input_default_getkeycode;
+	if (!dev->getkeycodebig)
+		dev->getkeycodebig = input_default_getkeycode;
 
-	if (!dev->setkeycode)
-		dev->setkeycode = input_default_setkeycode;
+	if (!dev->setkeycodebig)
+		dev->setkeycodebig = input_default_setkeycode;
 
 	dev_set_name(&dev->dev, "input%ld",
 		     (unsigned long) atomic_inc_return(&input_no) - 1);
diff --git a/include/linux/input.h b/include/linux/input.h
index 663208a..1f86f70 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -34,7 +34,7 @@ struct input_event {
  * Protocol version.
  */
 
-#define EV_VERSION		0x010000
+#define EV_VERSION		0x010001
 
 /*
  * IOCTLs (0x00 - 0x7f)
@@ -56,12 +56,22 @@ struct input_absinfo {
 	__s32 resolution;
 };
 
+struct keycode_table_entry {
+	__u32 keycode;	/* e.g. KEY_A */
+	__u32 index;		/* Index for the given scan/key table */
+	__u32 len;		/* Lenght of the scancode */
+	__u32 reserved[2];	/* Reserved for future usage */
+	char *scancode;		/* scancode, in machine-endian */
+};
+
 #define EVIOCGVERSION		_IOR('E', 0x01, int)			/* get driver version */
 #define EVIOCGID		_IOR('E', 0x02, struct input_id)	/* get device ID */
 #define EVIOCGREP		_IOR('E', 0x03, int[2])			/* get repeat settings */
 #define EVIOCSREP		_IOW('E', 0x03, int[2])			/* set repeat settings */
 #define EVIOCGKEYCODE		_IOR('E', 0x04, int[2])			/* get keycode */
 #define EVIOCSKEYCODE		_IOW('E', 0x04, int[2])			/* set keycode */
+#define EVIOCGKEYCODEBIG	_IOR('E', 0x04, struct keycode_table_entry) /* get keycode */
+#define EVIOCSKEYCODEBIG	_IOW('E', 0x04, struct keycode_table_entry) /* set keycode */
 
 #define EVIOCGNAME(len)		_IOC(_IOC_READ, 'E', 0x06, len)		/* get device name */
 #define EVIOCGPHYS(len)		_IOC(_IOC_READ, 'E', 0x07, len)		/* get physical location */
@@ -1022,11 +1032,15 @@ struct ff_effect {
  * @keycodemax: size of keycode table
  * @keycodesize: size of elements in keycode table
  * @keycode: map of scancodes to keycodes for this device
- * @setkeycode: optional method to alter current keymap, used to implement
+ * @setkeycode: optional legacy method to alter current keymap, used to
+ *	implement sparse keymaps. Shouldn't be used on new drivers
+ * @getkeycode: optional legacy method to retrieve current keymap.
+ *	Shouldn't be used on new drivers.
+ * @setkeycodebig: optional method to alter current keymap, used to implement
  *	sparse keymaps. If not supplied default mechanism will be used.
  *	The method is being called while holding event_lock and thus must
  *	not sleep
- * @getkeycode: optional method to retrieve current keymap. If not supplied
+ * @getkeycodebig: optional method to retrieve current keymap. If not supplied
  *	default mechanism will be used. The method is being called while
  *	holding event_lock and thus must not sleep
  * @ff: force feedback structure associated with the device if device
@@ -1101,6 +1115,10 @@ struct input_dev {
 	void *keycode;
 	int (*setkeycode)(struct input_dev *dev, int scancode, int keycode);
 	int (*getkeycode)(struct input_dev *dev, int scancode, int *keycode);
+	int (*setkeycodebig)(struct input_dev *dev,
+			     struct keycode_table_entry *kt_entry);
+	int (*getkeycodebig)(struct input_dev *dev,
+			     struct keycode_table_entry *kt_entry);
 
 	struct ff_device *ff;
 
@@ -1366,6 +1384,11 @@ static inline void input_set_abs_params(struct input_dev *dev, int axis, int min
 
 int input_get_keycode(struct input_dev *dev, int scancode, int *keycode);
 int input_set_keycode(struct input_dev *dev, int scancode, int keycode);
+int input_get_keycode_big(struct input_dev *dev,
+			  struct keycode_table_entry *kt_entry);
+int input_set_keycode_big(struct input_dev *dev,
+			  struct keycode_table_entry *kt_entry);
+
 
 extern struct class input_class;
 
