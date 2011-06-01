Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab1FAQ6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 12:58:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39305 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490Ab1FAQ6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 12:58:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=iFJ6FR6im1WlFKjsmac+7pQtAACzndexkdthb+eBKo/RSyxCDwL1JbZzHxzAmvFR3b
         93KuCAJsHJHLPSNdJoPQ==
Date: Wed, 1 Jun 2011 09:58:18 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Hellwig <hch@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/14] tmpfs: take control of its truncate_range
In-Reply-To: <20110601003942.GB4433@infradead.org>
Message-ID: <alpine.LSU.2.00.1106010940590.23468@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils> <alpine.LSU.2.00.1105301737040.5482@sister.anvils> <20110601003942.GB4433@infradead.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot for looking at these.

On Tue, 31 May 2011, Christoph Hellwig wrote:
> > Note that drivers/gpu/drm/i915/i915_gem.c i915_gem_object_truncate()
> > calls the tmpfs ->truncate_range directly: update that in a separate
> > patch later, for now just let it duplicate the truncate_inode_pages().
> > Because i915 handles unmap_mapping_range() itself at a different stage,
> > we have chosen not to bundle that into ->truncate_range.
> 
> In your next series that makes it call the readpae replacement directly
> it might be nice to also call directly into shmem for hole punching.

(i915 isn't really doing hole-punching there, I think it just found it
a useful interface to remove the page-and-swapcache without touching
i_size.  Parentheses because it makes no difference to your point.)

Okay, I'd better do a v2 (probably not before the weekend), and change
that around to go explicitly to shmem there as well: I'd rather settle
the interfaces to other subsystems in this series, than mix it with the
implementation in the next series.

When I say "shmem", I am including the !SHMEM-was-TINY_SHMEM case too,
which goes to ramfs.  Currently i915 has been configured to disable that
possibility, though we insisted on it originally: there may or may not be
good reason for disabling it - may just be a side-effect of the rather
twisted unintuitive SHMEM/TMPFS dependencies.

> 
> > I notice that ext4 is now joining ocfs2 and xfs in supporting fallocate
> > FALLOC_FL_PUNCH_HOLE: perhaps they should support truncate_range, and
> > tmpfs should support fallocate?  But worry about that another time...
> 
> No, truncate_range and the madvice interface are pretty sad hacks that
> should never have been added in the first place.  Adding
> FALLOC_FL_PUNCH_HOLE support for shmem on the other hand might make
> some sense.

Fine, I'll add tmpfs PUNCH_HOLE later on.  And wire up madvise MADV_REMOVE
to fallocate PUNCH_HOLE, yes?

Would you like me to remove the ->truncate_range method from
inode_operations completely?  I can do that now, hack directly to tmpfs
in the interim, in the same way as for i915.

Hugh
