Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab0CaVFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:05:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61321 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab0CaVFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:05:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Date: Wed, 31 Mar 2010 23:04:30 +0200
User-Agent: KMail/1.13.1 (Linux/2.6.33-00063-g0795fff; KDE/4.4.1; x86_64; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <20100331172208.GB5163@nowhere> <201003312221.23953.arnd@arndb.de>
In-Reply-To: <201003312221.23953.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003312304.30917.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+2nyE+Z0nsbphaa3c+Mh7a7VNF+st+GkQqf1y
 MyAOqiBNdnO6eNhZdLBlregGYb/BGagyDZSVwvBWEHzIlnYVDQ
 5Ub5+xh/QE0lBsrXQT7jQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 March 2010 22:21:23 Arnd Bergmann wrote:
> Another crazy idea I had was to simply turn the BKL into a regular mutex
> as soon as we can show that all remaining users are of the non-recursive
> kind and don't rely on the autorelease-on-sleep. Doing that would be
> much easier without the pushdown into .unlocked_ioctl than it would be
> with it.

I just looked at all the users of lock_kernel remaining with my patch
series. For 90% of them, it is completely obvious that they don't rely
on nested locking, and they very much look like they don't need the
autorelease either, because the BKL was simply pushed down into the
open, ioctl and llseek functions.

There are a few file systems (udf, ncpfs, autofs, coda, ...) and some
network protocols (appletalk, ipx, irnet and x25) for which it is not
obviously, though still quite likely, the case.

So we could actually remove the BKL recursion code soon, or even turn
all of it into a regular mutex, at least as an experimental option.

The recursive users that I've removed in my series are the block, tty,
input and sound subsystems, as well as the init code.

	Arnd
