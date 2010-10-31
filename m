Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0JaDfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 23:35:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab0JaDfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 23:35:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eli Billauer <eli@billauer.co.il>
Subject: Re: open() on /dev/tty takes 30 seconds on 2.6.36
Date: Sun, 31 Oct 2010 04:36:18 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <4CCBCD8E.1020601@billauer.co.il> <20101030114634.b19c4e0c.akpm@linux-foundation.org> <4CCCB663.7010100@billauer.co.il>
In-Reply-To: <4CCCB663.7010100@billauer.co.il>
MIME-Version: 1.0
Message-Id: <201010310436.18613.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:wCyy5BgQza7aq42IFoiAnrpokKA/nQSnzlfYRKUw7OX
 Ergbc5OzyK4wnpCSKidd1D9ddij/ACWXAIsLIxCE+JPsN7j9aZ
 MWWMqqc8D1GD3cA6/bLwZitV0m6JssEebsQ8Q2tWPbxlcObOE/
 kQHeQzwqjQRGUh07C0GIIk3TAxgb7sYQ7hrOdJn2OpLgHeBQ2c
 gqKIyrEE4sFLVLLhWscZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 October 2010, Eli Billauer wrote:
> Andrew Morton wrote:
> 
> First, I'll explain what I did: Since I can't login while this problem 
> occurs, I had to modify sshd's service script to start sshd with strace, 
> and also kick off a script (called who-is-locking.sh), which creates 
> that sysrq call every five seconds. This could also be the place to 
> mention, that I got an NULL dereference oops during one of these (IP at 
> get_usage_chars+0x0/0x10e, while in the who-is-locking process). But 
> that happened after the desired data was logged.

An oops report is interesting most of the time, except when you know
that you caused it with your own kernel changes. If you can still
find the oops report, please post it here.

> Oct 31 01:14:28 ocho kernel: Serial: 8250/16550 driver, 4 ports, IRQ 
> sharing enabled
> Oct 31 01:14:28 ocho kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is 
> a 16550A
> Oct 31 01:14:28 ocho kernel: 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Oct 31 01:14:28 ocho kernel: serial 0000:05:04.0: PCI INT A -> GSI 16 
> (level, low) -> IRQ 16
> Oct 31 01:14:28 ocho kernel: 0000:05:04.0: ttyS1 at I/O 0xbe20 (irq = 
> 16) is a 8250
> Oct 31 01:14:28 ocho kernel: 0000:05:04.0: ttyS2 at I/O 0xbe28 (irq = 
> 16) is a 8250
> Oct 31 01:14:28 ocho kernel: 0000:05:04.0: ttyS3 at I/O 0xbe40 (irq = 
> 16) is a 8250
> Oct 31 01:14:28 ocho kernel: Couldn't register serial port 0000:05:04.0: -28

For some reason, your kernel finds five ports at boot time, while it's
been configured at build time to support only four.

> Oct 31 01:23:59 ocho kernel: =============================================
> Oct 31 01:23:59 ocho kernel:
> Oct 31 01:24:04 ocho kernel: SysRq : Show Locks Held
> Oct 31 01:24:04 ocho kernel:
> Oct 31 01:24:04 ocho kernel: Showing all locks held in the system:
> Oct 31 01:24:04 ocho kernel: 2 locks held by modem-manager/1835:
> Oct 31 01:24:04 ocho kernel: #0:  (big_tty_mutex){+.+.+.}, at: 
> [<ffffffff814b9c09>] tty_lock+0x3f/0x4a
> Oct 31 01:24:04 ocho kernel: #1:  (&port->mutex){+.+.+.}, at: 
> [<ffffffff812fcace>] uart_close+0x82/0x312

So modem-manager is the process you need to look at, as it holds the
BTM, probably for a long time. It should not do that. First you should
verify that when you don't have modem-manager running, the problem goes
away. This may indeed be related to the misdetection of a serial port.

The other thing to check is what modem-manager is actually doing. You can
find out by looking at /proc/<pid>/stack, where <pid> is the pid of the
modem-manager process, 1835 in your example.

You can also look at <sysrq>+t to get all the stack traces for the running
processes and finding the process in there. 

I think you're closing in on the bug, thanks to your providing exactly the
right parts of information.

	Arnd
