Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920Ab2ILRMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:12:09 -0400
Received: from fieldses.org ([174.143.236.118]:41186 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760899Ab2ILRLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:11:35 -0400
Date: Wed, 12 Sep 2012 13:11:28 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Namjae Jeon <linkinjeon@gmail.com>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
Message-ID: <20120912171128.GG3009@fieldses.org>
References: <87k3w3ph8d.fsf@devron.myhome.or.jp>
 <CAKYAXd-k4yVV3h8k0kcFMsyGnOVckYRjXi8fkZrLtjuWVi7Eqw@mail.gmail.com>
 <87har6kmfx.fsf@devron.myhome.or.jp>
 <CAKYAXd-ZNmCbHqmFX=YXti7XprhD_Hgvmnd=TnKPVoFc88Sc4A@mail.gmail.com>
 <87oblc4u6f.fsf@devron.myhome.or.jp>
 <CAKYAXd-gO5Pw=0unjB=YQJhu6W=g7VpZYnmHXkve-k8_4VjpgA@mail.gmail.com>
 <871ui84l4l.fsf@devron.myhome.or.jp>
 <CAKYAXd89CKZa9nV3pBiFgcpGsYzX1-iCB+UJ8bBvst88GnB4mg@mail.gmail.com>
 <20120912143227.GE3009@fieldses.org>
 <87vcfjfa14.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vcfjfa14.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 02:03:51AM +0900, OGAWA Hirofumi wrote:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> >> > Supposing, the server/client state is after cold boot, and client try to
> >> > rename at first without any cache on client/server.
> >> >
> >> > Even if this state, does the server return ESTALE? If it doesn't return
> >> > ESTALE, I can't understand why it is really unfixable.
> >> Hi OGAWA.
> >> Server will not return ESTALE in this case. because the client does
> >> not have any information for files yet.
> >
> > It does if the client mounted before the server rebooted.  NFS is
> > designed so that servers can reboot without causing clients to fail.
> > (Applications will just see a delay during the reboot.)
> >
> > It probably isn't possible to this work in the case of fat.
> >
> > But from fat's point of view there probably isn't much difference
> > between a filehandle lookup after a reboot and a filehandle lookup after
> > the inode's gone from cache.
> 
> This is talking about to retry by client side, not server side solution.
> What happens if client retry after got ESTALE? (Yes, this would not be
> the solution for all NFS clients. But, I guess this solution can be for
> linux NFS client.)
> 
> > I really don't see what you can do to help here.  Won't anything that
> > allows looking up an uncached inode by filehandle also risk finding the
> > wrong file?
> 
> On other view (as server side solution), we are thinking there is
> possible to make the stable filehandle on FAT if we disabled some
> operations (e.g. rename(), unlink()) which change inode location in FAT.
> 
> Yes, it would be stable, but supporting limited operations.
> 
> This is server side solution, and we comparing it with client solution.

Is that useful to anyone?

> >> > If it returns ESTALE, why does it return? I'm assuming the previous code
> >> > path is the cached FH path.
> >> The main point for observation is the file handle-which is used for
> >> all the NFS operation.
> >> So for all the NFS operation(read/write....) which makes use of the
> >> NFS file handle in between if there is a change in inode number
> >> It will result in ESTALE.
> >> Changing inode number on rename happened at NFS server by inode cache
> >> eviction with memory pressure.
> >> 
> >> lookupcache is used at NFS client to reduce number of LOOKUP operations.
> >> But , we can still get ESTALE if inode number at NFS Server change
> >> after LOOKUP, although lookupcache is disable.
> >> 
> >> LOOKUP return NFS FH->[inode number changed at NFS Server] ->
> >> But we still use old NFS FH returned from LOOKUP for any file
> >> operation(write,read,etc..)
> >> -> ESTALE will be returned.
> 
> Yes.  And I'm expecting as client side solution,
> 
> -> ESTALE will be returned -> discard old FH -> restart from LOOKUP ->
> make cached inode -> use returned new FH.
> 
> Yeah, I know this is unstable (there is no perfect solution for now),

You may end up with a totally different file, of course:

	client:			server:

	open "/foo/bar"
				rename "/foo/baz"->"/foo/bar"
	write to file

And now we're writing to the file that was originally named /foo/baz
when we should have gotten ESTALE.

--b.

> but if this works, this doesn't limit any operations.
> 
> We would want to compare client solution (-mm) and server solution
> (stable ino). Or I'd like to know which my knowledges/understanding are
> wrong here.
> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
