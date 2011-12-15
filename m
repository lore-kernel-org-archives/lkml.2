Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab1LODFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:05:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48020 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab1LODFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:05:24 -0500
Date: Wed, 14 Dec 2011 19:05:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: slub: Fix per cpu partial statistics
In-Reply-To: <alpine.LFD.2.02.1112120913000.2555@tux.localdomain>
Message-ID: <alpine.DEB.2.00.1112141858380.27595@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1111230924500.16544@router.home> <alpine.LFD.2.02.1112120913000.2555@tux.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011, Pekka Enberg wrote:

> > Subject: slub: Fix per cpu partial statistics
> > 
> > Support for SO_OBJECTS was not properly added to show_slab_objects().
> > 
> > If SO_OBJECTS is not set then the number of slab pages needs to be
> > returned and not the number of objects in the partial slabs as now.
> > 
> > We do not have that number so just return 1 until we find a better
> > way to determine that.
> > 
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> > 
> > ---
> > mm/slub.c |   10 +++++++---
> > 1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6/mm/slub.c
> > ===================================================================
> > --- linux-2.6.orig/mm/slub.c	2011-11-22 13:42:23.000000000 -0600
> > +++ linux-2.6/mm/slub.c	2011-11-22 13:47:52.000000000 -0600
> > @@ -4451,8 +4451,8 @@ static ssize_t show_slab_objects(struct
> > 				continue;
> > 
> > 			if (c->page) {
> > -					if (flags & SO_TOTAL)
> > -						x = c->page->objects;
> > +				if (flags & SO_TOTAL)
> > +					x = c->page->objects;
> > 				else if (flags & SO_OBJECTS)
> > 					x = c->page->inuse;
> > 				else

This was already fixed up by "slub: avoid potential NULL dereference or 
corruption" in slab/next, so I suggest dropping this hunk.

> > @@ -4464,7 +4464,11 @@ static ssize_t show_slab_objects(struct
> > 			page = c->partial;
> > 
> > 			if (page) {
> > -				x = page->pobjects;
> > +				if (flags & SO_OBJECTS)
> > +					x = page->pobjects;
> > +				else
> > +					/* Assume one */
> > +					x = 1;
> >                                 total += x;
> >                                 nodes[c->node] += x;
> > 			}
> > 
> 
> Looks OK to me. David, Eric?
> 

I thought page->pages would be better?
