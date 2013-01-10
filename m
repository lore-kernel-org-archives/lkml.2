Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3AJR3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:29:35 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:33011 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3AJR3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:29:34 -0500
Message-ID: <50EEF8FD.9000004@suse.cz>
Date: Thu, 10 Jan 2013 18:23:09 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Florian Westphal <fw@strlen.de>
CC: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        gaowanlong@cn.fujitsu.com, gregkh@linuxfoundation.org,
        frank@lichtenheld.de
Subject: Re: regression, bisected: openpty fails from 3.7 onwards without
 devpts
References: <20130110144626.GA26279@breakpoint.cc> <20130110155058.12f66e73@bob.linux.org.uk> <20130110162907.GB26279@breakpoint.cc>
In-Reply-To: <20130110162907.GB26279@breakpoint.cc>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 05:29 PM, Florian Westphal wrote:
> Alan Cox <alan@linux.intel.com> wrote:
>> > On Thu, 10 Jan 2013 15:46:26 +0100
>> > Florian Westphal <fw@strlen.de> wrote:
>>> > > Frank Lichtenheld discovered that openpty() doesn't work anymore when
>>> > > /dev/pts is not present.
>>> > > 
>>> > > We bisected this down to
>>> > > 
>>> > > commit bbb63c514a3464342967237a51a21ea8f61ab951
>>> > > Author: Wanlong Gao <gaowanlong@cn.fujitsu.com>
>>> > > Subject: drivers:tty:fix up ENOIOCTLCMD error handling
> [..]
> 
>>> > > #include <stdio.h>
>>> > > #include <pty.h>
>>> > > int main(void) {
>>> > >  int pty_fd, tty_fd;
>>> > >  if (openpty(&pty_fd, &tty_fd, NULL, NULL, NULL) != 0) {
>>> > >   perror("openpty");
>>> > >   return 1;
>>> > >  }
>>> > > return 0;
>>> > > }
>>> > > ----
>>> > > [ compile with cc -lutil pty.c -o pty ]
>>> > > 
>>> > > If devpts is available or above commit reverted openpty works again.
>> > 
>> > The commit is fairly general - what we need to do here is to figure out
>> > which specific thing trips up openpty so we can put the error on that
>> > back as it was (or find a better way) so it still works.
>> > 
>> > Can you attach an strace of the working/failing cases without /dev/pts 
> Sure, attached.  /dev/pts is not present.
> Both traces are from the same machine, with same kernel version (except
> above commit reverted).

> execve("./ptytest", ["./ptytest"], [/* 7 vars */]) = 0
...
> open("/dev/ptmx", O_RDWR)         = -1 ENOSPC (No space left on device)
> open("/dev/ptyp0", O_RDWR)        = 3
> ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
> ioctl(3, TIOCGPTN, [0])           = -1 ENOTTY (Inappropriate ioctl for device)


getptsname expects EINVAL on failure to fall back to /dev/ttyp*... The
same as unlockpt. We should definitely revert now and can teach glibc to
accept also ENOTTY. After some years, we can try again :).

thanks,
-- 
js
suse labs
