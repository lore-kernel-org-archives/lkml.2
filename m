Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab2BPAkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 19:40:43 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54457 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2BPAkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 19:40:40 -0500
MIME-Version: 1.0
In-Reply-To: <20120215233002.GB20816@kroah.com>
References: <CAGWcZkJs2uQHM=7wmf1JOLmUeS3Mxo5L4arMuMQSez1mvJLKQA@mail.gmail.com>
 <CAGWcZkKV1vc47zB_d0e+Q3+XG08mDt6TfzQ3d0p4=wswKN3ePg@mail.gmail.com> <20120215233002.GB20816@kroah.com>
From: Egmont Koblinger <egmont@gmail.com>
Date: Thu, 16 Feb 2012 01:39:59 +0100
Message-ID: <CAGWcZkJHCRppjONbHuNop2r2X=n7efK94dQMXrA2=0Ou39bOAg@mail.gmail.com>
Subject: Re: PROBLEM: Data corruption when pasting large data to terminal
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Sorry, I didn't emphasize the point that makes me suspect it's a kernel issue:

- strace reveals that the terminal emulator writes the correct data
into /dev/ptmx, and the kernel reports no short writes(!), all the
write(..., ..., 68) calls actually return 68 (the length of the
example file's lines incl. newline; I'm naively assuming I can trust
strace here.)
- strace reveals that the receiving application (bash) doesn't receive
all the data from /dev/pts/N.
- so: the data gets lost after writing to /dev/ptmx, but before
reading it out from /dev/pts/N.

First I was also hoping for a bug in the terminal emulators not
handling short writes correctly, but it's not the case.

Could you please verify that stracing the terminal and the app shows
the same behavior to you?  If it's the same, and if strace correctly
reports the actual number of bytes written, then can it still be an
application bug?

Not being able to reproduce in vim/whatever doesn't mean too much, as
it seems to be some kind of race condition (behaves differently on
different machines, buggy only at ~10% of the time for me), the actual
circumstances that trigger the bug might depend on timing or the way
the applications read the buffer (byte by byte, or larger chunks) or
number of processors or I don't know what.

Unfortunately I have no information about "known good" reference
point, but I recall seeing a similar bug a year or two ago, I just
didn't pay attention to it. So probably it's not a new one.


thanks a lot,
egmont


On Thu, Feb 16, 2012 at 00:30, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Feb 15, 2012 at 07:50:58PM +0100, Egmont Koblinger wrote:
> > Hi,
> >
> > Short summary:  When pasting large amount of data (>4kB) to terminals,
> > often the data gets mangled.
> >
> > How to reproduce:
> > Create a text file that contains this line about 100 times:
> > a=(123456789123456789123456789123456789123456789123456789123456789)
> > (also available at http://pastebin.com/LAH2bmaw for a while)
> > and then copy-paste its entire contents in one step into a "bash" or
> > "python" running in a graphical terminal.
> >
> > Expected result: The interpreter correctly parses these lines and
> > produces no visible result.
> > Actual result: They complain about syntax error.
> > Reproducibility: About 10% on my computer (2.6.38.8), reportedly 100%
> > on friends' computers running 2.6.37 and 3.1.1.
>
> Has this ever worked properly for you on older kernels?  How about 3.2?
> 3.3-rc3?  Having a "known good" point to work from here would be nice to
> have.
>
> I can reproduce this using bash, BUT, I can not reproduce it using vim
> running in the same window bash was running in.
>
> So, that implies that this is a userspace bug, not a kernel one,
> otherwise the results would be the same both times, right?
>
> > Why I believe this is a kernel bug:
> > - Reproducible with any source of copy-pasting (e.g. various
> > terminals, graphical editors, browsers).
>
> Bugs are common when people start with the same original codebase :)
>
> > - Reproducible with at least five different popular graphical terminal
> > emulators where you paste into (xterm, gnome, kde, urxvt, putty).
> > - Reproducble with at least two applications (bash, python).
>
> Again, I can't duplicate this with vim in a terminal window, which rules
> out the terminal, and points at bash, right?
>
> > - stracing the terminal shows that it does indeed write the correct
> > copy-paste buffer into /dev/ptmx, and all its writes return the full
> > amount of bytes requested, i.e. no short write.
>
> short writes are legal, but so many userspace programs don't handle them
> properly.
>
> > - stracing the application clearly shows that it does not receive all
> > the desired characters from its stdin, some are simply missing, i.e. a
> > read(0, "3", 1) = 1 is followed by a read(0, "\n", 1) = 1 (with a
> > write() and some rt_sigprocmask()s in between), although the char '3'
> > shouldn't be followed by a newline.
>
> Perhaps the buffer is overflowing as the program isn't able to keep up
> properly?  It's not an "endless" buffer, it can overflow if reads don't
> keep up.
>
> > - Not reproducible on MacOS.
>
> That means nothing :)
>
> > Additional informaiton:
> > - On friends' computers the bug always happens from the offset 4163
> > which is exactly the length of the first line (data immediately
> > processed by the application) plus the magic 4095. The rest of that
> > line, up to the next newline, is cut off.
> >
> > - On my computer, the bug, if happens, always happens at an offset
> > behind this one; moreover, there's a lone digit '3' appearing on the
> > display on its own line exactly 4095 bytes before the syntax error.
> > Here's a "screenshot" with "$ " being the bash prompt, and with my
> > comments after "#":
> >
> > $ a=(123456789123456789123456789123456789123456789123456789123456789)
> > # repeated a few, varying number of times
> > 3
> > # <- notice this lone '3' on the display
> > $ a=(123456789123456789123456789123456789123456789123456789123456789)
> > # 60 times, that's 4080 bytes incl. newlines
> > $ a=(123456789123
> > > a=(123456789123456789123456789123456789123456789123456789123456789)
> > bash: syntax error near unexpected token `('
> > $ a=(123456789123456789123456789123456789123456789123456789123456789)
> > # a few more times
> >
> > - I couldn't reproduce with cat-like applications, I have a feeling
> > perhaps the bug only occurs in raw terminal mode, but I'm really not
> > sure about this.
>
> That kind of proves the "there's a problem in the application you are
> testing" theory, right?
>
> > I'd be glad if you could find the time to look at this problem, it's
> > quite unfortunate that I cannot safely copy-paste large amount of data
> > into terminals.
>
> Works for me, just use an editor to do that...
>
> thanks,
>
> greg k-h
