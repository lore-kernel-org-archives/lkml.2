Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab2DSOWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 10:22:37 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:37670 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab2DSOWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 10:22:35 -0400
Message-ID: <4F901FA9.90107@msgid.tls.msk.ru>
Date: Thu, 19 Apr 2012 18:22:33 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: A very old issue: stalling serial ports
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is something that exists since 2.4 kernel I think.

When any regular serial port is written, but no device
is connected to the port, the application which does
write becomes stuck in kernel mode somewhere, and may
be there for a very long time, unkillable.

Just a trivial

 echo foo > /dev/ttyS0

will sleep for a long time, unkillable.

This happens on close of the device.

Here's a typical call trace of this:

[  591.497867] bash            S c1218130     0  1457   1453 0x00000000
[  591.497965]  f6c725e0 00000082 c14d77c0 c1218130 00000246 c121a4ed 00000287 f65080f0
[  591.498229]  f7005b40 c145cb40 c145cb40 ec834119 00000087 c145cb40 f65080f0 c145cb40
[  591.498492]  f6feb008 00000000 c1218735 c1216302 00000000 f6feb000 00000000 f65080f0
[  591.498755] Call Trace:
[  591.498797]  [<c1218130>] ? serial8250_set_mctrl+0x60/0x70
[  591.498844]  [<c121a4ed>] ? serial8250_do_set_termios+0x2ad/0x3c0
[  591.498891]  [<c1218735>] ? serial8250_get_mctrl+0x5/0x40
[  591.498937]  [<c1216302>] ? uart_startup+0xe2/0x190
[  591.498983]  [<c105f850>] ? wake_up_bit+0x60/0x60
[  591.499028]  [<c12edf8a>] ? tty_lock+0x1a/0x33
[  591.499072]  [<c104ffe7>] ? lock_timer_base+0x27/0x50
[  591.499119]  [<c12ec856>] ? schedule_timeout+0x126/0x250
[  591.499164]  [<c10501a0>] ? del_timer+0xa0/0xa0
[  591.499210]  [<c1216fd0>] ? uart_close+0x170/0x2f0
[  591.499255]  [<c105f850>] ? wake_up_bit+0x60/0x60
[  591.499300]  [<c11feba0>] ? tty_release+0xf0/0x4e0
[  591.499345]  [<c12153d4>] ? uart_start+0x24/0x90
[  591.499391]  [<c105fb07>] ? remove_wait_queue+0x17/0x50
[  591.499436]  [<c1034bc2>] ? __wake_up+0x42/0x60
[  591.499482]  [<c10febfd>] ? fput+0xad/0x220
[  591.499526]  [<c10fb41d>] ? filp_close+0x4d/0x80

Now, depending on the kernel and/or on actual sequence of events --
I don't really know yet -- sometimes the app is stuck but is actually
killable, sometimes it "unstucks" by its own after some time (a
minute or two), sometimes it becomes unkillable forever.

To me it does not look like a feature, but I might be wrong.

Is it a rigth behavour?

Thank you!

/mjt
