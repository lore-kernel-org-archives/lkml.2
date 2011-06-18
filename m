Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab1FRVsx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 17:48:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752741Ab1FRVsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 17:48:52 -0400
Date: Sat, 18 Jun 2011 14:48:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/12] radix_tree: exceptional entries and indices
Message-Id: <20110618144832.cfc665b0.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1106171702150.1345@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
	<alpine.LSU.2.00.1106140341070.29206@sister.anvils>
	<20110617163854.49225203.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1106171702150.1345@sister.anvils>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011 17:13:38 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> On Fri, 17 Jun 2011, Andrew Morton wrote:
> > On Tue, 14 Jun 2011 03:42:27 -0700 (PDT)
> > Hugh Dickins <hughd@google.com> wrote:
> > 
> > > The low bit of a radix_tree entry is already used to denote an indirect
> > > pointer, for internal use, and the unlikely radix_tree_deref_retry() case.
> > > Define the next bit as denoting an exceptional entry, and supply inline
> > > functions radix_tree_exception() to return non-0 in either unlikely case,
> > > and radix_tree_exceptional_entry() to return non-0 in the second case.
> > 
> > Yes, the RADIX_TREE_INDIRECT_PTR hack is internal-use-only, and doesn't
> > operate on (and hence doesn't corrupt) client-provided items.
> > 
> > This patch uses bit 1 and uses it against client items, so for
> > practical purpoese it can only be used when the client is storing
> > addresses.  And it needs new APIs to access that flag.
> > 
> > All a bit ugly.  Why not just add another tag for this?  Or reuse an
> > existing tag if the current tags aren't all used for these types of
> > pages?
> 
> I couldn't see how to use tags without losing the "lockless" lookups:

So lockless pagecache broke the radix-tree tag-versus-item coherency as
well as the address_space nrpages-vs-radix-tree coherency.  Isn't it
fun learning these things.

> because the tag is a separate bit from the entry itself, unless you're
> under tree_lock, there would be races when changing from page pointer
> to swap entry or back, when slot was updated but tag not or vice versa.

So...  take tree_lock?  What effect does that have?  It'd better be
"really bad", because this patchset does nothing at all to improve core
MM maintainability :(

