Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab1GKNzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:55:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757468Ab1GKNzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:55:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1310385651.18678.59.camel@twins>
References: <1310385651.18678.59.camel@twins> <1310305703.13309.7.camel@twins> <4E0AF2BA.2040706@gmail.com> <1302756608.2854.10.camel@perseus.themaw.net> <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com> <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com> <4DA5DCB8.3040101@gmail.com> <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com> <4DA5F569.9020309@gmail.com> <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com> <24792.1302808448@redhat.com> <2477.1309342656@redhat.com> <4E1962BE.8010204@redhat.com> <1408.1310382069@redhat.com> 
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, Ric Wheeler <rwheeler@redhat.com>,
        Alexander Viro <aviro@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Michal Suchanek <hramrach@centrum.cz>, Ian Kent <ikent@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, miklos@szeredi.hu
Subject: Re: Union mount and lockdep design issues
Date: Mon, 11 Jul 2011 14:54:50 +0100
Message-ID: <16414.1310392490@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> At some point lockdep runs out of resources and you'll have to reboot.
> This is true for all module muck.

Fair enough; I guess for normal use, modules just don't get unloaded.

> > There can be more than 2 - one upperfs (the actual union) and many lowerfs -
> > though I think only one lowerfs is accessed at a time.
> 
> Right, however I understood from our earlier discussion that the vfs
> would only ever try to lock 2 filesystems at a time, the top and one
> lower.

That's what I meant by 'only one lowerfs is accessed at a time'.

> Aside from lockdep, how many fs locks will you nest and how will you
> enforce the filesystem relations remain a DAG?

This ought to be fine.  Unionmount requires the superblock for the upperfs be
fresh and unsullied when it gets to union it.  Furthermore, it shouldn't allow
that partition to be mounted elsewhere in a second mount whilst it is still
unioned.  Bind mounts should be okay, since they're effectively a reference on
the union we already have.

> Right, ok, but lets try and make the current situation work first. I
> understand the desire to later grow.

Indeed.

> > The upper filesystem can be empty or filled by a previous union.  In fact,
> > there's nothing stopping the upper fs being an ordinary fs that's then used
> > as the upper layer in a union, but I'm not sure you can then access the
> > lower echelons as the directories don't contain fallthru entries.
> 
> Right, so in both cases they can be fully formed, in that case we'll
> need to iterate all inodes and change their lock class as well.

I think I misunderstood you, then.  'Fully formed' in what sense?  I assumed
you meant populated on disk.

I'll post the two patches I have to deal with this.  The first propagates the
mount flags to sget() and the second makes use of MS_UNION in sget() to key the
locks appropriately.

David
