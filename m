Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851Ab0J2XW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 19:22:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52016 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab0J2XW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 19:22:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Timur Tabi <timur@freescale.com>
Subject: Re: Writing a console/tty driver -- how to use tty_port?
Date: Fri, 29 Oct 2010 16:21:42 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
References: <4CC893CD.7020701@freescale.com> <201010282257.33898.arnd@arndb.de> <4CC9E646.6070405@freescale.com>
In-Reply-To: <4CC9E646.6070405@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010291621.42890.arnd@arndb.de>
X-Provags-ID: V02:K0:tsbZOx1hYWw4nRrY3t2sLSYhz2jSwoW0iQjlLkhiXii
 gTu8Fqx9aFMVoQl5BkNYNa1My5TdSHeBzr3XyUSg0JYMF8NJnI
 j/2Tm035Xuzn9Xkiw4fVBmDWHIqZK8365U8GKh9ZbdeIJMirp9
 tg9wJM8W5sZ4w8sncJm+UMWYU3Zwy7t5KHb/E5lSGcBYy2NUTV
 Xod5u4FHpgjgGyBmyQiig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 October 2010, Timur Tabi wrote:
> Arnd Bergmann wrote:
> > If the device is not a UART, the best option may be to make the driver
> > a backend to the hvc driver, like e.g. drivers/char/hvc_tile.c.
> 
> The current version *is* a backend to hvc, but I have to abandon that because of
> this thread:
> 
> http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-September/085664.html
> 
> I posted a patch that causes hvc to spin if the backend driver returns -EAGAIN,
> which is my driver does when the output buffer is full.
> 
> In other words, hvc does not support backend drivers that can detect full output
> buffers.

To be more specific, hvc does support retransmitting characters on the tty
but not on the console!

The backend drivers return 0 to notify the tty driver that output is busy
and should be retried, which will set the timer.

> > This works for all devices with or without interrupts that don't need
> > to set up the communication parameters but simply provide a read/write
> > character interface.
> 
> If my patch were accepted, I wouldn't need to do the rewrite.  Dropping
> characters during a printk() is not acceptable for us.

Why do you care about printk output overflowing more than others do? Most
of the hvc drivers block internally and never return 0, but those that
do probably all need the same solution.

Your original one-line patch from last year didn't seem too wrong, though
you might want to check with the iseries people, since that driver might
return zero in error cases.

The idea of adding a special return code from ->put_chars to distinguish
buffer full from other errors also seemed reasonable, as did the approach
to flag the hv_ops to tell the base layer wether you want retransmits
or drops.

	Arnd

