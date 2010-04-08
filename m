Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab0DHNeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 09:34:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52487 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758608Ab0DHNd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 09:33:56 -0400
Date: Thu, 8 Apr 2010 14:37:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Schnell <mschnell@lumino.de>
Cc: linux-kernel@vger.kernel.org, nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
Message-ID: <20100408143750.0acebaa1@lxorguk.ukuu.org.uk>
In-Reply-To: <4BBDC7D4.6040301@lumino.de>
References: <4BBD86A5.5030109@lumino.de>
	<20100408114542.47b6589a@lxorguk.ukuu.org.uk>
	<4BBDC7D4.6040301@lumino.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The important task (for me right now) is providing decent FUTEX
> (multiple of those ! ). Here you need to do atomic instructions in user
> spaces on the (multiple) FUTEX handling word (so interrupt
> disabling/enabling  is not possible). If you try to implement this by
> using a _single_ lock (surrounding the would-be atomic instruction
> sequence), this IMHO only lifts the problem to another level:

Sorry, but FUTEX is *irrelevant*, utterly and totally. It's an
implementation of a model of fast user space locking for certain classes
of processor, and its not exposed to applications in that form.

Your first problem is to implement spin_lock and friends in the kernel,
which you can do with a single fast lock in your special memory
area/instructions. So with your extra bit of magic FPGA memory and
instructions you can implement kernel locking. At that point you've got
the main thing you need - a bootable SMP kernel that doesn't require
mangling the entire kernel. Futexes or not you need a workable SMP kernel
first.

> If one thread locks the "cpu_atomic_instruction_lock" and now the Kernel
> does a task switch and now a second thread tries to lock it as well,

The cpu atomic instruction lock lets you do kernel space. That is all.
There are other approaches including a semi-insane ways of creating an SMP
ll/sc behaviour with scheduler hacks, at least for small processor counts.

> I suppose the current NIOS _Kernel_ code implements atomic operations by
> disabling/enabling the interrupts. This of course is not possible with
> SMP designs and OTOH it's not possible in user space. That is why
> implementing FUTEX and SMP seems to ask for similar considerations.

No

The kernel needs a way of implementing a tiny set of operations fast.
Those operations need to match the existing kernel locking system. They
don't have security properties, they don't have to deal with pageable
memory. They have a fixed, definite API.

FUTEX is to all intents and purposes an internal kernel magic interface
with arch specific corner cases used by the C library to provide posix
locking. You don't even need futex. If its not the right model for your
platform you make the C library use your own totally unrelated locking
scheme internally.

Indeed if your FPGA memory doesn't go via the MMU etc I don't see how you
can implement any kind of futex like system.

If you have got some kind of way to assign/protect futex space then I'd
expect your interfaces will look something like this at the low level


	open /dev/lockspace
	
	[some kind of operation to select if we are mapping a page of
	locks from another task or making a new set]

	mmap /dev/lockspace	[map a suitable page of lockspace
				 somewhere into the task]
	do lock ops on the lockspace mapping

providing userspace sees a correct fast implementation of posix locks
which is what actually gets used by well behaved apps (and most people not
clinically insane given how much fun futex is to work with at the low
level)

You might also of course want to review the store ordering and visibility
rules for the CPU for both cached and uncached memory. There are several
algorithms that work rather well which don't require locked instructions
to implement locks, merely some ordering rules

(eg look up Lamports Bakery,  Wallace's Bakery etc)

http://research.microsoft.com/en-us/um/people/lamport/pubs/bakery.pdf

futex is just one way of skinning that particular cat

Alan
