Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2ILRqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:46:03 -0400
Received: from fieldses.org ([174.143.236.118]:50485 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab2ILRqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:46:01 -0400
Date: Wed, 12 Sep 2012 13:45:56 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Namjae Jeon <linkinjeon@gmail.com>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
Message-ID: <20120912174556.GH3009@fieldses.org>
References: <87har6kmfx.fsf@devron.myhome.or.jp>
 <CAKYAXd-ZNmCbHqmFX=YXti7XprhD_Hgvmnd=TnKPVoFc88Sc4A@mail.gmail.com>
 <87oblc4u6f.fsf@devron.myhome.or.jp>
 <CAKYAXd-gO5Pw=0unjB=YQJhu6W=g7VpZYnmHXkve-k8_4VjpgA@mail.gmail.com>
 <871ui84l4l.fsf@devron.myhome.or.jp>
 <CAKYAXd89CKZa9nV3pBiFgcpGsYzX1-iCB+UJ8bBvst88GnB4mg@mail.gmail.com>
 <20120912143227.GE3009@fieldses.org>
 <87vcfjfa14.fsf@devron.myhome.or.jp>
 <20120912171128.GG3009@fieldses.org>
 <87r4q7f8fw.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4q7f8fw.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 02:38:11AM +0900, OGAWA Hirofumi wrote:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> >> On other view (as server side solution), we are thinking there is
> >> possible to make the stable filehandle on FAT if we disabled some
> >> operations (e.g. rename(), unlink()) which change inode location in FAT.
> >> 
> >> Yes, it would be stable, but supporting limited operations.
> >> 
> >> This is server side solution, and we comparing it with client solution.
> >
> > Is that useful to anyone?
> 
> Good question. I'm not sure though, Namjae is asking. And I was asked
> about stable read-only export in past.
> 
> >> >> LOOKUP return NFS FH->[inode number changed at NFS Server] ->
> >> >> But we still use old NFS FH returned from LOOKUP for any file
> >> >> operation(write,read,etc..)
> >> >> -> ESTALE will be returned.
> >> 
> >> Yes.  And I'm expecting as client side solution,
> >> 
> >> -> ESTALE will be returned -> discard old FH -> restart from LOOKUP ->
> >> make cached inode -> use returned new FH.
> >> 
> >> Yeah, I know this is unstable (there is no perfect solution for now),
> >
> > You may end up with a totally different file, of course:
> >
> > 	client:			server:
> >
> > 	open "/foo/bar"
> > 				rename "/foo/baz"->"/foo/bar"
> > 	write to file
> >
> > And now we're writing to the file that was originally named /foo/baz
> > when we should have gotten ESTALE.
> 
> I see. So, client can't solve the ESTALE if inode cache was evicted,
> right? (without application changes)

I don't see how.


As another server-side workaround: maybe they could try tuning the inode
caching to make eviction less likely?

Grepping around...  Documentation/sysctl/vm.txt mentions a
vfs_cache_pressure parameter.

--b.
