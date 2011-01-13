Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab1AMOvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:51:09 -0500
Received: from misc-148-66-126-238.pool.starband.net ([148.66.126.238]:57707
	"EHLO archaeopteryx.synaptics.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751951Ab1AMOvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:51:07 -0500
X-Greylist: delayed 28172 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jan 2011 09:50:57 EST
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
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Abraham Arce <x0066660@ti.com>
Subject: [PATCH 0/1] input synaptics-rmi4: Synaptics Touchscreen Driver
Date: Wed, 12 Jan 2011 18:40:52 -0800
Message-Id: <1294886453-7972-1-git-send-email-cheiny@synaptics.com>
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

This patch builds and runs in our development environment, but I cannot
guarantee that it will build for you.  We're working on making sure it
builds generically, and feedback relating to that will be greatly
appreciated (special thanks to Joerie de Gram for his previous feedback on
this).


This version of the driver implements the following:
    - basic device control support
    - support basic multifinger touchscreen behavior
    - support for device reflash
It represents a significant rearchitecture and reimplementation since
our patch of 2010/07/27, based on feedback from that patch and subsequent
discussions with kernel maintainers.

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

    - individual sensors are presented on the bus as /sys/bus/rmi/sensor0/,
      /sys/bus/rmi/sensor01/, and so on.
      
    - functions for each sensor are presented as devices below that sensor, for
      example /sys/bus/rmi/sensor0/f01, /sys/bus/rmi/sensor0/f11, and so on.

    - per-function drivers are matched to these devices by the kernel bus
      functionality

We chose this approach because almost all RMI4 functions are independent
of one another.  The sole exception is F01, and its primary interaction
with other functions is to notify them of the need to read or write data
from or to the sensor.

This structure eliminates the ad hoc device matching that was present in our
previous driver submissions.  It also enables easy addition of support for 
additional RMI4 functions, either by Synaptics or by third parties.


Comments and other feedback on this driver are welcomed.

Bill Manson
Allie Xiong
Christopher Heiny

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Abraham Arce <x0066660@ti.com>


---
