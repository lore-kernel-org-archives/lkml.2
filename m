Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab2HMKhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:37:53 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44313 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2HMKhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:37:51 -0400
MIME-Version: 1.0
In-Reply-To: <1344846039.31459.14.camel@twins>
References: <1344324343-3817-1-git-send-email-walken@google.com>
	<1344846039.31459.14.camel@twins>
Date: Mon, 13 Aug 2012 03:37:50 -0700
Message-ID: <CANN689GFMvHHwnweK_=RrrSisOqm5CdcGat1txmW48t3k1VDNg@mail.gmail.com>
Subject: Re: [PATCH 0/5] rbtree based interval tree as a prio_tree replacement
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: riel@redhat.com, vrajesh@umich.edu, daniel.santos@pobox.com,
        aarcange@redhat.com, dwmw2@infradead.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 1:20 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-08-07 at 00:25 -0700, Michel Lespinasse wrote:
>> a faster worst-case complexity of O(k+log N) for stabbing queries in a
>> well-balanced prio tree, vs O(k*log N) for interval trees (where k=number
>> of matches, N=number of intervals). Now this sounds great, but in practice
>> prio trees don't realize this theorical benefit. First, the additional
>> constraint makes them harder to update, so that the kernel implementation
>> has to simplify things by balancing them like a radix tree, which is not
>> always ideal.
>
> Not something spending a great deal of time on, but do you have any idea
> what the radix like balancing does the the worst case stabbing
> complexity?

Well, it's not terribly bad as the height of the radix tree is still
bounded by (IIRC) log(ULONG_MAX) + log(max pgoff_t in the file). So
the complexity ends up being O(k + some constant) where the constant
is in practice always larger than log(N).

One can still construct cases where a prio tree stabbing query would
read less nodes (so touch less cache lines) than with augmented
rbtree. I think the best way to explain this is to look at what
augmented rbtree does - for a stabbing query returning k matches, it
visits all nodes between the root and the k matching nodes (plus one
extra path at the end to conclude that there are no further matches).
So the worst case there would be if the matching nodes are all close
to leaf level in the tree, and if the paths leading to them branch up
close to the root level. It's easy to construct such a case by making
all N nodes in the tree start to the left of the stabbing query, and
having only an arbitrary k among them end to the right of the query.
Prio tree achieves a better worst case complexity by placing these k
nodes near the top of the tree (due to the heap constraint). But this
worst case situation isn't very likely to begin with, and in the
typical case the k paths leading to the matching nodes in an augmented
rbtree don't branch up so close to the root so typically prio tree
doesn't get an advantage there.

To sum it up, I would say that both algorithms are really pretty good,
with prio tree getting a slightly better theorical worst-case and
augmented rbtree getting (IMO) a practical advantage due to lower
constant factors and a still very acceptable worst case.

> Anyway, I like the thing, that prio-tree code always made my head hurt.

Black magic I tell you ;-)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
