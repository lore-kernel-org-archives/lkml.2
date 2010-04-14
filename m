Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab0DNImr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 04:42:47 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:32775 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0DNImq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 04:42:46 -0400
Message-ID: <4BC57FFE.5050703@lumino.de>
Date: Wed, 14 Apr 2010 10:42:38 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
       nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de> <4BBDA1CB.3070204@davidnewall.com> <4BBDA742.9010507@lumino.de> <20100412125402.GA22773@ucw.cz>
In-Reply-To: <20100412125402.GA22773@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 02:54 PM, Pavel Machek wrote:
>
> You could create unpriviledged 'disable interrupts for 10
> instructions' and 'test if interrupts are still disabled'
> instructions, and base your mutex implementation on that.
>   
That would be great, but AFAIK, it's not decently possible with NIOS.

The interrupt enable flag of the CPU can't be accessed by custom
instructions. The CPU has up to 32 interrupt lines that it exposes to
the custom FPGA "hardware". of course it _would_ be possible to gate all
of them and manage this additional flag by a custom instruction. We
would need to investigate how big the min/max delay between setting the
interrupt and the CPU acknowledging it is. According to this, the count
of NOPs between the "custom interrupt disable" and the load of the
atomic value needs to be chosen and how many clock cycles the interrupt
lock needs to be held.

Unfortunately, AFAIK, the CPU-external FPGA "hardware" (that implements
the custom instructions) can't see the shifting of the CPU's instruction
queue. So the lock duration only can be counted in clock cycles, but not
in instructions. The CPU might need to wait for a very large count of
clocks for accessing (instructions or data) words e.g. in external
dynamic RAM.

That is why (when considering how to implement the atomic user land
macros necessary for FUTEX) I did consider your idea to reduce the
average overhead imposed by the necessity of having the Kernel ISR code
finish a would be atomic operation. But as the delay is very uncertain,
I feel that the ISR-trick can't be dropped completely.

It might be a good idea to ask Altera to implement such a
userland-enabled instruction (disable interrupt for the next n
instructions). That would be really easy within the NIOS CPU iP-Core,
but with custom instructions we are out of luck :(.

Moreover, of course any interrupt logic only helps with the nos-SMP-case.
> But you'll have to stop calling it futex at that point...
>   
FUTEX (e.g. the userland part of same) is just one paradigm (and IMHO
the most important one, as pthread_mutex_..() uses it for fast POSIX
compatible thread synchronization) that requires atomic user land
operations. So any implementation of the appropriate atomic userland
operations can be used to do FUTEX on top of it.
> Or you could just optimize syscalls to be really fast...
I trust that the Kernel developers already did that :).

My test showed that with a x86 PC, the system calls really are
astonishingly fast. But same supposedly features sophisticated hardware
to support syscalls. Nonetheless using Futex did provide a considerable
speed gain, even with SMP hardware where atomic operations are
expensive, due to cache synchronization done by hardware.

But the little old NIOS hardware of course is done using as few gates as
possible ;)

Thanks !
-Michael
