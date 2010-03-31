Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab0CaV40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:56:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41530 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758241Ab0CaV4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:56:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fy12BTyCY+AEw35HkSKVcr5Z456KYqJW6BgAjE+7mSgJ7ZqEMukKcw6pqOZAYWMSTz
         ZDrYK7uyrcYfUDlDw0Ucr3bvPqrxPK/EVER2rFrzGPnPtQg4mow4AI7d9tFct+1ylGfh
         ZaPMlJUoScTOrOq/giD7uNu/XwFn9T0lI/5BQ=
Date: Wed, 31 Mar 2010 23:56:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Message-ID: <20100331215624.GF5163@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <20100331172208.GB5163@nowhere> <201003312221.23953.arnd@arndb.de> <201003312304.30917.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003312304.30917.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 11:04:30PM +0200, Arnd Bergmann wrote:
> On Wednesday 31 March 2010 22:21:23 Arnd Bergmann wrote:
> > Another crazy idea I had was to simply turn the BKL into a regular mutex
> > as soon as we can show that all remaining users are of the non-recursive
> > kind and don't rely on the autorelease-on-sleep. Doing that would be
> > much easier without the pushdown into .unlocked_ioctl than it would be
> > with it.
> 
> I just looked at all the users of lock_kernel remaining with my patch
> series. For 90% of them, it is completely obvious that they don't rely
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
> 
> The recursive users that I've removed in my series are the block, tty,
> input and sound subsystems, as well as the init code.


This is a solution that has been tried more than once already. But Linus
has told he wouldn't pull something that turns the bkl into a mutex or a
semaphore.

Plus it's quite hard to tell that it does or not auto-release somewhere
This is often something you can really spot on runtime or on small path
only.

The simple fact the bkl is not always a leaf lock makes it need the
auto-release, otherwise you experience very bad unexpected lock
dependencies.

