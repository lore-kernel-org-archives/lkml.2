Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab1LWSqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 13:46:46 -0500
Received: from mx2.compro.net ([12.186.155.4]:38141 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566Ab1LWSqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 13:46:44 -0500
X-IronPort-AV: E=Sophos;i="4.71,400,1320642000"; 
   d="scan'208";a="7422823"
Message-ID: <4EF4CC92.5090502@compro.net>
Date: Fri, 23 Dec 2011 13:46:42 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: markh@compro.net
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: tty  TTY_HUPPED anomaly
References: <4EF49579.9040907@compro.net>
In-Reply-To: <4EF49579.9040907@compro.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2011 09:51 AM, Mark Hounschell wrote:
> I have an application that has seemingly been stable for many years and
> even using the 3.1.1 kernel all is fine. I'm using the openSuSE
> distribution. All is good with the openSuSE-11.4 dist and the 3.1.1
> kernel. We recently started testing this application on openSuSE-12.1
> using the same vanilla 3.1.1 kernel and now we have problems with just
> about all out tty/serial related devices that we use. I thought the
> problem maybe an openSuSE glibc problem so I built and ran the
> openSuSE-12.1 version of glibc on the openSuSE-11.4 dist but the
> application worked just fine. So I started looking at the kernel and one
> of our serial devices that fails. I choose the Synclink GT because its
> driver is "in kernel".
>
> In our application with this particular card, the following TIOCSETD
> ioctl is this code snippet fails most of the time.
>
> int32_t hdlc_disc = N_HDLC;
>
> Q->fd = open(Q->FileName, (O_RDWR | O_NONBLOCK), 0);
>
> if (Q->fd < 0)
> return (FALSE);
>
> Q->File = fdopen(Q->fd, "rw");
>
> fcntl(Q->fd, F_SETFL, fcntl(S->fd,F_GETFL) & ~O_NONBLOCK);
>
> if (ioctl(Q->fd, TIOCSETD, &hdlc_disc) < 0) {
> perror("SCM_open_port: TIOCSETD failed: ");
> return (FALSE);
> }
>
>
> The kernel code that results in the above code snippet failure is the
> following section of the tty_set_ldisc function in tty_io.c.
>
> if (test_bit(TTY_HUPPED, &tty->flags)) {
> /* We were raced by the hangup method. It will have stomped
> the ldisc data and closed the ldisc down */
> clear_bit(TTY_LDISC_CHANGING, &tty->flags);
> mutex_unlock(&tty->ldisc_mutex);
> tty_ldisc_put(new_ldisc);
> tty_unlock();
> return -EIO;
> }
>
> I do not really understand what TTY_HUPPED is or how it could be getting
> set. I look at it when the tty_set_ldisc function is entered and it is
> not set. Some where between entrance of the tty_set_ldisc and getting to
> the above code TTY_HUPPED gets set causing the -EIO return.
>
> I see nothing in my code that should cause this to happen. At start up
> time a thread for each port used does this then goes to sleep. Again, I
> can't understand why now with openSuSE-12.1 this starts happening. Can
> someone help me understand why this might happen. I don't know if it is
> me, the dist, or the kernel. Frequently it all works at startup and will
> eventually fail during operation.
>
> Other serial cards that I also have similar problems with (different
> ioctls) are various Digi serial cards. I haven't look into the kernel to
> see what is happening with those as yet but am sure the problem is
> related. Sometimes they work, most of the time they do not.
>

More info:

I turned the TTY_DEBUG_HANGUP and added some additional printks. You see 
below the first port works just fine but the second fails because 
something is calling the tty_hangup function around 70usecs after I open 
the device???
What and Why???


Dec 23 13:36:19 harley kernel: [ 1139.456286] tty_open: opening ttySLG0...
Dec 23 13:36:19 harley kernel: [ 1139.456357] tiocsetd: Entered. tty = 
0xe6b60c00  p = 0x0000000d tty->flags = 0x00000a00
Dec 23 13:36:19 harley kernel: [ 1139.456359] tiocsetd: setting tty 
ldisc to 0x0000000d
Dec 23 13:36:19 harley kernel: [ 1139.456361] tty_set_ldisc: Entered. 
tty = 0xe6b60c00 ldisk = 0x0000000d tty->flags = 0x00000a00 TTY_HUPPED = 
0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.456363] tty_set_ldisc: 
TTY_HUPPED-a = 0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.456364] tty_set_ldisc: 
TTY_HUPPED-b = 0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.456365] tty_set_ldisc: 
TTY_HUPPED-0 = 0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.456368] tty_set_ldisc: 
TTY_HUPPED-1 = 0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.456369] tty_set_ldisc: 
TTY_HUPPED-2 = 0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.456370] tty_set_ldisc: 
TTY_HUPPED-3 = 0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.456373] tty_set_ldisc: retval from 
tty_ldisc_wait_idle = 0x00000000 TTY_HUPPED = 0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.456384] tty_set_ldisc: returning 
0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.456385] tiocsetd: Complete. ret = 
0x00000000


Dec 23 13:36:19 harley kernel: [ 1139.458194] tty_open: opening ttySLG1...
Dec 23 13:36:19 harley kernel: [ 1139.458270] tty_hangup: ttySLG1 hangup...
Dec 23 13:36:19 harley kernel: [ 1139.458274] tiocsetd: Entered. tty = 
0xe6b60800  p = 0x0000000d tty->flags = 0x00000a00
Dec 23 13:36:19 harley kernel: [ 1139.458276] tiocsetd: setting tty 
ldisc to 0x0000000d
Dec 23 13:36:19 harley kernel: [ 1139.458278] tty_set_ldisc: Entered. 
tty = 0xe6b60800 ldisk = 0x0000000d tty->flags = 0x00000a00 TTY_HUPPED = 
0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.458281] tty_set_ldisc: 
TTY_HUPPED-a = 0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.458283] tty_set_ldisc: 
TTY_HUPPED-b = 0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.458284] tty_set_ldisc: 
TTY_HUPPED-0 = 0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.458288] tty_set_ldisc: 
TTY_HUPPED-1 = 0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.458289] tty_set_ldisc: 
TTY_HUPPED-2 = 0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.458290] tty_set_ldisc: 
TTY_HUPPED-3 = 0x00000000
Dec 23 13:36:19 harley kernel: [ 1139.458307] tty_hangup: ttySLG1 hangup...
Dec 23 13:36:19 harley kernel: [ 1139.458309] __tty_hangup: Entered for 
tty = 0xe6b60800
Dec 23 13:36:19 harley kernel: [ 1139.458340] __tty_hangup: Setting 
TTY_HUPPED for tty at 0xe6b60800
Dec 23 13:36:19 harley kernel: [ 1139.458347] tty_set_ldisc: retval from 
tty_ldisc_wait_idle = 0x00000000 TTY_HUPPED = 0x00040000
Dec 23 13:36:19 harley kernel: [ 1139.458349] tty_set_ldisc: tty->flags 
= 0x00040a02 TTY_HUPPED = 0x00040000 returning -EIO
Dec 23 13:36:19 harley kernel: [ 1139.458350] tiocsetd: Complete. ret = 
0xfffffffb


Thanks again for any help on this
Regards
Mark


