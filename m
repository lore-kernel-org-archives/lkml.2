Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab0JaCT6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 22:19:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53202 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0JaCT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 22:19:56 -0400
MIME-Version: 1.0
Message-ID: <c983e3e9-ac83-442e-9b03-33602fc7a04b@default>
Date: Sat, 30 Oct 2010 19:19:17 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Chris Mason <chris.mason@oracle.com>
Subject: RE: Ping? RE: [GIT PULL] mm/vfs/fs:cleancache for 2.6.37 merge window
References: <ec76a6ed-a1dc-4e8b-a4ac-1e72ab367d0f@default>
 <7b34b3ea-9436-4077-a35e-a5eaabd59813@default
 20101030120632.40345d0d.akpm@linux-foundation.org>
In-Reply-To: <20101030120632.40345d0d.akpm@linux-foundation.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6539.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> So can we please revisit all this from the top level?
> Jeremy, your input would be valuable.

Hi Andrew --

Thanks for your reply!  Between preparing for LPC and some
upcoming personal time off, I may not be able to reply in
a timely way to some future discussion on this thread, so
I will try to respond now but still encourage others to
respond.  I would also be happy to talk f2f at LPC.  I see as
I type this that Jeremy has already replied and will try
to incorporate information re his comments.

Andrew, I think you raise four interesting questions...
I hope it's OK if I paraphrase rather than quote directly?

1) Is something Xen-specific [though no, it's not] worth
   the cost of this addition to the code base?
2) Even if (1) is yes, is this going to be used by a
   significant percentage of Xen users?
3) Is cleancache beneficial to NON-Xen users?
4) Ignoring the "user-base" questions, are there technical
   objections to and issues with cleancache that would
   stop it from being merged?

So, I hope you have the time to read my long-winded reply:

1) By using the term, "micro-audience" to refer to the xen
   user base, I think you are grossly minimizing their
   number.  Since this is a technical list, we can leave
   it up to industry analysts to argue that point, but I
   think it is at least fair to point out that there are
   literally dozens of merges accepted in just this window
   that had a much larger code impact than cleancache
   but have a much smaller user base than Xen.

   While it is reasonable to argue that most of those other
   merges don't touch core mm/vfs code, please realize that
   the cleancache impact to mm/vfs totals less than 50 lines,
   (written by Chris Mason, not me) and these patched lines
   have been essentially static since about 2.6.18, and
   in all of the versions I've posted.  Most of the
   cleancache version churn was designing a clean layer
   so that those hooks are more broadly useful plus
   my inexperience in Linux coding style and the process
   for posting patches to lkml.  (The layering, plus
   some sysfs info and documentation contributes nearly
   all of the additional lines of the patch.)

2) Will a lot of Xen users use this?  That's sort of a
   chicken and egg thing.  I have talked to many real
   Xen users who would love to use cleancache (actually
   Transcendent Memory of which cleancache is the
   key part), but they get scared when I tell them it
   requires patches that are not upstream yet.  Distros
   (including Oracle's) are similarly skittish.

   At Linux and Xen conferences[1], I've shown a nice performance
   improvement on some workloads and negligible worst case
   loss.  The on-list controversies over cleancache have rarely
   involved any performance questions/issues, but I can
   revisit the data if it makes a difference on the
   decision to merge.

3) GregKH was ready to apply Nitin's zram (actually called
   zcache) patch until I pointed out that it was dependent
   on cleancache which wasn't yet merged.  See:
   http://lkml.org/lkml/2010/7/22/491.  Due to an internal
   API change at v5 (to use exportfs to support fs's where
   an inode_t doesn't uniquely represent a file -- with
   input and guidance from Andreas Dilger),
   zcache needs a few changes and Nitin appears otherwise
   occupied right now.   If Nitin doesn't get `round to it
   and doesn't object, and this is the only barrier to merging
   cleancache, I'll be happy to make those changes myself.

   I'm separately working on some similar in-kernel compression
   ideas,  plus the "page-accessible memory" ideas I proposed
   for LSF10/MM where, ahem, certain future idiosyncratic fast
   solid-state-ish memory technologies are a good match for
   cleancache.  The core hooks are highly similar to what was
   used for Geiger (google Geiger ASPLOS 2006) and I've heard
   from several university students that are interested in
   researching other ideas built on top of cleancache.
   Oh, and at LinuxCon, Anthony Liguori told me he thought
   there were at least parts of it that KVM can use.

   So, no, this isn't a xen-only thing, nor a one-time
   thing.  Cleancache is a generic mechanism for grabbing
   data from clean pages when they are reclaimed, cacheing
   the data in non-kernel-directly-addressable memory, and
   avoiding kernel disk reads into file cache when the pages
   can be found in cleancache.  I just happen to get paid to
   work on Xen, so that's where this story started.

4) The on-list lkml patch review process was very helpful
   in helping to clean up the cleancache patchset.  The
   biggest technical hole -- filesystems for which an
   inode_t can't uniquely identify a file -- is fixed.
   Other technical questions/feedback are summarized
   in the commit comments and in the FAQ included with
   the patch including, I believe, everything both
   on-list and f2f from hch.

   A LOT of people have provided review, useful feedback
   and questions, and I've tried to be very diligent in
   replying to all reviewers. If I've missed any that
   would lead anyone to disagree with merging cleancache,
   I hope they will re-raise them prior to the next
   merge window.

Hope that helps... and I hope I am not sounding defensive.
Thanks again for offering to revisit it.

Thanks,
Dan

[1] For a quick performance summary, see slides 37-39 of http://oss.oracle.com/projects/tmem/dist/documentation/presentations/TranscendentMemoryXenSummit2010.pdf 
