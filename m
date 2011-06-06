Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1FFFhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 01:37:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38545 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab1FFFhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 01:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=rTVhuf1pa4e0+HsnBwm8afXZnk3qbQ7JwGRHZx6gbUZgejU9usbZPiNC4C+3wELhzs
         qiKd9vW+5+Y4w1Ez8htg==
Date: Sun, 5 Jun 2011 22:37:08 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Hellwig <hch@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/14] tmpfs: take control of its truncate_range
In-Reply-To: <20110603051609.GC16721@infradead.org>
Message-ID: <alpine.LSU.2.00.1106052206260.17330@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils> <alpine.LSU.2.00.1105301737040.5482@sister.anvils> <20110601003942.GB4433@infradead.org> <alpine.LSU.2.00.1106010940590.23468@sister.anvils> <20110603051609.GC16721@infradead.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jun 2011, Christoph Hellwig wrote:
> On Wed, Jun 01, 2011 at 09:58:18AM -0700, Hugh Dickins wrote:
> 
> > Fine, I'll add tmpfs PUNCH_HOLE later on.  And wire up madvise MADV_REMOVE
> > to fallocate PUNCH_HOLE, yes?
> 
> Yeah.  One thing I've noticed is that the hole punching doesn't seem
> to do the unmap_mapping_range.  It might be worth to audit that from the
> VM point of view.

I'd noticed that recently too.

At first I was alarmed, but it's actually an inefficiency rather than
a danger: because at some stage a safety unmap_mapping_range() call has
been added into truncate_inode_page().  I don't know what case that was
originally for, but it will cover fallocate() for now.

This is a call to unmap_mapping_range() with 0 for the even_cows arg
i.e. it will not remove COWed copies of the file page from private
mappings.  I think that's good semantics for hole punching (and it's
difficult to enforce the alternative, because we've neither i_size nor
page lock to prevent races); but it does differ from the (odd) POSIX
truncation behaviour, to unmap even the private COWs.

What do you think?  If you think we should unmap COWs, then it ought
to be corrrected sooner.  Otherwise I was inclined not to rush (I'm
also wondering about cleancache in truncation: that should be another
mail thread, but might call for passing down a flag useful here too).

You might notice that the alternate hole-punching's vmtruncate_range()
is passing even_cows 1: doesn't matter in practice, since that one has
been restricted to operating on shared writable mappings.  Oh, I
suppose there could also be a parallel private writable mapping,
whose COWs would get unmapped.  Hmm, worth worrying about if we
choose the opposite with fallocate hole punching?

> 
> > Would you like me to remove the ->truncate_range method from
> > inode_operations completely?
> 
> Doing that would be nice.  Do we always have the required file struct
> for ->fallocate in the callers?

Good point, but yes, no problem.

I'm carrying on using ->truncate_range for the moment, partly because
I don't want to get diverted by testing the ->fallocate alternative yet,
but also because removing ->truncate_range now would force an immediate
change on drm/i915: better use shmem_truncate_range() for the transition.

Hugh
