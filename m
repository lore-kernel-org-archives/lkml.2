Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab0DAQdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:33:45 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:55027 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932226Ab0DAQda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:33:30 -0400
Date: Thu, 1 Apr 2010 06:22:00 -0400 (EDT)
From: John Kacur <jkacur@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <894495169.344621270117320439.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <201003312304.30917.arnd@arndb.de>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Arnd Bergmann" <arnd@arndb.de> wrote:

> On Wednesday 31 March 2010 22:21:23 Arnd Bergmann wrote:
> > Another crazy idea I had was to simply turn the BKL into a regular
> mutex
> > as soon as we can show that all remaining users are of the
> non-recursive
> > kind and don't rely on the autorelease-on-sleep. Doing that would
> be
> > much easier without the pushdown into .unlocked_ioctl than it would
> be
> > with it.
> 
> I just looked at all the users of lock_kernel remaining with my patch
> series. For 90% of them, it is completely obvious that they don't
> rely
> on nested locking, and they very much look like they don't need the
> autorelease either, because the BKL was simply pushed down into the
> open, ioctl and llseek functions.
> 
> There are a few file systems (udf, ncpfs, autofs, coda, ...) and some
> network protocols (appletalk, ipx, irnet and x25) for which it is not
> obviously, though still quite likely, the case.
> 
> So we could actually remove the BKL recursion code soon, or even turn
> all of it into a regular mutex, at least as an experimental option.

Well, that would be quite similar to what we do in real-time with the
"Big Kernel Semaphore". However, Linus didn't want that pushed into
mainstream. As an experimental tree it's fine, but we're really stuck
with removing the BKL one by one until it's gone.

> 
> The recursive users that I've removed in my series are the block,
> tty,
> input and sound subsystems, as well as the init code.
> 
> 	Arnd
