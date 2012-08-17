Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab2HQXUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 19:20:53 -0400
Received: from [12.239.217.82] ([12.239.217.82]:28612 "EHLO
	venom.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756833Ab2HQXUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 19:20:45 -0400
X-Greylist: delayed 3724 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2012 19:20:45 EDT
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [RFC PATCH 00/11] input: Synaptics RMI4 Touchscreen Driver
Date: Fri, 17 Aug 2012 15:17:40 -0700
Message-Id: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a driver supporting Synaptics ClearPad and other
touchscreen sensors that use the RMI4 protocol, as defined here:

    http://www.synaptics.com/sites/default/files/511-000136-01-Rev-E-RMI4%20Intrfacing%20Guide.pdf

as well as successor documents that haven't made their way through to
publication yet.

This code supersedes the patch submitted on 2011-12-21.  We believe that all
outstanding issues arising from the previous submissions have been addressed,
except certain issues relating to the use of device_type and the binding of 
the individual function drivers (see below).


This patch is against the v2.6.38 tag of Linus' kernel tree, commit
521cb40b0c44418a4fd36dc633f575813d59a43d.  This will be our last patch against
such an old kernel version, future patches will be against 3.x kernels.



Included in this patch are:
    - full support for an RMI virtual bus as a standard kernel bus

    - physical layer implementations for I2C and SPI

    - function implementations for the following RMI4 functions:
        * F01 device control
        * F09 self test (aka BIST)
        * F11 multifinger pointing
        * F17 pointing sticks
        * F19 capacitive buttons
        * F1A simple capacitive buttons
        * F21 force sensing
        * F30 GPIO and LED controls
        * F34 device reflash
        * F41 active pen pointing
        * F54 analog data reporting

    - character device access to the RMI4 register map via rmidev
    
    - firmware reflash using the request_firmware mechanism

The driver supports a system having one or more RMI sensors attached to it.
Most devices have just a single touch sensor, but some have more than one.
An example is the Fuse concept phone, which has 4 RMI sensors in it.

Each sensor is presented as a device on the RMI logical bus (/sys/bus/rmi).
Devices are named/numbered in the order they are discovered on the bus,
starting with /sys/bus/rmi/devices/sensor00 for the first once, .../sensor01
for the second one, and so on.

Individual RMI functions are presented as child devices of the sensor device.
For example, sensor00/fn01, sensor00/fn11, and so on.  Control of an RMI
function's operating parameters is implemented via sysfs.

For diagnostic purposes, the rmidev interface is provided.  This implements
a character device (/dev/rmi0, and so on) that provides flat file access to
the RMI4 register map.  For more information, see the file
Documentation/input/rmidev.txt.



Note regarding device_type and functional driver matching.

Feedback on our patch submission from 2011-12 requested that we use device_type
to help match drivers that worked directly with the sensor (such as rmi_dev.c)
and drivers that work with individual functions (such as rmi_f11.c).  We spent
some effort on this request, but in the meantime the original customer
requirements that led to the differentiation between the two types of driver
no longer exist.  As a result, we have rolled back that work, and plan to merge
the rmi_dev functionality into the core of the driver, eliminating the need
to support two device_types and their drivers.  This will be included in our
next patch submission, along with changes to how function drivers are matched
functions.

We considered postponing this patch until that was done, but it's been a 
very long time since the last one, and we wanted to make the other work
available.


Due to the large amount of code, we've broken this patch into 17 parts, as
follows:
    01 - public header files and documentation
    02 - core sensor and bus implementation
    03 - physical layer drivers
    04 - Kconfigs and Makefiles
    05 - rmidev
    06 - firmware update
    07..17 - drivers for individual RMI functions


Comments and other feedback on this driver are welcomed.

Christopher Heiny and the Synaptics RMI4 driver team

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

---
