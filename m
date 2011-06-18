Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab1FRAOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 20:14:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9045 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab1FRANx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 20:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=CkEfB3aksFdIJgV4ZXbcixfDOz9mksfk4+r9dEpk8WHPp6SQagTV5SipLFdIkAiXPG
         uSUmrR1woR1VxZw3p77g==
Date: Fri, 17 Jun 2011 17:13:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/12] radix_tree: exceptional entries and indices
In-Reply-To: <20110617163854.49225203.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1106171702150.1345@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils> <alpine.LSU.2.00.1106140341070.29206@sister.anvils> <20110617163854.49225203.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011, Andrew Morton wrote:
> On Tue, 14 Jun 2011 03:42:27 -0700 (PDT)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > The low bit of a radix_tree entry is already used to denote an indirect
> > pointer, for internal use, and the unlikely radix_tree_deref_retry() case.
> > Define the next bit as denoting an exceptional entry, and supply inline
> > functions radix_tree_exception() to return non-0 in either unlikely case,
> > and radix_tree_exceptional_entry() to return non-0 in the second case.
> 
> Yes, the RADIX_TREE_INDIRECT_PTR hack is internal-use-only, and doesn't
> operate on (and hence doesn't corrupt) client-provided items.
> 
> This patch uses bit 1 and uses it against client items, so for
> practical purpoese it can only be used when the client is storing
> addresses.  And it needs new APIs to access that flag.
> 
> All a bit ugly.  Why not just add another tag for this?  Or reuse an
> existing tag if the current tags aren't all used for these types of
> pages?

I couldn't see how to use tags without losing the "lockless" lookups:
because the tag is a separate bit from the entry itself, unless you're
under tree_lock, there would be races when changing from page pointer
to swap entry or back, when slot was updated but tag not or vice versa.

Perhaps solvable, like seqlocks, by having two tag bits, the combination
saying come back and look again in a moment.  Hah, that can/is already
done with the low bit, the deref_retry.  So, yes, we could use one tag
bit: but it would be messier (could no longer use the slow-path-slightly-
modified find_get_page() etc).  I thought, while we've got a nearby bit
available, let's put it to use.

Hugh
