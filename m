Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139Ab2JLOZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:25:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57310 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983Ab2JLOZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:25:47 -0400
Message-ID: <1350051936.2299.29.camel@kjgkr>
Subject: RE: [PATCH 00/16] f2fs: introduce flash-friendly file system
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
Date: Fri, 12 Oct 2012 23:25:36 +0900
In-Reply-To: <1350045007.2026.97.camel@slavad-ubuntu>
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com>
	 <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com>
	 <1349553966.12699.132.camel@kjgkr> <50712AAA.5030807@gmail.com>
	 <002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
	 <F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com>
	 <004101cda52e$72210e20$56632a60$%kim@samsung.com>
	 <55A93BD0-CBCB-4707-A970-EB823EC54B2D@dubeyko.com>
	 <006f01cda5ec$e63e9b60$b2bbd220$%kim@samsung.com>
	 <1349855868.1889.87.camel@slavad-ubuntu>
	 <009f01cda6cb$b8cb1020$2a613060$%kim@samsung.com>
	 <1350045007.2026.97.camel@slavad-ubuntu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-12 (금), 16:30 +0400, Vyacheslav Dubeyko:
> On Wed, 2012-10-10 at 18:43 +0900, Jaegeuk Kim wrote:
> > [snip]
> > > > How about the following scenario?
> > > > 1. data "a" is newly written.
> > > > 2. checkpoint "A" is done.
> > > > 3. data "a" is truncated.
> > > > 4. checkpoint "B" is done.
> > > >
> > > > If fs supports multiple snapshots like "A" and "B" to users, it cannot reuse the space allocated by
> > > > data "a" after checkpoint "B" even though data "a" is safely truncated by checkpoint "B".
> > > > This is because fs should keep data "a" to prepare a roll-back to "A".
> > > > So, even though user sees some free space, LFS may suffer from cleaning due to the exhausted free
> > > space.
> > > > If users want to avoid this, they have to remove snapshots by themselves. Or, maybe automatically?
> > > >
> > > 
> > > I feel that here it exists some misunderstanding in checkpoint/snapshot terminology (especially, for
> > > the NILFS2 case). It is possible that NILFS2 volume can contain only checkpoints (if user doesn't
> > > created any snapshot). You are right, snapshot cannot be deleted because, in other word, user marked
> > > this file system state as important point. But checkpoints can be reclaimed easily. I can't see any
> > > problem to reclaim free space from checkpoints in above-mentioned scenario in the case of NILFS2. But
> > 
> > I meant that snapshot does checkpoint.
> > And, the problem is related to real file system utilization managed by NILFS2.
> >                      [fs utilization to users]   [fs utilization managed by NILFS2]
> >                                 X - 1                       X - 1
> > 1. new data "a"            X                            X
> > 2. snapshot "A"            X                            X
> > 3. truncate "a"            X - 1                       X
> > 4. snapshot "B"            X - 1                       X
> > 
> > After this, user can see X-1, but the performance will be affected by X.
> > Until the snapshot "A" is removed, user will experience the performance determined by X.
> > Do I misunderstand?
> > 
> 
> Ok. Maybe I have some misunderstanding but checkpoint and snapshot are different things for me (especially, in the case of NILFS2). :-)
> 
> The most important is that f2fs has more efficient scheme of working with checkpoints, from your point of view. If you are right then it is very good. And I need to be more familiar with f2fs code.
> 

Ok, thanks.

> [snip]
> > > As I know, NILFS2 has Garbage Collector that removes checkpoints automatically in background. But it
> > > is possible also to force removing as checkpoints as snapshots by hands with special utility using. As
> > 
> > If users may not want to remove the snapshots automatically, should they configure not to do this too?
> > 
> 
> As I know, NILFS2 doesn't delete snapshots automatically but checkpoints - yes. Moreover, it exists nilfs_cleanerd.conf configuration file that makes possible to manage by NILFS cleanerd daemon's behavior (min/max number of clean segments, selection policy, check/clean intervals and so on).
> 

Ok.

> [snip]
> > > > IMHO, user does not need to know how many snapshots there exist and track the fs utilization all the
> > > time.
> > > > (off list: I don't know why cleaning process should be tuned by users.)
> > > >
> > > 
> > > What do you plan to do in the case of users' complains about issues with free space reclaiming? If
> > > user doesn't know about checkpoints and haven't any tools for accessing to checkpoints then how is it
> > > possible to investigate issues with free space reclaiming on an user side?
> > 
> > Could you explain why reclaiming free space is an issue?
> > IMHO, that issue is caused by adopting multiple snapshots.
> > 
> 
> I didn't mean that reclaiming free space is an issue. I hope that f2fs
> is stable but unfortunately it is not possible for any software to be
> completely without bugs. So, anyway, f2fs users can have some issues
> during using. One of the possible issue can be unexpected situation
> with not reclaiming of free space. So, my question was about
> possibility to investigate such bug on the user's side. From my point
> of view, NILFS2 has very good utilities for such investigation.

You mean fsck?
Of course, we've implemented fsck tool also.
But, why I didn't open it is that code is a mess.
Another reason is that current fsck tool only checks
the consistency of f2fs.
Now we're still working on it to open.

> 
> [snip]
> > > > In our experiments *also* on android phones, we've seen many random patterns with frequent fsync
> > > calls.
> > > > We found that the main problem is database, and I think f2fs is beneficial to this.
> > > 
> > > I think that database is not main use-case on Android phones. The dominating use-case can be operation
> > > by multimedia information and operations with small files, from my point of view.
> > > 
> > > So, it is possible to extract such key points from the shared paper: (1) file has complex structure;
> > > (2) sequential access is not sequential; (3) auxiliary files dominate; (4) multiple threads perform
> > > I/O.
> > > 
> > > I am afraid that random modification of different part of files and I/O operations from multiple
> > > threads can lead to significant fragmentation as file fragments as directory meta-information because
> > > of garbage collection.
> > 
> > Could you explain in more detail?
> > 
> 
> I mean that complex structure of modern files can lead to random modification of small file's parts.
> Moreover, such modifications can occur from multiple threads.
> So, it means for me that Copy-On-Write policy can lead to file's content fragmentation.
> Then GC can make additional fragmentation also.
> But maybe I have some misunderstanding of f2fs internal techniques.
> 

Right. Random modification may cause data fragmentation due to COW in LFS.
But, this is from the host side view only.
If we consider FTL with file system adopting the in-place-update scheme,
eventually FTL should handle the fragmentation issue instead of
file system.
So, I think fragmentation is not a particular issue in LFS only.

> With the best regards,
> Vyacheslav Dubeyko.
> 
> 

-- 
Jaegeuk Kim
Samsung

