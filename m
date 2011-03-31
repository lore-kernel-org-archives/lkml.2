Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab1CaCkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:40:31 -0400
Received: from [12.234.97.163] ([12.234.97.163]:6286 "EHLO
	brontomerus.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756800Ab1CaCk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:40:28 -0400
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 0/3] (corrected) input/touchscreen: Synaptics RMI4 Touchscreen Driver
Date: Wed, 30 Mar 2011 19:39:26 -0700
Message-Id: <1301539169-9105-1-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a driver supporting Synaptics ClearPad and other
touchscreens that use the RMI4 protocol, as defined here:

    http://www.synaptics.com/sites/default/files/511-000136-01_revD.pdf

This patch is against the v2.6.38 tag of Linus' kernel tree, commit
521cb40b0c44418a4fd36dc633f575813d59a43d.  Note that previous patches
were against the synaptics-rmi4 branch of Dmitry Torokhov's input
tree.  At Dmitry's request, we have switched the base for our work
to v2.6.38 - this should make it easier for people to pick up and
test this and future patches.

This patch is functionally the same as yesterday's patch.  It adds a missing
file, and cleans up a bunch of printks and #if 0's.

I2C functionality was previously ACK'ed by Jean Delvare on 2010/05/29.

SPI code is included, but not ready for prime time yet.

This patch completely supersedes the previous patch of 2011/03/01.  In addition
to benefitting from more thorough review and testing, this version of the
driver includes the following:
      
    - preliminary implementation of rmi_f11 relative motion support

    - support for RMI4 Function 19 (capacitive buttons)
    
    - fixes for a kernel panic in rmi_f34.c configuration
    
    - additional sysfs parameters, particularly for rmi_f11 (2D pointing)
    
    - major restructuring of platformdata to (hopefully) simplify its
      use while also allowing more operating parameters to be specified
      via the platformdata.
    
    - deletion of more legacy code and behavior

This patch supports a system having one or more RMI sensors attached to it.
Most devices have just a single touch sensor, but some have more than one.
An example is the Fuse concept phone, which has 4 RMI sensors in it).
Each sensor implements a number of RMI4 functions, which are best represented
as devices on the bus.

The patch is divide into three parts:

    1/3 - the core of the driver, implementing the logical rmi_bus and 
    	  access to the physical bus (rmi_i2c and rmi_spi).
    	  
    2/3 - the sensor and function implementation.
      
    3/3 - Makefile and Kconfig

The driver core manages the sensors on a device via the rmi bus (/sys/bus/rmi),
handles interfunction communications (mostly IRQ notifications from F01 to
other functions), and proxies register read/write requests to the appropriate
physical layer for a given sensor.

Individual sensors are presented on the bus as /sys/bus/rmi/devices/sensor00,
/sys/bus/rmi/devices/sensor01/, and so on.
      
Functions for each sensor are presented as devices next to that sensor, for
example /sys/bus/rmi/devices/sensor00f01, /sys/bus/rmi/devices/sensor00f11,
and so on.
      
Sensor driver instances are attached to the bus using the kernel device discovery
mechanism.  A future release will do the same for function driver instances,
but for now we use an ad hoc mechanism to match functions to sensors.

We chose this approach because almost all RMI4 functions are independent
of one another.  The sole exception is F01, and its primary interaction
with other functions is to notify them of the need to read or write data
from or to the sensor.  In the long term, this will allow 3rd parties to
implement additional RMI functions in a modular fashion, without having
to modify the core driver implementation or the implementation of unrelated
functions.


Comments and other feedback on this driver are welcomed.

Bill Manson
Allie Xiong
Christopher Heiny

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

---
