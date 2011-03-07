Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1CGUCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:02:03 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54141 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab1CGUCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:02:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [ANNOUNCE] RT for v2.6.34.8 now available.
Date: Mon, 7 Mar 2011 21:01:51 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        linux-kernel@vger.kernel.org, lwn@lwn.net
References: <4D71668F.9050201@windriver.com>
In-Reply-To: <4D71668F.9050201@windriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103072101.51326.arnd@arndb.de>
X-Provags-ID: V02:K0:8OYd8b4/4dVevbkCQilQyVwzqcOfe1B989oc+g56Zcl
 E+6WrXOBZQfcru8cgBj/q6UPVYV5Zz0Js/M2NjA3ZAo4gb5SGW
 Wny8dIKBo+bq9IaE6l8us+OA95tXIO15iLuWFSLtv5y5FiHmc7
 Vm1lIgzOAK6itOFWG/ZhFZoGW5Jqvvsvibn3NjHrGy1cdgvwZS
 Sa2ZKbE2L5qBAsBWg6xwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 March 2011 23:24:15 Paul Gortmaker wrote:
> As a value add to the 2.6.34 long term release, I'm happy to also
> announce the availability of 2.6.34-RT.  
> 
> You can find it in the v2.6.34-rt branch at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulg/rt-patches.git
> 
> as a repository of patches.  The v2.6.34-rt branch contains the latest
> RT patches against the latest v2.6.34.8 kernel release. (The master
> branch currently stops at v2.6.34 flat, i.e. 2.6.34.0 so to speak.)
> 
> I've also created over 400 known working RT enabled bisection points
> between 33 and 34 that you can make use of for testing.  The details
> on how/why those exist follows - read on if it is of interest to you.

A great achievement, but I think your approach can be improved in
case you want to do it again for another kernel version.

The problem with your method is that you have more work that depends
on the amount of changes in upstream than the work that depends on
the size of the patch set.

Note that I'm not using the -rt patch set myself, but I have some
experience with managing other patch sets.

> For those who track these things, you will know that the most recent
> release of RT was based on v2.6.33, and in turn, it was created by
> merging forward the mainline kernel.org v2.6.33 content into the older
> v2.6.31 RT tree.  There was no rebase.

I think 2.6.31 was done the right way, with a number of topic branches
that got merged into one release branch. This made it fairly easy to
come out with a quick-and-dirty forward port to 2.6.33, but from that
point on, it became much harder to port it again.

> There are roughly 500 RT patches, and literally 10,000+ commits between
> v2.6.33 and v2.6.34.  So if one was to move things ahead all in one go,
> there can be roughly 5 million things that can go wrong.  Maybe some sharp
> person can move those ahead all in one shot, and then figure out the
> resulting inevitable runtime breakage, but that isn't me.  After all, a
> man has to know his limitations, and I'm pretty much just a patch monkey. 

Doing it all in one shot is not really possible, I fully agree. However,
it's absolutely possible to port a small self-contained series of
interdependent patches over 10000 or more other changesets. The trick
is to split the 500 patches into e.g. 20 branches of less than 50 patches,
where each branch by itself adds one aspect of the full tree and can
be built and run independently of the other branches.

This is a lot of upfront work, but less work to keep it running if you
maintain the branches after the initial release (unlike the 2.6.33-rt
tree).

I've played around with your tree a bit and it seems fairly easy
to split into multiple series, e.g. one for each arch, one for
drivers, mm, rtmutex, mm using git-rebase and some heuristics.
Making sure that each of those branches actually makes sense
by itself may be a different story.

When you have these branches, you can merge them all into one release
branch, similar to how linux-next works, and then just merge updates
from the branches. To port the entire tree to a new upstream, you
look at each branch individually and do a merge, a rebase, a rewrite
or whatever is appropriate for that branch. Finally, you merge the
new branches into another release.

	Arnd
