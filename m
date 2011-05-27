Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1E0LjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 07:39:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61078 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab1E0LjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 07:39:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andreas Bombe <aeb@debian.org>
Subject: Re: tty_lock held during transmit wait in close: still unresolved
Date: Fri, 27 May 2011 13:38:54 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
References: <20110525235920.GA5279@amos.fritz.box> <20110526091726.55edf6c3@lxorguk.ukuu.org.uk> <20110527004104.GB4369@amos.fritz.box>
In-Reply-To: <20110527004104.GB4369@amos.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201105271338.54713.arnd@arndb.de>
X-Provags-ID: V02:K0:2jFIH8byckrnx4nf+kYnanxDbEDWwTEzf1R2HTJK/yS
 +cVbRNVdCBLMOpBuvA1uZTr4cd0AUwpaAM8FEnvvGpwC/A5SEc
 /+JGZCQnT3b1OmeAvdFZJXrTADmcl2XvRElDojKgLYkQWv4cOs
 o+wM30eh0aNH98Go808RvkYI61Gnu3PTbhF0BsZkRXt5VeDZjs
 plwLwpJ8SlMucLPqgWqkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 May 2011, Andreas Bombe wrote:
> > At any point you can show the code sleeps you can drop and retake the
> > tty mutex either side of it, so you should be able to do that in the
> > close timeout case. You may need to think about the order of locking with
> > the port mutex but I suspect you can drop and retake both there.
> 
> …basically emulating the BKL semantics? Sounds more doable. I'll look
> into it.

If I understand it correctly, the problem is the msleep_interruptible()
in __uart_wait_until_sent(), right?

Note that this function may be called with or without the port mutex
held, depending on whether the caller is uart_close or uart_wait_until_sent.
The tricky part here will be making sure that you hold neither the
port mutex nor the tty_mutex while sleeping, and to always retake them
in the correct order (tty_mutex before port mutex).

My mistake here must have been that I assumed the timeout was relatively
short to not hurt when holding a mutex, since we already hold the port
mutex. I expected the wait time to be a fraction of a second as in the time
that it takes to send a few remaining characters, which would be acceptable,
unlike the 30 second sleep that you are seeing.

> Of course that means it has to be done individually in all drivers.

Right. Fortunately, we have now reduced the number of drivers a bit, by
moving some of them to staging or completely out of the kernel.

Some drivers call their wait_until_sent function directly from their
close function, some call it through tty_wait_until_sent, and some
actually do both.

Further, some of the drivers have a rather ugly part in them where we take
tty_lock() conditionally in wait_until_sent(), depending on whether the
current thread already holds it (i.e. when coming from ->close, not when
coming from ioctl).

	Arnd
