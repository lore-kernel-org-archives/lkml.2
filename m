Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab1KDTG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 15:06:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52832 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932296Ab1KDTG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 15:06:27 -0400
Date: Fri, 4 Nov 2011 19:06:16 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Xiaotian Feng <dfeng@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Message-ID: <20111104190616.GB3366@decadent.org.uk>
References: <20111102221600.GA26650@kroah.com>
 <20111102221454.703920975@clark.kroah.org>
 <1320420256.3079.172.camel@deadeye>
 <20111104171425.GA4893@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104171425.GA4893@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [050/107] block: check for proper length of iov entries
 earlier in blk_rq_map_user_iov()
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 10:14:26AM -0700, Greg KH wrote:
> On Fri, Nov 04, 2011 at 03:24:16PM +0000, Ben Hutchings wrote:
> > On Wed, 2011-11-02 at 15:14 -0700, Greg KH wrote:
> > > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > > 
> > > ------------------
> > > 
> > > From: Xiaotian Feng <dfeng@redhat.com>
> > > 
> > > commit 5478755616ae2ef1ce144dded589b62b2a50d575 upstream.
> > > 
> > > commit 9284bcf checks for proper length of iov entries in
> > > blk_rq_map_user_iov(). But if the map is unaligned, kernel
> > > will break out the loop without checking for the proper length.
> > > So we need to check the proper length before the unalign check.
> > 
> > This will catch an unaligned zero-length entry.  But there's still no
> > check for zero-length iov entries *after* the unaligned entry.
> > 
> > [...]
> > > --- a/block/blk-map.c
> > > +++ b/block/blk-map.c
> > > @@ -201,12 +201,13 @@ int blk_rq_map_user_iov(struct request_q
> > >  	for (i = 0; i < iov_count; i++) {
> > >  		unsigned long uaddr = (unsigned long)iov[i].iov_base;
> > >  
> > > +		if (!iov[i].iov_len)
> > > +			return -EINVAL;
> > > +
> > >  		if (uaddr & queue_dma_alignment(q)) {
> > >  			unaligned = 1;
> > >  			break;
> > 
> > I think the correct fix is just to remove the 'break'.
> 
> Then the fix should go upstream first :)

But if I'm right, this is a non-fix and doesn't belong in the
longterm update.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
