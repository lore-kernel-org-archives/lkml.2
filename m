Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086Ab0EMPg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:36:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58478 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056Ab0EMPgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:36:23 -0400
Date: Thu, 13 May 2010 11:36:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@infradead.org,
       akpm@linux-foundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org, david@fromorbit.com
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100513153620.GA2774@infradead.org>
References: <20100512212403.GE3597@localhost.localdomain> <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 09:39:27PM -0400, Josef Bacik wrote:
> I just got a suggestion from hpa about instead just moving what BTRFS does into
> the generic_perform_write.  What btrfs does is allocates a chunk of pages to
> cover the entirety of the write, sets everything up, does the copy from user
> into the pages, and tears everything down, so essentially what
> generic_perform_write does, just with more pages.  I could modify
> generic_perform_write and the write_begin/write_end aops to do this, where
> write_begin will return how many pages it allocated, copy in all of the
> userpages into the pages we allocated at once, and then call write_end with the
> pages we allocated in write begin.  Then I could just make btrfs do
> write_being/write_end.  So which option seems more palatable?  Thanks,

Having a more efficient generic write path would be great.  I'm not
quite sure btrfs gets everything that is needed right already, but
getting started on this would be great.

And to get back to the original question: adding a ->perform_write
is a really dumb idea.  It doesn't fit into the structure of the real
AOPs at all as it required context dependent locking and so and so
on.  It would just be a nasty hack around the fact that we still leave
too much work to the filesystem in the write path, and for the bad
prototype of the ->aio_read/->aio_write methods.

For a start generic_segment_checks should move out of the methods
and into fs/read_write.c before calling into the methods.  To do
this fully we'll need to pass down a count of total bytes into
->aio_read and ->aio_write, though.

Adding a new generic_write_prep helper for all the boilderplate
code in ->aio_write also seems fine to me.
