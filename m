Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1LLSkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:40:13 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51582 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1LLSkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:40:11 -0500
MIME-Version: 1.0
In-Reply-To: <20111212172059.GC23870@elte.hu>
References: <20111210132220.083204833@linutronix.de>
	<alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
	<alpine.LFD.2.02.1112102144370.3020@ionos>
	<alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
	<20111211103047.GA19299@elte.hu>
	<alpine.LFD.2.02.1112111459270.3020@ionos>
	<20111211155347.GA1297@elte.hu>
	<CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com>
	<20111212172059.GC23870@elte.hu>
Date: Mon, 12 Dec 2011 20:40:10 +0200
X-Google-Sender-Auth: Ov6nPxE7kIuHPSKP7nraZzn90tE
Message-ID: <CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 7:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> I'm seeing 1.5 usecs per character for this little benchmark:
>
> Interesting - what do you see with the top -b measurement i
> posted - can you see similar slowdowns?

ssh-4.2# time top -d 0.01 -n 10 -b

[snip]

real	0m2.935
user	0m0.006s
sys	0m0.049s

That's 9.7 usecs per character which is roughly 6x slowdown.

It seems to be related to interrupt handling because if I bump up
TIMER_INTEVAL_NS to 10 msec:

--- a/tools/kvm/kvm.c
+++ b/tools/kvm/kvm.c
@@ -412,7 +412,7 @@ found_kernel:
        return ret;
 }

-#define TIMER_INTERVAL_NS 1000000      /* 1 msec */
+#define TIMER_INTERVAL_NS 10000000     /* 10 msec */

serial console output slows down by the same 10x factor:

real	0m24.631s
user	0m0.007s
sys	0m0.025s

Lowering the interval too 100 usec speeds things up but unfortunately
chokes the serial layer rather quickly:

    8 root      RT   [    6.759222] serial8250: too much work for irq4
0     0    0    0 S  0.0  0.0   0:00.00 migration/1
    9 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kworker/1:0
   10 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ksoftirqd/1
   11 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kworker/0:1
   12 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/1
   13 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/2
   14 root      20   0     0    0    0 S  0[    6.759222] serial8250:
too much work for irq4
.0  0.0   0:00.00 kworker/2:0
   15 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ksoftirqd/2

So i'm pretty sure it's some bug in hw/serial.c that's limiting
character output by interrupts.

                                Pekka
