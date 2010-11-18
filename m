Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039Ab0KRSAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:00:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:23709 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759984Ab0KRSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:00:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=oOvYCRp7m3PNAjSPcyYX1PqnohqF5Xe+8KDx0fl3PtQ8oABVTQnSIkftDnRhx8h+OC
         pnHxNFUclX4dhuQdMAkw==
Date: Thu, 18 Nov 2010 10:00:13 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: Christoph Hellwig <hch@infradead.org>
cc: Theodore Tso <tytso@mit.edu>, Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering
 writeback
In-Reply-To: <20101118133904.GB18834@infradead.org>
Message-ID: <alpine.LSU.2.00.1011180941450.3210@tigran.mtv.corp.google.com>
References: <1289996638-21439-1-git-send-email-walken@google.com> <1289996638-21439-4-git-send-email-walken@google.com> <20101117125756.GA5576@amd> <1290007734.2109.941.camel@laptop> <20101118054629.GA3339@amd> <2ADBEB7E-0EC8-4536-B556-0453A8E1D5FA@mit.edu>
 <20101118133904.GB18834@infradead.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Christoph Hellwig wrote:
> On Thu, Nov 18, 2010 at 05:43:06AM -0500, Theodore Tso wrote:
> > Why is it at all important that mlock() force block allocation for sparse blocks?    It's  not at all specified in the mlock() API definition that it does that.
> > 
> > Are there really programs that assume that mlock() == fallocate()?!?
> 
> If there are programs that do they can't predate linux 2.6.15, and only
> work on btrfs/ext4/xfs/etc, but not ext2/ext3/reiserfs.  Seems rather
> unlikely to me.

Yes, almost.  I'm very much on this side, that mlocking should not dirty
all those pages; but better admit one argument for the opposition - it's
possible that we'd find a case somewhere, which has always (i.e. even pre-
page_mkwrite) relied upon mlock of an entirely sparse file to result in
a nicely ordered allocation of blocks to the file (as would often have
happened with pdflush, I think), to give good sequential read patterns
ever after; but with this patch would now get much more random block
ordering, according to where the real writes actually fall.

It would be possible for a filesystem's ->fault(vma, &vmf) to observe
that it's being called on a VM_LOCKED|VM_SHARED vma, and make sure that
the page has backing in that case, to reproduce the old allocation behaviour
without all the unnecessary writing.  But that would be extra work in every
filesystem that cares.

Hugh
