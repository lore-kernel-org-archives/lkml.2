Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab1COVPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:15:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49599 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688Ab1COVPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:15:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-iio@vger.kernel.org
Subject: IIO comments
Date: Tue, 15 Mar 2011 22:15:20 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103152215.20059.arnd@arndb.de>
X-Provags-ID: V02:K0:yOO5p0+yQz/Nw6OL/ybuKrVUv/06HMYrhdu3iPbONy0
 nocmKb8FUoTe/JeaMX+2fpfQWGS3V+17O/qvoTGqTrSrujoj/p
 MRWLLqovUUVgelqX/3vckW4iJLFQf5iBYS0GXO307b5alkuWdh
 1s4UGe/DXQpR/wnuG+NIejIYb8irgcVNICYKyhtv3OmMWL2o9D
 iiQWPrG3CEtdQHtPU6lHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've started looking at the current code base in staging,
this is basically a log of what I'm finding there that
may get improved:

* Your bus_type is not really a bus in the sense we normally
use it, because it does not have any driver/device matching.
You only register devices from the same files that drive
the hardware. This is normally done using a class, not
a bus.

* Since you specify the sysfs attributes globally in the
documentation, it would be nice if drivers did not have
to implement them as attribute show function, but as
a function that simply returns a value that is then
printed by common code. You can do this using a structure
of function pointers that each driver fills with the
relevant ones, like file_operations, replacing the
attribute groups.

* iio_allocate_device() could get a size argument and
allocate the dev_data together with the iio_dev in 
a single allocation, like netdev_alloc does. In addition,
you can pass a structure with all constant data, such
as THIS_MODULE, and the operations and/or attribute groups,
instead of having to set them individually for each dev.

* It's not clear to me why you need one additional device
and one chardev for each interrupt line of a device, my
feeling is that this could be simplified a lot if you find
a way to represent an iio_dev with a single chardev to
user space. This may have been an attempt to avoid ioctl()
calls, but I think in this case an ioctl interface would
be cleaner than a complex hierarchy of devices.
Another alternative would be for the device driver to
register multiple iio_devs in case it needs multiple
interfaces.

* Neither of your two file operations supports poll(), only
read. Having poll() support is essential if you want to
wait for multiple devices in user space. Maybe it's
possible to convert the code to use eventfd instead of
rolling your own event interface?

* The name rip_lots doesn't really mean anything to me
as a non-native speaker. Maybe think of a better word for
this. Also, there is only one driver providing such a function,
so this is probably a good candidate for deferring to a later
stage, along with all the the entire ring file code that seems
rather pointless otherwise.

* The exported symbols should probably become EXPORT_SYMBOL_GPL

* iio-trig-sysfs should not be a platform driver

That's probably enough for today, to start some discussion
about the core. Overall, I'm pleasantly surprised by the
quality of the code, it's much better than I was expecting
after having looked at drivers from hardware vendors a lot
recently.

	Arnd
