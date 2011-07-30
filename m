Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1G3UVf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 16:21:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65021 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab1G3UV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 16:21:27 -0400
MIME-Version: 1.0
In-Reply-To: <CANqCtQ+VhmfpNZ8Oh_0MR+bZfAeBuowBsK9TyC5iA4B2oLpXfg@mail.gmail.com>
References: <alpine.LFD.2.02.1107282213000.31246@ionos>
	<CANqCtQ+VhmfpNZ8Oh_0MR+bZfAeBuowBsK9TyC5iA4B2oLpXfg@mail.gmail.com>
Date: Sat, 30 Jul 2011 22:21:25 +0200
X-Google-Sender-Auth: b2plKVHTIl-NqvYtBeOCvi4hKvA
Message-ID: <CANqCtQLjy4Ez9D9yH9gJ_h026ThEWOYeQGrosOrSAMsnvx5HPg@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.0-rt6
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/7/30 Remy Bohmer <linux@bohmer.net>:
>> Please keep on testing and sending patches. Peter Zijlstra kindly
>> volunteered to cover for me. He'll pick up stuff and eventually push
>> out releases when a reasonable number of sane patches hits his inbox.
>
> I got rt5 booting yesterday on a ARM core (Atmel AT91):
> * LCD driver broken, booting stops during initialising driver (seems
> to be broken in mainstream too)

Still need to debug this one.

> * Strange issue with finding files in a directory. (currently checking
> if it is RT-patch related.)

It seems that the busybox (v1.17.1) mount for loopback devices is
broken on linux-3.0. The util-linux-ng mount still works.
This is NOT a RT-patch issue.

> * Furthermore, the board feels slow... Can be perception only, need to
> check it out...

This seems to be caused by the fact that the IRQ-thread of the
ttyS0/dbgu usart is running in thread context now.
Previously it was shared with the timer interrupt and as such running
in hard-irq context. It therefor felt faster.
The debug usart now frequently misses some characters, since it only
has a 1 byte 'fifo' and the interrupt handler thread cannot keep up
with the 115200 baudrate on this board. (at91sam9261ek). The
atmel-serial driver needs an update to use threaded interrupts, and
read the fifo in hard-irq context. Maybe I pick this one up as well.

> * The patch (http://www.spinics.net/lists/arm-kernel/msg45022.html)
> that solved the problem at https://lkml.org/lkml/2007/11/26/73 is no
> longer part of the RT-patch. I Need to test if it is still needed...

Not tested yet.

Furthermore, I built a patch to add a sched_clock implementation for
the TC-based clocksource driver since the default jiffies based
sched_clock stopped running for some reason during boot. (jiffies do
not seem to be properly updated)
This patch conflicts with the RT-patch since the RT-patch touches the
same files. Should it go to mainline directly, or go via the RT-tree
first? (I will post the patch tomorrow)

Kind regards,

Remy
