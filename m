Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab1JQUkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:40:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43264 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab1JQUki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:40:38 -0400
Message-ID: <4E9C92C2.6000505@gmail.com>
Date: Mon, 17 Oct 2011 22:40:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Jiri Slaby <jslaby@suse.cz>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>
Subject: Re: WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x52/0x90()
 [3.0]
References: <20110828131502.GA2580@redhat.com> <4E5FF216.2020207@suse.cz> <CABqxG0c0wiaSXrLKCYc8Ef+uXEwkp=nuG+7-+pLoEEURkkDt=Q@mail.gmail.com>
In-Reply-To: <CABqxG0c0wiaSXrLKCYc8Ef+uXEwkp=nuG+7-+pLoEEURkkDt=Q@mail.gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2011 08:59 AM, Dave Young wrote:
> On Fri, Sep 2, 2011 at 4:59 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 08/28/2011 03:15 PM, Dave Jones wrote:
>>>
>>> Just saw this on a box that was recieving an rsync while I ssh'd in.
>>> The ssh session hung.
>>
>> Yes, could you apply the attached debug patch and post a dmesg output?
> 
> I see this problem as well, the debug patch reports the refcount is 2
> 
> You can produce the WARN as below:
> in xterm run:
> 
> exec 0<>/dev/console 1<>/dev/console 2<>/dev/console

Thanks for the info. I suppose your console is something where also some
getty runs. Then the warning is perfectly OK. And with the hunk below
constifying timing, I guess your system dies after the 5s timeout of
tty_ldisc_wait_idle. (You don't need to test the patch, just confirm
there is a getty running on the console.)

So actually I'm not sure what we should do there to not die. Perhaps
wait infinitely? Because the user wants to steal a terminal?


--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -49,6 +49,7 @@
 #include <linux/file.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
+#include <linux/delay.h>

 #include <asm/system.h>

@@ -1575,6 +1576,7 @@ static int n_tty_open(struct tty_struct *tty)

        /* These are ugly. Currently a malloc failure here can panic */
        if (!tty->read_buf) {
+               msleep(100);
                tty->read_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
                if (!tty->read_buf)
                        return -ENOMEM;
@@ -1815,6 +1817,7 @@ do_it_again:
                        /* FIXME: does n_tty_set_room need locking ? */
                        n_tty_set_room(tty);
                        timeout = schedule_timeout(timeout);
+                       msleep(20);
                        BUG_ON(!tty->read_buf);
                        continue;
                }


thanks,
-- 
js
