Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0HISi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:38:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63924 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab0HISi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:38:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Whitcroft <apw@canonical.com>
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
Date: Mon, 9 Aug 2010 20:38:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <20100805213528.GA13794@kroah.com> <20100806202228.GA6153@suse.de> <AANLkTinaQz22DAzrcvYREWAe9AFv8enC88Gu_9o_Ghg-@mail.gmail.com>
In-Reply-To: <AANLkTinaQz22DAzrcvYREWAe9AFv8enC88Gu_9o_Ghg-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008092038.49439.arnd@arndb.de>
X-Provags-ID: V02:K0:EiU5+nbEz2RdiPFCOuY1BmlzTvDmJLsL2CS23p3oZno
 YV9k24QXawMmp7A0FZWIPe8zdB8ai+I6DJ81NU3ikabv8ARUqM
 GCTJzgwWfZA6AvtVhEb/K2XWhwRccit1rXWURoKckPGUVy+M7+
 mrUCSOp9Wh/paDXLKWIIVI8NzeAGlLISz1JWgwo9WODwwhKggN
 P5f1Uymd4BWqbR+mqPOKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 August 2010, Andy Whitcroft wrote:
> With the new locking the BTM is held in place of the BKL, which
> effectivly means throughout open and close processing, which
> effectively means all TTY open/closes are serialised throughout
> regardless of the length of the shutdown processing.  The EIO appears
> to be no longer returnable.
> 
> Is this change in semantics expected?  If not, it is likely something
> which could be addressed separately after merging, as long as we are
> aware.

I audited (or tried to) all code that is able to sleep while holding the
BTM. In the cases that looked like they might sleep long, I added explicit
tty_unlock()/tty_lock() pairs around the sleeping code.

Code that potentially sleeps but should not do so for an indefinite
time (e.g. kmalloc(GFP_KERNEL)), I did not do this and still hold the BKL.

This means the code shifted to holding the BTM more often than it used
to hold the BKL, but for cases where we wait on user or hardware interaction,
it should still behave as it used to. If you found a place where this
is not true, that is probably an oversight and we should add explicit
tty_unlock() statements around it.

The problem is that we cannot easily give up the BTM while already holding
tty_port->mutex, tty_port->buf_mutex, console_semaphore, tty->termios_mutex
or tty->atomic_write_lock, which would give an AB-BA deadlock without
the autorelease semantics of the BKL. Similarly, any wait_event or
flush_work_queue potentially has the same problem (besides the fact that
it can self-deadlock what it waits for tried to take the BTM). Auditing
all these was the bulk of the work for the conversion.

I did not specifically audit for the case where tty_open() returns -EIO,
but I'd hope that it would be covered by the method I used for the
conversion.

	Arnd
