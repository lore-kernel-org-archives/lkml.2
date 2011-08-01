Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1HASI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 14:08:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46204 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1HASIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 14:08:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110801092806.GD15578@n2100.arm.linux.org.uk>
References: <1312124593-6088-1-git-send-email-linux@bohmer.net>
	<20110731150707.GA2975@n2100.arm.linux.org.uk>
	<CANqCtQJwUsLXfA408GzAr0rQtc2DRjtKqP8-m2UBUGEy-YP5dg@mail.gmail.com>
	<20110801092806.GD15578@n2100.arm.linux.org.uk>
Date: Mon, 1 Aug 2011 20:08:19 +0200
X-Google-Sender-Auth: UZ6QElOdF9XrwXRw4Bof8CjcDAA
Message-ID: <CANqCtQK=H_B04A7knZSiuE5RLogTgMKxwtMK1HSqSgKA_U2J7A@mail.gmail.com>
Subject: Re: [PATCH] Add sched_clock to AT91 TCB clocksource driver
From: Remy Bohmer <linux@bohmer.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Remy Bohmer <l.pinguin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> You're forgetting that jiffies doesn't jump about.  A late initializing
> sched_clock could jump.

Agreed. Currently the jiffies based clock does not move at all, thus
it surely does not jump... ;-)

>> Anyway, do you have a better suggestion how to fix this? The tcb
>> clocksource is loaded during a arch_initcall(), perhaps we need
>> something before that point.
>> I do not see an easy way to integrate it in MACHINE_START(.timer).
>> Would 'late_time_init' be a better solution?
>
> late_time_init() is not that much better as that still happens after
> sched_init() has been called.  sched_init() initializes various
> structures which involves reading sched_clock().

But late_time_init does it before the sched_clock is declared stable.
Until that point sched_clock will always return zero, as such we can
IMHO safely assume that the scheduler is designed such that it can
handle fixed zero timestamps for a while. The new sched_clock also
nicely starts counting from zero once enabled, and does not make a
jump start.

> Why can't it initialize itself at the standard point during the boot
> sequence, which is time_init() - which in turn is as you say the
> .timer callback?

In that case it has to replace the PIT based clocksource completely.
Since the TCB based clocksource and event device are
optional/configurable for this architecture and it is implemented as a
clocksource driver instead of part of the BSP, it would result in a
lot of ifdefs throughout that code.
The arch_initcall() has to be removed and replaced by something else...
I will try to work out a different solution, and post an update, see
how that looks like...

Kind regards,

Remy
