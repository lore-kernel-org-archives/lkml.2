Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1GKLBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:01:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab1GKLBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:01:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1310305703.13309.7.camel@twins>
References: <1310305703.13309.7.camel@twins> <4E0AF2BA.2040706@gmail.com> <1302756608.2854.10.camel@perseus.themaw.net> <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com> <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com> <4DA5DCB8.3040101@gmail.com> <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com> <4DA5F569.9020309@gmail.com> <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com> <24792.1302808448@redhat.com> <2477.1309342656@redhat.com> <4E1962BE.8010204@redhat.com> 
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, Ric Wheeler <rwheeler@redhat.com>,
        Alexander Viro <aviro@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Michal Suchanek <hramrach@centrum.cz>, Ian Kent <ikent@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, miklos@szeredi.hu
Subject: Re: Union mount and lockdep design issues
Date: Mon, 11 Jul 2011 12:01:09 +0100
Message-ID: <1408.1310382069@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> > > The main problem I've got is that it causes lockdep to generate warnings
> > > when the top layer and one of the lower layers are of the same
> > > filesystem type.  The obvious way round this is to give each superblock
> > > its own i_mutex lock class rather than putting this in the
> > > file_system_type struct, but I'm not sure of the consequences (the two
> > > obvious problems are superblock transience and the fact that there may
> > > be so many more of them that it may explode lockdep).
> 
> Can't, that would involve classes in dynamically allocated memory (as
> you cannot a-priori determine how many instances there will be of a
> particular sb). There a number of good (although at times rather
> frustrating) reasons why lockdep cannot do dynamic memory.

What does this mean for filesystem modules that get removed and inserted
again?  That's something I do during development rather than rebooting the
machine.

> Most of those arguments center around things like: allocating memory
> involves locks, therefore we could end up wanting to allocate memory
> while in the allocator etc.

I'm not sure what these arguments are.  Initialising the lock class doesn't
need to be done with any locks held.

I assumed the problems came from key reuse and the storage of out-of-date
keys, and an over-abundance of keys, where a lock class's key is simply the
pointer to its struct.

> Also, why would you want to have a class per sb-instance? From last
> talking to David, he said there could only ever be 2 filesystems
> involved in this, the top and bottom, and it is determined on (union)
> mount time which is which.

There can be more than 2 - one upperfs (the actual union) and many lowerfs -
though I think only one lowerfs is accessed at a time.

However, I was wondering that if in the future it could be possible to make it
possible to union over a union.  I think that conceptually it shouldn't be that
hard, but definitely lockdep presents a barrier unless the top union goes
behind the scenes of the lower union and interacts with its lowerfs's directly.

> I'm also assuming that once a filesystem is part of a union mount, it
> cannot be accessed from outside of said union (can it? can the botton be
> itself be the top layer of another union?)

Not at the moment; the hard read-only requirements on the lowerfs versus the
writeability requirements of the upperfs (you can't enter a directory that you
can't mirror up) prevent it.

However, at some point I'd be interested in trying to make it possible to union
over a writeable filesystem.  This is pretty much a requirement for unioning
over NFS (as you can't tell the server to make the volume you're mounting hard
read-only).

> Therefore, why can't we, on constructing the union layers, reset the lock
> classes?

Reset in what sense?

> Also, in what state are the filesystems on construction of the union?  Are
> they already fully formed and populated (do inodes already exist?)

The lower filesystems must be fully formed and, at present, may not be modified
whilst in the union.

The upper filesystem can be empty or filled by a previous union.  In fact,
there's nothing stopping the upper fs being an ordinary fs that's then used as
the upper layer in a union, but I'm not sure you can then access the lower
echelons as the directories don't contain fallthru entries.

David
