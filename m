Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1DEWjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 18:39:18 -0400
Received: from imr4.ericy.com ([198.24.6.8]:59785 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab1DEWjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 18:39:16 -0400
Date: Tue, 5 Apr 2011 15:38:14 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Nat Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH] Make all it87 drivers SMP safe.
Message-ID: <20110405223814.GA21350@ericsson.com>
References: <1302038697-28985-1-git-send-email-natg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1302038697-28985-1-git-send-email-natg@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 05:24:57PM -0400, Nat Gurumoorthy wrote:
> There are 3 different drivers that touch the it87 hardware registers.
> The 3 drivers have been written independently and access the it87 hardware
> registers assuming they are the only driver accessing it. This change
> attempts to serialize access to the hardware by defining a global spinlock
> it87_io_lock in a file it87_lock.c. This lock has to be acquired by each
> of the it87 drivers before it can access the hardware. We have defined
> a new Kconfig option IT87_LOCK. When it is selected it87_lock.c is compiled
> into the kernel thereby making the lock global and accessable to the it87
> drivers which are typically built as loadable modules. All the it87 drivers
> select IT87_LOCK to compile the lock into the kernel.
> The routines accessing the hardware are being called from module init,
> open, ioctl and module exit routines and hence it is sufficient to use
> calls to spin_lock and spin_unlock to acquire and release the locks. For
> the same reasons it87_wdt.c has extensive changes to remove calls to
> spin_lock_irqsave and spin_unlock_irqrestore. The lock is now acquired
> in superio_enter and released in superio_exit. This is now identical
> to the code in drivers/hwmon/it87.c and drivers/watchdog/it8712f_wdt.c.
> Added __acquire and __release annotations wherever needed.
> ---
>  drivers/hwmon/Kconfig          |    1 +
>  drivers/hwmon/it87.c           |   14 ++++++++++++-
>  drivers/watchdog/Kconfig       |   12 +++++++++++
>  drivers/watchdog/Makefile      |    1 +
>  drivers/watchdog/it8712f_wdt.c |   10 ++++----
>  drivers/watchdog/it87_lock.c   |   27 +++++++++++++++++++++++++
>  drivers/watchdog/it87_wdt.c    |   42 ++++++---------------------------------
>  include/linux/it87_lock.h      |   28 ++++++++++++++++++++++++++
>  8 files changed, 94 insertions(+), 41 deletions(-)
>  create mode 100644 drivers/watchdog/it87_lock.c
>  create mode 100644 include/linux/it87_lock.h
> 
> Signed-off-by: Nat Gurumoorthy <natg@google.com>
> 
Seems to me those should be separate patches, one per affected subsystem.

Guenter
