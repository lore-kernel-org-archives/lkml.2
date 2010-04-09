Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0DIKzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 06:55:16 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:39311 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab0DIKzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 06:55:11 -0400
Message-ID: <4BBF0784.2060002@lumino.de>
Date: Fri, 09 Apr 2010 12:55:00 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de>	<20100408114542.47b6589a@lxorguk.ukuu.org.uk>	<4BBDC7D4.6040301@lumino.de> <20100408143750.0acebaa1@lxorguk.ukuu.org.uk>
In-Reply-To: <20100408143750.0acebaa1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 03:37 PM, Alan Cox wrote:
> Sorry, but FUTEX is *irrelevant*, utterly and totally. It's an
> implementation of a model of fast user space locking for certain classes
> of processor, and its not exposed to applications in that form.
>   

FUTEX is kind of _invisible_ to the user code.Usually it's hidden behind
pthread_mutex() and pthread_mutex_...() automatically falls back to
non-FUTEX based locking (that always do Kernel calls).

But it is very relevant, as without it, a multithreaded application will
perform a lot poorer. Here many locks might be necessary to protect
resources (mostly modifications to  memory locations) used by multiple
threads (running on multiple CPUs when doing SMP). This can happen very
often and always doing two Kernel calls (lock and unlock) is a very poor
option. This problem is even worse with the archs in question as even a
simple inc can't be done in an atomic way (even using ASM) and even for
this, a lock is necessary (or directly using the "atomic" macros we talk
about and that are not correctly implemented for the said archs right now).
> Your first problem is to implement spin_lock and friends in the kernel,
> which you can do with a single fast lock in your special memory
> area/instructions. 
Yep. I suppose in Kernel space this can be easily handled either by
disabling / enabling the interrupt in non-SMP designs or by a hardware
MUTEX (that for NIOS is provided by Altera as an I/O element)
> Futexes or not you need a workable SMP kernel
> first.
>   
If "you" is You that might be true. But if "you" is me its utterly and
totally wrong. For my heavily multithreaded application I need FUTEX but
not SMP (yet). For me, SMP is no advantage if it does not support FUTEX
and I suppose the SMP solution with a single hardware mutex can't do
this (but maybe I'm wrong here and a software workaround is possible).

Happily Thomas (the maintainer of the NIOS distribution) agrees with me
that FUTEX is important and I hope we soon will work together on making
it possible for the MMU based NIOS distribution. Right now I just want
to discuss if doing a hardware based thing - that might help with doing
SMP one day, too - would be more agreeable than the currently suggested
way with the "atomic region" software workaround (for non-SMP). I
suppose the current NIOS _Kernel_ code implements atomic operations by
enabling / disabling interrupt, so no hardware lock is necessary.
> FUTEX is to all intents and purposes an internal kernel magic interface
> with arch specific corner cases used by the C library to provide posix
> locking. You don't even need futex. If its not the right model for your
> platform you make the C library use your own totally unrelated locking
> scheme internally.
>   
pthread_mutex..() uses FUTEX if available with the arch, so FUTEX is a
way of complying to the POSIX standard. Of course there are other ways
(that pthread_mutex_...() use if FUTEX is not available) but this asks
for Kernel calls with any lock and any unlock and thus is a lot slower -
maybe unusable with certain applications.
> Indeed if your FPGA memory doesn't go via the MMU etc I don't see how you
> can implement any kind of futex like system.
>   
The internal memory can be designed to go via the MMU (and the cache).
That is not the problem. The problem is that with this simple
"load-store RISC"-architecture, there is _no_ way to have the processor
do a read-modify-write operation (sequence) in user space. Not SMP safe
and not even thread safe. This _can_ be relaxed by implementing a
"custom instruction" in "hardware". But a "custom instruction" can't use
the MMU and the cache. It can be designed to use a dedicated memory area
(not accessible by other CPU instructions) or to use the any memory
_directly_ (bypassing the MMU and the cache). It would be a very nice
feature if Altera would provide a "normal" memory interface for custom
instructions, but this is not an option right now.
> providing userspace sees a correct fast implementation of posix locks
> which is what actually gets used by well behaved apps (and most people not
> clinically insane given how much fun futex is to work with at the low
> level)
>   
....
> futex is just one way of skinning that particular cat
>   
IMHO, the only decent way to go is to provide FUTEX perfectly compatible
to what other archs do, and thus have it be accessed via pthread_mutex()
so that any "standard" POSIX compatible multithreaded application will
take advantage of the speed gain.

Thanks,
-Michael
