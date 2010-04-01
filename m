Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab0DALiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:38:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51603 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab0DALiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:38:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Date: Thu, 1 Apr 2010 13:37:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <201003312304.30917.arnd@arndb.de> <20100331215624.GF5163@nowhere>
In-Reply-To: <20100331215624.GF5163@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011337.58506.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+wcN4+mLn4YecjNnI7hshyxPzF+dLMyaEiyvU
 Iij07v5M0Qiufti6YZ3x9vd8Y4tghokzhSFBC2N4We6XCYkuUj
 Ub5mo1pBnwA9fphRUjg1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 March 2010, Frederic Weisbecker wrote:
> This is a solution that has been tried more than once already. But Linus
> has told he wouldn't pull something that turns the bkl into a mutex or a
> semaphore.

Ok. Starting from the same observation of simplicity in the remaining code,
we should also be able to find a semi-automatic way of turning the BKL usage
in these drivers into a per-module mutex.

> Plus it's quite hard to tell that it does or not auto-release somewhere
> This is often something you can really spot on runtime or on small path
> only.

Well, the autorelease by itself is not needed anywhere. What is needed
is the consequence of autorelease avoiding AB-BA type deadlocks.

> The simple fact the bkl is not always a leaf lock makes it need the
> auto-release, otherwise you experience very bad unexpected lock
> dependencies.

I'm arguing that we can probably show the BKL to be the outermost
lock for the majority of the remaining drivers, which only get it
from their open(), ioctl() or llseek() functions, which are all
called without any locks held. If the BKL is a regular mutex, lockdep
should warn of the other cases.

	Arnd
