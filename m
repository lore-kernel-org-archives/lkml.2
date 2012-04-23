Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab2DWBRW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 21:17:22 -0400
Received: from science.horizon.com ([71.41.210.146]:26677 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753062Ab2DWBRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 21:17:21 -0400
Date: 22 Apr 2012 21:17:19 -0400
Message-ID: <20120423011719.24546.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: acme@ghostprotocols.net
Subject: Re: [GIT PULL 00/13] Annotation improvements (G+ edition)
Cc: linux@horizon.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simpler way might just be to use the gas syntax of appending a "b" or
"f" to the branch number, indicating whether the target is in front
or behind.

Gas permits integer branch labels to be re-used, so it's necessary to
specify a direction.

Another thing that might help a reader is a comment indicating the number
of branches to a target, divided by direction.  Targets of backward
branches are obviously more interesting from a performance standpoint,
as they're likely to be the start of loops.


If you *want* to re-use branch target labels, there's a simple algorithm
for assigning them, given a list of all branch origins for each target:

First, collapse the list of all branch origins into a range, listing
the first and last reference to the target.  (The target itself counts
as a reference.)

Then repeat the following for n=0, 1, 2, ... until there are
no more targets left:

In some arbitrary order (I suggest increasing order of range size),
consider each of the remaining targets.  If there are no other targets
within its range, it may be assigned the label n.  If there are other
targets within its range, postpone this target for a later pass, and
remove it from the list of remaining targets.

Once the decision has been made to postpone a target to a later pass, it
no longer counts as "in the range" for other targets considered this pass.
This resolves the intersecting branches case:

	je 1f
0:
	foo
1:
	jbe 0b

Here, the 1: target was considered first, and had to be postponed
because the 0: target was in its range.  Then the 0: target saw nothing
conflicting it its range, and so was assigned.

Because it's not possible to postpone every target (if this were about
to happen, there will be no remaining targets within the range of the
last target considered, so it will be assigned and not postponed),
each iteration will assign at least one target.

After considering all remaining targets, forget about the assigned ones,
incrmeent n, and go back and re-consider the postponed ones.

While the algorithm is potentially inefficient in contrived cases,
I don't think it'll be a huge problem in practice.

Even if you don't want to assign labels this way, a similar algorithm
can assign columns to branching arrows so they do not overlap.
