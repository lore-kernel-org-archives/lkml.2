Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423091Ab2JaPAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:00:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47148 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423051Ab2JaPAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:00:38 -0400
MIME-Version: 1.0
In-Reply-To: <1351457210-25222-2-git-send-email-stigge@antcom.de>
References: <1351457210-25222-1-git-send-email-stigge@antcom.de> <1351457210-25222-2-git-send-email-stigge@antcom.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 31 Oct 2012 16:00:17 +0100
X-Google-Sender-Auth: n6qehNE41E4Kk0vPWnQo6DUPj-s
Message-ID: <CACxGe6vgryMPygc8SKFLKqP8Wq=pcGiJe_dPCiDC-evzf32UMA@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/5 v6] gpio: Add a block GPIO API to gpiolib
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 9:46 PM, Roland Stigge <stigge@antcom.de> wrote:
> The recurring task of providing simultaneous access to GPIO lines (especially
> for bit banging protocols) needs an appropriate API.
>
> This patch adds a kernel internal "Block GPIO" API that enables simultaneous
> access to several GPIOs. This is done by abstracting GPIOs to an n-bit word:
> Once requested, it provides access to a group of GPIOs which can range over
> multiple GPIO chips.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Hey Roland,

Linus and I just sat down and talked about your changes. I think I
understand what you need to do, but I've got concerns about the
approach. I'm already not a big fan of the sysfs gpio interface
design*, so you can understand that I'm not keen to extend the
interface further. At the very least, I want to be really careful
about the form that the extension takes.

First off, thank you for writing good documentation. That makes it a
lot easier to understand how the series is intended to be used, and I
really appreciate it.

For the API, I don't think it is a good idea at all to try and
abstract away gpios on multiple controllers. I understand that it
makes life a lot easier for userspace to abstract those details away,
but the problem is that it hides very important information about how
the system is actually constructed that is important to actually get
things to work. For example, say you have a gpio-connected device with
the constraint that GPIOA must change either before or at the same
time as GPIOB, but never after. If those GPIOs are on separate
controllers, then the order is completely undefined, and the user has
no way to control that other than to fall back to manipulating GPIOs
one at a time again (and losing all the performance benefits). Either
controller affinity needs to be explicit in the API, or the API needs
to be constraint oriented (ie. a stream of commands and individual
commands can be coalesced if they meet the constraints**). Also, the
API requires remapping the GPIO numbers which forces the code to be a
lot more complex than it needs to be.

I would rather see new attribute(s) added to the gpiochip's directory
to allow modifying all the pins on a given controller. It's
considerably less complex, and I'm a lot happier about extending the
sysfs ABI in that way than committing to the remapping block approach.

Second, the API appears a little naive in the way it approaches
changing values. It makes the assumption that every gpio in the block
will be written at the same time, which doesn't take into account that
even within a block it is highly likely that only a subset of the
gpios need to be manipulated. A lot of GPIO controllers implement
separate 'set' and 'clear' registers for exactly this reason. The API
needs to allow users to choose a subset for manipulation. The ABI
needs to either have separate 'set' and 'clear' operations, or
operations need to have both mask and value arguments. Similarly, how
do users manipulate pin direction with this ABI?

*The big problem with the sysfs interface is that each operation is
performed on a different file descriptor. While it is convenient for
manipulating gpios from shell scripts, it doesn't provide any good
mechanism to restrict gpios to a specific process or keep track of
which gpios are "opened' by userspace. Ultimately what I think what is
really needed is a proper character device interface that can keep
track of multiple users and who can flip which bits, but that is
slightly out of scope for this discussion.
** Actually, the command stream model is a very interesting idea. It
is worth exploring. It would be a more natural ABI than the multiple
files-and-directories model currently used. It would also eliminate
the problems I have with the sysfs abi while still being usable from
shell script.  :-)

g.
