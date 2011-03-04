Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab1CDWYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:24:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:34211 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab1CDWYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:24:21 -0500
Message-ID: <4D71668F.9050201@windriver.com>
Date: Fri, 04 Mar 2011 17:24:15 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110127 Thunderbird/3.1.7
MIME-Version: 1.0
To: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
CC: linux-kernel@vger.kernel.org, lwn@lwn.net
Subject: [ANNOUNCE] RT for v2.6.34.8 now available.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2011 22:24:17.0339 (UTC) FILETIME=[E65678B0:01CBDABA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a value add to the 2.6.34 long term release, I'm happy to also
announce the availability of 2.6.34-RT.  

You can find it in the v2.6.34-rt branch at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/rt-patches.git

as a repository of patches.  The v2.6.34-rt branch contains the latest
RT patches against the latest v2.6.34.8 kernel release. (The master
branch currently stops at v2.6.34 flat, i.e. 2.6.34.0 so to speak.)

I've also created over 400 known working RT enabled bisection points
between 33 and 34 that you can make use of for testing.  The details
on how/why those exist follows - read on if it is of interest to you.

Note that all credit of the thinking and engineering of the RT stuff
lies with the original patch authors -- to be clear, I'm just doing
the grunt work of a carry forward here.

Have fun with it, maybe drop me a note if you find it useful etc.

Paul.


The carry forward process:
---------------------------

This warrants some notes, since (a) it has strong consequence on how
you can diagnose/bisect problems that were not in 33-rt but may exist
in 34-rt and (b) we've recently seen people who wonder how to do a
similar task and I think they *really* underestimate the complexities
and sheer effort of trying to do any sort of RT carry-forward.

For those who track these things, you will know that the most recent
release of RT was based on v2.6.33, and in turn, it was created by
merging forward the mainline kernel.org v2.6.33 content into the older
v2.6.31 RT tree.  There was no rebase.

With that detail, some of you are probably now going "Aha, now I know
why he created that merge-free v2.6.33 based RT tree some weeks ago."
(see: http://www.spinics.net/lists/linux-rt-users/msg06310.html )

Step one was that I needed the RT commits rebased against 33 (and not 31)
as my starting point for rebasing RT onto v2.6.34 -- see the above
link for details on the significant work involved with that.

There are roughly 500 RT patches, and literally 10,000+ commits between
v2.6.33 and v2.6.34.  So if one was to move things ahead all in one go,
there can be roughly 5 million things that can go wrong.  Maybe some sharp
person can move those ahead all in one shot, and then figure out the
resulting inevitable runtime breakage, but that isn't me.  After all, a
man has to know his limitations, and I'm pretty much just a patch monkey. 

Knowing that the RT patches applied (and worked) on base X, but fail to
apply or fail to work on X+N (where N is small) can be very empowering
to a dumb person like me.  It reduces the problem space *immensely* and
it lets you focus on what changed and caused the problem/conflict.  With
that in mind, I saw no choice but to undertake what would have been the
equivalent of recreating history, had a continuous integration between
the two streams taken place during the 33 --> 34 dev cycle.

What this means in concrete terms, is incrementally applying, updating,
and testing the 500-odd RT patches at successive points along the 10000
commits found in the 33 --> 34 development cycle.  But assuming you
agree with that logic, what does a person choose/use as increments?

At a 1st guess, a person might suggest choosing the rcN tags (where we
have N=1,2,... 7) as places for these incremental tests.  The problem
is that the granularity is too coarse -- just for N=1 means you have
already jumped over 6000 commits ahead, and so you are still facing
being lost for the same reason 10000 commits left you lost before.

At the opposite end of the scale is a brute force approach, where a
person tries applying/updating/testing the RT patch on *each* of the
10,000 development commits. Sounds like it might work, but no.  The
problem here is that the kernel development history is non-linear
in time.  See the git FAQ on why bisects can drag you back in time, if
you've never personally encountered this yourself.  A lot of people
are surprised by this when they first encounter it.

My approach was to adopt a semi-brute force approach.  During the dev
cycle of any kernel, Linus merges the content from various subsystem
maintainers.  Each of these merge points represents a point where
you are guaranteed to not be "rewound in time", should you choose it
as a bisect point.  Using git, these points can easily be identified.

There happens to be ~400 of them, so the 10,000 development commits get
"digested" at an average rate of a humanly manageable number of about 25
commits each -- something that a stupid person like me has a chance to
be able to diagnose/debug without going insane.  You will find that there
is an un-annotated tag for each of these merges in the patch repository.
You really should use these for bisecting your own problems/issues.

On each of these, I've done a patch test, a compile test (x86, x86-64,
ppc, arm) and a boot test (x86, x86-64, ppc-SMP) to ensure that I've not
done a colossal screw-up.  I've probably still screwed *something* up,
but at least I've ensured some level of continuing sanity with these tests
being done across these integration points.
--
