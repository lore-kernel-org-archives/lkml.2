Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1KBFVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 01:21:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36192 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1KBFVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 01:21:22 -0400
MIME-Version: 1.0
In-Reply-To: <20111101113607.15b254c6@bob.linux.org.uk>
References: <CA+Y=x3=xEa6XVspsodhbKOArtZ7VMYSMLhpF4WZ1sFNfaJ_E9g@mail.gmail.com>
	<20111101113607.15b254c6@bob.linux.org.uk>
Date: Wed, 2 Nov 2011 16:21:21 +1100
Message-ID: <CA+Y=x3k+jxN7LEk64mHkFQkkQhWa_KX7Uh+Uwuk0u87c+FiG_Q@mail.gmail.com>
Subject: Re: [PATCH] Fix Corruption issue in USB ftdi driver drivers/usb/serial/ftdi_sio.c
From: Andrew Worsley <amworsley@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
        Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid unnecessary Control URBs that reset the data/parity or baud rate
to the currently set settings which can cause the FTDI chip to glitch
it's serial output and cause a corruption of a character it is
currently outputting.

Signed-off-by: amworsley@gmail.com

---

On 1 November 2011 22:36, Alan Cox <alan@linux.intel.com> wrote:
>> I don't know why it repeatedly tries to set this all the time - it
>> would appear to be quite a lot of work so perhaps there is something
>> else that could be cleaned up. This was the simplest safe change that
>> fixed my problem. It appears this code hasn't changed very much since
>> the first history information in git that I could see - so perhaps
>> nobody else is really noticing this issue for some reason?
>
> It could be a problem specific to some firmware or revision. We've had
> a similar quirk with a different USB adapter. The actual calls to keep
> changing it are coming from your application however.

"My" application is getty via inittab e.g.
T0:23:respawn:/sbin/getty -L ttyUSB0 115200 vt100

  Something I would expect to be fairly common. Actually after login
it is "bash" which is running presumably the getty set the tty
parameters like speed and flow control.

>
>>         cflag = termios->c_cflag;
>>
>> -       /* FIXME -For this cut I don't care if the line is really
>> changing or
>> -          not  - so just do the change regardless  - should be able
>> to
>> -          compare old_termios and tty->termios */
>> +       /* compare old_termios and tty->termios */
>> +    if (old_termios->c_cflag == termios->c_cflag)
>> +        goto no_c_cflag_changes;
>
> You can't do it this way because the speed data is not entirely within
> c_cflag. Check c_ispeed and c_ospeed match and for the parity if you want to skip
> that check if the parity bits change specifically.
>
This is getting into magic flags I don't understand. There are so few
bits in c_cflag not related to speed and data/parity I am hesitant  to
write a complex check I might well get wrong. But flow control appears
to be switched off / on frequently during data flow,
my guess as part of flow controlling the input and I suggest a speed
change is likely to be a once per login or line usage occurrence.

Here's a more sophisticated version of this which attempts to do this.
It works on my 2.6.32 kernel and compiles the latest kernel.

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 8fe034d..66a2d09 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2104,13 +2104,20 @@ static void ftdi_set_termios(struct tty_struct *tty,

        cflag = termios->c_cflag;

-       /* FIXME -For this cut I don't care if the line is really changing or
-          not  - so just do the change regardless  - should be able to
-          compare old_termios and tty->termios */
+       /* compare old_termios and tty->termios */
+    if (old_termios->c_cflag == termios->c_cflag
+      && old_termios->c_ispeed == termios->c_ispeed
+      && old_termios->c_ospeed == termios->c_ospeed
+      )
+        goto no_c_cflag_changes;
+
        /* NOTE These routines can get interrupted by
           ftdi_sio_read_bulk_callback  - need to examine what this means -
           don't see any problems yet */

+    if ((old_termios->c_cflag & (CSIZE|PARODD|CSTOPB|PARODD)) ==
+        (termios->c_cflag & (CSIZE|PARODD|CSTOPB|PARODD)))
+        goto no_data_parity_stop_changes;
        /* Set number of data bits, parity, stop bits */

        urb_value = 0;
@@ -2150,6 +2157,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
                        "databits/stopbits/parity\n", __func__);
        }

+no_data_parity_stop_changes:
        /* Now do the baudrate */
        if ((cflag & CBAUD) == B0) {
                /* Disable flow control */
@@ -2176,6 +2184,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
                        set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
        }

+no_c_cflag_changes:
        /* Set flow control */
        /* Note device also supports DTR/CD (ugh) and Xon/Xoff in hardware */
        if (cflag & CRTSCTS) {
