Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0IUClG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 22:41:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab0IUClF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 22:41:05 -0400
Date: Tue, 21 Sep 2010 12:40:56 +1000
From: Neil Brown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] ovl: add initial revalidate support
Message-ID: <20100921124056.63408477@notabene>
In-Reply-To: <E1OwFkH-000742-GV@pomaz-ex.szeredi.hu>
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
	<20100906005029.20775.80833.stgit@localhost.localdomain>
	<E1OwFkH-000742-GV@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 16:47:29 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Mon, 06 Sep 2010, NeilBrown wrote:
> > Add dentry_revalidate method and fail validation of either the
> > upper or lower dentry has been renamed or unlinked directly in the
> > otherlying filesystem.
> > This allows such changes to appear promptly in the overlay providing
> > the file isn't currently in use.
> 
> I fixed up some things in the revalidation logic and tested it out.
> There are some unexpected effects, but they boil down to the fact that
> busy directories can't be invalidated.  Mostly it works as expected.
> 
> However, the "rearange directories so that a/b becomes b/a" trick
> still strikes in evil ways.  Consider the following script:
> 
> mkdir /upper/a/b
> cd /mnt/overlay/a
> while true; do
> 	cd b
> 	mv /upper/a/b /upper/b
> 	mv /upper/a /upper/b/a
> 	cd a
> 	mv /upper/b/a /upper/a
> 	mv /upper/b /upper/a/b
> done
> 
> It will create an ever deeper directory tree on the overlay.
> 
> Can this be prevented?  Probably, e.g. lookup should make sure that
> each new directory gets a *unique* set of lower and upper dentries
> (e.g. by creating hash tables indexed by lower and upper dentries).
> 
> Is it worth the trouble?

The only real problem here is that an unprivileged user with direct access
to 'upper' could consume unlimited kernel memory without using a
corresponding mount of storage space (so quotas etc wouldn't stop them).

Maybe the easiest counter-measure to that is to keep track of a 'depth' of
each dentry and disallow lookups that go much beyond PATH_MAX???

Either that or rely in the sysadmin to hide the upper/lower filesystems from
untrusted users.  I particularly see value in sysadmins being able to modify
these filesystem - not so much for 'regular users'.

NeilBrown

> 
> Any other ideas?
> 
> Thanks,
> Miklos
> 
>
