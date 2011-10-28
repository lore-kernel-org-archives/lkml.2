Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1J1G5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 02:57:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54352 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab1J1G5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 02:57:44 -0400
MIME-Version: 1.0
Date: Fri, 28 Oct 2011 17:57:26 +1100
Message-ID: <CA+Y=x3=xEa6XVspsodhbKOArtZ7VMYSMLhpF4WZ1sFNfaJ_E9g@mail.gmail.com>
Subject: [PATCH] Fix Corruption issue in USB ftdi driver drivers/usb/serial/ftdi_sio.c
From: Andrew Worsley <amworsley@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
        Alan Cox <alan@linux.intel.com>, Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftdi_set_termios() is always setting the baud rate and data bits and
parity on every call. When called while characters are being
transmitted can cause the FTDI chip to corrupt the serial port bit
stream by stalling the output half a bit during the output of a
character.
Simple fix by skipping this setting if the baud rate/data bits/parity
are unchanged.

Signed-off-by: Andrew Worsley <amworsley@gmail.com>
----

This bug was observed on 2.6.32 kernel (this patch is ported to latest
kernel for ease of review).
Using a FTDI USB serial chip at 38400 repeatedly generating output by
running a simple command such as "uname -a" or "echo Linux"  gives
occasional corruption on the output

...
> echo Linux
L�nux

 Andrew:~
> echo Linux
Linux

 Andrew:~
> echo Linux
�inux

 Andrew:~
> echo Linux
Linux

 Andrew:~
>
....

  After tracing the USB URBs sent and looking at the bits coming out
of the serial port it was found that the glitch involves a delay in
the middle of a character of one of the bits by half a bit time
causing incorrect characters to be displayed. i.e. one of the bits is
stretched. I noticed that ftdi_set_termios() was repeatedly called
after line of input and would set the data length (8 bits no parity),
baud rate, and control flow.
It seems this often just hits the chip as it is transmitting the
output and presumably the chip doesn't like having all these
parameters being set while transmitting and causing the glitch. The
following fixed the problem by not doing the FTDI_SIO_SET_DATA	and
FTDI_SIO_SET_BAUD_RATE if they are not required.

I don't know why it repeatedly tries to set this all the time - it
would appear to be quite a lot of work so perhaps there is something
else that could be cleaned up. This was the simplest safe change that
fixed my problem. It appears this code hasn't changed very much since
the first history information in git that I could see - so perhaps
nobody else is really noticing this issue for some reason?

Comments / suggestions appreciated

Thanks

Andrew

To be applied against

commit 396e6e49c58bb23d1814d3c240c736c9f01523c5
Merge: 1897436 6ad390a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Oct 27 08:44:20 2011 +0200

    Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input

    * 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input: (68 commits)
      Input: adp5589-keys - add support for the ADP5585 derivatives
      Input: imx_keypad - add pm suspend and resume support
...

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 8fe034d..bda9e5b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2104,9 +2104,10 @@ static void ftdi_set_termios(struct tty_struct *tty,

        cflag = termios->c_cflag;

-       /* FIXME -For this cut I don't care if the line is really changing or
-          not  - so just do the change regardless  - should be able to
-          compare old_termios and tty->termios */
+       /* compare old_termios and tty->termios */
+    if (old_termios->c_cflag == termios->c_cflag)
+        goto no_c_cflag_changes;
+
        /* NOTE These routines can get interrupted by
           ftdi_sio_read_bulk_callback  - need to examine what this means -
           don't see any problems yet */
@@ -2176,6 +2177,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
                        set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
        }

+no_c_cflag_changes:
        /* Set flow control */
        /* Note device also supports DTR/CD (ugh) and Xon/Xoff in hardware */
        if (cflag & CRTSCTS) {
