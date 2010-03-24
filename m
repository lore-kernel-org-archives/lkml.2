Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0CXWZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:25:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57549 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab0CXWZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:25:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Date: Wed, 24 Mar 2010 23:25:23 +0100
User-Agent: KMail/1.13.1 (Linux/2.6.33-00063-g0795fff; KDE/4.4.1; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, John Kacur <jkacur@redhat.com>
References: <201003242240.54907.arnd@arndb.de> <20100324221016.0b444a23@lxorguk.ukuu.org.uk>
In-Reply-To: <20100324221016.0b444a23@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003242325.24625.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+XHZX2ZXMKiW8x9CNS2u2lEMQHyLSMJUrsBE6
 A7ttdnxZFn9dh3XsP4BTisFlWK+9DiJqvtoLwhKoUjnuTk7L98
 Pj/mz2KJy1pyOpm/0s2LA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 March 2010 23:10:16 Alan Cox wrote:
> >   The basic idea here is to make recursive locking and the release-on-sleep
> >   explicit, so every mutex_lock, wait_event, workqueue_flush and schedule
> >   in the TTY layer now explicitly releases the BTM before blocking.
> 
> I'm not sure if that is actually the path of sanity (yours at least), nor
> the right way to whack the other BKL users whose use is horrible but
> essentially private.
> 
> It would be nice to get the other bits in first removing BKL from most of
> the kernel and building kernels which are non BKL except for the tty
> layer. That (after Ingo's box from hell has run it a bit) would
> reasonably test the assertion that the tty layer has no BKL requirements
> that are driven by external to tty layer code.

Yes, we can do that by applying all patches except 'tty: implement BTM
as mutex instead of BKL', which is the only one in the tty section of
my series that should really change the behaviour. Building a kernel
with all other BKL users gone currently implies disabling usbcore,
videodev, soundcore, i4l and capi, as well as a large number of obsolete
device drivers.

The only ones that I can imagine still interacting with the tty code
are the ISDN drivers, and even those look pretty unlikely.

> That to me would test the biggest question of all and be a reasonably
> good base from which to then either apply the tty BTM patches or attack
> the problem properly with the BKL localised to one subtree.

We could also make the 'tty: implement BTM as mutex instead of BKL'
patch a config option that makes it possible to test it out some more
while conservative users just continue to get the BKL semantics.

	Arnd
