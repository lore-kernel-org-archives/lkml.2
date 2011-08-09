Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1HIVIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:08:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab1HIVIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:08:43 -0400
Date: Tue, 9 Aug 2011 17:08:29 -0400
From: Don Zickus <dzickus@redhat.com>
To: Alex Neronskiy <zakmagnus@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v4 2/2] Output stall traces in /proc
Message-ID: <20110809210829.GH1972@redhat.com>
References: <1312495991-28377-1-git-send-email-zakmagnus@chromium.org>
 <1312495991-28377-2-git-send-email-zakmagnus@chromium.org>
 <20110805134042.GJ1972@redhat.com>
 <CAAuSN919rQj93P8HE69_N5vC04ywMFfeJjRdMhn8ga1V-jFb7A@mail.gmail.com>
 <20110805184323.GK20762@redhat.com>
 <CAAuSN91Pi8SbWbU87v7QdDWS_N1GiXsM8dGUYSYKTUCUp+2Mww@mail.gmail.com>
 <20110808201951.GY1972@redhat.com>
 <1312836771.22367.35.camel@twins>
 <20110808213721.GA1972@redhat.com>
 <CAAuSN91zeipoQVU5jEtvVR1bXeu2c1KGY2sqowYuDzozpa818w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAuSN91zeipoQVU5jEtvVR1bXeu2c1KGY2sqowYuDzozpa818w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 04:34:33PM -0700, Alex Neronskiy wrote:
> On Mon, Aug 8, 2011 at 2:37 PM, Don Zickus <dzickus@redhat.com> wrote:
> > Maybe irq_work isn't what we needed.  I just wasn't smart enough to figure
> > out how to make sure we can write data in an NMI context and read it in a
> > normal context.  I supposed the whole swapping buffers could work and is
> > simpler.
> So each of the buffers has its own lock, right? If a lock protects a
> pair of buffers, then: A reader takes the lock, and a writing NMI
> comes in and writes to the non-readable buffer and swaps the two. The
> reader still has the lock. Another NMI comes in, sees that the lock is
> unavailable, and writes to the "backup" buffer, which is actually the
> one the reader is still reading from. Bad corrupted read results.

Actually it should just overwrite the non-readable buffer as that data is
now stale and useless.  The reader can atomically set which buffer is
being read.  The only problem is once you read it, you lose it.

> 
> Either way, I don't see how to make the idea work safely for one pair
> of buffers shared by multiple CPU's. It works one-pair-per-CPU, but
> that's not how the current design is. I guess it would need to
> add/remove files every time a processor is added/removed, and there
> have to be some other changes too, obviously. What do you think, Don?
> Should this be a per-CPU thing, instead of global worst?

Well, looking at the code again, I think the spin_locks in the NMI handler
will block the other cpus from writing to the page at the same time.  So
it gets serialized that way, I think.  The next trick is to do something
with procfs like swapping buffers successfully.

I am trying to think how that would work, but I guess if you use the
cmpxchg macros then

procfs could cmpxchg a READ_BIT on the buffer and if successful (no
WRITE_BIT), then proceed to read the buffer.  Otherwise use the other
buffer.  A lock would have to be used to serialize access on the procfs.

The NMI code could do the same with a WRITE_BIT and if succesful (no
READ_BIT), then proceed to write the buffer.  Otherwise use the other
buffer.  Because the NMI is serialized only one write could go on at any
one time.

I was reading the kernel/irq_work.c code to generate the above idea.

Not sure if it works.  Thoughts?

Cheers,
Don
