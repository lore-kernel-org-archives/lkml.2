Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab0J3Hps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 03:45:48 -0400
Received: from mxout3.netvision.net.il ([194.90.6.2]:50731 "EHLO
	mxout3.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab0J3Hpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 03:45:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <4CCBCD8E.1020601@billauer.co.il>
Date: Sat, 30 Oct 2010 09:47:26 +0200
From: Eli Billauer <eli@billauer.co.il>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
To: linux-kernel@vger.kernel.org
Subject: open() on /dev/tty takes 30 seconds on 2.6.36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm sorry about my previous overconclusive email, but there is a real 
problem with opening TTYs during a few minutes after a system boots 
(Fedora 12 in my case). I'll stick to the facts this time.

The kernel involved is 2.6.36, downloaded a few days ago as "latest 
stable kernel" at kernel.org.

Running strace on sshd with -T and -tt flags, hence showing the time 
each call took, these two lines were found. The number in brackets is 
the time the system call took (not to the time to the next call or 
something).

...
21:35:21.131436 open("/dev/tty", O_RDWR|O_NOCTTY) = -1 ENXIO (No such 
device or address) <30.022532>
...
21:35:51.175642 open("/dev/pts/0", O_RDWR) = 4 <30.063213>
...

So it took 30 seconds just to fail opening /dev/tty.

I then went on to add printk's in pty.c. Among others, I had:

static int ptmx_open(struct inode *inode, struct file *filp)
{
    struct tty_struct *tty;
    int retval;
    int index;

    nonseekable_open(inode, filp);

    /* find a device that is not in use. */
    printk(KERN_ALERT  "34: ptmx_open to lock\n");
    tty_lock();
    printk(KERN_ALERT  "35: ptmx_open locked\n");

[snipped here]

And then found in my /var/log/messages (no log lines between these two):
Oct 29 16:14:58 ocho kernel: 34: ptmx_open to lock
Oct 29 16:15:13 ocho kernel: 35: ptmx_open locked

So we can see it took 15 seconds to acquire a lock in this case. In all 
other pairs of lock messages there was no time difference. To me it 
looks like 15 seconds in order to acquire a lock in the kernel is a 
smoking gun.

Please look into this.
   Eli

-- 
Web: http://www.billauer.co.il

