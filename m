Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760373Ab0JISDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 14:03:45 -0400
Received: from postdiluvian.org ([128.30.54.21]:53803 "EHLO
	porklips.postdiluvian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab0JISDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 14:03:42 -0400
X-Greylist: delayed 1249 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Oct 2010 14:03:41 EDT
Date: Sat, 9 Oct 2010 13:42:46 -0400
From: Mark Mason <mason@postdiluvian.org>
To: Iwo Mergler <iwo@call-direct.com.au>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Scheduler latency problems when using NAND
Message-ID: <20101009174246.GA19591@postdiluvian.org>
References: <20100929221401.GA32583@postdiluvian.org>
 <4CA3D92E.9060109@call-direct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA3D92E.9060109@call-direct.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iwo Mergler <iwo@call-direct.com.au> wrote:

> Mark Mason wrote:
> > Hi all,
> > 
> > I hope this is the right place for this question.  I'm having some
> > problems with scheduler latency when using UBIFS, and I'm hoping for
> > some suggestions.
> <snip>
> > The application is storing streaming video, almost entirely large
> > sequential files, roughly 250K to 15M, to a 1.6G filesystem.  There's
> > no seeking or rewriting, just creat, write, close, repeat.  No
> > compression is used on the filesystem.
> > 
> > The problem I'm seeing is excessively large scheduler latency when
> > data is flushed to NAND.
> <snip>
> > Does anyone have any suggestions, ideas, hints, advice, etc?
> 
> The Linux block cache is optimised for mechanical hard drives,
> to minimise seek times. Some of the assumptions don't make much
> sense with FLASH and streaming storage.
> 
> Maybe try to flush data whenever you have written a few blocks'
> worth. Or have a look at the O_DIRECT flag (or madvise), although
> I don't know how it interacts with UBIFS.

I tried lowering dirty_writeback_centisecs and dirty_expire_centisecs,
the latency dropped when I used values around 1 or 2 (down from 500 &
3000), but it's still a problem.

> You could use a real filesystem to store the metadata for your
> circular storage partition (file name, length, offset).
> 
> Maybe use raw UBI so you don't have to worry about bad blocks.
> 
> Either way, the time to erase a block and write a single page
> is predictable and you can do it as soon as you get the data.

A custom filesystem would be good, but I still hold out hope that
somebody has already fought this battle for me.

Regardless, it looks like I have a genuine hardware problem on my
hands, and it's one that I would expect other people to have, although
I suspect it wouldn't be an issue with reasonable flash loads.

The flash driver (fsl_elbc_nand.c) goes to sleep right after it issues
a page program, and a context switch to another high priority thread
takes place promptly.  This thread is often one that reads from
another (video) chip on the same bus as the flash (the MPC8315 LBC).
The flash asserts its BUSY line while the page program is in
operation.  When the other thread comes along to read from video chip,
it's held off for the 200us duration of the page program (the LBC
controller for the video chip is running in UPM mode, so the BUSY line
is a BUSY line and not a TA line, in case any 83xx junkies are reading
this).

What I see on a logic analyzer is the BUSY line held by the flash for
200us, a single 32 bit read of the video chip (broken up into two 16
bit reads for the 16 bit bus), then another 200us BUSY from the flash,
two more 16 bit reads, etc, all the way to the end of the logic
analyzer screen.

What I think is happening is that the flash background thread is
running very efficiently - it comes in, issues a page program, and
relinquishes the CPU.  The thread reading the video chip then runs,
stalls for 200us waiting for a single read, gets its read, then is
preempted for the flash BGT.

My guess is that the scheduler sees the flash background thread as
running almost not at all, and the video thread as running a lot more,
although it's stalled for most of the first 200us of its time slice on
a single bus transaction, so it can't really do anything with its time
slice.  I further suspect that the scheduler is dynamically adjusting
the priorities to boost the flash BGT, since it's using much less CPU
time than the video thread, even though the video thread can't use
most of its time slice.  Can someone tell me if this makes sense?

I tried some messing with priorities, but ultimately the flash has to
run, and it has to run frequently in very short bursts to issue all of
the page programs.  The video chip needs to be serviced promptly, so
there is always a significant chance that it will run right after a
page program is issued.

I tried disabling preemption for the duration of a transfer in the
video driver so it wouldn't get preempted once it had waited its 200us
to get the bus.  It helped, but ultimately there's still a 200us delay
to perform a sequence of operations that usually take somewhere
between 5 and 30 us.

Most devices that would sit on the bus will only assert the BUSY line
while the chip select is held.  The NAND, however, asserts BUSY for
the duration of a page program.  So I could add a gate to the BUSY
line to gate it with the chip select.  This would require a respin of
the board, and I'm not 100% certain that it wouldn't confuse the
8315's NAND controller.  I'm going to try this next week.  I could
also take the bus controller out of flash (FCM) mode, depop the
resistors to the NAND's BUSY line, and have the NAND layer talk to the
NAND like it's just a chip on a plain old bus, and poll for BUSY.
This option might be better than it sounds, since the delays are very
predictable.

Any words of wisdom?
