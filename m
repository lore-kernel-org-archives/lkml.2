Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab1KCFGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 01:06:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49103 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1KCFGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 01:06:32 -0400
MIME-Version: 1.0
In-Reply-To: <20111102113104.3a641f7a@bob.linux.org.uk>
References: <CA+Y=x3=xEa6XVspsodhbKOArtZ7VMYSMLhpF4WZ1sFNfaJ_E9g@mail.gmail.com>
	<20111101113607.15b254c6@bob.linux.org.uk>
	<CA+Y=x3k+jxN7LEk64mHkFQkkQhWa_KX7Uh+Uwuk0u87c+FiG_Q@mail.gmail.com>
	<20111102113104.3a641f7a@bob.linux.org.uk>
Date: Thu, 3 Nov 2011 16:06:31 +1100
Message-ID: <CA+Y=x3=iPBW4UcWbsD2VX3nfbxwMBCwAYS4176iseZ-Niy+oKw@mail.gmail.com>
Subject: Re: [PATCH] Fix Corruption issue in USB ftdi driver drivers/usb/serial/ftdi_sio.c
From: Andrew Worsley <amworsley@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
        Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid unnecessary Control URBs that reset the data/parity or baud rate
to the currently set settings which can cause the FTDI chip to glitch
it's serial output and cause a corruption of a character it is
currently outputting.

Signed-off-by: amworsley@gmail.com

---

....
> It shouldn't be unless the apps you are running are doing odd things.
> I'd not expect parity to keep changing certainly. What may be occuring
> is that some of these devices only handle RTS/CTS flow and force the
> flag on, indicating it back to the app. If the app ignores that then it
> may end up trying to clear it several times.

Okay - Thanks I will try stracing the process and see if it is issuing
all the requests. I thought
it might be the line discipline trying to flow control the input. I've
lost my box for the moment so that
will be tomorrow perhaps.

....

>> +
>>         /* NOTE These routines can get interrupted by
>>            ftdi_sio_read_bulk_callback  - need to examine what this
>> means - don't see any problems yet */
>>
>> +    if ((old_termios->c_cflag & (CSIZE|PARODD|CSTOPB|PARODD)) ==
>> +        (termios->c_cflag & (CSIZE|PARODD|CSTOPB|PARODD)))
>
> I think you need
>
> CSIZE (for CS7/8 switch)
> PARODD (parity odd/even)
> CMSPAR (parity mark/space v odd/even)
> CSTOPB (stop bits)
>
> while you have PARODD twice.
>
> Otherwise this looks correct.


  Woops - yep that was wrong. I attach a new patch - with CMSPAR and
PARENB which I assume is also parity related.

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index bda9e5b..89dbf8a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2105,13 +2105,19 @@ static void ftdi_set_termios(struct tty_struct *tty,
        cflag = termios->c_cflag;

        /* compare old_termios and tty->termios */
-    if (old_termios->c_cflag == termios->c_cflag)
+    if (old_termios->c_cflag == termios->c_cflag
+      && old_termios->c_ispeed == termios->c_ispeed
+      && old_termios->c_ospeed == termios->c_ospeed
+      )
         goto no_c_cflag_changes;

        /* NOTE These routines can get interrupted by
           ftdi_sio_read_bulk_callback  - need to examine what this means -
           don't see any problems yet */

+    if ((old_termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)) ==
+        (termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)))
+        goto no_data_parity_stop_changes;
        /* Set number of data bits, parity, stop bits */

        urb_value = 0;
@@ -2151,6 +2157,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
                        "databits/stopbits/parity\n", __func__);
        }

+no_data_parity_stop_changes:
        /* Now do the baudrate */
        if ((cflag & CBAUD) == B0) {
                /* Disable flow control */
