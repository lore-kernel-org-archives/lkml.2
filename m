Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1LFWe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:34:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63825 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1LFWez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:34:55 -0500
Message-ID: <4EDE988B.6010501@suse.cz>
Date: Tue, 06 Dec 2011 23:34:51 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111130 Thunderbird/9.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: UV serial regression since 2.6.36
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In short, the issue causes serial port traffic to stop after some time
on UV machines. Only when serial is used as a console. It worked
perfectly with 2.6.32. It's a standard 16550 on 0x3f8 (well, it's
emulated to be at that port). Also in the PNP subsys.

To reproduce that 'debug' kernel parameter must not be used.

The root cause seems to be that the serial "chip" there has problems
with interrupts. It generates some but doesn't indicate it's the source
or somebody clears it (NOINT is set). And when it is supposed to
generate one (on THRE), it does not. So there are bytes in the TX buffer
which are never sent. Until the port is kicked e.g. by "echo h >
/proc/sysrq-trigger".

The unhandled interrupts were always an issue, but somehow hidden. It
became a real problem with patches post 2.6.32.

I bisected it to these two commits _together_:

commit 3f582b8c11014e4ce310d9839fb335164195333f
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Jun 29 22:31:40 2010 +0200

    serial: fix termios settings in open

AND

commit 74c2107759dc6efaa1b9127014be58a742a1e7ac
Author: Alan Cox <alan@linux.intel.com>
Date:   Tue Jun 1 22:53:00 2010 +0200

    serial: Use block_til_ready helper

Those reverted on the top of 2.6.37 makes it work again. Those reverted
on the top of 3.0 plus mine 3 reverted which removed update_set_termios
completely makes it work again.

I didn't look closely to why those patches are causing that. Like
c_cflag copy in uart_update_termios and "tty->termios->c_cflag & CBAUD"
test in tty_port_block_til_ready don't look good to me...

<rant from a person who spent with that bug 2 weeks :( >
I had to bisect three times. First to find a patch which allows booting
on <2.6.36 kernels on that machine. Second to narrow down the interval
-- it pointed to a merge commit. The third one to find the culprit.

The third one was unsuccessful because of two commits causing the issue.
Yes, hunting this crap

Now I'm going on vacation till the end of the year so I will be seldomly
responding.
</rant>

thanks,
-- 
js
suse labs
