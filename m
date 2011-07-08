Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1GHP1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:27:38 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:59079 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753439Ab1GHP1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:27:36 -0400
From: James Nuss <jamesnuss@nanometrics.ca>
To: Rodolfo Giometti <rodolfo.giometti@enneenne.com>
Cc: Ricardo Martins <rasm@fe.up.pt>, Ben Gardiner <bengardiner@nanometrics.ca>,
        linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Igor Plyatov <plyatov@gmail.com>
Subject: [PATCH v3 0/2] New PPS client driver using GPIO
Date: Fri,  8 Jul 2011 11:27:24 -0400
Message-Id: <1310138846-1164-1-git-send-email-jamesnuss@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
. manually specify label for pr_fmt() since KBUILD_MODNAME equates to
pps_gpio rather than pps-gpio which is the driver name.
. cleanup return values
. call gpio_free() on error if gpio_request() has been called.

Changes since v1:
. rename module to pps-gpio
. add platform data options for gpio pin number, gpio pin label, assert edge type,
and clear event capture.
. no need to setup gpio and IRQ resource in platform device. This is performed by
the driver.
. cleanup as per comments

---

This patchset contains 2 patches.  It is based on the work done by
Ricardo Martins <rasm@fe.up.pt> who submitted an initial implementation [1]
of a PPS IRQ client driver to the linuxpps mailing-list on Dec 3 2010. Most
of the work was in removing the platform device registration from the
driver itself as this is not the standard way of platform driver/device
registration.

[1] http://ml.enneenne.com/pipermail/linuxpps/2010-December/004155.html

[PATCH 1/2] is mostly a cleanup and contains refactoring of the echo
function definition interface. A default echo function has been defined
so all you need to do is set one of the ECHO flags and this function will
be used. Alternatively, don't set the ECHO flags or override the echo
function as required.

[PATCH 2/2] adds a new PPS client driver for use with GPIO. The module is
implemented as a platform driver therefore it is necessary to register
platform device(s) to make use of it. Usually this is performed
in your specific board setup.

TESTING:
Testing was performed using the Texas Instruments OMAP-L138 based DA850
evaluation board. GPIO6.6 was selected as the GPIO pin with assert events
on the rising edge and also capturing clear events.  The platform device was
registered in arch/arm/mach-davinci/board-da850-evm.c.
This GPIO was connected to a Trimble Lassen IQ generating real PPS signals.
The dmesg output with PPS debugging enabled is as follows:

...
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
pps_core: source pps-gpio.0 got cdev (253:0)
pps pps0: new PPS source pps-gpio.0
pps pps0: Registered IRQ 203 as PPS source
...
pps pps0: PPS event at 1309287783.084940917
pps pps0: capture assert seq #29
pps pps0: PPS event at 1309287783.085086500
pps pps0: capture clear seq #31
pps pps0: PPS event at 1309287784.084908209
pps pps0: capture assert seq #30
pps pps0: PPS event at 1309287784.085053209
pps pps0: capture clear seq #32
...

---

James Nuss (2):
  pps: default echo function
  pps: new client driver using GPIO

 drivers/pps/clients/Kconfig       |    9 ++
 drivers/pps/clients/Makefile      |    1 +
 drivers/pps/clients/pps-gpio.c    |  227 +++++++++++++++++++++++++++++++++++++
 drivers/pps/clients/pps-ktimer.c  |   12 --
 drivers/pps/clients/pps_parport.c |    9 --
 drivers/pps/kapi.c                |   20 ++-
 include/linux/pps-gpio.h          |   32 +++++
 7 files changed, 282 insertions(+), 28 deletions(-)
 create mode 100644 drivers/pps/clients/pps-gpio.c
 create mode 100644 include/linux/pps-gpio.h

