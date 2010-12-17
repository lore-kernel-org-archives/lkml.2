Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab0LQGxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 01:53:04 -0500
Received: from smtp-out.google.com ([216.239.44.51]:60610 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0LQGxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 01:53:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=k0laDRyKbwymZIGcfHu1jXStoaddwfiCm4V2dO4nAAjKK80bZHh9YWQ6oCS4bXyHSS
         eOdDsEWXGV4OVg2r0+hg==
Date: Thu, 16 Dec 2010 22:52:50 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
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
Subject: Re: [PATCH 22/35] writeback: trace global dirty page states
In-Reply-To: <20101217021934.GA9525@localhost>
Message-ID: <alpine.LSU.2.00.1012162239270.23229@sister.anvils>
References: <20101213144646.341970461@intel.com> <20101213150329.002158963@intel.com> <20101217021934.GA9525@localhost>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010, Wu Fengguang wrote:
> On Mon, Dec 13, 2010 at 10:47:08PM +0800, Wu, Fengguang wrote:
> 
> > +	TP_fast_assign(
> > +		strlcpy(__entry->bdi,
> > +			dev_name(mapping->backing_dev_info->dev), 32);
> > +		__entry->ino			= mapping->host->i_ino;
> 
> I got an oops against the above line on shmem. Can be fixed by the
> below patch, but still not 100% confident..
> 
> Thanks,
> Fengguang
> ---
> Subject: writeback fix dereferencing NULL shmem mapping->host
> Date: Thu Dec 16 22:22:00 CST 2010
> 
> The oops happens when doing "cp /proc/vmstat /dev/shm". It seems to be
> triggered on accessing host->i_ino, since the offset of i_ino is exactly
> 0x50. However I'm afraid the problem is not fully understand
> 
> 1) it's not normal that tmpfs will have mapping->host == NULL
> 
> 2) I tried removing the dereference as the below diff, however it
>    didn't stop the oops. This is very weird.
> 
> TRACE_EVENT balance_dirty_state:
> 
>  	TP_fast_assign(
>  		strlcpy(__entry->bdi,
>  			dev_name(mapping->backing_dev_info->dev), 32);

I believe this line above is actually the problem: you can imagine that
tmpfs leaves backing_dev_info->dev NULL, and dev_name() appears to
access dev->init_name at 64-bit offset 0x50 down struct device.

> -		__entry->ino			= mapping->host->i_ino;
>  		__entry->nr_dirty		= nr_dirty;
>  		__entry->nr_writeback		= nr_writeback;
>  		__entry->nr_unstable		= nr_unstable;
...
> 
> CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>

I prefer hughd@google.com, but the tiscali address survived unexpectedly.

> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/page-writeback.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- linux-next.orig/mm/page-writeback.c	2010-12-17 09:30:11.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2010-12-17 09:31:05.000000000 +0800
> @@ -907,6 +907,9 @@ void balance_dirty_pages_ratelimited_nr(
>  {
>  	struct backing_dev_info *bdi = mapping->backing_dev_info;
>  
> +	if (!mapping_cap_writeback_dirty(mapping))
> +		return;
> +
>  	current->nr_dirtied += nr_pages_dirtied;
>  
>  	if (unlikely(!current->nr_dirtied_pause))

That would not really be the right patch to fix your oops, but it
or something like would be a very sensible patch in its own right:
looking back through old patches I never got around to sending in,
I can see I had a very similar one two years ago, to save wasting
time on dirty page accounting here when it's inappropriate.
Though mine was testing !mapping_cap_account_dirty(mapping).

Hugh
