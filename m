Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0J3SsA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 14:48:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753026Ab0J3Sr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 14:47:58 -0400
Date: Sat, 30 Oct 2010 11:46:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eli Billauer <eli@billauer.co.il>
Cc: linux-kernel@vger.kernel.org
Subject: Re: open() on /dev/tty takes 30 seconds on 2.6.36
Message-Id: <20101030114634.b19c4e0c.akpm@linux-foundation.org>
In-Reply-To: <4CCBCD8E.1020601@billauer.co.il>
References: <4CCBCD8E.1020601@billauer.co.il>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Oct 2010 09:47:26 +0200 Eli Billauer <eli@billauer.co.il> wrote:

> Hello,
> 
> I'm sorry about my previous overconclusive email, but there is a real 
> problem with opening TTYs during a few minutes after a system boots 
> (Fedora 12 in my case). I'll stick to the facts this time.
> 
> The kernel involved is 2.6.36, downloaded a few days ago as "latest 
> stable kernel" at kernel.org.
> 
> Running strace on sshd with -T and -tt flags, hence showing the time 
> each call took, these two lines were found. The number in brackets is 
> the time the system call took (not to the time to the next call or 
> something).
> 
> ...
> 21:35:21.131436 open("/dev/tty", O_RDWR|O_NOCTTY) = -1 ENXIO (No such 
> device or address) <30.022532>
> ...
> 21:35:51.175642 open("/dev/pts/0", O_RDWR) = 4 <30.063213>
> ...
> 
> So it took 30 seconds just to fail opening /dev/tty.
> 
> I then went on to add printk's in pty.c. Among others, I had:
> 
> static int ptmx_open(struct inode *inode, struct file *filp)
> {
>     struct tty_struct *tty;
>     int retval;
>     int index;
> 
>     nonseekable_open(inode, filp);
> 
>     /* find a device that is not in use. */
>     printk(KERN_ALERT  "34: ptmx_open to lock\n");
>     tty_lock();
>     printk(KERN_ALERT  "35: ptmx_open locked\n");
> 
> [snipped here]
> 
> And then found in my /var/log/messages (no log lines between these two):
> Oct 29 16:14:58 ocho kernel: 34: ptmx_open to lock
> Oct 29 16:15:13 ocho kernel: 35: ptmx_open locked
> 
> So we can see it took 15 seconds to acquire a lock in this case. In all 
> other pairs of lock messages there was no time difference. To me it 
> looks like 15 seconds in order to acquire a lock in the kernel is a 
> smoking gun.
> 

Odd.  Presumably someone else was holding big_tty_mutex for 15 seconds.

We can find out who, with the sysrq-d command if you have the time
please.  You'll need to enable lockdep and magic sysrq in .config. 
Then run `dmesg -n 8' so all messages get printed by the kernel and
then, in the middle of that 15-second delay, do

	echo d > /proc/sysrq-trigger

I'll confess that I've never used sysrq-d and am unsure what the output
looks like.  Fingers crossed!

