Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab0KABLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 21:11:07 -0400
Received: from mxout3.netvision.net.il ([194.90.6.2]:64972 "EHLO
	mxout3.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab0KABLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 21:11:02 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <4CCE140C.8050909@billauer.co.il>
Date: Mon, 01 Nov 2010 03:12:44 +0200
From: Eli Billauer <eli@billauer.co.il>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: open() on /dev/tty takes 30 seconds on 2.6.36
References: <4CCBCD8E.1020601@billauer.co.il>
 <20101030114634.b19c4e0c.akpm@linux-foundation.org>
 <4CCCB663.7010100@billauer.co.il> <201010310436.18613.arnd@arndb.de>
In-reply-to: <201010310436.18613.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me start with the headline: It's close() of a ttySx that takes 30 
seconds, during which the big TTY lock is held. Now to details.


Arnd Bergmann wrote:

> So modem-manager is the process you need to look at, as it holds the
> BTM, probably for a long time. It should not do that. First you should
> verify that when you don't have modem-manager running, the problem goes
> away. This may indeed be related to the misdetection of a serial port.
>   
That test is built-in: When modem-manager stops poking around, 
everything becomes fine again.
> The other thing to check is what modem-manager is actually doing. You can
> find out by looking at /proc/<pid>/stack, where <pid> is the pid of the
> modem-manager process, 1835 in your example.
>   
OK, so this is what I did eventually: I ran strace on sshd and 
modem-manager, and I also added printk's to tell me when tty_lock() is 
invoked, when it actually got the lock, and when tty_unlock() is 
invoked. Pretty messy, and still.

Let's start with sshd's strace. We have a
01:06:20.152787 open("/dev/tty", O_RDWR|O_NOCTTY) = -1 ENXIO (No such 
device or address) <30.008153>

And this is what we have in /var/log/messages:

Nov  1 01:06:20 ocho modem-manager: (ttyS2) closing serial device...
Nov  1 01:06:20 ocho kernel: tty_lock() called
Nov  1 01:06:20 ocho kernel: tty_lock() got lock
Nov  1 01:06:20 ocho kernel: tty_lock() called
Nov  1 01:06:50 ocho kernel: tty_unlock() called
Nov  1 01:06:50 ocho kernel: tty_lock() got lock
Nov  1 01:06:50 ocho kernel: tty_unlock() called
Nov  1 01:06:50 ocho kernel: tty_lock() called

So we can see that someone got the lock, and then didn't release it for 
30 seconds, and that someone else tried to get the lock and waited for 
it 30 seconds.

Here comes modem-manager's strace in the relevant time:
01:06:20.096730 sendto(3, "<29>Nov  1 01:06:20 modem-manager: (ttyS2) 
closing serial device...", 67, MSG_NOSIGNAL, NULL, 0) = 67 <0.000048>
01:06:20.096932 close(22)               = 0 <30.064112>
01:06:50.161255 ioctl(22, SNDCTL_TMR_START or TCSETS, {B9600 opost isig 
icanon echo ...}) = -1 EBADF (Bad file descriptor) <0.000132>

Surprise, surprise. modem-manager waits 30 seconds for a close() 
operation (maybe I should change this thread's subject?). But maybe 
modem-manager is waiting for someone else? Nope. In another part of 
modem-manager's strace we have:
01:05:50.001380 sendto(3, "<29>Nov  1 01:05:49 modem-manager: (ttyS1) 
closing serial device...", 67, MSG_NOSIGNAL, NULL, 0) = 67 <0.000237>
01:05:50.001765 close(21)               = 0 <30.064420>

Again (as always, actually), modem-manager waits 30 seconds for a 
close(). In /var/log/messages we have:
Nov  1 01:05:50 ocho modem-manager: (ttyS1) closing serial device...
Nov  1 01:05:50 ocho kernel: tty_lock() called
Nov  1 01:05:50 ocho kernel: tty_lock() got lock
Nov  1 01:05:54 ocho kernel: tty_lock() called
Nov  1 01:06:20 ocho kernel: tty_unlock() called

The last lock-related log entry was an unlock 9 seconds earlier. So it's 
clear that modem-manager's close() call got the lock right away, but 
held it for 30 seconds. In the middle we have some other process asking 
for the lock (and is put to wait).

An strace of modem-manager running under vanilla kernel 2.6.35-4 shows 
that close() takes 30 seconds there as well. It just so happens that it 
went unnoticed (maybe because of the changes in the locking schema?).

And in case we suspect that something special modem-manager did, I've 
attached the relevant piece of strace while handling some TTY. I've cut 
the log to cover a full cycle of a single TTY (file descriptor 21), but 
I chose not to omit the calls relevant to other ports, which are handled 
meanwhile.

I should only note that all TTY close() calls take 30 seconds, and that 
all ports get a ioctl() and extra close() after the file descriptor is 
closed, with an EBADF as response.

Trace follows. Hope this helps.
    Eli


01:06:20.067616 open("/dev/ttyS1", O_RDWR|O_EXCL|O_NOCTTY|O_NONBLOCK) = 
21 <0.020836>
01:06:20.088688 ioctl(21, TIOCEXCL, 0)  = 0 <0.000043>
01:06:20.088873 ioctl(21, TCFLSH, 0x2)  = 0 <0.000096>
01:06:20.089106 ioctl(21, SNDCTL_TMR_TIMEBASE or TCGETS, {B57600 -opost 
isig -icanon -echo ...}) = 0 <0.000098>
01:06:20.089377 ioctl(21, SNDCTL_TMR_TIMEBASE or TCGETS, {B57600 -opost 
isig -icanon -echo ...}) = 0 <0.000092>
01:06:20.089699 ioctl(21, SNDCTL_TMR_START or TCSETS, {B115200 -opost 
-isig -icanon -echo ...}) = 0 <0.000072>
01:06:20.089909 ioctl(21, SNDCTL_TMR_TIMEBASE or TCGETS, {B115200 -opost 
-isig -icanon -echo ...}) = 0 <0.000056>
01:06:20.090088 fstat(21, {st_mode=S_IFCHR|0660, st_rdev=makedev(4, 65), 
...}) = 0 <0.000091>
01:06:20.090294 fcntl(21, F_GETFL)      = 0x8802 (flags 
O_RDWR|O_NONBLOCK|O_LARGEFILE) <0.000088>
01:06:20.090515 poll([{fd=22, events=POLLIN}, {fd=23, events=POLLIN}, 
{fd=7, events=POLLIN}, {fd=8, events=POLLIN}, {fd=9, events=POLLIN}, 
{fd=10, events=POLLIN}, {fd=11, events=POLLIN}, {fd=12, events=POLLIN}, 
{fd=13, events=POLLIN}, {fd=14, events=POLLIN}, {fd=15, events=POLLIN}, 
{fd=16, events=POLLIN}, {fd=17, events=POLLIN}, {fd=18, events=POLLIN}, 
{fd=19, events=POLLIN}, {fd=20, events=POLLIN}, {fd=6, events=POLLIN}, 
{fd=5, events=POLLIN}, {fd=21, events=POLLIN}], 19, 0) = 0 (Timeout) 
<0.000034>
01:06:20.090752 poll([{fd=22, events=POLLIN}, {fd=23, events=POLLIN}, 
{fd=7, events=POLLIN}, {fd=8, events=POLLIN}, {fd=9, events=POLLIN}, 
{fd=10, events=POLLIN}, {fd=11, events=POLLIN}, {fd=12, events=POLLIN}, 
{fd=13, events=POLLIN}, {fd=14, events=POLLIN}, {fd=15, events=POLLIN}, 
{fd=16, events=POLLIN}, {fd=17, events=POLLIN}, {fd=18, events=POLLIN}, 
{fd=19, events=POLLIN}, {fd=20, events=POLLIN}, {fd=6, events=POLLIN}, 
{fd=5, events=POLLIN}, {fd=21, events=POLLIN}], 19, 0) = 0 (Timeout) 
<0.000032>
01:06:20.090916 write(21, "\0", 1)      = 1 <0.000028>
01:06:20.091012 nanosleep({0, 1000000}, NULL) = 0 <0.001152>
01:06:20.092246 write(21, "x", 1)       = 1 <0.000027>
01:06:20.092425 nanosleep({0, 1000000}, NULL) = 0 <0.001090>
01:06:20.093690 write(21, "\360", 1)    = 1 <0.000093>
01:06:20.093950 nanosleep({0, 1000000}, NULL) = 0 <0.001154>
01:06:20.095203 write(21, "~", 1)       = 1 <0.000094>
01:06:20.095389 nanosleep({0, 1000000}, NULL) = 0 <0.001144>
01:06:20.096730 sendto(3, "<29>Nov  1 01:06:20 modem-manager: (ttyS2) 
closing serial device...", 67, MSG_NOSIGNAL, NULL, 0) = 67 <0.000048>
01:06:20.096932 close(22)               = 0 <30.064112>
01:06:50.161255 ioctl(22, SNDCTL_TMR_START or TCSETS, {B9600 opost isig 
icanon echo ...}) = -1 EBADF (Bad file descriptor) <0.000132>
01:06:50.161623 close(22)               = -1 EBADF (Bad file descriptor) 
<0.000121>
01:06:50.162061 sendto(3, "<29>Nov  1 01:06:50 modem-manager: (ttyS2) 
opening serial device...", 67, MSG_NOSIGNAL, NULL, 0) = 67 <0.000165>
01:06:50.162465 open("/dev/ttyS2", O_RDWR|O_EXCL|O_NOCTTY|O_NONBLOCK) = 
22 <0.020821>
01:06:50.183512 ioctl(22, TIOCEXCL, 0)  = 0 <0.000163>
01:06:50.183894 ioctl(22, TCFLSH, 0x2)  = 0 <0.000102>
01:06:50.184121 ioctl(22, SNDCTL_TMR_TIMEBASE or TCGETS, {B57600 -opost 
isig -icanon -echo ...}) = 0 <0.000090>
01:06:50.184374 ioctl(22, SNDCTL_TMR_TIMEBASE or TCGETS, {B57600 -opost 
isig -icanon -echo ...}) = 0 <0.000092>
01:06:50.184631 ioctl(22, SNDCTL_TMR_START or TCSETS, {B115200 -opost 
-isig -icanon -echo ...}) = 0 <0.000050>
01:06:50.184768 ioctl(22, SNDCTL_TMR_TIMEBASE or TCGETS, {B115200 -opost 
-isig -icanon -echo ...}) = 0 <0.000074>
01:06:50.184934 fstat(22, {st_mode=S_IFCHR|0660, st_rdev=makedev(4, 66), 
...}) = 0 <0.000020>
01:06:50.185040 fcntl(22, F_GETFL)      = 0x8802 (flags 
O_RDWR|O_NONBLOCK|O_LARGEFILE) <0.000020>
01:06:50.185237 sendto(3, "<29>Nov  1 01:06:50 modem-manager: (ttyS3) 
closing serial device...", 67, MSG_NOSIGNAL, NULL, 0) = 67 <0.000026>
01:06:50.185358 close(23)               = 0 <30.063507>
01:07:20.248957 ioctl(23, SNDCTL_TMR_START or TCSETS, {B9600 opost isig 
icanon echo ...}) = -1 EBADF (Bad file descriptor) <0.000025>
01:07:20.249074 close(23)               = -1 EBADF (Bad file descriptor) 
<0.000020>
01:07:20.249242 sendto(3, "<29>Nov  1 01:07:20 modem-manager: (ttyS3) 
opening serial device...", 67, MSG_NOSIGNAL, NULL, 0) = 67 <0.000050>
01:07:20.249397 open("/dev/ttyS3", O_RDWR|O_EXCL|O_NOCTTY|O_NONBLOCK) = 
23 <0.021043>
01:07:20.270531 ioctl(23, TIOCEXCL, 0)  = 0 <0.000031>
01:07:20.270628 ioctl(23, TCFLSH, 0x2)  = 0 <0.000104>
01:07:20.270816 ioctl(23, SNDCTL_TMR_TIMEBASE or TCGETS, {B57600 -opost 
isig -icanon -echo ...}) = 0 <0.000029>
01:07:20.270940 ioctl(23, SNDCTL_TMR_TIMEBASE or TCGETS, {B57600 -opost 
isig -icanon -echo ...}) = 0 <0.000023>
01:07:20.271039 ioctl(23, SNDCTL_TMR_START or TCSETS, {B115200 -opost 
-isig -icanon -echo ...}) = 0 <0.000032>
01:07:20.271147 ioctl(23, SNDCTL_TMR_TIMEBASE or TCGETS, {B115200 -opost 
-isig -icanon -echo ...}) = 0 <0.000023>
01:07:20.271248 fstat(23, {st_mode=S_IFCHR|0660, st_rdev=makedev(4, 67), 
...}) = 0 <0.000022>
01:07:20.271362 fcntl(23, F_GETFL)      = 0x8802 (flags 
O_RDWR|O_NONBLOCK|O_LARGEFILE) <0.000021>
01:07:20.271494 poll([{fd=7, events=POLLIN}, {fd=8, events=POLLIN}, 
{fd=9, events=POLLIN}, {fd=10, events=POLLIN}, {fd=11, events=POLLIN}, 
{fd=12, events=POLLIN}, {fd=13, events=POLLIN}, {fd=14, events=POLLIN}, 
{fd=15, events=POLLIN}, {fd=16, events=POLLIN}, {fd=17, events=POLLIN}, 
{fd=18, events=POLLIN}, {fd=19, events=POLLIN}, {fd=20, events=POLLIN}, 
{fd=6, events=POLLIN}, {fd=5, events=POLLIN}, {fd=21, events=POLLIN}, 
{fd=22, events=POLLIN}, {fd=23, events=POLLIN}], 19, 0) = 0 (Timeout) 
<0.000031>
01:07:20.271666 poll([{fd=7, events=POLLIN}, {fd=8, events=POLLIN}, 
{fd=9, events=POLLIN}, {fd=10, events=POLLIN}, {fd=11, events=POLLIN}, 
{fd=12, events=POLLIN}, {fd=13, events=POLLIN}, {fd=14, events=POLLIN}, 
{fd=15, events=POLLIN}, {fd=16, events=POLLIN}, {fd=17, events=POLLIN}, 
{fd=18, events=POLLIN}, {fd=19, events=POLLIN}, {fd=20, events=POLLIN}, 
{fd=6, events=POLLIN}, {fd=5, events=POLLIN}, {fd=21, events=POLLIN}, 
{fd=22, events=POLLIN}, {fd=23, events=POLLIN}], 19, 0) = 0 (Timeout) 
<0.000042>
01:07:20.271868 write(22, "\0", 1)      = 1 <0.000040>
01:07:20.271983 nanosleep({0, 1000000}, NULL) = 0 <0.001189>
01:07:20.273259 write(22, "x", 1)       = 1 <0.000041>
01:07:20.273378 nanosleep({0, 1000000}, NULL) = 0 <0.001188>
01:07:20.274653 write(22, "\360", 1)    = 1 <0.000036>
01:07:20.274807 nanosleep({0, 1000000}, NULL) = 0 <0.001193>
01:07:20.276086 write(22, "~", 1)       = 1 <0.000035>
01:07:20.276213 nanosleep({0, 1000000}, NULL) = 0 <0.001190>
01:07:20.277509 write(23, "\0", 1)      = 1 <0.000039>
01:07:20.277626 nanosleep({0, 1000000}, NULL) = 0 <0.001189>
01:07:20.278900 write(23, "x", 1)       = 1 <0.000035>
01:07:20.279011 nanosleep({0, 1000000}, NULL) = 0 <0.001192>
01:07:20.280288 write(23, "\360", 1)    = 1 <0.000039>
01:07:20.280404 nanosleep({0, 1000000}, NULL) = 0 <0.001193>
01:07:20.281695 write(23, "~", 1)       = 1 <0.000039>
01:07:20.281814 nanosleep({0, 1000000}, NULL) = 0 <0.001191>
01:07:20.283113 write(21, "\0", 1)      = 1 <0.000039>
01:07:20.283232 nanosleep({0, 1000000}, NULL) = 0 <0.001190>
01:07:20.284506 write(21, "x", 1)       = 1 <0.000034>
01:07:20.284615 nanosleep({0, 1000000}, NULL) = 0 <0.001189>
01:07:20.285888 write(21, "\360", 1)    = 1 <0.000040>
01:07:20.286005 nanosleep({0, 1000000}, NULL) = 0 <0.001186>
01:07:20.287276 write(21, "~", 1)       = 1 <0.000040>
01:07:20.287392 nanosleep({0, 1000000}, NULL) = 0 <0.001186>
01:07:20.288690 poll([{fd=7, events=POLLIN}, {fd=8, events=POLLIN}, 
{fd=9, events=POLLIN}, {fd=10, events=POLLIN}, {fd=11, events=POLLIN}, 
{fd=12, events=POLLIN}, {fd=13, events=POLLIN}, {fd=14, events=POLLIN}, 
{fd=15, events=POLLIN}, {fd=16, events=POLLIN}, {fd=17, events=POLLIN}, 
{fd=18, events=POLLIN}, {fd=19, events=POLLIN}, {fd=20, events=POLLIN}, 
{fd=6, events=POLLIN}, {fd=5, events=POLLIN}, {fd=21, events=POLLIN}, 
{fd=22, events=POLLIN}, {fd=23, events=POLLIN}], 19, 3000) = 0 (Timeout) 
<3.003405>
01:07:23.292250 poll([{fd=7, events=POLLIN}, {fd=8, events=POLLIN}, 
{fd=9, events=POLLIN}, {fd=10, events=POLLIN}, {fd=11, events=POLLIN}, 
{fd=12, events=POLLIN}, {fd=13, events=POLLIN}, {fd=14, events=POLLIN}, 
{fd=15, events=POLLIN}, {fd=16, events=POLLIN}, {fd=17, events=POLLIN}, 
{fd=18, events=POLLIN}, {fd=19, events=POLLIN}, {fd=20, events=POLLIN}, 
{fd=6, events=POLLIN}, {fd=5, events=POLLIN}, {fd=21, events=POLLIN}, 
{fd=22, events=POLLIN}, {fd=23, events=POLLIN}], 19, 707) = 0 (Timeout) 
<0.707898>
01:07:24.000331 poll([{fd=7, events=POLLIN}, {fd=8, events=POLLIN}, 
{fd=9, events=POLLIN}, {fd=10, events=POLLIN}, {fd=11, events=POLLIN}, 
{fd=12, events=POLLIN}, {fd=13, events=POLLIN}, {fd=14, events=POLLIN}, 
{fd=15, events=POLLIN}, {fd=16, events=POLLIN}, {fd=17, events=POLLIN}, 
{fd=18, events=POLLIN}, {fd=19, events=POLLIN}, {fd=20, events=POLLIN}, 
{fd=6, events=POLLIN}, {fd=5, events=POLLIN}, {fd=21, events=POLLIN}, 
{fd=22, events=POLLIN}, {fd=23, events=POLLIN}], 19, 0) = 0 (Timeout) 
<0.000044>
01:07:24.000506 write(22, "\0", 1)      = 1 <0.000038>
01:07:24.000620 nanosleep({0, 1000000}, NULL) = 0 <0.001209>
01:07:24.001914 write(22, "x", 1)       = 1 <0.000039>
01:07:24.002028 nanosleep({0, 1000000}, NULL) = 0 <0.001208>
01:07:24.003320 write(22, "\360", 1)    = 1 <0.000035>
01:07:24.003434 nanosleep({0, 1000000}, NULL) = 0 <0.001207>
01:07:24.004743 write(22, "~", 1)       = 1 <0.000036>
01:07:24.004867 nanosleep({0, 1000000}, NULL) = 0 <0.001189>
01:07:24.006171 write(23, "\0", 1)      = 1 <0.000039>
01:07:24.006300 nanosleep({0, 1000000}, NULL) = 0 <0.001177>
01:07:24.007571 write(23, "x", 1)       = 1 <0.000034>
01:07:24.007696 nanosleep({0, 1000000}, NULL) = 0 <0.001189>
01:07:24.008988 write(23, "\360", 1)    = 1 <0.000034>
01:07:24.009113 nanosleep({0, 1000000}, NULL) = 0 <0.001191>
01:07:24.010402 write(23, "~", 1)       = 1 <0.000034>
01:07:24.010526 nanosleep({0, 1000000}, NULL) = 0 <0.001192>
01:07:24.011859 sendto(3, "<29>Nov  1 01:07:24 modem-manager: (ttyS1) 
closing serial device...", 67, MSG_NOSIGNAL, NULL, 0) = 67 <0.000084>
01:07:24.012044 close(21)               = 0 <30.063920>
01:07:54.076064 ioctl(21, SNDCTL_TMR_START or TCSETS, {B57600 -opost 
isig -icanon -echo ...}) = -1 EBADF (Bad file descriptor) <0.000021>
01:07:54.076186 close(21)               = -1 EBADF (Bad file descriptor) 
<0.000019>

-- 
Web: http://www.billauer.co.il

