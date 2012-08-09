Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2HIG7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:59:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64951 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab2HIG7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:59:30 -0400
Date: Thu, 9 Aug 2012 02:59:31 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 11/12] block: Add bio_clone_bioset()
Message-ID: <20120809065931.GB9128@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-12-git-send-email-koverstreet@google.com>
 <20120808232120.GK6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809025610.GK7262@moria.home.lan>
 <20120809065251.GD2845@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809065251.GD2845@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 11:52:51PM -0700, Tejun Heo wrote:
> On Wed, Aug 08, 2012 at 07:56:10PM -0700, Kent Overstreet wrote:
> > > So, bio_clone() loses its function comment.  Also, does it even make
> > > sense to call bio_clone() from fs_bio_set?
> > 
> > I'll re add the function comment if you want, just for a single line
> > wrapper I don't know if it's worth the cost - comments get out of date,
> > and they're more stuff to wade through.
> 
> People actually look at docbook generated docs.  I don't know why but
> they do.  It's a utility function at block layer.  Please just add the
> comment.

Will do then.

> > > Let's say it's so, then
> > > what's the difference from using _kmalloc variant?
> > 
> > bio_kmalloc() fails if nr_iovecs > 1024, bio_alloc_bioset() fails if
> > nr_iovecs > 256
> > 
> > and bio_alloc_bioset() is mempool backed, bio_kmalloc() is not.
> > 
> > AFAICT that's it.
> 
> So, the thing is being mempool backed doesn't mean anything if
> multiple layers use the pool. 

It's worse than just using kmalloc, because then you've introduced the
possibility of deadlock.

> I *suspect* fs_bio_set is supposed to
> be used by fs layer - ie. where bios originate.  The reason why I
> wondered about bio_clone() is that bio_clone() is almost always used
> from stacking drivers and stacking driver tapping into fs reserve is
> buggy.  So, I'm wondering whether cloning from fs_bio_set should be
> supported at all.

That's actually a really good point.

I just grepped and there's actually only 3 callers - I thought there'd
be more.  That should be easy to fix, at least.
