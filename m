Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1KBLUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 07:20:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:60277 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab1KBLUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 07:20:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,443,1315206000"; 
   d="scan'208";a="85198656"
Date: Wed, 2 Nov 2011 11:31:04 +0000
From: Alan Cox <alan@linux.intel.com>
To: Andrew Worsley <amworsley@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
        Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix Corruption issue in USB ftdi driver
 drivers/usb/serial/ftdi_sio.c
Message-ID: <20111102113104.3a641f7a@bob.linux.org.uk>
In-Reply-To: <CA+Y=x3k+jxN7LEk64mHkFQkkQhWa_KX7Uh+Uwuk0u87c+FiG_Q@mail.gmail.com>
References: <CA+Y=x3=xEa6XVspsodhbKOArtZ7VMYSMLhpF4WZ1sFNfaJ_E9g@mail.gmail.com>
	<20111101113607.15b254c6@bob.linux.org.uk>
	<CA+Y=x3k+jxN7LEk64mHkFQkkQhWa_KX7Uh+Uwuk0u87c+FiG_Q@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +       /* compare old_termios and tty->termios */
> >> +    if (old_termios->c_cflag == termios->c_cflag)
> >> +        goto no_c_cflag_changes;
> >
> > You can't do it this way because the speed data is not entirely
> > within c_cflag. Check c_ispeed and c_ospeed match and for the
> > parity if you want to skip that check if the parity bits change
> > specifically.
> >
> This is getting into magic flags I don't understand. There are so few
> bits in c_cflag not related to speed and data/parity I am hesitant  to
> write a complex check I might well get wrong. But flow control appears
> to be switched off / on frequently during data flow,

It shouldn't be unless the apps you are running are doing odd things.
I'd not expect parity to keep changing certainly. What may be occuring
is that some of these devices only handle RTS/CTS flow and force the
flag on, indicating it back to the app. If the app ignores that then it
may end up trying to clear it several times.

> +    if (old_termios->c_cflag == termios->c_cflag
> +      && old_termios->c_ispeed == termios->c_ispeed
> +      && old_termios->c_ospeed == termios->c_ospeed
> +      )
> +        goto no_c_cflag_changes;

That is safe enough

> +
>         /* NOTE These routines can get interrupted by
>            ftdi_sio_read_bulk_callback  - need to examine what this
> means - don't see any problems yet */
> 
> +    if ((old_termios->c_cflag & (CSIZE|PARODD|CSTOPB|PARODD)) ==
> +        (termios->c_cflag & (CSIZE|PARODD|CSTOPB|PARODD)))

I think you need

CSIZE (for CS7/8 switch)
PARODD (parity odd/even)
CMSPAR (parity mark/space v odd/even)
CSTOPB (stop bits)

while you have PARODD twice.

Otherwise this looks correct.

Alan

