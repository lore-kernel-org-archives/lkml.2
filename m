Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab1DGV1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:27:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40158 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab1DGV07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:26:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=Ew5Oynoz7+XrgIJCfo7fc8b+6yuNe+ECi43sNsb2O9ixsVWWfLwZNGdLnBIk13Vcp
	zDuBqNUqHVaU6+ch3GWRQ==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v2 0/3] Make all it87 drivers SMP safe.
Date: Thu,  7 Apr 2011 14:26:00 -0700
Message-Id: <1302211560-8052-1-git-send-email-natg@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 3 different drivers that touch the it87 hardware registers.
The 3 drivers have been written independently and access the it87 hardware
registers assuming they are the only driver accessing it. This change
attempts to serialize access to the hardware by defining a global spinlock
it87_io_lock in a file it87_lock.c. This lock has to be acquired by each
of the it87 drivers before it can access the hardware. We have defined
a new Kconfig option IT87_LOCK. When it is selected it87_lock.c is compiled
into the kernel thereby making the lock global and accessable to the it87
drivers which are typically built as loadable modules. All the it87 drivers
select IT87_LOCK to compile the lock into the kernel.
The routines accessing the hardware are being called from module init,
open, ioctl and module exit routines and hence it is sufficient to use
calls to spin_lock and spin_unlock to acquire and release the locks. For
the same reasons it87_wdt.c has extensive changes to remove calls to
spin_lock_irqsave and spin_unlock_irqrestore. The lock is now acquired
in superio_enter and released in superio_exit. This is now identical
to the code in drivers/hwmon/it87.c and drivers/watchdog/it8712f_wdt.c.
Added __acquire and __release annotations wherever needed.

01 - Adds the relevant lock files.
 drivers/watchdog/Kconfig
 drivers/watchdog/Makefile
 drivers/watchdog/it87_lock.c
 include/linux/it87_lock.h

02 - Adds changes to watchdog drivers to use the new lock.
 drivers/watchdog/it8712f_wdt.c
 drivers/watchdog/it87_wdt.c

03 - Adds changes to hwmon driver to use the new lock.
 drivers/hwmon/Kconfig
 drivers/hwmon/it87.c


 drivers/hwmon/Kconfig          |    1 +
 drivers/hwmon/it87.c           |   14 ++++++++++++-
 drivers/watchdog/Kconfig       |   12 +++++++++++
 drivers/watchdog/Makefile      |    1 +
 drivers/watchdog/it8712f_wdt.c |   10 ++++----
 drivers/watchdog/it87_lock.c   |   27 +++++++++++++++++++++++++
 drivers/watchdog/it87_wdt.c    |   42 ++++++---------------------------------
 include/linux/it87_lock.h      |   28 ++++++++++++++++++++++++++
 8 files changed, 96 insertions(+), 41 deletions(-)
 create mode 100644 drivers/watchdog/it87_lock.c
 create mode 100644 include/linux/it87_lock.h

Signed-off-by: Nat Gurumoorthy <natg@google.com>
