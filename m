Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2JJJoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:44:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32451 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2JJJoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:44:09 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-ad-5075434978de
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Vyacheslav Dubeyko'" <slava@dubeyko.com>
Cc: "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com>
 <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com>
 <1349553966.12699.132.camel@kjgkr> <50712AAA.5030807@gmail.com>
 <002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
 <F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com>
 <004101cda52e$72210e20$56632a60$%kim@samsung.com>
 <55A93BD0-CBCB-4707-A970-EB823EC54B2D@dubeyko.com>
 <006f01cda5ec$e63e9b60$b2bbd220$%kim@samsung.com>
 <1349855868.1889.87.camel@slavad-ubuntu>
In-reply-to: <1349855868.1889.87.camel@slavad-ubuntu>
Subject: RE: [PATCH 00/16] f2fs: introduce flash-friendly file system
Date: Wed, 10 Oct 2012 18:43:37 +0900
Message-id: <009f01cda6cb$b8cb1020$2a613060$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2mvPnhFAu+Lb6PQ6uMz0RYjjzhfQABgNiA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQV1P59IAg+MbNCz27D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLenN3JWNAVULHhy0XGBsZmuy5GTg4JAROJ12+XM0LY
	YhIX7q1n62Lk4hASmM4oMf3DfhYI5x+jRPOJ2UxdjBwcbALaEpv3G4A0iAjoSPxYuYIdpIZZ
	YBuTxJ7/h1khGp4xS0xb8IENpIpTwFTizY8OFhBbWMBVov1PO9g6FgFVicsds8HivAK2EnPv
	TGaHsAUlfky+xwKyjFlAXWLKlFyQMLOAvMTmNW+ZQcISQOFHf3UhbjCSeHj5NDNEiYjEvhfv
	GCcwCs1CMmgWwqBZSAbNQtKxgJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwQD+T3sG4
	qsHiEKMAB6MSD29FRkmAEGtiWXFl7iFGCQ5mJRFemZVAId6UxMqq1KL8+KLSnNTiQ4zSHCxK
	4rzNHikBQgLpiSWp2ampBalFMFkmDk6pBkY/Y891/77e+m1R9lFqx5Wcp0piTVWx84o+3Pyu
	ufxq9WvrTc7Of6OkXGd+D5XvYuu9nrPNlWuZTRFD5V9X0YTV6Qt3fWWRFCqO8vuky9KWWn3W
	6V+0YNyJkAhWE47brB8jDXW1Kxi9dwsbrlk/W3fuWwP/CaVBAZec9wTEb9uVz8Dy8eyJG0os
	xRmJhlrMRcWJAKPxUuZkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
> > How about the following scenario?
> > 1. data "a" is newly written.
> > 2. checkpoint "A" is done.
> > 3. data "a" is truncated.
> > 4. checkpoint "B" is done.
> >
> > If fs supports multiple snapshots like "A" and "B" to users, it cannot reuse the space allocated by
> > data "a" after checkpoint "B" even though data "a" is safely truncated by checkpoint "B".
> > This is because fs should keep data "a" to prepare a roll-back to "A".
> > So, even though user sees some free space, LFS may suffer from cleaning due to the exhausted free
> space.
> > If users want to avoid this, they have to remove snapshots by themselves. Or, maybe automatically?
> >
> 
> I feel that here it exists some misunderstanding in checkpoint/snapshot terminology (especially, for
> the NILFS2 case). It is possible that NILFS2 volume can contain only checkpoints (if user doesn't
> created any snapshot). You are right, snapshot cannot be deleted because, in other word, user marked
> this file system state as important point. But checkpoints can be reclaimed easily. I can't see any
> problem to reclaim free space from checkpoints in above-mentioned scenario in the case of NILFS2. But

I meant that snapshot does checkpoint.
And, the problem is related to real file system utilization managed by NILFS2.
                     [fs utilization to users]   [fs utilization managed by NILFS2]
                                X - 1                       X - 1
1. new data "a"            X                            X
2. snapshot "A"            X                            X
3. truncate "a"            X - 1                       X
4. snapshot "B"            X - 1                       X

After this, user can see X-1, but the performance will be affected by X.
Until the snapshot "A" is removed, user will experience the performance determined by X.
Do I misunderstand?

> if a user decides to make a snapshot then it is a law.
> 

I don't believe users can do all the things perfectly.

> So, from my point of view, f2fs volume contains only checkpoints without possibility freeze some of it
> as snapshot. The f2fs volume contains checkpoints also but user can't touch it in some way.
> 

Right.

> As I know, NILFS2 has Garbage Collector that removes checkpoints automatically in background. But it
> is possible also to force removing as checkpoints as snapshots by hands with special utility using. As

If users may not want to remove the snapshots automatically, should they configure not to do this too?

> I can understand, f2fs has Garbage Collector also that reclaims free space of dirty checkpoints. So,
> what is the difference? I have such opinion that difference is in lack of easy manipulation by
> checkpoints in the case of f2fs.

The problem that I concerned was performance degradation due to the real utilization available to the file system.

> 
> > >
> > > Moreover, user can't manage by f2fs checkpoints completely, as I can understand. It is not so
> clear
> > > what critical points can be a starting points of recovery actions. How is it possible to define
> how
> > > many checkpoints f2fs volume will have?
> >
> > IMHO, user does not need to know how many snapshots there exist and track the fs utilization all the
> time.
> > (off list: I don't know why cleaning process should be tuned by users.)
> >
> 
> What do you plan to do in the case of users' complains about issues with free space reclaiming? If
> user doesn't know about checkpoints and haven't any tools for accessing to checkpoints then how is it
> possible to investigate issues with free space reclaiming on an user side?

Could you explain why reclaiming free space is an issue?
IMHO, that issue is caused by adopting multiple snapshots.

[snip]

> 
> So, as I can understand, f2fs can be recovered by driver in the case of validity of one from two
> checkpoints. Sudden power-off can occur anytime. How high probability to achieve unrecoverable by
> driver state of f2fs during sudden power-off? Is it possible to recover f2fs in such case by fsck, for

In order to avoid that case, f2fs minimizes data writes and carefully overwrites some of them during roll-forward.

> example?
> 
> > > >
> > > >> As I understand, it is not possible to have a perfect performance in all possible workloads.
> Could
> > > you
> > > >> point out what workloads are the best way of F2FS using?
> > > >
> > > > Basically I think the following workloads will be good for F2FS.
> > > > - Many random writes : it's LFS nature
> > > > - Small writes with frequent fsync : f2fs is optimized to reduce the fsync overhead.
> > > >
> > >
> > > Yes, it can be so for the case of non-aged f2fs volume. But I am afraid that for the case of aged
> f2fs
> > > volume the situation can be opposite. I think that in the case of aged state of f2fs volume the GC
> > > will be under hard work in above-mentioned workloads.
> >
> > Yes, you're right.
> > In the LFS paper above, there are two logging schemes: threaded logging and copy-and-compaction.
> > In order to avoid high cleaning overhead, f2fs adopts a hybrid one which changes the allocation
> policy dynamically
> > between two schemes.
> > Threaded logging is similar to the traditional approach, resulting in random writes without cleaning
> operations.
> > Copy-and-compaction is another name of cleaning, resulting in sequential writes with cleaning
> operations.
> > So, f2fs adopts one of them in runtime according to the file system status.
> > Through this, we could see the random write performance comparable to ext4 even in the worst case.
> >
> 
> As I can understand, the goal of f2fs is to be a flash-friendly file system by means of reducing
> unnecessary FTL operations. This goal is achieving by means of alignment on operation unit and copy-
> on-write policy, from my understanding. So, I think that write operations without cleaning can be
> resulted in additional FTL operations.

Yes, but try to minimize them.

[snip]

> > In our experiments *also* on android phones, we've seen many random patterns with frequent fsync
> calls.
> > We found that the main problem is database, and I think f2fs is beneficial to this.
> 
> I think that database is not main use-case on Android phones. The dominating use-case can be operation
> by multimedia information and operations with small files, from my point of view.
> 
> So, it is possible to extract such key points from the shared paper: (1) file has complex structure;
> (2) sequential access is not sequential; (3) auxiliary files dominate; (4) multiple threads perform
> I/O.
> 
> I am afraid that random modification of different part of files and I/O operations from multiple
> threads can lead to significant fragmentation as file fragments as directory meta-information because
> of garbage collection.

Could you explain in more detail?

> 
> I think that Iozone can be not fully proper benchmarking suite for file system performance estimation
> in such case. Maybe it needs to use special synthetic benchmarking tool.
> 

Yes, it needs.

> > As you mentioned, I agree that it is important to handle many small files too.
> > It is right that this may cause additional cleaning overhead, and f2fs has some metadata payload
> overhead.
> > In order to reduce the cleaning overhead, f2fs adopts static and dynamic hot and cold data
> separation.
> > The main goal is to split the data according to their type (e.g., dir inode, file inode, dentry data,
> etc) as much as possible.
> > Please see the document in detail.
> > I think this approach is quite effective to achieve the goal.
> > BTW, the payload overhead can be resolved by adopting embedding data in the inode likewise ext4.
> > I think it is also good idea, and I hope to adopt it in future.
> >
> 
> As I can understand, f2fs uses old-fashioned (ext2/ext3 likewise) block-mapping scheme. This approach
> have significant metadata and performance payload. Extent approach can be more promising approach. But
> I am afraid that extent approach contradicts to f2fs internal techniques (Garbage Collector technique).
> So, it will be very hard to adopt extent approach in f2fs, from my point of view.
> 

Right, so f2fs adopts an extent cache for better read performance.

> 
> > > >
> > > > As you can see the f2fs kernel document patch, I think one of the most important features is to
> > > align operating units between f2fs and ftl.
> > > > Specifically, f2fs has section and zone, which are cleaning unit and basic allocation unit
> > > respectively.
> > > > Through these configurable units in f2fs, I think f2fs is able to reduce the unnecessary
> operations
> > > done by FTL.
> > > > And, in order to avoid changing IO patterns by the block-layer, f2fs merges itself some bios
> > > likewise ext4.
> > > >
> > >
> > > As I can understand, it is not so easy to create partition with f2fs volume which is aligned on
> > > operating units (especially in the case of eMMC or SSD).
> >
> > Could you explain why it is not so easy?
> >
> > > Performance of unaligned volume can degrade
> > > significantly because of FTL activity. What mechanisms has f2fs for excluding such situation and
> > > achieving of the goal to reduce unnecessary FTL operations?
> >
> > Could you please explain your concern more exactly?
> > In the kernel doc, the start address of f2fs data structure is aligned to the segment size (i.e.,
> 2MB).
> > Do you mean that or another operating units (e.g., section and zone)?
> >
> 
> I mean that every volume is placed inside any partition (MTD or GPT). Every partition begins from any
> physical sector. So, as I can understand, f2fs volume can begin from physical sector that is laid
> inside physical erase block. Thereby, in such case of formating the f2fs's operation units will be
> unaligned in relation of physical erase blocks, from my point of view. Maybe, I misunderstand
> something but it can lead to additional FTL operations and performance degradation, from my point of
> view.

I think mkfs already calculates the offset to align that.

Thanks,

