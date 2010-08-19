Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0HSW0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 18:26:17 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:36432 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751653Ab0HSW0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 18:26:14 -0400
Date: Fri, 20 Aug 2010 08:25:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        npiggin@kernel.dk, a.p.zijlstra@chello.nl
Subject: Re: [bug] radix_tree_gang_lookup_tag_slot() looping endlessly
Message-ID: <20100819222559.GW10429@dastard>
References: <20100818135651.GK7362@dastard>
 <20100818173708.GB15010@quack.suse.cz>
 <20100818232917.GN7362@dastard>
 <20100819072520.GR7362@dastard>
 <20100819132552.GU10429@dastard>
 <20100819155838.GB3295@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819155838.GB3295@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 05:58:39PM +0200, Jan Kara wrote:
>   Hi Dave,
> 
> On Thu 19-08-10 23:25:52, Dave Chinner wrote:
> > It looks to me like radix_tree_set_tag_if_tagged() is fundamentally
> > broken.  All the tag set/clear code stores the tree path in a cursor
> > and uses that to propagate the tags if and only if the full path
> > from root to leaf is resolved. radix_tree_set_tag_if_tagged() sets
> > tags on intermediate nodes before it has resolved the full path and
> > hence can set tags when it should not. The "should not" cases occur
> > when we have to tag sub-ranges or the scan aborts because it's
> > reached the number ot tag in a batch.
>   Thanks for debugging this! You are right that the code can leave dangling
> tag when we end the scan at the end of given range but the first tagged
> leaf is after the end of the given range (there shouldn't be a problem with
> the batches because there we can exit only just after we tag a leaf so that
> should be OK).
>   There are two possibilities how to fix the bug:
> a) Always tag bottom up - i.e., when we see leaf that should be tagged, go
> up and tag the parent as well if it is not already tagged.
> b) When we exit the search and we didn't not set any leaf tag since last
> time we went down, we walk up the tree and do an equivalent of
> radix_tree_clear_tag().
>   I'll probably go for a) since it looks more robust but b) would be
> probably faster.

I think that when it comes to data integrity, more robust should
win over speed every time. I think it can be done quite easily,
though, having slept on it - we have the current path in the
open_slots[] array, so we could just walk that when we set a leaf
tag. That should be easy to optimise as well - just keep track of
how high up the path we have set the tag and only walk that far
when setting the tags. That way we don't continually set the tag on
the root higher level slots. That shouldn't be any slower than the
current code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
