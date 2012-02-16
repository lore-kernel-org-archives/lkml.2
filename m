Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2BPA62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 19:58:28 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54497 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916Ab2BPA60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 19:58:26 -0500
X-Sasl-enc: u67LOwrm7NSE5q04mSIjObNCGPH1hrdrcC3qvhlx1gVH 1329353905
Date: Wed, 15 Feb 2012 16:54:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Egmont Koblinger <egmont@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Data corruption when pasting large data to terminal
Message-ID: <20120216005437.GA22858@kroah.com>
References: <CAGWcZkJs2uQHM=7wmf1JOLmUeS3Mxo5L4arMuMQSez1mvJLKQA@mail.gmail.com>
 <CAGWcZkKV1vc47zB_d0e+Q3+XG08mDt6TfzQ3d0p4=wswKN3ePg@mail.gmail.com>
 <20120215233002.GB20816@kroah.com>
 <CAGWcZkJHCRppjONbHuNop2r2X=n7efK94dQMXrA2=0Ou39bOAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGWcZkJHCRppjONbHuNop2r2X=n7efK94dQMXrA2=0Ou39bOAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Thu, Feb 16, 2012 at 01:39:59AM +0100, Egmont Koblinger wrote:
> Hi Greg,
> 
> Sorry, I didn't emphasize the point that makes me suspect it's a kernel issue:
> 
> - strace reveals that the terminal emulator writes the correct data
> into /dev/ptmx, and the kernel reports no short writes(!), all the
> write(..., ..., 68) calls actually return 68 (the length of the
> example file's lines incl. newline; I'm naively assuming I can trust
> strace here.)
> - strace reveals that the receiving application (bash) doesn't receive
> all the data from /dev/pts/N.
> - so: the data gets lost after writing to /dev/ptmx, but before
> reading it out from /dev/pts/N.

Which it will, if the reader doesn't read fast enough, right?  Is the
data somewhere guaranteed to never "overrun" the buffer?  If so, how do
we handle not just running out of memory?

> First I was also hoping for a bug in the terminal emulators not
> handling short writes correctly, but it's not the case.

Yes, that would make things easier.

> Could you please verify that stracing the terminal and the app shows
> the same behavior to you?  If it's the same, and if strace correctly
> reports the actual number of bytes written, then can it still be an
> application bug?

You can do that stracing vim if you want to, I'm currently on the road
at the moment, and have to give a presentation in a few minutes, so my
spare time for this is a bit limited :)

> Not being able to reproduce in vim/whatever doesn't mean too much, as
> it seems to be some kind of race condition (behaves differently on
> different machines, buggy only at ~10% of the time for me), the actual
> circumstances that trigger the bug might depend on timing or the way
> the applications read the buffer (byte by byte, or larger chunks) or
> number of processors or I don't know what.

Not being able to reproduce it with a different userspace program is
important, in that there is at least one "known good" userspace program
here that does things correctly.

I bet you can write a simple userspace program that also does this
correctly, have you tried that?  That might be best to provide a "tiny"
reproducer.

Odds are bash and python don't do things properly, as they aren't
accustomed to such large buffers coming in at this rate of speed.  They
are designed for this type of thing, while vim is used to it.

> Unfortunately I have no information about "known good" reference
> point, but I recall seeing a similar bug a year or two ago, I just
> didn't pay attention to it. So probably it's not a new one.

If you can trace something down in the kernel to point to where we are
doing something wrong, I would be glad to look at it.  But without that,
there's not much I can do here, sorry.

thanks,

greg k-h
