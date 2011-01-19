Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab1ASPmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:42:16 -0500
Received: from ixqw-mail-out.ixiacom.com ([66.77.12.12]:14060 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1ASPmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:42:15 -0500
Message-ID: <4D370654.7020400@ixiacom.com>
Date: Wed, 19 Jan 2011 07:42:12 -0800
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: RFC: UIO  null parent for __uio_register_device and uio_device_name()
References: <4D366104.1000400@ixiacom.com> <20110119145619.GA17399@local>
In-Reply-To: <20110119145619.GA17399@local>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans,

Thanks for the quick response.

>> o Allow a null parent during uio_register_device. We've had
>>   situations where there was no convenient parent. We could
>>   concoct a parent, but it seemed to make sense to allow
>>   for a null.
> 
> Hmm. I saw many UIO drivers over the years but we never had that
> problem. In the probe() function of your UIO driver you get a
> suitable device as parameter. Why don't you just use it?

We build custom hardware, and UIO has served us well by providing
a way out of kernel space.

[ I'm calling the driver we write the "UIO client driver" to
  avoid confusion with the Linux UIO driver. ]

In some implementations, the HW binds directly to the CPU
physical address space. In particular, it is not accessed via
PCI space. Thus there is no probe() function required at the
UIO client driver.

The physical address assignments for the device are fixed
at system design time, and the UIO client driver (for the custom hardware)
has those addresses built into it.

No probing is required in this scenario.

> Yes, we intentionally defined struct uio_device in uio.c and not in
> a header file to prevent driver authors from using it ;-)

Yes. This is a good pattern. I like using it too  ;-)

>> +const char *uio_device_name(struct uio_info *info)
>> +{
>> +       return dev_name(info->uio_dev->dev);
> 
> No NULL checks? Note that info->uio_dev can be NULL if uio_register_device()
> failed...

Apologies. I've tightened up the code.  See below.

> The function above returns strings like "uio0", "uio1", and so on. What's
> the value of that? To identify a certain driver or distinguish several
> instances of it, the "name" member of struct uio_info should be used.
> 
> But maybe I just miss the point. What's your use case?

This is how our code currently works.

1. UIO client driver registers with Linux UIO driver.
2. UIO client driver advertises the name of the Linux UIO driver
   instance to which it is bound (eg "uio2") to our custom
   application
3. Our custom application queries for the name of the driver
   to use (eg "uio2")
4. Our custom application issues open("/dev/uio2") to access hardware.

Working on the implementation of our new system last night I realise
that our new configuration runs very lean, and I now do not have the
use of udev to populate /dev/uio[0-9].

This new configuration runs so lean that I don't have access to sysfs.
I've asked about including sysfs, but there are good reasons not to
include it. This means that /sys/class/uio[0-9]/... will not be available.

The result is that I need to figure out the major/minor device number in
order to access the Linux UIO device. I will advertise this through /proc/
entries specific to the UIO client driver. We can then use this information
to mknod /dev/uio[0-9].

I've added uio_device_chrdev() alongside uio_device_name() to allow
us to figure out the coordinates of the Linux UIO device.

Earl



--- /tmp/uio_driver.h.orig      2011-01-18 19:42:13.777452360 -0800
+++ /tmp/uio_driver.h   2011-01-19 07:26:58.037452472 -0800
@@ -105,6 +105,8 @@
 }
 extern void uio_unregister_device(struct uio_info *info);
 extern void uio_event_notify(struct uio_info *info);
+extern const char *uio_device_name(struct uio_device *info);
+extern dev_t uio_device_chrdev(struct uio_device *info);

 /* defines for uio_info->irq */
 #define UIO_IRQ_CUSTOM -1


--- /tmp/uio.c.orig     2011-01-18 17:38:17.157452875 -0800
+++ /tmp/uio.c  2011-01-19 07:39:48.457461684 -0800
@@ -808,6 +808,36 @@
 }

 /**
+ * uio_device_chrdev - obtain the name of the registered device
+ * @info:      UIO device capabilities
+ *
+ * returns device number or NULL if not available.
+ */
+dev_t uio_device_chrdev(struct uio_info *info)
+{
+       if (info && info->uio_dev)
+               return MKDEV(uio_major, info->uio_dev->minor);
+
+       return 0;
+}
+EXPORT_SYMBOL_GPL(uio_device_chrdev);
+
+/**
+ * uio_device_name - obtain the name of the registered device
+ * @info:      UIO device capabilities
+ *
+ * returns name of device or NULL if not available.
+ */
+const char *uio_device_name(struct uio_info *info)
+{
+       if (info && info->uio_dev && info->uio_dev->dev)
+               return dev_name(info->uio_dev->dev);
+
+       return NULL;
+}
+EXPORT_SYMBOL_GPL(uio_device_name);
+
+/**
  * uio_register_device - register a new userspace IO device
  * @owner:     module that creates the new device
  * @parent:    parent device
@@ -822,7 +852,7 @@
        struct uio_device *idev;
        int ret = 0;

-       if (!parent || !info || !info->name || !info->version)
+       if (!info || !info->name || !info->version)
                return -EINVAL;

        info->uio_dev = NULL;

