Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab1D0SOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:14:44 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:48346 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260Ab1D0SOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MLVa1foS4oSGaeKpcXj4zqL4ygrQ9lC7KYA+l7EAbVdNyIpr6Xs4CDJROhG5yV5vbY
         qqg2/tdek93ib7PiI+wO/mp3IXrdV0AKCUHabaQUtg+8xq9pvQNMR8daQiLK3EfCk+Qe
         GeELUzppPBDbRLLS3qqy5qCsi+KA3kGVq5Uxk=
From: James Nuss <jamesnuss@nanometrics.ca>
To: Rodolfo Giometti <rodolfo.giometti@enneenne.com>,
        Ricardo Martins <rasm@fe.up.pt>
Cc: Ben Gardiner <bengardiner@nanometrics.ca>, linux-kernel@vger.kernel.org,
        linuxpps@ml.enneenne.com, James Nuss <jamesnuss@nanometrics.ca>
Subject: [PATCH 0/2] New PPS client driver for IRQs
Date: Wed, 27 Apr 2011 14:14:12 -0400
Message-Id: <1303928054-14662-1-git-send-email-jamesnuss@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

[PATCH 2/2] adds a new PPS client driver for use with IRQs. The module is
implemented as a platform driver therefore it is necessary to register
platform device(s) to make use of it. Usually this is performed
in your specific board setup.

TESTING:
Testing was performed using the Texas Instruments OMAP-L138 based DA850
evaluation board. GPIO6.6 was configured as an input and registered as
an IRQ resource and platform device in the board setup - 
arch/arm/mach-davinci/board-da850-evm.c.
This GPIO was connected to a Trimble Lassen IQ generating real PPS signals.
The dmesg output with PPS debugging enabled is as follows:

pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
pps-irq: registering IRQ 203 as PPS source
pps_core: source pps-irq.-1 got cdev (253:0)
pps pps0: new PPS source pps-irq.-1
pps-irq: requesting IRQ 203
pps pps0: Registered IRQ 203 as PPS source
pps pps0: PPS event at 946684801.344852542
pps pps0: capture assert seq #1
pps pps0: PPS event at 946684802.344817167
pps pps0: capture assert seq #2
pps pps0: PPS event at 946684803.344781959
pps pps0: capture assert seq #3
...

This patchset applies cleanly (using 'git am') against v2.6.38.
After applying to v2.6.39-rc5, a manual 'patch --merge' is also required to
resolve the conflict.

James Nuss (2):
  pps: default echo function
  pps: new client driver using IRQs

 drivers/pps/clients/Kconfig       |    8 ++
 drivers/pps/clients/Makefile      |    1 +
 drivers/pps/clients/pps-irq.c     |  169 +++++++++++++++++++++++++++++++++++++
 drivers/pps/clients/pps-ktimer.c  |   12 ---
 drivers/pps/clients/pps_parport.c |    9 --
 drivers/pps/kapi.c                |   20 +++--
 6 files changed, 191 insertions(+), 28 deletions(-)
 create mode 100644 drivers/pps/clients/pps-irq.c

