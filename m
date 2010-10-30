Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0J3LQX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 07:16:23 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59561 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616Ab0J3LQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 07:16:20 -0400
Date: Sat, 30 Oct 2010 13:16:18 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: use after free in serport
Message-ID: <20101030111618.GA29915@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a userland tool called inputattach which binds a serial port to
a specific device lets say a touch screen. serport
(CONFIG_SERIO_SERPORT) is the couterpart in the kernel. So the userland
does the following:

- 1. open("/dev/ttySx", O_RDWR | O_NOCTTY | O_NONBLOCK);
- 2. setline()
- 3. ioctl(fd, TIOCSETD, &ldisc); with ldisc = N_MOUSE
  if the ldisc class is not set (yet), it calls serport_ldisc_open()
  which allocates a little bit of memory.
- 4. ioctl(fd, SPIOCSTYPE, &devt) with devt beeing the device the user
  wants to attach
- 5. read(fd, NULL, 0);
  this attaches the device, calls its ->connect function and the program
  stays here for as long as the driver has to remain attached and
  working.
- 6. ioctl(fd, TIOCSETD, &ldisc); with ldisc = 0.
  this calls serport_ldisc_close() and the extra memory is gone.
- 7. close()

Now the program remains in step 5. If the user starts it again then it
behaves a little different:
- step 3 does nothing because the correct ldisc is allready set.
  tty_set_ldisc() discovers that (tty->ldisc->ops->num == ldisc) is true
  (Check the no-op case) so nothing happens.
- in step 5 serport_ldisc_read() discovers that it allready performing a
  read() and returns with -EBUSY.
- step 6 deallocates memory which was allocated by the other process.

Now we have the struct serport freed but the first process is still
using it.

Any idea how to fix it? I've seen that it is possible to manually bind
devices via /sys so maybe we could remove serport. However I'm not sure
if this kind of bug also affects other ldisc classes.

Sebastian
