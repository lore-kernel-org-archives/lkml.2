Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0DAJHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 05:07:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52559 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab0DAJHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 05:07:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Date: Thu, 1 Apr 2010 11:07:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <201003312304.30917.arnd@arndb.de> <20100331225500.3ed98c1f@lxorguk.ukuu.org.uk>
In-Reply-To: <20100331225500.3ed98c1f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011107.13774.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ame5gnyeT5wVW2P4c37tJEZnM+frN72oVoFC
 9a6xDkSIjhSQZxl8OfsZs2K1ylxi6YshJigQ3TeS/gInFvuOJf
 fRTfiYYMKkCRpv0JkSZLw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 March 2010, Alan Cox wrote:
> > The recursive users that I've removed in my series are the block, tty,
> > input and sound subsystems, as well as the init code.
> 
> There are some very subtle recursive cases in the tty code - hangup
> triggered close and consoles being an absolute gem I've just had to debug
> in my lock removal bits so far...

Yes, I've seen some of them. What I meant above is that with
CONFIG_TTY_MUTEX=y, the TTY code no longer uses the BKL in a
nested way, and quite likely no either code does either.

The TTY code with my patch now has tty_lock() for all cases that
I concluded are never nested in another tty_lock, and tty_lock_nested()
for those I did not understand or that I know they are nested (the
latter type usually comes with a comment). The only difference
between the two is a WARN_ON(tty_locked()) in tty_lock, so we can
see where the analysis was wrong.

	Arnd
