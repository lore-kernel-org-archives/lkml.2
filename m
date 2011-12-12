Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1LLVDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:03:14 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:43741 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1LLVDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:03:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com>
References: <20111210132220.083204833@linutronix.de>
	<alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
	<alpine.LFD.2.02.1112102144370.3020@ionos>
	<alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
	<20111211103047.GA19299@elte.hu>
	<alpine.LFD.2.02.1112111459270.3020@ionos>
	<20111211155347.GA1297@elte.hu>
	<CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com>
	<20111212172059.GC23870@elte.hu>
	<CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com>
Date: Mon, 12 Dec 2011 21:03:09 +0000
Message-ID: <CAAMvbhGP-=7jhZsBLMjSPRQnfemBYYzoaQP769_Fe5a8GrALwQ@mail.gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 December 2011 18:40, Pekka Enberg <penberg@kernel.org> wrote:
> -#define TIMER_INTERVAL_NS 1000000      /* 1 msec */
> +#define TIMER_INTERVAL_NS 10000000     /* 10 msec */
>
> serial console output slows down by the same 10x factor:
>
> real    0m24.631s
> user    0m0.007s
> sys     0m0.025s
>
> Lowering the interval too 100 usec speeds things up but unfortunately
> chokes the serial layer rather quickly:
>
>    8 root      RT   [    6.759222] serial8250: too much work for irq4
> 0     0    0    0 S  0.0  0.0   0:00.00 migration/1
>    9 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kworker/1:0
>   10 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ksoftirqd/1
>   11 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kworker/0:1
>   12 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/1
>   13 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/2
>   14 root      20   0     0    0    0 S  0[    6.759222] serial8250:
> too much work for irq4
> .0  0.0   0:00.00 kworker/2:0
>   15 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ksoftirqd/2
>
> So i'm pretty sure it's some bug in hw/serial.c that's limiting
> character output by interrupts.
>
Surely the system should be limiting the character output.
If the baud rate is set to 9600, the simulation of the serial port
should be slow.
If the baud rate is set to 115200, the simulation of the serial port
should be faster.
On real hardware, IO ports (outb/inb) are much slower than PCI memory mapped IO.
I am not sure if perceived slowness of kvm is by design or by accident though.

Now, if we want the guest serial console port to actually be fast, we
should let it be set to a baud of 921000 bps.
You could then use the nagle algorithm to improve its performance when
working in a kvm guest.

I have an application where when I set the guest serial port to 9600,
I want it to be slow, and be as close to real 9600 baud as possible.
