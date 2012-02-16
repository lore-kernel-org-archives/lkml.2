Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab2BPBNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 20:13:20 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57225 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab2BPBNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 20:13:14 -0500
MIME-Version: 1.0
In-Reply-To: <20120216005437.GA22858@kroah.com>
References: <CAGWcZkJs2uQHM=7wmf1JOLmUeS3Mxo5L4arMuMQSez1mvJLKQA@mail.gmail.com>
 <CAGWcZkKV1vc47zB_d0e+Q3+XG08mDt6TfzQ3d0p4=wswKN3ePg@mail.gmail.com>
 <20120215233002.GB20816@kroah.com> <CAGWcZkJHCRppjONbHuNop2r2X=n7efK94dQMXrA2=0Ou39bOAg@mail.gmail.com>
 <20120216005437.GA22858@kroah.com>
From: Egmont Koblinger <egmont@gmail.com>
Date: Thu, 16 Feb 2012 02:12:33 +0100
Message-ID: <CAGWcZkK=DYW8bxP1iLoy35zuakUNE_7WHJ+-3n1BSobrFRQ61w@mail.gmail.com>
Subject: Re: PROBLEM: Data corruption when pasting large data to terminal
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 01:54, Greg KH <gregkh@linuxfoundation.org> wrote:

>> - so: the data gets lost after writing to /dev/ptmx, but before
>> reading it out from /dev/pts/N.
>
> Which it will, if the reader doesn't read fast enough, right?  Is the
> data somewhere guaranteed to never "overrun" the buffer?  If so, how do
> we handle not just running out of memory?

If the buffer is full, the write() into /dev/ptmx should signal it by
returning a smaller-than-requested number (short write), or 0 or it
should block (perhaps depending on whether the fd is in blocking mode)
-- am I correct?  If the write() returns 68 whereas actually it stored
15 bytes and threw out the rest, then there's no way applications
could handle this.  As I said, stracing the terminal tells me that the
terminal wrote 68 bytes 100 times, and all hundred times the write()
call returned 68, not less.

> I bet you can write a simple userspace program that also does this
> correctly, have you tried that?  That might be best to provide a "tiny"
> reproducer.
>
> Odds are bash and python don't do things properly, as they aren't
> accustomed to such large buffers coming in at this rate of speed.  They
> are designed for this type of thing, while vim is used to it.

Again: stracing bash reveals that it reads from its stdin byte by
byte, and at one point it read()s a '3' character followed by a '\n'
with the next read() - something that never occurs in the input.

I wish I had a simpler test case, but I don't have yet.

Anyway, I'm not looking at the internals of the terminal or the
application, I'm observing the interface where they talk to the pty,
and what I see is that the terminal writes the correct stuff, and the
application receives a garbled one.  Whatever bash does with that data
later on is irrelevant, isn't it?


> If you can trace something down in the kernel to point to where we are
> doing something wrong, I would be glad to look at it.  But without that,
> there's not much I can do here, sorry.

I still can't understand why the two strace outputs are not convincing
enough.  I'm also uncertain what the desired behavior would be if one
tries to write to ptmx while the kernel's buffer is full.


thanks,
e.
