Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2BSVOk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 16:14:40 -0500
Received: from smtprelay.restena.lu ([158.64.1.62]:60005 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab2BSVOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 16:14:39 -0500
Date: Sun, 19 Feb 2012 22:14:12 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Egmont Koblinger <egmont@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Data corruption when pasting large data to terminal
Message-ID: <20120219221412.1b6912ba@neptune.home>
In-Reply-To: <CAGWcZk+_NpBZ2Gquv_ynXKdAivd3FhkHDDxu488y9Y9OrG2yfw@mail.gmail.com>
References: <CAGWcZkJs2uQHM=7wmf1JOLmUeS3Mxo5L4arMuMQSez1mvJLKQA@mail.gmail.com>
	<CAGWcZkKV1vc47zB_d0e+Q3+XG08mDt6TfzQ3d0p4=wswKN3ePg@mail.gmail.com>
	<20120215233002.GB20816@kroah.com>
	<CAGWcZkJHCRppjONbHuNop2r2X=n7efK94dQMXrA2=0Ou39bOAg@mail.gmail.com>
	<20120216005437.GA22858@kroah.com>
	<20120217192825.GE2707@elf.ucw.cz>
	<20120217225708.0f31f2ac@neptune.home>
	<CAGWcZk+_NpBZ2Gquv_ynXKdAivd3FhkHDDxu488y9Y9OrG2yfw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Egmont,

On Sun, 19 February 2012 Egmont Koblinger <egmont@gmail.com> wrote:
> Unfortunately the lost tail is a different thing: the terminal is in
> cooked mode by default, so the kernel intentionally keeps the data in
> its buffer until it sees a complete line.  A quick-and-dirty way of
> changing to byte-based transmission (I'm lazy to look up the actual
> system calls, apologies for the terribly ugly way of doing this) is:
>                  pty = open(ptsdname, O_RDWR):
>                  if (pty == -1) { ... }
> +                char cmd[100];
> +                sprintf(cmd, "stty raw <>%s", ptsdname);
> +                system(cmd);
>                  ptmx_slave_test(pty, line, rsz);
> 
> Anyway, thanks very much for your test program, I'll try to modify it
> to trigger the data corruption bug.

Well, not sure but the closing of ptmx on sender side should force kernel
to flush whatever is remaining independently on end-of-line (I was
thinking I should push an EOF over the ptmx instead of closing it before
waiting for child process though I have not yet looked-up how to do so!).

The amount of missing tail for my few runs of the test program were of
varying length, but in all cases way more than a single line, thus I would
hope it's not line-buffering by the kernel which causes the missing data!

Bruno


> egmont
> 
> On Fri, Feb 17, 2012 at 22:57, Bruno Prémont <bonbons@linux-vserver.org> wrote:
> > Hi,
> >
> > On Fri, 17 February 2012 Pavel Machek <pavel@ucw.cz> wrote:
> >> > > Sorry, I didn't emphasize the point that makes me suspect it's a kernel issue:
> >> > >
> >> > > - strace reveals that the terminal emulator writes the correct data
> >> > > into /dev/ptmx, and the kernel reports no short writes(!), all the
> >> > > write(..., ..., 68) calls actually return 68 (the length of the
> >> > > example file's lines incl. newline; I'm naively assuming I can trust
> >> > > strace here.)
> >> > > - strace reveals that the receiving application (bash) doesn't receive
> >> > > all the data from /dev/pts/N.
> >> > > - so: the data gets lost after writing to /dev/ptmx, but before
> >> > > reading it out from /dev/pts/N.
> >> >
> >> > Which it will, if the reader doesn't read fast enough, right?  Is the
> >> > data somewhere guaranteed to never "overrun" the buffer?  If so, how do
> >> > we handle not just running out of memory?
> >>
> >> Start blocking the writer?
> >
> > I did quickly write a small test program (attached). It forks a reader child
> > and sends data over to it, at the end both write down their copy of the buffer
> > to a /tmp/ptmx_{in,out}.txt file for manual comparing results (in addition
> > to basic output of mismatch start line)
> >
> > From the time it took the writer to write larger buffers (as seen using strace)
> > it seems there *is* some kind of blocking, but it's not blocking long enough
> > or unblocking too early if the reader does not keep up.
> >
> >
> > For quick and dirty testing of effects of buffer sizes, tune "rsz", "wsz"
> > and "line" in main() as well as total size with BUFF_SZ define.
> >
> >
> > The effects for me are that writer writes all data but reader never sees tail
> > of written data (how much is being seen seems variable, probably matter of
> > scheduling, frequency scaling and similar racing factors).
> >
> > My test system is single-core uniprocessor centrino laptop (32bit x86) with
> > 3.2.5 kernel.
> >
> > Bruno
