Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2BSU4H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 15:56:07 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45313 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab2BSU4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 15:56:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of egmont@gmail.com designates 10.181.12.106 as permitted sender) smtp.mail=egmont@gmail.com; dkim=pass header.i=egmont@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120217225708.0f31f2ac@neptune.home>
References: <CAGWcZkJs2uQHM=7wmf1JOLmUeS3Mxo5L4arMuMQSez1mvJLKQA@mail.gmail.com>
 <CAGWcZkKV1vc47zB_d0e+Q3+XG08mDt6TfzQ3d0p4=wswKN3ePg@mail.gmail.com>
 <20120215233002.GB20816@kroah.com> <CAGWcZkJHCRppjONbHuNop2r2X=n7efK94dQMXrA2=0Ou39bOAg@mail.gmail.com>
 <20120216005437.GA22858@kroah.com> <20120217192825.GE2707@elf.ucw.cz> <20120217225708.0f31f2ac@neptune.home>
From: Egmont Koblinger <egmont@gmail.com>
Date: Sun, 19 Feb 2012 21:55:23 +0100
Message-ID: <CAGWcZk+_NpBZ2Gquv_ynXKdAivd3FhkHDDxu488y9Y9OrG2yfw@mail.gmail.com>
Subject: Re: PROBLEM: Data corruption when pasting large data to terminal
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruno,

Unfortunately the lost tail is a different thing: the terminal is in
cooked mode by default, so the kernel intentionally keeps the data in
its buffer until it sees a complete line.  A quick-and-dirty way of
changing to byte-based transmission (I'm lazy to look up the actual
system calls, apologies for the terribly ugly way of doing this) is:
                 pty = open(ptsdname, O_RDWR):
                 if (pty == -1) { ... }
+                char cmd[100];
+                sprintf(cmd, "stty raw <>%s", ptsdname);
+                system(cmd);
                 ptmx_slave_test(pty, line, rsz);

Anyway, thanks very much for your test program, I'll try to modify it
to trigger the data corruption bug.


egmont

On Fri, Feb 17, 2012 at 22:57, Bruno Prémont <bonbons@linux-vserver.org> wrote:
> Hi,
>
> On Fri, 17 February 2012 Pavel Machek <pavel@ucw.cz> wrote:
>> > > Sorry, I didn't emphasize the point that makes me suspect it's a kernel issue:
>> > >
>> > > - strace reveals that the terminal emulator writes the correct data
>> > > into /dev/ptmx, and the kernel reports no short writes(!), all the
>> > > write(..., ..., 68) calls actually return 68 (the length of the
>> > > example file's lines incl. newline; I'm naively assuming I can trust
>> > > strace here.)
>> > > - strace reveals that the receiving application (bash) doesn't receive
>> > > all the data from /dev/pts/N.
>> > > - so: the data gets lost after writing to /dev/ptmx, but before
>> > > reading it out from /dev/pts/N.
>> >
>> > Which it will, if the reader doesn't read fast enough, right?  Is the
>> > data somewhere guaranteed to never "overrun" the buffer?  If so, how do
>> > we handle not just running out of memory?
>>
>> Start blocking the writer?
>
> I did quickly write a small test program (attached). It forks a reader child
> and sends data over to it, at the end both write down their copy of the buffer
> to a /tmp/ptmx_{in,out}.txt file for manual comparing results (in addition
> to basic output of mismatch start line)
>
> From the time it took the writer to write larger buffers (as seen using strace)
> it seems there *is* some kind of blocking, but it's not blocking long enough
> or unblocking too early if the reader does not keep up.
>
>
> For quick and dirty testing of effects of buffer sizes, tune "rsz", "wsz"
> and "line" in main() as well as total size with BUFF_SZ define.
>
>
> The effects for me are that writer writes all data but reader never sees tail
> of written data (how much is being seen seems variable, probably matter of
> scheduling, frequency scaling and similar racing factors).
>
> My test system is single-core uniprocessor centrino laptop (32bit x86) with
> 3.2.5 kernel.
>
> Bruno
