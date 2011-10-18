Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab1JRBZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:25:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53230 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab1JRBZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:25:03 -0400
MIME-Version: 1.0
In-Reply-To: <4E9C92C2.6000505@gmail.com>
References: <20110828131502.GA2580@redhat.com>
	<4E5FF216.2020207@suse.cz>
	<CABqxG0c0wiaSXrLKCYc8Ef+uXEwkp=nuG+7-+pLoEEURkkDt=Q@mail.gmail.com>
	<4E9C92C2.6000505@gmail.com>
Date: Tue, 18 Oct 2011 09:25:02 +0800
Message-ID: <CABqxG0cPHVEG5XU9M+eNrgo7nvnhTxL4wHRFdEtpaUjhwcY2Nw@mail.gmail.com>
Subject: Re: WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x52/0x90()
 [3.0]
From: Dave Young <hidave.darkstar@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 4:40 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 10/09/2011 08:59 AM, Dave Young wrote:
>> On Fri, Sep 2, 2011 at 4:59 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>> On 08/28/2011 03:15 PM, Dave Jones wrote:
>>>>
>>>> Just saw this on a box that was recieving an rsync while I ssh'd in.
>>>> The ssh session hung.
>>>
>>> Yes, could you apply the attached debug patch and post a dmesg output?
>>
>> I see this problem as well, the debug patch reports the refcount is 2
>>
>> You can produce the WARN as below:
>> in xterm run:
>>
>> exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
>
> Thanks for the info. I suppose your console is something where also some
> getty runs. Then the warning is perfectly OK. And with the hunk below
> constifying timing, I guess your system dies after the 5s timeout of
> tty_ldisc_wait_idle. (You don't need to test the patch, just confirm
> there is a getty running on the console.)

I just startx from tty1

bash-4.1$ ps ax|grep getty
 1626 tty2     Ss+    0:00 /sbin/agetty 38400 tty2 linux
 1627 tty3     Ss+    0:00 /sbin/agetty 38400 tty3 linux
 1628 tty4     Ss+    0:00 /sbin/agetty 38400 tty4 linux
 1629 tty5     Ss+    0:00 /sbin/agetty 38400 tty5 linux
 1630 tty6     Ss+    0:00 /sbin/agetty 38400 tty6 linux
 3586 tty1     Ss+    0:00 /sbin/agetty 38400 tty1 linux
 5928 pts/1    S+     0:00 grep getty

What do you means of "die"? X11 died indeed as I saw.

>
> So actually I'm not sure what we should do there to not die. Perhaps
> wait infinitely? Because the user wants to steal a terminal?
>
>
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -49,6 +49,7 @@
>  #include <linux/file.h>
>  #include <linux/uaccess.h>
>  #include <linux/module.h>
> +#include <linux/delay.h>
>
>  #include <asm/system.h>
>
> @@ -1575,6 +1576,7 @@ static int n_tty_open(struct tty_struct *tty)
>
>        /* These are ugly. Currently a malloc failure here can panic */
>        if (!tty->read_buf) {
> +               msleep(100);
>                tty->read_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
>                if (!tty->read_buf)
>                        return -ENOMEM;
> @@ -1815,6 +1817,7 @@ do_it_again:
>                        /* FIXME: does n_tty_set_room need locking ? */
>                        n_tty_set_room(tty);
>                        timeout = schedule_timeout(timeout);
> +                       msleep(20);
>                        BUG_ON(!tty->read_buf);
>                        continue;
>                }
>
>
> thanks,
> --
> js
>



-- 
Regards
Dave
