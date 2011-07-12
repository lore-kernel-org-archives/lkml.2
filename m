Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab1GLW4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 18:56:36 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58279 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab1GLW4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 18:56:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=PFp5cCL3Bx5vix5O1Z06gpS/o/b5IFMBZLSw7zhjwKXfCNSdp3IJ6TBtMb11q7oPb
	E78L2mWJsP25jmdjbUv+w==
Date: Tue, 12 Jul 2011 15:56:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/12] radix_tree: exceptional entries and indices
In-Reply-To: <20110618144832.cfc665b0.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1107121536100.2112@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils> <alpine.LSU.2.00.1106140341070.29206@sister.anvils> <20110617163854.49225203.akpm@linux-foundation.org> <alpine.LSU.2.00.1106171702150.1345@sister.anvils>
 <20110618144832.cfc665b0.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jun 2011, Andrew Morton wrote:
> On Fri, 17 Jun 2011 17:13:38 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> > On Fri, 17 Jun 2011, Andrew Morton wrote:
> > > On Tue, 14 Jun 2011 03:42:27 -0700 (PDT)
> > > Hugh Dickins <hughd@google.com> wrote:
> > > 
> > > > The low bit of a radix_tree entry is already used to denote an indirect
> > > > pointer, for internal use, and the unlikely radix_tree_deref_retry() case.
> > > > Define the next bit as denoting an exceptional entry, and supply inline
> > > > functions radix_tree_exception() to return non-0 in either unlikely case,
> > > > and radix_tree_exceptional_entry() to return non-0 in the second case.
> > > 
> > > Yes, the RADIX_TREE_INDIRECT_PTR hack is internal-use-only, and doesn't
> > > operate on (and hence doesn't corrupt) client-provided items.
> > > 
> > > This patch uses bit 1 and uses it against client items, so for
> > > practical purpoese it can only be used when the client is storing
> > > addresses.  And it needs new APIs to access that flag.
> > > 
> > > All a bit ugly.  Why not just add another tag for this?  Or reuse an
> > > existing tag if the current tags aren't all used for these types of
> > > pages?
> > 
> > I couldn't see how to use tags without losing the "lockless" lookups:
> 
> So lockless pagecache broke the radix-tree tag-versus-item coherency as
> well as the address_space nrpages-vs-radix-tree coherency.

I don't think that remark is fair to lockless pagecache at all.  If we
want the scalability advantage of lockless lookup, yes, we don't have
strict coherency with tagging at that time.  But those places that need
to worry about that coherency, can lock to do so.

> Isn't it fun learning these things.
> 
> > because the tag is a separate bit from the entry itself, unless you're
> > under tree_lock, there would be races when changing from page pointer
> > to swap entry or back, when slot was updated but tag not or vice versa.
> 
> So...  take tree_lock?

I wouldn't call that an improvement...

> What effect does that have?

... but admit I have not measured: I rather assume that if we now change
tmpfs from lockless to locked lookup, someone else will soon come up with
the regression numbers.

> It'd better be
> "really bad", because this patchset does nothing at all to improve core
> MM maintainability :(

I was aiming to improve shmem.c maintainability; and you have good grounds
to accuse me of hurting shmem.c maintainability when I highmem-ized the
swap vector nine years ago.

I was not aiming to improve core MM maintainability, nor to harm it.
I am extending the use to which the radix-tree can be put, but is that
so bad?

Hugh
