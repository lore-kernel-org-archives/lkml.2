Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab1DEXFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 19:05:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29156 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab1DEXFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 19:05:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VU60tFb+YAIghrULtchmlt99ZOMrUHRd+us/AxI3WfdnXV5cRhxnAciKDYzbfYHQLj
         48eBU06j5h49mCoDG4oA==
MIME-Version: 1.0
In-Reply-To: <20110405223814.GA21350@ericsson.com>
References: <1302038697-28985-1-git-send-email-natg@google.com>
	<20110405223814.GA21350@ericsson.com>
Date: Tue, 5 Apr 2011 16:05:47 -0700
Message-ID: <BANLkTikX5fAkdrZAktQON=8DwuQL+5Ow-w@mail.gmail.com>
Subject: Re: [PATCH] Make all it87 drivers SMP safe.
From: Natarajan Gurumoorthy <natg@google.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,
       This patch patch applies a common fix to all IT87 driver.
Separating it into 2 patches (one for drivers/hwmon and one for
drivers/watchdog) does not seem to be the right thing to do. I think
having all the patches in one file makes it easier to understand the
rationale behind the patch. The it87_io_lock.c and it87_io_lock.h
files are in drivers/watchdog directory and the lock defined in it is
needed by the changes in drivers/hwmon/it87.c

Regards
Nat


On Tue, Apr 5, 2011 at 3:38 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
>
> On Tue, Apr 05, 2011 at 05:24:57PM -0400, Nat Gurumoorthy wrote:
> > There are 3 different drivers that touch the it87 hardware registers.
> > The 3 drivers have been written independently and access the it87 hardware
> > registers assuming they are the only driver accessing it. This change
> > attempts to serialize access to the hardware by defining a global spinlock
> > it87_io_lock in a file it87_lock.c. This lock has to be acquired by each
> > of the it87 drivers before it can access the hardware. We have defined
> > a new Kconfig option IT87_LOCK. When it is selected it87_lock.c is compiled
> > into the kernel thereby making the lock global and accessable to the it87
> > drivers which are typically built as loadable modules. All the it87 drivers
> > select IT87_LOCK to compile the lock into the kernel.
> > The routines accessing the hardware are being called from module init,
> > open, ioctl and module exit routines and hence it is sufficient to use
> > calls to spin_lock and spin_unlock to acquire and release the locks. For
> > the same reasons it87_wdt.c has extensive changes to remove calls to
> > spin_lock_irqsave and spin_unlock_irqrestore. The lock is now acquired
> > in superio_enter and released in superio_exit. This is now identical
> > to the code in drivers/hwmon/it87.c and drivers/watchdog/it8712f_wdt.c.
> > Added __acquire and __release annotations wherever needed.
> > ---
> >  drivers/hwmon/Kconfig          |    1 +
> >  drivers/hwmon/it87.c           |   14 ++++++++++++-
> >  drivers/watchdog/Kconfig       |   12 +++++++++++
> >  drivers/watchdog/Makefile      |    1 +
> >  drivers/watchdog/it8712f_wdt.c |   10 ++++----
> >  drivers/watchdog/it87_lock.c   |   27 +++++++++++++++++++++++++
> >  drivers/watchdog/it87_wdt.c    |   42 ++++++---------------------------------
> >  include/linux/it87_lock.h      |   28 ++++++++++++++++++++++++++
> >  8 files changed, 94 insertions(+), 41 deletions(-)
> >  create mode 100644 drivers/watchdog/it87_lock.c
> >  create mode 100644 include/linux/it87_lock.h
> >
> > Signed-off-by: Nat Gurumoorthy <natg@google.com>
> >
> Seems to me those should be separate patches, one per affected subsystem.
>
> Guenter



--
Regards
Nat Gurumoorthy AB6SJ
