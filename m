Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597Ab0LUGAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 01:00:01 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab0LUF77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 00:59:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ubdmeDQbIB091AewB2h6yQ0xM2bxuinxbHYglQDmuu5a+/lE96XXQfy5PKUGL0Xgu7
         vtfRG5qRgKoAvAiinh/A==
Date: Mon, 20 Dec 2010 21:59:46 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: skip balance_dirty_pages() for in-memory fs
In-Reply-To: <20101217112111.GA8323@localhost>
Message-ID: <alpine.LSU.2.00.1012202127310.16112@tigran.mtv.corp.google.com>
References: <20101213144646.341970461@intel.com> <20101213150329.002158963@intel.com> <20101217021934.GA9525@localhost> <alpine.LSU.2.00.1012162239270.23229@sister.anvils> <20101217112111.GA8323@localhost>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010, Wu Fengguang wrote:

> This avoids unnecessary checks and dirty throttling on tmpfs/ramfs.
> 
> It also prevents
> 
> [  388.126563] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
> 
> in the balance_dirty_pages tracepoint, which will call
> 
> 	dev_name(mapping->backing_dev_info->dev)
> 
> but shmem_backing_dev_info.dev is NULL.
> 
> CC: Hugh Dickins <hughd@google.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Whilst I do like this change, and I do think it's the right thing to do
(given that the bdi has explicitly opted out of what it then got into),
I've a sneaking feeling that something somewhere may show a regression
from it.  IIRC, there were circumstances in which it actually did
(inadvertently) end up throttling the tmpfs writing - if there were
too many dirty non-tmpfs pages around??

What am I saying?!  I think I'm asking you to look more closely at what
actually used to happen, and be more explicit about the behavior you're
stopping here - although the patch is mainly code optimization, there
is some functional change I think.  (You do mention throttling on
tmpfs/ramfs, but the way it worked out wasn't straightforward.)

I'd better not burble on for a third paragraph!

Hugh

> ---
>  mm/page-writeback.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- linux-next.orig/mm/page-writeback.c	2010-12-17 19:09:19.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2010-12-17 19:09:22.000000000 +0800
> @@ -899,6 +899,9 @@ void balance_dirty_pages_ratelimited_nr(
>  {
>  	struct backing_dev_info *bdi = mapping->backing_dev_info;
>  
> +	if (!bdi_cap_account_dirty(bdi))
> +		return;
> +
>  	current->nr_dirtied += nr_pages_dirtied;
>  
>  	if (unlikely(!current->nr_dirtied_pause))
