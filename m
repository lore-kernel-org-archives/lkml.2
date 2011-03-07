Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1CGUkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:40:40 -0500
Received: from mail.windriver.com ([147.11.1.11]:35606 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1CGUkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:40:39 -0500
Message-ID: <4D7542BF.1000007@windriver.com>
Date: Mon, 07 Mar 2011 15:40:31 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110127 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        linux-kernel@vger.kernel.org, lwn@lwn.net
Subject: Re: [ANNOUNCE] RT for v2.6.34.8 now available.
References: <4D71668F.9050201@windriver.com> <201103072101.51326.arnd@arndb.de>
In-Reply-To: <201103072101.51326.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2011 20:40:32.0550 (UTC) FILETIME=[E7504C60:01CBDD07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-03-07 03:01 PM, Arnd Bergmann wrote:
> On Friday 04 March 2011 23:24:15 Paul Gortmaker wrote:
>> As a value add to the 2.6.34 long term release, I'm happy to also
>> announce the availability of 2.6.34-RT.  
>>
>> You can find it in the v2.6.34-rt branch at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulg/rt-patches.git
>>
>> as a repository of patches.  The v2.6.34-rt branch contains the latest
>> RT patches against the latest v2.6.34.8 kernel release. (The master
>> branch currently stops at v2.6.34 flat, i.e. 2.6.34.0 so to speak.)
>>
>> I've also created over 400 known working RT enabled bisection points
>> between 33 and 34 that you can make use of for testing.  The details
>> on how/why those exist follows - read on if it is of interest to you.
> 
> A great achievement, but I think your approach can be improved in
> case you want to do it again for another kernel version.
> 
> The problem with your method is that you have more work that depends
> on the amount of changes in upstream than the work that depends on
> the size of the patch set.

You might think so, but that really isn't the case at all.  The
work involved is dictated only by the upstream subset that have
an impact on the RT commits.   If there was a stream of a thousand
contiguous upstream commits that did not break patch application,
or the run time boot test, I'd not have to lift a finger.  Scripts
applied the commits and ensured a continuous sanity.   If I was to
do it again, I'd employ the exact same tactic in a heartbeat.

> 
> Note that I'm not using the -rt patch set myself, but I have some
> experience with managing other patch sets.
> 
>> For those who track these things, you will know that the most recent
>> release of RT was based on v2.6.33, and in turn, it was created by
>> merging forward the mainline kernel.org v2.6.33 content into the older
>> v2.6.31 RT tree.  There was no rebase.
> 
> I think 2.6.31 was done the right way, with a number of topic branches
> that got merged into one release branch. This made it fairly easy to
> come out with a quick-and-dirty forward port to 2.6.33, but from that
> point on, it became much harder to port it again.
> 
>> There are roughly 500 RT patches, and literally 10,000+ commits between
>> v2.6.33 and v2.6.34.  So if one was to move things ahead all in one go,
>> there can be roughly 5 million things that can go wrong.  Maybe some sharp
>> person can move those ahead all in one shot, and then figure out the
>> resulting inevitable runtime breakage, but that isn't me.  After all, a
>> man has to know his limitations, and I'm pretty much just a patch monkey. 
> 
> Doing it all in one shot is not really possible, I fully agree. However,
> it's absolutely possible to port a small self-contained series of
> interdependent patches over 10000 or more other changesets. The trick
> is to split the 500 patches into e.g. 20 branches of less than 50 patches,
> where each branch by itself adds one aspect of the full tree and can
> be built and run independently of the other branches.

This could make sense if they were real independent functionality
boundaries that happened to give you this nice uniform division.
But it is unlikely in practice.   And adding an artificial division
may not work if there are implicit dependencies between the patches
that a patch monkey like me might not see.  Another added cost is that
I would now have 20 branches to individually compile and boot test.
Maybe I could get away with more sparse testing, but maybe not.

In any case, I really don't see what you are trying to propose here
as being really all that fundamentally different -- you want to move
a small set of patches over a bigger set of patches.  So you can say
I'm moving a set of 20 odd patches, which were merged by Linus (and hence
already known to be treatable as a whole self contained unit) over a larger
set of some 500 RT patches.  Does it matter which group you call the
big set and which one the small set?

> 
> This is a lot of upfront work, but less work to keep it running if you
> maintain the branches after the initial release (unlike the 2.6.33-rt
> tree).
> 
> I've played around with your tree a bit and it seems fairly easy
> to split into multiple series, e.g. one for each arch, one for
> drivers, mm, rtmutex, mm using git-rebase and some heuristics.
> Making sure that each of those branches actually makes sense
> by itself may be a different story.
> 
> When you have these branches, you can merge them all into one release
> branch, similar to how linux-next works, and then just merge updates
> from the branches. To port the entire tree to a new upstream, you
> look at each branch individually and do a merge, a rebase, a rewrite
> or whatever is appropriate for that branch. Finally, you merge the
> new branches into another release.

If any knowledge is embedded in a merge commit, it makes it difficult to
extract a commit and deal with it in isolation, should it be something
that has a chance of being pushed upstream.  A merge commit makes sense
when there is value in capturing that patches X-->Y were developed and
tested on baseline Z.  On the other hand, there is value in showing instead
X'--->Y' which are meant to apply to a newer baseline Z'.  For the RT
case, I think the latter is more valuable (at least to me) so I'll be
sticking to a linear merge-free patchset on anything RT related.

Thanks for the comments though -- at least I know someone was reading
the process I used and thinking about it.

Paul.

> 
> 	Arnd
