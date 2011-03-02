Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972Ab1CBFB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:01:57 -0500
Received: from [12.234.97.163] ([12.234.97.163]:45776 "EHLO
	archaeopteryx.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750702Ab1CBFBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:01:55 -0500
X-Greylist: delayed 2084 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Mar 2011 00:01:54 EST
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 0/1] input synaptics-rmi4: Synaptics RMI4 Touchscreen Driver
Date: Tue,  1 Mar 2011 20:26:34 -0800
Message-Id: <1299039995-11055-1-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a driver supporting Synaptics ClearPad and other
touchscreens that use the RMI4 protocol, as defined here:

http://www.synaptics.com/sites/default/files/511-000136-01_revA.pdf

This patch is against the synaptics-rmi4 branch of Dmitry's Torokhov's input
git repository.  Base point is the origin of the branch, commit
a6268cc5f94c89c9e661150fe136b24e69d6cc01.

I2C functionality was previously ACK'ed by Jean Delvare on 2010/05/29.

SPI code is included, but not ready for prime time yet.

This patch completely supersedes the previous patch of 2011/01/12, which
contained an embarassingly large number of really egregious bugs.  In addition
to benefitting from more thorough review and testing, this version of the
driver includes the following:
    - full multifinger position reporting (tested for up to 10 fingers)
    - support of ATTN interrupt or polled mode
    - some sysfs parameters for adjusting the bounds and position of the
      touch area and reported coordinates
    - implementation of the requested /sys/bus/rmi at the sensor level.
    - deletion of a great deal of legacy code and behavior

We intended to include device reflash support, but at the last minute
discovered an oops in the function configuration code, so that is commented out.

This patch supports a system having one or more RMI sensors attached to it.
Most devices have just a single touch sensor, but some have more than one.
An example is the Fuse concept phone, which has 4 RMI sensors in it).
Each sensor implements a number of RMI4 functions, which are best represented
as devices on the bus.

Included in this patch are the following components:

    - a low level layer providing access to the physical bus (rmi_i2c
      and rmi_spi).

    - an rmi_bus module, implementing /sys/bus/rmi.  This module presents
      the individual devices on the bus, handles interdevice communications
      (mostly just IRQ notifications from F01 to other functions), and
      proxies register read/write requests to the appropriate physical layer
      for a given sensor.

    - individual sensors are presented on the bus as /sys/bus/rmi/devices/sensor00,
      /sys/bus/rmi/devices/sensor01/, and so on.
      
    - functions for each sensor are presented as devices next to that sensor, for
      example /sys/bus/rmi/devices/sensor00f01, /sys/bus/rmi/devices/sensor00f11,
      and so on.
      
Sensor driver instances are attached to the bus using the kernel device discovery
mechanism.  A future release will do the same for function driver instances,
but for now we use an ad hoc mechanism to match functions to sensors.

We chose this approach because almost all RMI4 functions are independent
of one another.  The sole exception is F01, and its primary interaction
with other functions is to notify them of the need to read or write data
from or to the sensor.


Comments and other feedback on this driver are welcomed.

Bill Manson
Allie Xiong
Christopher Heiny

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>


---
