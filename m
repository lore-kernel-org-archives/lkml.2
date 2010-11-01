Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab0KATi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:38:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab0KATi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:38:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eli Billauer <eli@billauer.co.il>
Subject: Re: open() on /dev/tty takes 30 seconds on 2.6.36
Date: Mon, 1 Nov 2010 20:39:16 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <4CCBCD8E.1020601@billauer.co.il> <201010310436.18613.arnd@arndb.de> <4CCE140C.8050909@billauer.co.il>
In-Reply-To: <4CCE140C.8050909@billauer.co.il>
MIME-Version: 1.0
Message-Id: <201011012039.16312.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:u/JHzcFxnJl1dc5LHtbPkNDjZTPC6xGoKXIJ5pXkFfD
 RW0F92TzdNka8qoRzEMFe6oQ8FUbOnwEfESUjWul375IUv5YpD
 /R8NFMXu++ZuUd50u3eFwVKuWYtWcfw/FbLtTCihLpdQ7BELiV
 CmTrKmyceTXipAAzz3FYgrSm6Ln2KZNB4kya7PZ1oGswnK8QXA
 4JP77VlXqIIavoE3vZ/bA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 November 2010, Eli Billauer wrote:
> Let me start with the headline: It's close() of a ttySx that takes 30 
> seconds, during which the big TTY lock is held. Now to details.

Ok, good to hear you tracked it down this far!

> Arnd Bergmann wrote:
> 
> > So modem-manager is the process you need to look at, as it holds the
> > BTM, probably for a long time. It should not do that. First you should
> > verify that when you don't have modem-manager running, the problem goes
> > away. This may indeed be related to the misdetection of a serial port.
> >   
> That test is built-in: When modem-manager stops poking around, 
> everything becomes fine again.

Ok.

> > The other thing to check is what modem-manager is actually doing. You can
> > find out by looking at /proc/<pid>/stack, where <pid> is the pid of the
> > modem-manager process, 1835 in your example.
> >   
> OK, so this is what I did eventually: I ran strace on sshd and 
> modem-manager, and I also added printk's to tell me when tty_lock() is 
> invoked, when it actually got the lock, and when tty_unlock() is 
> invoked. Pretty messy, and still.
> 
> Let's start with sshd's strace. We have a
> 01:06:20.152787 open("/dev/tty", O_RDWR|O_NOCTTY) = -1 ENXIO (No such 
> device or address) <30.008153>

That looks unrelated, as far as I can tell.

> And this is what we have in /var/log/messages:
> 
> Nov  1 01:06:20 ocho modem-manager: (ttyS2) closing serial device...
> Nov  1 01:06:20 ocho kernel: tty_lock() called
> Nov  1 01:06:20 ocho kernel: tty_lock() got lock
> Nov  1 01:06:20 ocho kernel: tty_lock() called
> Nov  1 01:06:50 ocho kernel: tty_unlock() called
> Nov  1 01:06:50 ocho kernel: tty_lock() got lock
> Nov  1 01:06:50 ocho kernel: tty_unlock() called
> Nov  1 01:06:50 ocho kernel: tty_lock() called
> 
> So we can see that someone got the lock, and then didn't release it for 
> 30 seconds, and that someone else tried to get the lock and waited for 
> it 30 seconds.

Ok, that's certainly modem-manager in the tty_release function, calling
uart_close, which has this code:

        if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE) {
                /*
                 * hack: open-coded tty_wait_until_sent to avoid
                 * recursive tty_lock
                 */
                long timeout = msecs_to_jiffies(port->closing_wait);
                if (wait_event_interruptible_timeout(tty->write_wait,
                                !tty_chars_in_buffer(tty), timeout) >= 0)
                        __uart_wait_until_sent(uport, timeout);
        }

port->closing_wait gets initialized to 30 seconds, which fits your
symptom.

I'm not sure whether it blocks in wait_event or in __uart_wait_until_sent
though, both get the same timeout.

> An strace of modem-manager running under vanilla kernel 2.6.35-4 shows 
> that close() takes 30 seconds there as well. It just so happens that it 
> went unnoticed (maybe because of the changes in the locking schema?).

Exactly. The code used to hold the BKL, which gets implicitly released
during a sleeping operation like wait_event_interruptible_timeout or 
__uart_wait_until_sent. With the change to a mutex, this does not
happen any more.

When I did the change, I did not anticipate the call actually timing
out the 30 seconds.

> I should only note that all TTY close() calls take 30 seconds, and that 
> all ports get a ioctl() and extra close() after the file descriptor is 
> closed, with an EBADF as response.

This must be an unrelated bug in modem-manager.

Can you confirm that this only happens on tty1 through tty4, but not on
tty0, which is your real uart?

I think we need to find out why it's hitting the timeout most of all,
and that means understanding what the hardware on your system is actually
doing or supposed to be doing. What does "lspci -vvx" show about the
port? Can you disable it in some way?

	Arnd
