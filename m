Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1LMHDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 02:03:55 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43215 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134Ab1LMHDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 02:03:54 -0500
Date: Tue, 13 Dec 2011 09:03:32 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
In-Reply-To: <alpine.LFD.2.02.1112130056370.3020@ionos>
Message-ID: <alpine.LFD.2.02.1112130859530.2138@tux.localdomain>
References: <20111210132220.083204833@linutronix.de> <alpine.LFD.2.02.1112101715500.10936@tux.localdomain> <alpine.LFD.2.02.1112102144370.3020@ionos> <alpine.LFD.2.02.1112111014500.1663@tux.localdomain> <20111211103047.GA19299@elte.hu>
 <alpine.LFD.2.02.1112111459270.3020@ionos> <20111211155347.GA1297@elte.hu> <CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com> <20111212172059.GC23870@elte.hu> <CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com>
 <20111212192135.GA18876@elte.hu> <alpine.LFD.2.02.1112130056370.3020@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg <penberg@kernel.org> wrote:
>>> So i'm pretty sure it's some bug in hw/serial.c that's
>>> limiting character output by interrupts.

On Tue, 13 Dec 2011, Thomas Gleixner wrote:
> No, that's not a bug. The current emulation has no fifo and it writes
> every single character to the terminal. Go figure. The timer
> limitation is due to the missing fifo and other details, which would
> drive the serial driver into the "too much work for irq 4" case.
>
> The approach I took was to keep the emulated device as close to the
> real HW for obvious reasons. You simply cannot ignore the way how a HW
> device works and how the corresponding kernel driver expects it to
> work.

No disagreement here.

On Mon, 12 Dec 2011, Ingo Molnar wrote:
>> Serial port control flow somehow being bound by timer frequency
>> [which is not really a necessity: both the host and the guest
>> could stream on full speed] was too my observation early on.
>
> That simply does not work with the way the serial driver for the 8250
> is written.
>
> If you emulate hardware then don't expect that the shortcomings of the
> real hardware and the clusterf*ck in the corresponding device drivers
> go magically away.
>
> If you want high performance virtualization then use virtual drivers
> and stop whining about a 30 years old legacy device and its warts.

If you compare Ingo's numbers to mine, there's still some slowdown which 
cannot be explained by legacy device warts.

Btw, I was able to double the speed of serial console with this simple 
patch:

diff --git a/tools/kvm/hw/serial.c b/tools/kvm/hw/serial.c
index c0f6970..1a8eaaa 100644
--- a/tools/kvm/hw/serial.c
+++ b/tools/kvm/hw/serial.c
@@ -232,7 +232,7 @@ static bool serial8250_out(struct ioport *ioport, struct kvm *kvm, u16 port, voi
  				term_putc(CONSOLE_8250, addr, size, dev->id);
  			/* else FIXME: Inject data into rcv path for LOOP */

-			if (++dev->txcnt == 16)
+			if (++dev->txcnt == 32)
  				dev->lsr &= ~(UART_LSR_TEMT | UART_LSR_THRE);
  			break;
  		} else {

I assume '16' here is the 16550A FIFO size? Is there any reason we can't 
cheat and use a deeper FIFO internally?

 			Pekka
