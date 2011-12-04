Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1LDXmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 18:42:40 -0500
Received: from mail.windriver.com ([147.11.1.11]:63545 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab1LDXmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 18:42:38 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: alan@linux.intel.com, gregkh@suse.de, scottwood@freescale.com,
        galak@kernel.crashing.org
Cc: linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] RFCv2 Fix Fsl 8250 BRK bug
Date: Sun,  4 Dec 2011 18:42:17 -0500
Message-Id: <1323042143-25330-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan wrote:

> Things like 8250_dw.c is perhaps more the style we want to be looking at
> for other devices and adjusting 8250.c as needed to export or split
> methods up so they can be used as helpers.

[...]

> Sorting out a ->handle_port override is probably ultimately the right
> thing to do and then we can push some of the other funnies out further.

I never figured spending this much time on this, but I think this is
a lot better, and 8250.c comes out slightly smaller and cleaner too,
hopefully satisfying Alan's other request "...we want less not more".

The errata is firewalled off in 8250_fsl.c (as per Alan's 1st comment),
and 8250.c now exports a couple more things to be used as helpers.

When I started looking at a handle_port override, I realized that it
really didn't need to exist at all, and the existing handle_irq
override we already have does the job nicely.  In the process, I found
an interesting quirk while cleaning up duplicated code in the timeout
handler, where we don't use the custom IRQ handler if there is one.

So, the errata is dealt with by installing a custom IRQ handler, and
it doesn't have the "eew ick" factor that Scott mentioned, in regards
to trying to learn state from watching serial_in() traffic.

The timeout cleanup seemed so obvious, that I was convinced I must
be missing some subtle thing.  So I confirmed it by stripping my IRQ
properties from my dts file and running the serial console IRQ-less.

I also re-tested the sysRq feature on sbc8349, to ensure the WAR was
actually doing its job, and I also tested with serial console on
an old SocketA board to make sure non-ppc didn't get hosed somehow.

Anyway, have a look and see if this version of things is acceptable
to all.  (Again, the dts update from Kumar isn't shown here).

Thanks to all who provided the feedback on v1.
Paul.

------

Paul Gortmaker (6):
  serial: move struct uart_8250_port from 8250.c to 8250.h
  serial: clean up parameter passing for 8250 Rx IRQ handling
  serial: export the key functions for an 8250 IRQ handler
  serial: make 8250 timeout use the specified IRQ handler
  serial: manually inline serial8250_handle_port
  serial: add irq handler for Freescale 16550 errata.

 arch/powerpc/kernel/legacy_serial.c |    3 +
 drivers/tty/serial/8250.c           |   92 ++++++++++++-----------------------
 drivers/tty/serial/8250.h           |   26 ++++++++++
 drivers/tty/serial/8250_fsl.c       |   63 ++++++++++++++++++++++++
 drivers/tty/serial/Kconfig          |    5 ++
 drivers/tty/serial/Makefile         |    1 +
 include/linux/serial_8250.h         |    5 ++
 7 files changed, 134 insertions(+), 61 deletions(-)
 create mode 100644 drivers/tty/serial/8250_fsl.c

-- 
1.7.7

