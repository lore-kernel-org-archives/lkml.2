Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab0EEVbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:31:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670Ab0EEVbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:31:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 10/13] tty: untangle locking of wait_until_sent
Date: Wed, 5 May 2010 23:31:03 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00090-g1509e54-dirty; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de> <1273012433-6125-11-git-send-email-arnd@arndb.de> <20100505205905.3c87b403@lxorguk.ukuu.org.uk>
In-Reply-To: <20100505205905.3c87b403@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005052331.03633.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18TkYqHQd/wPbfo8COKMVSSdfNhnDHYC5z/XeE
 Vy9H1dL3iXhimg9p31ymz9KujpiDUr1By/lehxS+OV8TjbYBQi
 Sw7b0SChhe12NA542Sq1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010 21:59:05 Alan Cox wrote:
> > Some wait_until_sent versions require the big
> > tty mutex, others don't and some callers of
> > wait_until_sent already hold it while other don't.
> > That leads to recursive use of the BTM in these
> > functions, which we're trying to get rid of.
> 
> I don't believe any of the currently live ones do.

Ok, that simplifies things, at least we can call
tty->ops->wait_until_sent(tty, timeout) while holding
the BTM then, even with the next patch that makes it
non-recursive.

> >  drivers/char/hvc_console.c    |    2 +-
> >  drivers/char/hvcs.c           |    2 +-
> 
> Doesn't seemn to need it

These, and most of the others in this patch call tty_wait_until_sent()
from their close() function. That contains the lines

        if (wait_event_interruptible_timeout(tty->write_wait,
                        !tty_chars_in_buffer(tty), timeout) >= 0) {

Part of what my patch does is to give up the BTM when already
holding it, to mimic the BKL behavior.
If you can confirm that this wait_event never blocks indefinitely
or has to wait for the BTM from another function, that could just
be removed. Otherwise, it probably needs to become something ugly
like

	if (tty_chars_in_buffer(tty)) {
		if (tty_locked()) {
			tty_unlock();
			wait = wait_event_interruptible_timeout(tty->write_wait,
	                        !tty_chars_in_buffer(tty), timeout) >= 0);
			tty_lock();
		} else {
			wait = wait_event_interruptible_timeout(tty->write_wait,
	                        !tty_chars_in_buffer(tty), timeout) >= 0);
		}
		if (wait && tty->ops->wait_until_sent)
			tty->ops->wait_until_sent(tty, timeout);
	}

I already had to introduce a few of these constructs to make the BTM
non-recursive, but I'd prefer to keep the number as low as possible
for obvious reasons.

> >  drivers/char/specialix.c      |    2 +-
> 
> Broken

> This makes me think that now might be a good time to consign the broken
> crap to the bitbucket unless someone stands up with hardware and who
> wants to maintain it.

Fine with me.
While I technically own a 16-port specialix card somewhere in my
parents' basement, I'm not exactly interested in maintaining the
driver.

	Arnd
