Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030264Ab2ERWVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:21:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37503 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab2ERWVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:21:34 -0400
Date: Fri, 18 May 2012 15:21:30 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 08/13] block: Kill bi_destructor
Message-ID: <20120518222130.GC32300@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <de05855cf0fa4800cfab7e8340f106dccc7a75a1.1337308722.git.koverstreet@google.com>
 <20120518162142.GH19388@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518162142.GH19388@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 09:21:42AM -0700, Tejun Heo wrote:
> Hello,
> 
> > @@ -417,8 +409,11 @@ void bio_put(struct bio *bio)
> >  
> >  		if (bio->bi_pool)
> >  			bio_free(bio, bio->bi_pool);
> > -		else
> > -			bio->bi_destructor(bio);
> > +		else {
> > +			if (bio_integrity(bio))
> > +				bio_integrity_free(bio, fs_bio_set);
> > +			kfree(bio);
> 
> if {
> } else {
> }
> 
> And wouldn't it be better to make bio_free() handle kfreeing too?

That'd kind of change the semantics of bio_free() - but I suppose it'd
make sense.

I'm not terribly happy with how the bio integrity data belongs to
fs_bio_set for kmalloced bios. Maybe I'll change that at some point.
