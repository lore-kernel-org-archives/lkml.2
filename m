Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab0DHKny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 06:43:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58162 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755212Ab0DHKnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 06:43:52 -0400
Date: Thu, 8 Apr 2010 11:45:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Schnell <mschnell@lumino.de>
Cc: linux-kernel@vger.kernel.org, nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
Message-ID: <20100408114542.47b6589a@lxorguk.ukuu.org.uk>
In-Reply-To: <4BBD86A5.5030109@lumino.de>
References: <4BBD86A5.5030109@lumino.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - no normal processor "read-modify-write" instructions that by design
> are not interrupted or even bus-locking
>  - new "custom" processor instructions can be defined that might work
> atomically, as well not interruptible as kind of bus-locking for SMP use
>  - these custom instructions can't access the memory in normal way
> (through the MMU and the cache).
> 
> So to implement atomic instructions a dedicated RAM area would be needed
> to hold the atomically accessible data. Same can't be accessed by the
> CPU in other ways. This RAM area would be implemented with the new
> atomic instructions and be located within the FPGA and thus could
> accessed very fast (no cache issues).

Take a look at sparc 32bit. That only has a single meaningful atomic
instruction (swap byte with 0xFF). It provides all the kernel atomic_t
operations via this: arch/sparc/lib/atomic32.c. That bitops are done a
similar way, which leaves spinlocks and the like.

More importantly if your true locks in the FPGA are really fast in CPU
terms then you can think of every other atomic instructions as being
implemented using

		lock(cpu_atomic_instruction_lock)
		do bits
		unlock(cpu_atomic_instruction_lock)

(its just this is normally done in hardware/microcode)

Doing it per instruction might be a bit naïve but I think you can
reasonably do it so that things like spinlocks use a single (or a hashed
set) of non kernel locks to implement "atomic" instructions, and as
sparc32 shows you only need a tiny subset of them to implement the rest
in their terms.

So I don't actually think you need any kernel core changes to get going,
and given the kernel dynamically allocates a lot of locks I suspect
trying to dynamically manage atomic ram allocations is going to cost more
than executing a few instructions here and there under a single very fast
hardware assisted lock.

Alan
