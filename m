Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab1ELQ3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:29:31 -0400
Received: from mx2.netapp.com ([216.240.18.37]:39823 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426Ab1ELQ3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:29:30 -0400
X-IronPort-AV: E=Sophos;i="4.64,359,1301900400"; 
   d="scan'208";a="547479315"
Subject: Re: [GIT PULL] fuse fix for 2.6.39
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
In-Reply-To: <BANLkTi=4rdtB5dQH=tycT1sybe7iJmTVcA@mail.gmail.com>
References: <87fwokarjj.fsf@tucsk.pomaz.szeredi.hu>
	 <BANLkTin6Ujea+qdkvwkH_9o5F8WKPyFdyA@mail.gmail.com>
	 <BANLkTi=4rdtB5dQH=tycT1sybe7iJmTVcA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Thu, 12 May 2011 12:28:52 -0400
Message-ID: <1305217732.15566.31.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
X-OriginalArrivalTime: 12 May 2011 16:28:53.0984 (UTC) FILETIME=[AF217600:01CC10C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 08:19 -0700, Linus Torvalds wrote:
> Ooh.
> 
> It's "lookup_one_len()", isn't it?
> 
> So any filesystem that uses that helper will need to be protected from
> a NULL 'nd'.
> 
> And then you have nfsd, ecryptfs and cachefiles that will do it on
> _other_ filesystems.
>
> Gaah. Ugly. So either we really should fix the filesystems that don't
> have protection from a NULL nd, or we should fix lookup_one_len() (are
> there perhaps other cases I missed?)

As long as we have filesystems that need to rely on intents and that
have the ability to generate automount points, we should deprecate the
use of lookup_one_len() and add something else to help ecryptfs and co
to do safe component-wise lookups, opens and creates.

The point is that filesystems such as Fuse and NFSv4 rely on intents for
opens and file creation; even NFSv3 relies on it for doing safe O_EXCL
creates. For NFSv4, the struct nameidata carries not only the path
information, but also returns the fully initialised 'struct file'. Al
has plans to clean up that interface, but lookup_one_len() will still be
insufficient as a replacement.

NFS also requires look up using the full 'struct path' if/when we happen
upon an automount point (i.e. if we cross into a submounted filesystem
on the server or if we encounter an NFSv4 referral). Again, this is
something that lookup_one_len() can't do.

Trond

> Al? Christoph? Comments?
> 
>                             Linus
> 
> On Thu, May 12, 2011 at 8:12 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Hmm.
> >
> > Do we really ever have a NULL 'nd' these days? Can you send me the
> > backtrace for whatever oops that was reported?
> >
> > The reason I ask is because at least NFS also does just
> >
> >        if (nd->flags & LOOKUP_RCU)
> >                return -ECHILD;
> >
> > in its nfs_lookup/open_revalidate() functions. As does cifs, ncpfs, p9
> > and coda from a quick grep.
> >
> >                        Linus
> >
> > On Thu, May 12, 2011 at 8:04 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >>
> >> Please pull from
> >>
> >>  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus
> >>
> >> Miklos Szeredi (1):
> >>      fuse: fix oops in revalidate when called with NULL nameidata
> >>
> >> ---
> >>  fs/fuse/dir.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

