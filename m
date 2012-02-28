Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965610Ab2B1PW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 10:22:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40946 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965002Ab2B1PW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 10:22:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomermargalit@gmail.com designates 10.216.139.25 as permitted sender) smtp.mail=tomermargalit@gmail.com; dkim=pass header.i=tomermargalit@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120228145624.GE4125@quack.suse.cz>
References: <CAG3n4CS5vyx2sn9t0geQoxa+kE+Nk9Q-0fwTCU6o9iQ33bORjA@mail.gmail.com>
 <20120120140157.GA11241@quack.suse.cz> <CAG3n4CRS5soJkZK4UaAQn8A1jZmTkDJGiks6zrmem9WczSKQ4w@mail.gmail.com>
 <20120123201410.GH28526@quack.suse.cz> <CAG3n4CRN75s+coxLjA=teZT-aJVBfuFnKUXQZbhZvAt8fJWEqA@mail.gmail.com>
 <20120228145624.GE4125@quack.suse.cz>
From: Tomer Margalit <tomermargalit@gmail.com>
Date: Tue, 28 Feb 2012 17:22:35 +0200
Message-ID: <CAG3n4CT=zGJP5bFZdDweB6f4VOjkdiMjro2TOxsizfPfGpbWpA@mail.gmail.com>
Subject: Re: Failing a bio right
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, scipioenterprises@yahoo.com,
        Nezer Zaidenberg <nzaidenberg@mac.com>,
        "Zaidenberg, Nezer" <Nezer.Zaidenberg@edfenergy.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Ok, I see, thanks.

Tomer

On Tue, Feb 28, 2012 at 4:56 PM, Jan Kara <jack@suse.cz> wrote:
>  Hi,
>
> On Tue 28-02-12 16:34:59, Tomer Margalit wrote:
>> I had a bug and that's what probably caused the problems (still need to
>> verify).
>>
>> However, I still get the I/O error on device warning.
>> Is that warning expected? And is this the right way of interrupting a
>> disk write?
>  The warning is expected from kernel POV because the buffer layer does not
> expect writes can be interrupted. From user POV they are unexpected I
> guess. But you'd have to modify end_io functions in buffer layer to handle
> your new behavior to avoid those messages.
>
>                                                                Honza
>
>> On Mon, Jan 23, 2012 at 10:14 PM, Jan Kara <jack@suse.cz> wrote:
>> >
>> > On Sun 22-01-12 11:29:44, Tomer Margalit wrote:
>> > > Hi Jav,
>> > >
>> > > Thanks for the reply.
>> > >
>> > > On Fri, Jan 20, 2012 at 4:01 PM, Jan Kara <jack@suse.cz> wrote:
>> > > >  Hello,
>> > > >
>> > > > On Thu 19-01-12 18:04:19, Tomer Margalit wrote:
>> > > >> I have a make_request function that blocks writes (by using
>> > > >> wait_event_interruptible on some event).
>> > > >> I want the user to be able to stop the function if it takes too long
>> > > >> (that's the reason for the interruptible version).
>> > > >> So when the call is interrupted I call bio_endio with the EINTR error
>> > > >> to signal the interruption.
>> > > >> Usually this works fine, but after a lot of writes, the system says
>> > > >> "lost page write due to I/O error on device".
>> > > >  This is because end_buffer_write_sync() doesn't really distinguish
>> > > > errors.  So when some error happens it complains about I/O error.
>> > > >
>> > > >> At this point the process hangs.
>> > > >  That is strange - you should probably collect stack trace of the failing
>> > > > process (e.g. via 'echo w >/proc/sysrq-trigger'). That should tell us more.
>> > > >
>> > >
>> > > I cannot get a stack trace of the process since it hangs (probably in
>> > > the write) - for instance doing 'gdb -p PID` or `strace -p PID` causes
>> > > those to hang as well. The process doesn't segfault either.
>> >  That's why I told you to use 'echo w >/proc/sysrq-trigger' and looking
>> > at dmesg.
>> >
>> > > >> Is this the right way to do what I'm trying to do?
>> > > >  I'm not sure how is it supposed to work. Writes happen usually in an
>> > >
>> > > The bdev I am creating is a virtual disk that replicates writes to a
>> > > remote location. My intention is that it will behave like a socket -
>> > > i.e. block until writes can be done. Actually the bdev is additionally
>> > > meant to be semi-synchronous, so that after a buffer is filled, all
>> > > writes are blocked until some buffers are sent to the remote end.
>> > >
>> > > This works in principle, but when I try to cancel a write which is
>> > > taking too long (for instance 100MB), it doesn't do anything (since
>> > > it's stuck in the kernel).
>> > >
>> > > > async manner (through page cache and flusher thread) or are you using
>> > > > direct IO? Also if a write is interrupted at this point, you just lost the
>> > >
>> > > All of this behavior happens when I do the final fsync(2) after all
>> > > the data has been written.
>> > >
>> > > > content of the buffer (as it is marked clean and !uptodate). Users usually
>> > > > don't like that.
>> > > >
>> > >
>> > > I don't mind about contents lost since the user doesn't want to wait
>> > > until the end of the write (if done without flush it may take as long
>> > > as it requires, but flushing means wait until writes are done).
>> > >
>> > > As a side note, I use the fsync since I have also implemented a
>> > > marking mechanism for the bdev - and before creating a mark I need to
>> > > make sure all previous writes have been flushed.
>> >  OK, I see. Let's see what the stack traces of the hung process are.
>> >
>> >                                                                Honza
>> > --
>> > Jan Kara <jack@suse.cz>
>> > SUSE Labs, CR
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
