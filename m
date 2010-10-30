Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab0J3UqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 16:46:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57076 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0J3UqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 16:46:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: open() on /dev/tty takes 30 seconds on 2.6.36
Date: Sat, 30 Oct 2010 22:46:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Eli Billauer <eli@billauer.co.il>, linux-kernel@vger.kernel.org
References: <4CCBCD8E.1020601@billauer.co.il> <20101030114634.b19c4e0c.akpm@linux-foundation.org>
In-Reply-To: <20101030114634.b19c4e0c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010302246.56539.arnd@arndb.de>
X-Provags-ID: V02:K0:wFA7nFB9XaoMbUDKSg2ECI+qQoNumhBtYR5QG1r4oue
 B6kY62EiuRNaUx9SLJIjpDexPDuWQio/hVat46no/ioaPBzPr0
 fT35fR+656C7Ll7uFujHbV5MBjEzKf63PJI50FTeWPK/gfBBYx
 01c+mfIQA/2cLCI0I/5/c2D+iQDuslEXG98lly/XctLS/A1T6O
 KOdrnhYmPBLIpL5G3faKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 October 2010, Andrew Morton wrote:
> > static int ptmx_open(struct inode *inode, struct file *filp)
> > {
> >     struct tty_struct *tty;
> >     int retval;
> >     int index;
> > 
> >     nonseekable_open(inode, filp);
> > 
> >     /* find a device that is not in use. */
> >     printk(KERN_ALERT  "34: ptmx_open to lock\n");
> >     tty_lock();
> >     printk(KERN_ALERT  "35: ptmx_open locked\n");
> > 
> > [snipped here]
> > 
> > And then found in my /var/log/messages (no log lines between these two):
> > Oct 29 16:14:58 ocho kernel: 34: ptmx_open to lock
> > Oct 29 16:15:13 ocho kernel: 35: ptmx_open locked
> > 
> > So we can see it took 15 seconds to acquire a lock in this case. In all 
> > other pairs of lock messages there was no time difference. To me it 
> > looks like 15 seconds in order to acquire a lock in the kernel is a 
> > smoking gun.

Agreed. When I changed the locking to use a mutex instead of the BKL,
I intentionally left it locked across sleeping functions, but none of
them are supposed to sleep for multiple seconds.

> 
> Odd.  Presumably someone else was holding big_tty_mutex for 15 seconds.
> 
> We can find out who, with the sysrq-d command if you have the time
> please.  You'll need to enable lockdep and magic sysrq in .config. 
> Then run `dmesg -n 8' so all messages get printed by the kernel and
> then, in the middle of that 15-second delay, do
> 
>         echo d > /proc/sysrq-trigger
> 
> I'll confess that I've never used sysrq-d and am unsure what the output
> looks like.  Fingers crossed!

With a little luck, lockdep by itself might even be able to find an
inconsistency in the BTM use and warn right away about it. I found
a number of bugs in the TTY code just by running with lockdep in the
mutex version.

	Arnd
