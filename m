Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab1J1UZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:25:23 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35914 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab1J1UZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:25:22 -0400
MIME-Version: 1.0
In-Reply-To: <20138.35080.947860.881774@elektron.ikp.physik.tu-darmstadt.de>
References: <CA+Y=x3=xEa6XVspsodhbKOArtZ7VMYSMLhpF4WZ1sFNfaJ_E9g@mail.gmail.com>
	<20138.35080.947860.881774@elektron.ikp.physik.tu-darmstadt.de>
Date: Sat, 29 Oct 2011 07:25:21 +1100
Message-ID: <CA+Y=x3msn2uFf+WWE9eU2Su6zDNkbpJUN3w_Vi0671DA3tRsBQ@mail.gmail.com>
Subject: Re: [PATCH] Fix Corruption issue in USB ftdi driver drivers/usb/serial/ftdi_sio.c
From: Andrew Worsley <amworsley@gmail.com>
To: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 October 2011 21:50, Uwe Bonnes
<bon@elektron.ikp.physik.tu-darmstadt.de> wrote:
>>>>>> "Andrew" == Andrew Worsley <amworsley@gmail.com> writes:
>
>    Andrew> ftdi_set_termios() is always setting the baud rate and data bits
>    Andrew> and parity on every call. When called while characters are being
>    Andrew> transmitted can cause the FTDI chip to corrupt the serial port
>    Andrew> bit stream by stalling the output half a bit during the output
>    Andrew> of a character.  Simple fix by skipping this setting if the baud
>    Andrew> rate/data bits/parity are unchanged.
>
>    Andrew> Signed-off-by: Andrew Worsley <amworsley@gmail.com> ----
>
>    Andrew> This bug was observed on 2.6.32 kernel (this patch is ported to
>    Andrew> latest kernel for ease of review).  Using a FTDI USB serial chip
>    Andrew> at 38400 repeatedly generating output by running a simple
>    Andrew> command such as "uname -a" or "echo Linux" gives occasional
>    Andrew> corruption on the output
>
>    Andrew> ...
>    >> echo Linux
>    Andrew> L�3u=nux
>
> Could you please give a more specific receipe to reproduce the bug. Running
> with an adapter with TX/RX shorted at "stty -F /dev/ttyUSB0" 38400", several
>> uname -a /dev/ttyUSB0
> runs gave no artifact in a "seyon -modem /dev/ttyUSB0" console.
>
> Doing
>> uname -a /dev/ttyUSB0
> in one xterm and receiving with
>>cat /dev/ttyUSB0
> in another xterm gives lot of repeated lines in the receiving terminal. But
> I have the same behaviour with /dev/ttyS0 on a real serial port on the
> mainboard.
>
> Otherwise, shouldn't all control transfers to the FTDI be only done with the
> tx buffer in the FTDI empty? I guess the RX buffer is not affected by some
> change. But this is something to be done with great knowledge...
>
Thank you for your testing efforts. In a sense I am not surprised that
an obvious attempt at reproduction doesn't show it as I would have
thought this bug would have been found long ago if it
did. At the moment the best I can do is describe my configuration and
invite requests for details on additional fields that you think
important.

We use the ftdi chip to provide a serial console so the program I am
running on it is
/sbin/getty -L ttyUSB0 38400. I can't give you the exact stty settings
the defaults set up as I
am at home but ixon was set but clearing it didn't help.

My key detective was to configure CONFIG_USB_MON and look at the
requests going to the port.
There were always 3 Control requests after each carriage return which
set speed/baud rate/flow control which seemed kinda crazy.

Perhaps it was something to do with the prompt which had an escape
sequence in it as other people noticed that playing with the delay of
the prompt could clear it. Alternatively the more modern kernel may
not illustrate the same issue - due to some fix that avoids or
minimises  the repeated calls of ftdi_set_termios() ?

I suspect the configuration of the tty line is critical and is
something I don't understand as it appears to be constantly adjusting
the settings but only changing the flow control.I don't have the exact
settings in front of me so from memory it appeared to be cycling
through

IXON, IXOFF and may be one other perhaps IXANY or possibly IUCLC?

If people are interested in any particular details I can send you
them, next week. Including
stack traces, CONFIG_USB_MON traces, screen shot of CRO with corrupted
character + other requested
info

But what I don't understand is the logic that drives
ftdi_set_termios() repeated calls with the flow control changes. I
would appreciate an explanation of this and others might be interested
in this if they are trying to optimise the kernel on serial I/O.

Even if such constant calling is justified (some how XON/XOFF is being
implemented?) I think it should be harmless (and more efficient) not
to skip setting the BAUD rate and other data parameters which is a
significant amount of work. And in my case this extract work appears
to be
glitch the FTDI chip.

Andrew
