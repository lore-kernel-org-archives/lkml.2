Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2KQD76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:59:58 -0500
Received: from [12.239.217.82] ([12.239.217.82]:30743 "EHLO
	brontomerus.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753904Ab2KQD74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:59:56 -0500
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [RFC PATCH 00/06] input: Synaptics RMI4 Touchscreen Driver
Date: Fri, 16 Nov 2012 19:58:48 -0800
Message-Id: <1353124734-16803-1-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a driver supporting Synaptics ClearPad and other
touchscreen sensors that use the RMI4 protocol, as defined here:

    http://www.synaptics.com/sites/default/files/511-000136-01-Rev-E-RMI4%20Intrfacing%20Guide.pdf

as well as successor documents that haven't made their way through to
publication yet.

This code supersedes the patch submitted on 2012-10-05.  For all files
included in this patch, we believe that all outstanding issues arising
from the previous submissions have been addressed, except as follows:

* we've investigated using irq_chip to manage chip interrupt dispatch, and
that certainly is a good idea.  However, we need to support kernels back to
3.0.x, and the required functionality is not yet present in those older kernels.
Once we no longer need to support 3.0.x, we'll jump onto irq_chip right
away.

* some of the requested changes to rmi_f11.c are simply not possible while
still retaining general driver functionality.  We've clarified existing comments
and added new ones to explain why that is the case.


This patch is against the v3.7-rc5 tag of Linus' kernel tree, object
77b67063bb6bce6d475e910d3b886a606d0d91f7.  It should work fine with that kernel,
but will not work with earlier kernels due to changes in the input subsystem.



Included in this patch are:
    - full support for an RMI virtual bus as a standard kernel bus

    - physical layer implementation for I2C

    - device driver for general RMI4 sensor functionality

    - function implementations for the following RMI4 functions:
        * F01 device control
        * F11 multifinger pointing

The driver supports a system having one or more RMI sensors attached to it.
Most devices have just a single touch sensor, but some have more than one.
An example is the Fuse concept phone, which has 4 RMI sensors in it.

Each sensor is presented as a device on the RMI logical bus (/sys/bus/rmi).
Devices are named/numbered in the order they are discovered on the bus,
starting with /sys/bus/rmi/devices/sensor00 for the first once, .../sensor01
for the second one, and so on.

Individual RMI functions are presented as child devices of the sensor device.
For example, sensor00.fn01, sensor00.fn11, and so on.  Control of an RMI
function's operating parameters is implemented via sysfs or debugfs (depending
on whether the parameters are used during normal operation or system
development/prototyping).



The amount of feedback received on previous patches precludes addressing each
item individually.  However, major changes for this patch are:
    - elimination of sysfs management macros
    - elimination of roll-your-own bitmask management
    - moved potentially large arrays and structs from the stack to the heap
    - elimination of the union/struct idiom for mapping register groups
    - corrected identification of input devices, including adding a BUS_RMI
      bus type.


We've broken this patch into 6 parts, as follows:
    01 - public header files and documentation
    02 - core sensor and bus implementation
    03 - I2C physical layer driver
    04 - Kconfigs and Makefiles
    05..06 - drivers for individual RMI functions


Comments and other feedback on this driver are welcomed.

Christopher Heiny and the Synaptics RMI4 driver team

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

---
