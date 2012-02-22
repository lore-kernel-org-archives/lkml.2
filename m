Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab2BVCAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 21:00:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:57171 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab2BVCAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 21:00:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="68898213"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 0/4] pch_uart: Cleanups, board quirks, and user uartclk parameter
Date: Tue, 21 Feb 2012 17:59:24 -0800
Message-Id: <cover.1329875301.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series does some minor clean-up to the pch_uart driver, adds support
for the Fish River Island II UART clock, and introduces a user_uartclk
parameter to aid in developing for early and changing hardware.

Note that this series is my proposed alternative solution to that provided
by Tomoya MORNIAGA and Feng Tang which drops the board quirks and opts to
assume a 192 MHz clock on all boards. The problem with this approach is
that the CLKCFG register may have been set to something other than the
192MHz configuration by the firmware. If so, then the pch_uart will send
garbage between the time the boot console is disabled and the pch_phub
sets the CLKCFG register again. In my case, the pch_phub PCI probe occurs
after the pch_uart_console_setup. Even if it happened before, the output
up until the PCI probing would be garbage.

In order to support an early serial console, we cannot rely on the pch_phub
probe function to setup the CFGCLK register. This series relies on the board
quirks and doesn't force the setting of the CLKREG in the pch_phub code.
Instead, it aligns with what is the default configuration (defined by firmware)
for a given board. The user_uartclk provides a mechanism to force a specific
uartclk if necessary.

--
Darren

The following changes since commit 27e74da9800289e69ba907777df1e2085231eff7:

  i387: export 'fpu_owner_task' per-cpu variable (2012-02-20 19:34:10 -0800)

are available in the git repository at:
  git://git.infradead.org/users/dvhart/linux-2.6.git pch_uart
  http://git.infradead.org/users/dvhart/linux-2.6.git/shortlog/refs/heads/pch_uart
Darren Hart (4):
  pch_uart: Use uartclk instead of base_baud
  pch_uart: Add Fish River Island II uart clock quirks
  pch_uart: Add user_uartclk parameter
  pch_uart: Use existing default_baud in setup_console

 drivers/tty/serial/pch_uart.c |   52 +++++++++++++++++++++++++++++-----------
 1 files changed, 37 insertions(+), 15 deletions(-)

-- 
1.7.6.5

