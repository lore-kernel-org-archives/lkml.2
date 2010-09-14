Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0INU2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:28:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262Ab0INU2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:28:07 -0400
MIME-Version: 1.0
In-Reply-To: <201009142206.54130.arnd@arndb.de>
References: <201009142206.54130.arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Sep 2010 13:20:22 -0700
Message-ID: <AANLkTimzFDdWbr2gtfmJmfGJVnyURcpvwnGf334ZHVYc@mail.gmail.com>
Subject: Re: [PATCH] Remove BKL from fs/locks.c
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 1:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> Christoph already made it clear that it cannot go upstream
> like this and Stephen said he consequently didn't want it
> in -next either. It may still be material for -mm or -rt,
> or just anyone who wants to test a kernel with CONFIG_BKL
> disabled.

I think something like this would be acceptable with that whole config
option removed.

That would not help your particular "test without BKL at all" case,
but basically I would suggest something like the following:

 - do the unconditional conversion to the new spinlock, so that
fs/locks.c is internally consistent and conceptually works without the
BKL at all.

 - remove all the EXPORT_SYMBOL()s

 - create wrapper functions named xyzzy_bkl() (perhaps in a different
fs/bkl.c file or whatever - or maybe just in the same file that you do
the bkl for CONFIG_BKL in the first place) that wrap the fs/locks.c
symbols with the kernel lock (so now those wrappers will take _both_
the BKL and the real spinlock)

 - fix up all modular users mindlessly to call the bkl version, and
ship it that way for one release

End result: anybody who uses the old exports will just not link at
all, and all in-kernel users (ie lockd etc) will now very explicitly
have that xyz_bkl() use.

After that one release, we can re-introduce the old names without the
bkl, and let filesystems and other subsystems just decide that they
don't want the bkl version one by one. So that first phase would be
basically a no-op with an interface rename just so that the rest could
then be done piece-meal.

                           Linus
