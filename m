Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0JaATL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 20:19:11 -0400
Received: from mxout3.netvision.net.il ([194.90.6.2]:37443 "EHLO
	mxout3.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab0JaATJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 20:19:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <4CCCB663.7010100@billauer.co.il>
Date: Sun, 31 Oct 2010 02:20:51 +0200
From: Eli Billauer <eli@billauer.co.il>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: open() on /dev/tty takes 30 seconds on 2.6.36
References: <4CCBCD8E.1020601@billauer.co.il>
 <20101030114634.b19c4e0c.akpm@linux-foundation.org>
In-reply-to: <20101030114634.b19c4e0c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> Odd.  Presumably someone else was holding big_tty_mutex for 15 seconds.
>
> We can find out who, with the sysrq-d command if you have the time
> please.  You'll need to enable lockdep and magic sysrq in .config. 
> Then run `dmesg -n 8' so all messages get printed by the kernel and
> then, in the middle of that 15-second delay, do
>
> 	echo d > /proc/sysrq-trigger
>
> I'll confess that I've never used sysrq-d and am unsure what the output
> looks like.  Fingers crossed!
>   

First, I'll explain what I did: Since I can't login while this problem 
occurs, I had to modify sshd's service script to start sshd with strace, 
and also kick off a script (called who-is-locking.sh), which creates 
that sysrq call every five seconds. This could also be the place to 
mention, that I got an NULL dereference oops during one of these (IP at 
get_usage_chars+0x0/0x10e, while in the who-is-locking process). But 
that happened after the desired data was logged.

Now, let's look at the interesting point of the strace (of sshd):

01:23:37.156475 open("/dev/tty", O_RDWR|O_NOCTTY) = -1 ENXIO (No such 
device or address) <29.999444>
01:24:07.156354 setsid()                = 2336 <0.000167>

The same open() taking 30 seconds, ending at 01:24:07. In 
/var/log/messages (below) we have
Oct 31 01:24:07 ocho modem-manager: (ttyS2) opening serial device...
Oct 31 01:24:07 ocho modem-manager: (ttyS3) closing serial device...

The same things happens again, when ssh opens /dev/pts/0, which takes 30 
seconds again, with the end of operation coinciding with modem-manager 
opening a tty device.

As far as I know, there is only one real serial port on my computer. 
Maybe this snippet from my boot log may be of interest:

Oct 31 01:14:28 ocho kernel: Serial: 8250/16550 driver, 4 ports, IRQ 
sharing enabled
Oct 31 01:14:28 ocho kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is 
a 16550A
Oct 31 01:14:28 ocho kernel: 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Oct 31 01:14:28 ocho kernel: serial 0000:05:04.0: PCI INT A -> GSI 16 
(level, low) -> IRQ 16
Oct 31 01:14:28 ocho kernel: 0000:05:04.0: ttyS1 at I/O 0xbe20 (irq = 
16) is a 8250
Oct 31 01:14:28 ocho kernel: 0000:05:04.0: ttyS2 at I/O 0xbe28 (irq = 
16) is a 8250
Oct 31 01:14:28 ocho kernel: 0000:05:04.0: ttyS3 at I/O 0xbe40 (irq = 
16) is a 8250
Oct 31 01:14:28 ocho kernel: Couldn't register serial port 0000:05:04.0: -28

Below is /var/log/message dump for the relevant time interval. I can 
submit more if necessary, but I think the picture is pretty clear.

Hope this helps,
    Eli

Oct 31 01:23:59 ocho kernel: =============================================
Oct 31 01:23:59 ocho kernel:
Oct 31 01:24:04 ocho kernel: SysRq : Show Locks Held
Oct 31 01:24:04 ocho kernel:
Oct 31 01:24:04 ocho kernel: Showing all locks held in the system:
Oct 31 01:24:04 ocho kernel: 2 locks held by modem-manager/1835:
Oct 31 01:24:04 ocho kernel: #0:  (big_tty_mutex){+.+.+.}, at: 
[<ffffffff814b9c09>] tty_lock+0x3f/0x4a
Oct 31 01:24:04 ocho kernel: #1:  (&port->mutex){+.+.+.}, at: 
[<ffffffff812fcace>] uart_close+0x82/0x312
Oct 31 01:24:04 ocho kernel: 2 locks held by who-is-locking./1850:
Oct 31 01:24:04 ocho kernel: #0:  (sysrq_key_table_lock){......}, at: 
[<ffffffff812e97de>] __handle_sysrq+0x28/0x15b
Oct 31 01:24:04 ocho kernel: #1:  (tasklist_lock){.?.+..}, at: 
[<ffffffff810798a5>] debug_show_all_locks+0x4c/0x178
Oct 31 01:24:04 ocho kernel: 1 lock held by gpm/1971:
Oct 31 01:24:04 ocho kernel: #0:  (tty_mutex){+.+.+.}, at: 
[<ffffffff812d5903>] tty_open+0x5a/0x4ac
Oct 31 01:24:04 ocho kernel: 1 lock held by mingetty/2125:
Oct 31 01:24:04 ocho kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: 
[<ffffffff812d7648>] n_tty_read+0x281/0x7b4
Oct 31 01:24:04 ocho kernel: 1 lock held by mingetty/2126:
Oct 31 01:24:04 ocho kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: 
[<ffffffff812d7648>] n_tty_read+0x281/0x7b4
Oct 31 01:24:04 ocho kernel: 1 lock held by mingetty/2127:
Oct 31 01:24:04 ocho kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: 
[<ffffffff812d7648>] n_tty_read+0x281/0x7b4
Oct 31 01:24:04 ocho kernel: 1 lock held by mingetty/2128:
Oct 31 01:24:04 ocho kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: 
[<ffffffff812d7648>] n_tty_read+0x281/0x7b4
Oct 31 01:24:04 ocho kernel: 1 lock held by mingetty/2129:
Oct 31 01:24:04 ocho kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: 
[<ffffffff812d7648>] n_tty_read+0x281/0x7b4
Oct 31 01:24:04 ocho kernel: 2 locks held by sshd/2336:
Oct 31 01:24:04 ocho kernel: #0:  (tty_mutex){+.+.+.}, at: 
[<ffffffff812d5903>] tty_open+0x5a/0x4ac
Oct 31 01:24:04 ocho kernel: #1:  (big_tty_mutex){+.+.+.}, at: 
[<ffffffff814b9c09>] tty_lock+0x3f/0x4a
Oct 31 01:24:04 ocho kernel:
Oct 31 01:24:04 ocho kernel: =============================================
Oct 31 01:24:04 ocho kernel:
Oct 31 01:24:07 ocho modem-manager: (ttyS2) opening serial device...
Oct 31 01:24:07 ocho modem-manager: (ttyS3) closing serial device...
Oct 31 01:24:09 ocho kernel: SysRq : Show Locks Held
Oct 31 01:24:09 ocho kernel:
Oct 31 01:24:09 ocho kernel: Showing all locks held in the system:
Oct 31 01:24:09 ocho kernel: 2 locks held by modem-manager/1835:
Oct 31 01:24:09 ocho kernel: #0:  (big_tty_mutex){+.+.+.}, at: 
[<ffffffff814b9c09>] tty_lock+0x3f/0x4a
Oct 31 01:24:09 ocho kernel: #1:  (&port->mutex){+.+.+.}, at: 
[<ffffffff812fcace>] uart_close+0x82/0x312
Oct 31 01:24:09 ocho kernel: 2 locks held by who-is-locking./1850:
Oct 31 01:24:09 ocho kernel: #0:  (sysrq_key_table_lock){......}, at: 
[<ffffffff812e97de>] __handle_sysrq+0x28/0x15b
Oct 31 01:24:09 ocho kernel: #1:  (tasklist_lock){.?.+..}, at: 
[<ffffffff810798a5>] debug_show_all_locks+0x4c/0x178
Oct 31 01:24:09 ocho kernel: 1 lock held by gpm/1971:
Oct 31 01:24:09 ocho kernel: #0:  (tty_mutex){+.+.+.}, at: 
[<ffffffff812d5903>] tty_open+0x5a/0x4ac
Oct 31 01:24:09 ocho kernel: 1 lock held by mingetty/2125:
Oct 31 01:24:09 ocho kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: 
[<ffffffff812d7648>] n_tty_read+0x281/0x7b4
Oct 31 01:24:09 ocho kernel: 1 lock held by mingetty/2126:
Oct 31 01:24:09 ocho kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: 
[<ffffffff812d7648>] n_tty_read+0x281/0x7b4
Oct 31 01:24:09 ocho kernel: 1 lock held by mingetty/2127:
Oct 31 01:24:09 ocho kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: 
[<ffffffff812d7648>] n_tty_read+0x281/0x7b4
Oct 31 01:24:09 ocho kernel: 1 lock held by mingetty/2128:
Oct 31 01:24:09 ocho kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: 
[<ffffffff812d7648>] n_tty_read+0x281/0x7b4
Oct 31 01:24:09 ocho kernel: 1 lock held by mingetty/2129:
Oct 31 01:24:09 ocho kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: 
[<ffffffff812d7648>] n_tty_read+0x281/0x7b4
Oct 31 01:24:09 ocho kernel: 2 locks held by sshd/2336:
Oct 31 01:24:09 ocho kernel: #0:  (tty_mutex){+.+.+.}, at: 
[<ffffffff812d5903>] tty_open+0x5a/0x4ac
Oct 31 01:24:09 ocho kernel: #1:  (big_tty_mutex){+.+.+.}, at: 
[<ffffffff814b9c09>] tty_lock+0x3f/0x4a
Oct 31 01:24:09 ocho kernel:
Oct 31 01:24:09 ocho kernel: =============================================
Oct 31 01:24:09 ocho kernel:

-- 

Web: http://www.billauer.co.il

