Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab1HST0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:26:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60744 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab1HST0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:26:11 -0400
MIME-Version: 1.0
In-Reply-To: <4E4E2B2A.40100@odi.ch>
References: <4E4E2B2A.40100@odi.ch>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Fri, 19 Aug 2011 15:25:30 -0400
Message-ID: <CAF_S4t_5qfx1H+nm+fvYd24k4ezF__JDFLvg6gv_so8SeVqKvA@mail.gmail.com>
Subject: Re: contention on long-held spinlock
To: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>,
        linux-driver@qlogic.com, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/19 Ortwin Glück <odi@odi.ch>:
> Hi,
>
> I have observed a bad behaviour that is likely caused by spinlocks in the
> qla2xxx driver. This is a QLogic Fibre Channel storage driver.

Please CC the relevant maintainers when reporting driver bugs (I'm
adding them in this reply); it will help make sure the right people
notice. Maintainer addresses can be found in the MAINTAINERS file at
the root of the linux source tree.

What version of the kernel are you using? It would also help to
provide dmesg output from when the problem is occurring, if anything
out of the ordinary can be found there (if you've already rebooted,
check /var/log/kern.log - or wherever your distribution puts the
kernel log)

> Somehow the attached SAN had a problem and became unresponsive. Many
> processes queued up waiting to write to the device. The processes were doing
> nothing but wait, but system load increased to insane values (40 and above
> on a 4 core machine). The system was very sluggish and unresponsive, making
> it very hard and slow to see what actually was the problem.
>
> I didn't run an indepth analysis, but this is my guess: I see that qla2xxx
> uses spinlocks to guard the HW against concurrent access. So if the HW
> becomes unresponsive all waiters would busy spin and burn resources, right?
> Those spinlocks are superfast as long as the HW responds well, but become a
> CPU burner once the HW becomes slow.
>
> I wonder if spinlocks could be made aware of such a situation and relax.
> Something like if spinning for more than 1000 times, perform a simple
> backoff and sleep. A spinlock should never spin busy for several seconds,
> right?

That's what mutexes are for. Note, however, that interrupt handlers
cannot use mutexes as they cannot sleep, nor can they wait for lock
holders which may themselves sleep.

Also note that holding spinlocks for a long time is more likely to
result in lockups than a slowdown - a CPU attempting to grab a
spinlock disables migration and preemption, so on your four CPU
system, four processes waiting on spinlocks is enough to completely
lock up the system (unless you're using the real-time branch's kernel,
which converts most spinlocks to mutexes).
