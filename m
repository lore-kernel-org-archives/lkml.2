Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab2JFEKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 00:10:43 -0400
Received: from [12.239.217.82] ([12.239.217.82]:38553 "EHLO
	brontomerus.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750858Ab2JFEKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 00:10:42 -0400
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chen <alexandra.chen@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [RFC PATCH 00/06] input: Synaptics RMI4 Touchscreen Driver
Date: Fri,  5 Oct 2012 21:09:57 -0700
Message-Id: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a driver supporting Synaptics ClearPad and other
touchscreen sensors that use the RMI4 protocol, as defined here:

    http://www.synaptics.com/sites/default/files/511-000136-01-Rev-E-RMI4%20Intrfacing%20Guide.pdf

as well as successor documents that haven't made their way through to
publication yet.

This code supersedes the patch submitted on 2012-08-17.  For all files
included in this patch, we believe that all outstanding issues arising
from the previous submissions have been addressed, except for looking into
using irq_chip to manage chip interrupt dispatch - was passed on that mainly
to limit the amount of major structural change since the previous patch.  We
will continue to pursue the irq_chip request, however.

Also, at the request of several maintainers, we have reduced the number of
files included in this patch.  Hopefully this is much less of a patch bomb
(perhaps just a patch firecracker).  The files provided are sufficient to
fully drive an RMI4 2D sensor, handling full multifinger reporting and device
and power management.


This patch is against the v3.6 tag of Linus' kernel tree, commit
a0d271cbfed1dd50278c6b06bead3d00ba0a88f9.  It should work fine with kernels
back to 3.1.



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
    - elimination of ad-hoc bus matching/binding and reliance on standard bus
      implementation.
    - elimination of out-of-tree features such as EARLY_SUSPEND
    - use of devm_kzalloc where appropriate
    - partition of control parameters between sysfs and debugfs
    - simplified configuration and control of debugging related features
    - IRQ management consolidated in once place


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
