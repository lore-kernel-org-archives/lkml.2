Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1GJNs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 09:48:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46889 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab1GJNsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 09:48:55 -0400
Subject: Re: Union mount and lockdep design issues
From: Peter Zijlstra <peterz@infradead.org>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Alexander Viro <aviro@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Michal Suchanek <hramrach@centrum.cz>, Ian Kent <ikent@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, miklos@szeredi.hu
In-Reply-To: <4E1962BE.8010204@redhat.com>
References: <4E0AF2BA.2040706@gmail.com>
	 <1302756608.2854.10.camel@perseus.themaw.net>
	 <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	 <4DA4B6A8.7030804@gmail.com>
	 <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	 <4DA5DCB8.3040101@gmail.com>
	 <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>
	 <4DA5F569.9020309@gmail.com>
	 <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
	 <24792.1302808448@redhat.com> <2477.1309342656@redhat.com>
	 <4E1962BE.8010204@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 10 Jul 2011 15:48:23 +0200
Message-ID: <1310305703.13309.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-10 at 09:28 +0100, Ric Wheeler wrote:
> On 06/29/2011 11:17 AM, David Howells wrote:
> > Ric Wheeler<ricwheeler@gmail.com>  wrote:
> >
> >> I think that it has been a while since David reposted the refreshed patch set
> >> for union mounts&  know that overlayfs has recent updates as well.
> >>
> >> Despite that, I have not seen a lot of feedback from reviewers or testers.

> > The main problem I've got is that it causes lockdep to generate warnings when
> > the top layer and one of the lower layers are of the same filesystem type.  The
> > obvious way round this is to give each superblock its own i_mutex lock class
> > rather than putting this in the file_system_type struct, but I'm not sure of
> > the consequences (the two obvious problems are superblock transience and the
> > fact that there may be so many more of them that it may explode lockdep).

Can't, that would involve classes in dynamically allocated memory (as
you cannot a-priori determine how many instances there will be of a
particular sb). There a number of good (although at times rather
frustrating) reasons why lockdep cannot do dynamic memory.

Most of those arguments center around things like: allocating memory
involves locks, therefore we could end up wanting to allocate memory
while in the allocator etc.

Also, why would you want to have a class per sb-instance? From last
talking to David, he said there could only ever be 2 filesystems
involved in this, the top and bottom, and it is determined on (union)
mount time which is which.

I'm also assuming that once a filesystem is part of a union mount, it
cannot be accessed from outside of said union (can it? can the botton be
itself be the top layer of another union?)

Therefore, why can't we, on constructing the union layers, reset the
lock classes?

Also, in what state are the filesystems on construction of the union?
Are they already fully formed and populated (do inodes already exist?)

> Peter, Ingo, are either of you the right people to think about how to fix 
> lockdep to handle stacked components (like ext4 used in union mounts stacked on 
> top of another ext4 fs) where both layers will routinely lock to the same object?

We would be.

> Should we do a specific hack to work around this for union mounts or look for 
> lockdep to change?

I still don't understand the problem at all, so lets start there ;-)
