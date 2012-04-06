Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab2DFS3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:29:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:52303 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab2DFS25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:28:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="138591154"
Subject: [PATCH 0/6] rework quirks for the "kt" serial port
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@linux.intel.com
Date: Fri, 06 Apr 2012 11:44:22 -0700
Message-ID: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kt serial port intermittently reports unreliable data in its IIR
register and needs to reset fifos to stay in sync with firmware when the
device is reset.

The IIR fixes that went into 3.3 were not complete so patch 3 replaces
them with an explicit way to turn on UART_BUG_THRE (i.e. the "I don't
trust my iir" flag).

A new fix for resetting the fifos on device reset is patch 5.  Alan
asked to make this a new quirk rather than add more workarounds to the
core (patch 4).

Patch 6 is an untested RFC / RFT from anyone that has a serial
suspend/resume use case with an 'init' quirk that has resources that
need de-allocation at 'exit'.

--
Dan

---

Dan Williams (5):
      Revert "serial/8250_pci: init-quirk msi support for kt serial controller"
      Revert "serial/8250_pci: setup-quirk workaround for the kt serial controller"
      serial/8250_pci: add a "force background timer" flag and use it for the "kt" serial port
      tegra, serial8250: add ->handle_break() uart_port op
      serial/8250_pci: fix suspend/resume vs init/exit quirks

Sudhakar Mamillapalli (1):
      serial/8250_pci: Clear FIFOs for Intel ME Serial Over Lan device on BI


 arch/arm/mach-tegra/board-harmony.c   |    1 +
 arch/arm/mach-tegra/board-paz00.c     |    2 +
 arch/arm/mach-tegra/board-seaboard.c  |    1 +
 arch/arm/mach-tegra/board-trimslice.c |    1 +
 arch/arm/mach-tegra/devices.c         |   18 ++++++++++
 arch/arm/mach-tegra/devices.h         |    2 +
 drivers/tty/serial/8250/8250.c        |   56 ++++++++++--------------------
 drivers/tty/serial/8250/8250.h        |    2 +
 drivers/tty/serial/8250/8250_pci.c    |   61 +++++++++++++++++++++++++--------
 include/linux/serial_8250.h           |    1 +
 include/linux/serial_core.h           |    7 +++-
 11 files changed, 99 insertions(+), 53 deletions(-)
