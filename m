Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab2ILOcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:32:46 -0400
Received: from fieldses.org ([174.143.236.118]:59670 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab2ILOcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:32:45 -0400
Date: Wed, 12 Sep 2012 10:32:27 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
Message-ID: <20120912143227.GE3009@fieldses.org>
References: <1347020137.2223.13.camel@iscandar.digidescorp.com>
 <87oblfpmnb.fsf@devron.myhome.or.jp>
 <87k3w3ph8d.fsf@devron.myhome.or.jp>
 <CAKYAXd-k4yVV3h8k0kcFMsyGnOVckYRjXi8fkZrLtjuWVi7Eqw@mail.gmail.com>
 <87har6kmfx.fsf@devron.myhome.or.jp>
 <CAKYAXd-ZNmCbHqmFX=YXti7XprhD_Hgvmnd=TnKPVoFc88Sc4A@mail.gmail.com>
 <87oblc4u6f.fsf@devron.myhome.or.jp>
 <CAKYAXd-gO5Pw=0unjB=YQJhu6W=g7VpZYnmHXkve-k8_4VjpgA@mail.gmail.com>
 <871ui84l4l.fsf@devron.myhome.or.jp>
 <CAKYAXd89CKZa9nV3pBiFgcpGsYzX1-iCB+UJ8bBvst88GnB4mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd89CKZa9nV3pBiFgcpGsYzX1-iCB+UJ8bBvst88GnB4mg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 11:12:56PM +0900, Namjae Jeon wrote:
> 2012/9/12 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> > Namjae Jeon <linkinjeon@gmail.com> writes:
> >
> >>>> I think that it is unfixable because we can not know i_pos of inode
> >>>> changed by rename.
> >>>> And even though we know it, there is no rebuild inode routine in -mm.
> >>>> And It even can not fix in our patches.
> >>>
> >>>>> And are you tried https://lkml.org/lkml/2012/6/29/381 patches? It sounds
> >>>>> like to improve performance by enabling lookupcache.
> >>>> We checked this patches when facing estale issue in -mm.
> >>>> But It is no use, these patches just retry system call one more when
> >>>> estale error.
> >>>
> >>> What happens if client retried from lookup() after -ESTALE? (client NFS
> >>> doesn't have the name of entry anymore?)
> >> Need to rebuild inode routine because inode cache is already evicted on Server.
> >>>
> >>> I'm assuming the retry means - it restarts from building the NFS file
> >>> handle. I might be just wrong here though.
> >> As I remember, just retry in VFS of NFS client..I heard this patch is
> >> needed for
> >> a very specific set of circumstances where an entry goes stale once
> >> between the lookup and the actual operation(s).
> >> It is not related with current issues(inode cache eviction on server).
> >
> > Supposing, the server/client state is after cold boot, and client try to
> > rename at first without any cache on client/server.
> >
> > Even if this state, does the server return ESTALE? If it doesn't return
> > ESTALE, I can't understand why it is really unfixable.
> Hi OGAWA.
> Server will not return ESTALE in this case. because the client does
> not have any information for files yet.

It does if the client mounted before the server rebooted.  NFS is
designed so that servers can reboot without causing clients to fail.
(Applications will just see a delay during the reboot.)

It probably isn't possible to this work in the case of fat.

But from fat's point of view there probably isn't much difference
between a filehandle lookup after a reboot and a filehandle lookup after
the inode's gone from cache.


I really don't see what you can do to help here.  Won't anything that
allows looking up an uncached inode by filehandle also risk finding the
wrong file?

(If looking up the same filehandle ever results in finding a *different*
file from before, that's a bug.  Probably a more dangerous bug than an
ESTALE--in the ESTALE case the failure is obvious whereas in the case
where you get the wrong file, you may silently corrupt data.)

--b.

> I mean NFS client does not have any old NFS FH(containing old inode
> number) for this.
> 
> >
> > If it returns ESTALE, why does it return? I'm assuming the previous code
> > path is the cached FH path.
> The main point for observation is the file handle-which is used for
> all the NFS operation.
> So for all the NFS operation(read/write....) which makes use of the
> NFS file handle in between if there is a change in inode number
> It will result in ESTALE.
> Changing inode number on rename happened at NFS server by inode cache
> eviction with memory pressure.
> 
> lookupcache is used at NFS client to reduce number of LOOKUP operations.
> But , we can still get ESTALE if inode number at NFS Server change
> after LOOKUP, although lookupcache is disable.
> 
> LOOKUP return NFS FH->[inode number changed at NFS Server] ->
> But we still use old NFS FH returned from LOOKUP for any file
> operation(write,read,etc..)
> -> ESTALE will be returned.
> 
> Thanks!
> > --
> > OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
