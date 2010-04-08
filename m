Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab0DHMLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 08:11:15 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:45032 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0DHMLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 08:11:13 -0400
Message-ID: <4BBDC7D4.6040301@lumino.de>
Date: Thu, 08 Apr 2010 14:11:00 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de> <20100408114542.47b6589a@lxorguk.ukuu.org.uk>
In-Reply-To: <20100408114542.47b6589a@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 12:45 PM, Alan Cox wrote:
> Take a look at sparc 32bit. That only has a single meaningful atomic
> instruction (swap byte with 0xFF). It provides all the kernel atomic_t
> operations via this: arch/sparc/lib/atomic32.c. That bitops are done a
> similar way, which leaves spinlocks and the like.
>   
As the NIOS and similar "load/store" archs by the underlaying hardware
design can't provide any atomic memory read-modify write operations
(without or with bus lock) at all, we need to search for a completely
CPU-hardware independent way of doing atomic stuff both with non-SMP and
SMP designs. The new ARM processors provide "load locked" / "store
conditional" instructions to overcome this with a combination of
hardware and software means.
> More importantly if your true locks in the FPGA are really fast in CPU
> terms then you can think of every other atomic instructions as being
> implemented using
>
> 		lock(cpu_atomic_instruction_lock)
> 		do bits
> 		unlock(cpu_atomic_instruction_lock)
>   
I feel that this does not help.
The important task (for me right now) is providing decent FUTEX
(multiple of those ! ). Here you need to do atomic instructions in user
spaces on the (multiple) FUTEX handling word (so interrupt
disabling/enabling  is not possible). If you try to implement this by
using a _single_ lock (surrounding the would-be atomic instruction
sequence), this IMHO only lifts the problem to another level:

If one thread locks the "cpu_atomic_instruction_lock" and now the Kernel
does a task switch and now a second thread tries to lock it as well,
same would need to do a kernel call to do the waiting. So the
"cpu_atomic_instruction_lock" is nothing but a FUTEX itself and asks for
the same complexity the FUTEX handling needs: (A) it needs an SMP-safe
user space atomic read-modify-write <here of course only a single one
instead of multiple> and (B) it needs the Kernel-infrastructure to
handle this (see the multiple articles available on Futex being nasty ;)
. The "cpu_atomic_instruction_lock" Futex only provides for atomic
operations and thus the normal  (here: second level) Futex needs to stay
in place, as well.

I have no idea how the Kernel infrastructure for two-level Futex could
be implemented.

> So I don't actually think you need any kernel core changes to get going,
> and given the kernel dynamically allocates a lot of locks I suspect
> trying to dynamically manage atomic ram allocations is going to cost more
> than executing a few instructions here and there under a single very fast
> hardware assisted lock.
>   

I suppose the current NIOS _Kernel_ code implements atomic operations by
disabling/enabling the interrupts. This of course is not possible with
SMP designs and OTOH it's not possible in user space. That is why
implementing FUTEX and SMP seems to ask for similar considerations.

-Michael
