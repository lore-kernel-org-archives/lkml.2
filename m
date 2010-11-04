Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab0KDT0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:26:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53629 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab0KDT0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=RPbZ5+k3CjGyvtjgFqxO+glu0yAf4iwY/C/OKqOhBdvHlfKXr03Fn8e41+wHG9qiu1
         96gymTr0va73LgYOFZ3QPSzHAH/ciOZr4G+hkM7NSEodVl5yXwj5R4GyEa+h6Puk/gnu
         Ujmy71zsnRyiJXD0voMNPatPdYNfdY+mjpNUk=
Date: Thu, 4 Nov 2010 20:26:34 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC 0/8] Dynamic clock devices
Message-ID: <cover.1288897198.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, here is a work in progress, not well tested, but I would like to
get some feedback whether the direction is good or not.

The first patch introduces clock devices which can appear and
disappear like usb devices (and, I suppose, hot plug PCI but I am not
too sure that what is offered here would really work in that case).
The subsequent patches convert the clock_ and timer_ system calls, one
by one.

The clock_ syscalls are moved into a new file and they call the older
posix functions when needed. The timer_ syscalls stay where they are,
in posix-timers.c, since I did not want to change the fairly involved
timer management code. Eventually, we could remove the posix clock_*
functions for the CLOCK_* ids from posix-timers.c and rework them
using the new dynamic clock api. That would leave just the timer code
in posix-timers.c, as the file name suggests.

I dropped the idea of having user space open a sysfs file in order to
get a reference to a clock, since there are no open/release hooks
within sysfs for drivers (coincidentally, there has been some talk
about this on the lkml recently, but previously Greg KH object to
abusing sysfs as a "clockfs").

Instead, since many clocks (hpet, rtc, ptp, ...) will want to offer a
custom chardev for special advanced functionality, the dynamic clock
layer registers a cdev for the driver, placing its own hooks into the
open/release methods. The driver thus needs to access its private data
via a standard access method (not just by using fp->private_data). If
a driver doesn't want any chardev functions, that is okay, too.

Well, please take a look and let me know what you think.

Thanks,

Richard


Richard Cochran (8):
  Introduce dynamic clock devices
  clock device: convert clock_gettime
  clock device: convert clock_getres
  clock device: convert clock_settime
  clock device: convert timer_create
  clock device: convert timer_delete
  clock device: convert timer_gettime
  clock device: convert timer_settime

 include/linux/clockdevice.h  |  117 +++++++++++++++
 include/linux/posix-timers.h |   23 +++-
 include/linux/time.h         |    2 +
 kernel/posix-timers.c        |   51 +++++--
 kernel/time/Makefile         |    3 +-
 kernel/time/clockdevice.c    |  336 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 518 insertions(+), 14 deletions(-)
 create mode 100644 include/linux/clockdevice.h
 create mode 100644 kernel/time/clockdevice.c

