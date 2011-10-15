Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1JONMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 09:12:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65374 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1JONMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 09:12:44 -0400
MIME-Version: 1.0
In-Reply-To: <4E994A65.7000509@suse.cz>
References: <CAB4+JYLiF4wr+U5s_m15baC=Ktf8NnAYFKfcyhM3AxG9PZ4YPA@mail.gmail.com>
	<CAB4+JYJYVFouMYZMX4bGVA+vPm1rD3KY3GvwVjKBZS7bwf6-zQ@mail.gmail.com>
	<CAB4+JYLjjdo_nmwPqWTmd9YFk=4x4AVcprr-b7LoEc9JDqGthQ@mail.gmail.com>
	<4E994A65.7000509@suse.cz>
Date: Sat, 15 Oct 2011 09:12:42 -0400
Message-ID: <CAB4+JYKvhDqJKjXr8HYKuZtN3Z1RiHJTAB3uAGMrZtNSj1_fTA@mail.gmail.com>
Subject: Re: Q.: Why does tty_ioctl.c: set_termios return EINTR instead of ERESTARTSYS?
From: Godmar Back <godmar@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 4:55 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>
> On 10/14/2011 06:52 PM, Godmar Back wrote:
> > A student in my OS class noticed during their shell assignment that
> > tcsetattr() is being interrupted with EINTR even though they had set
> > SA_RESTART.
> >
> > Upon taking a closer look, I noticed that
> > drivers/char/tty_ioctl.c:set_termios(), which lies on the code path
> > for the POSIX tcsetattr() function, returns -EINTR when a signal is
> > pending. Consequently, the SA_RESTART flag is not honored and user
> > code must check for and handle EINTR.
> >
> > I don't immediately see what would prevent this system call from being
> > restartable.
> >
> > Is there a particular reason why it cannot be made restartable?
>
> EINTR is used when there is no way to rollback already performed
> actions. In this case, a flush could be performed. (This holds only for
> TCSETSF, TCSETSF2 and similar.) So I think this is the reason we cannot
> return ERESTARTSYS.

TCSETSF flushes the terminal buffer (discarding input).

TCSETSW (which I believe is what the call I'm worried about uses:
tcsetattr(, TCSADRAIN,)) calls set_termios with TERMIOS_WAIT, which
results in a call to tty_wait_until_sent() that drains the terminal's
output buffer. See
http://lxr.linux.no/linux+v3.0.4/drivers/tty/tty_ioctl.c#L616

However, why would that necessitate EINTR?  Both draining the output
buffer and flushing the input buffer are, presumably, idempotent
operations (?)

Furthermore, applications will most likely blindly retry on EINTR
anyway. For example, that's what user mode linux does/suggests (see
CATCH_EINTR in http://lxr.linux.no/linux+v3.0.4/arch/um/include/shared/os.h#L15
and http://lxr.linux.no/linux+v3.0.4/arch/um/drivers/chan_user.c#L108
) which is included with the Linux source tree.

 - Godmar
