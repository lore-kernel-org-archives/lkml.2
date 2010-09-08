Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab0IHHrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 03:47:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756393Ab0IHHri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 03:47:38 -0400
Date: Wed, 8 Sep 2010 17:47:26 +1000
From: Neil Brown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, haveblue@us.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] VFS: Remove read-only checks from
 dentry_permission
Message-ID: <20100908174726.21aec19b@notabene>
In-Reply-To: <E1Osh50-0005s0-V7@pomaz-ex.szeredi.hu>
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
	<20100906005029.20775.70918.stgit@localhost.localdomain>
	<E1Osh50-0005s0-V7@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Sep 2010 21:10:10 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Mon, 06 Sep 2010, NeilBrown wrote:
> > It is not sufficient to depend on the the "filesystem is readonly"
> > tests in dentry_permission as it does not check if the vfsmnt is
> > readonly.
> > All call sites already call mnt_want_write or __mnt_is_readonly which
> > includes the test on MS_RDONLY.
> 
> Last time I checked I found some holes (in nfsd IIRC).  That was a
> long time ago and things may have changed.

nfsd looks OK to me.  I didn't do an exhaustive audit but couldn't find
things that would not still work correctly.


> 
> That check could be replaced with a
> 
> 		if (IS_RDONLY(inode) &&
> 		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
> 			BUG();

That wouldn't quite work currently.
sys_faccessat checks __mnt_is_readonly *after* the call to dentry_permission,
so the above would cause it to BUG.  Possibly the __mnt_is_readonly could be
checked before dentry_permission.

However nfsd_permission is a bit more awkward to fix as sometimes it
deliberately wants to ignore read-only-filesystem issues ... but it might
still be possible to work around..

> 
> which would catch these cases but only if the superblock was marked
> r/o.  Otherwise it's basically impossible to make sure the callers of
> the VFS play by the rules.  That was one reason I advocated a
> path_... interface for the VFS instead of the current dentry based
> one, but Al didn't like it.
>

I guess there comes a point were we just have to document the rules and if
someone doesn't play by them - that is a bug...

NeilBrown
