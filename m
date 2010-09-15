Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0IOWZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 18:25:54 -0400
Received: from THUNK.ORG ([69.25.196.29]:60972 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab0IOWZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 18:25:52 -0400
Date: Wed, 15 Sep 2010 18:25:09 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
Message-ID: <20100915222509.GE3730@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	David Rientjes <rientjes@google.com>,
	Pekka Enberg <penberg@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org>
 <1284490101-2362-2-git-send-email-penberg@kernel.org>
 <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com>
 <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com>
 <alpine.DEB.2.00.1009141320090.7123@chino.kir.corp.google.com>
 <4C8FE263.5070101@kernel.org>
 <alpine.DEB.2.00.1009141646350.26982@chino.kir.corp.google.com>
 <1097CAA8-8234-4FE2-BAA1-9C7D9FA01CEC@mit.edu>
 <alpine.DEB.2.00.1009151322370.29425@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009151322370.29425@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 01:33:07PM -0700, David Rientjes wrote:
> I'd love to have per-cache statistics that we could export without the 
> cost of the extra memory from fragmented partial slabs.  You'd have to do 
> this for every cache even if it's a "superslab", though, to avoid a branch 
> in the fastpath to find the cpu slab.  I'm not sure if Pekka and Christoph 
> will be happy with the allocation of kmem_cache structures for mergable 
> caches and the increment of the statistic in the fastpath.

I agree, it would be cleaner if we could separate out the data
structures which are used for accounting for the number of objects
allocated and reclaimed for each object type, and then have a separate
data structure which is used for dealing with the pages used by those
slabs that have been merged together.

All I can say is I hope the merging code is intelligent.  We recently
had a problem where we were wasting huge amounts of memory because we
were allocating large numbers of a the ext4_group_info structure,
which was 132 bytes, and for which kmalloc() used a size-256 slab ---
and the wasted memory was enough to cause OOM's in a critical
(unfortunately statically sized) container when the disks got large
enough and numerous enough.  The fix was to use a separate cache just
for these 132-byte objects, and not to use kmalloc().

I would be really annoyed if we switched to a slab allocator which did
merging, and then found that the said slab allocator helpfully merged
the 132-byte slab cache and the size-256 slab into a single slab
cache, on the grounds that it thought it would save memory...  (I
guess I'm just really really nervous about merging happening behind my
back, and I really like having the per-object type allocation
statistics.)

							- Ted
