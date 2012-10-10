Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2JJH6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 03:58:04 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:51595 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754306Ab2JJH6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 03:58:02 -0400
Message-ID: <1349855868.1889.87.camel@slavad-ubuntu>
Subject: RE: [PATCH 00/16] f2fs: introduce flash-friendly file system
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
Date: Wed, 10 Oct 2012 11:57:48 +0400
In-Reply-To: <006f01cda5ec$e63e9b60$b2bbd220$%kim@samsung.com>
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com>
	 <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com>
	 <1349553966.12699.132.camel@kjgkr> <50712AAA.5030807@gmail.com>
	 <002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
	 <F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com>
	 <004101cda52e$72210e20$56632a60$%kim@samsung.com>
	 <55A93BD0-CBCB-4707-A970-EB823EC54B2D@dubeyko.com>
	 <006f01cda5ec$e63e9b60$b2bbd220$%kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 178.177.141.123 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 16:08 +0900, Jaegeuk Kim wrote:
> > -----Original Message-----
> > From: Vyacheslav Dubeyko [mailto:slava@dubeyko.com]
> > Sent: Tuesday, October 09, 2012 4:23 AM
> > To: Jaegeuk Kim
> > Cc: 'Marco Stornelli'; 'Jaegeuk Kim'; 'Al Viro'; tytso@mit.edu; gregkh@linuxfoundation.org; linux-
> > kernel@vger.kernel.org; chur.lee@samsung.com; cm224.lee@samsung.com; jooyoung.hwang@samsung.com;
> > linux-fsdevel@vger.kernel.org
> > Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system

> > >>> NILFS2 is one of major log-structured file systems, which supports multiple snap-shots.
> > >>> IMO, that feature is quite promising and important to users, but it may degrade the performance.
> > >>> There is a trade-off between functionalities and performance.
> > >>> F2FS chose high performance without any further fancy functionalities.
> > >>>
> > >>
> > >> Performance is a good goal. But fault-tolerance is also very important point. Filesystems are used
> > by
> > >> users, so, it is very important to guarantee reliability of data keeping. Degradation of
> > performance
> > >> by means of snapshots is arguable point. Snapshots can solve the problem not only some
> > unpredictable
> > >> environmental issues but also user's erroneous behavior.
> > >>
> > >
> > > Yes, I agree. I concerned the multiple snapshot feature.
> > > Of course, fault-tolerance is very important, and file system should support it as you know as
> > power-off-recovery.
> > > f2fs supports the recovery mechanism by adopting checkpoint similar to snapshot.
> > > But, f2fs does not support multiple snapshots for user convenience.
> > > I just focused on the performance, and absolutely, the multiple snapshot feature is also a good
> > alternative approach.
> > > That may be a trade-off.
> > 
> > So, maybe I misunderstand something, but I can't understand the difference. As I know, snapshot in
> > NILFS2 is a checkpoint converted by user in snapshot. So, NILFS2's checkpoint is a log that adds new
> > file system's state changing (user data + metadata). In other words, checkpoint is mechanism of
> > writing on volume. Moreover, NILFS2 gives flexible way of checkpoint/snapshot management.
> > 
> > As you are saying, f2fs supports checkpoints also. It means for me that checkpoints are the basic
> > mechanism of writing operations on f2fs. But, about what performance gain and difference do you talk?
> 
> How about the following scenario?
> 1. data "a" is newly written.
> 2. checkpoint "A" is done.
> 3. data "a" is truncated.
> 4. checkpoint "B" is done.
> 
> If fs supports multiple snapshots like "A" and "B" to users, it cannot reuse the space allocated by
> data "a" after checkpoint "B" even though data "a" is safely truncated by checkpoint "B".
> This is because fs should keep data "a" to prepare a roll-back to "A".
> So, even though user sees some free space, LFS may suffer from cleaning due to the exhausted free space.
> If users want to avoid this, they have to remove snapshots by themselves. Or, maybe automatically?
> 

I feel that here it exists some misunderstanding in checkpoint/snapshot terminology (especially, for the NILFS2 case). It is possible that NILFS2 volume can contain only checkpoints (if user doesn't created any snapshot). You are right, snapshot cannot be deleted because, in other word, user marked this file system state as important point. But checkpoints can be reclaimed easily. I can't see any problem to reclaim free space from checkpoints in above-mentioned scenario in the case of NILFS2. But if a user decides to make a snapshot then it is a law.  

So, from my point of view, f2fs volume contains only checkpoints without possibility freeze some of it as snapshot. The f2fs volume contains checkpoints also but user can't touch it in some way.

As I know, NILFS2 has Garbage Collector that removes checkpoints automatically in background. But it is possible also to force removing as checkpoints as snapshots by hands with special utility using. As I can understand, f2fs has Garbage Collector also that reclaims free space of dirty checkpoints. So, what is the difference? I have such opinion that difference is in lack of easy manipulation by checkpoints in the case of f2fs.

> > 
> > Moreover, user can't manage by f2fs checkpoints completely, as I can understand. It is not so clear
> > what critical points can be a starting points of recovery actions. How is it possible to define how
> > many checkpoints f2fs volume will have?
> 
> IMHO, user does not need to know how many snapshots there exist and track the fs utilization all the time.
> (off list: I don't know why cleaning process should be tuned by users.)
> 

What do you plan to do in the case of users' complains about issues with free space reclaiming? If user doesn't know about checkpoints and haven't any tools for accessing to checkpoints then how is it possible to investigate issues with free space reclaiming on an user side?

> f2fs writes two checkpoints alternatively. One is for the last stable checkpoint and another is for next checkpoint.
> So, during the recovery, f2fs starts to find one of the latest stable checkpoint.
> The stable checkpoint must have whole index structures and data consistently.
> As you knew, many things can be found in the following LFS paper.
> http://www.cs.berkeley.edu/~brewer/cs262/LFS.pdf
> 
> 
> > 
> > How many user data (metadata) can be lost in the case of sudden power off? Is it possible to estimate
> > this?
> > 
> 
> If user calls sync, f2fs via vfs writes all the data, and it writes a checkpoint.
> In that case, all the data are safe.
> After sync, several fsync can be triggered, and it occurs sudden power off.
> In that case, f2fs first performs roll-back to the last stable checkpoint among two, and then roll-forward to recover fsync'ed data only.
> So, f2fs recovers data triggered by sync or fsync only.
> 

So, as I can understand, f2fs can be recovered by driver in the case of validity of one from two checkpoints. Sudden power-off can occur anytime. How high probability to achieve unrecoverable by driver state of f2fs during sudden power-off? Is it possible to recover f2fs in such case by fsck, for example?  

> > >
> > >> As I understand, it is not possible to have a perfect performance in all possible workloads. Could
> > you
> > >> point out what workloads are the best way of F2FS using?
> > >
> > > Basically I think the following workloads will be good for F2FS.
> > > - Many random writes : it's LFS nature
> > > - Small writes with frequent fsync : f2fs is optimized to reduce the fsync overhead.
> > >
> > 
> > Yes, it can be so for the case of non-aged f2fs volume. But I am afraid that for the case of aged f2fs
> > volume the situation can be opposite. I think that in the case of aged state of f2fs volume the GC
> > will be under hard work in above-mentioned workloads.
> 
> Yes, you're right.
> In the LFS paper above, there are two logging schemes: threaded logging and copy-and-compaction.
> In order to avoid high cleaning overhead, f2fs adopts a hybrid one which changes the allocation policy dynamically
> between two schemes.
> Threaded logging is similar to the traditional approach, resulting in random writes without cleaning operations.
> Copy-and-compaction is another name of cleaning, resulting in sequential writes with cleaning operations.
> So, f2fs adopts one of them in runtime according to the file system status.
> Through this, we could see the random write performance comparable to ext4 even in the worst case.
> 

As I can understand, the goal of f2fs is to be a flash-friendly file system by means of reducing unnecessary FTL operations. This goal is achieving by means of alignment on operation unit and copy-on-write policy, from my understanding. So, I think that write operations without cleaning can be resulted in additional FTL operations. 

> > 
> > But, as I can understand, smartphones and tablets are the most promising way of f2fs using. Because
> > f2fs designs for NAND flash memory based-storage devices. So, I think that such workloads as "many
> > random writes" or "small writes with frequent fsync" are not so frequent use-cases. Use-case of
> > creation and deletion many small files can be more frequent use-case under smartphones and tablets.
> > But, as I can understand, f2fs has slightly expensive metadata payload in the case of small files
> > creation. Moreover, frequent and random deletion of small files ends in the very sophisticated and
> > unpredictable GC behavior, as I can understand.
> > 
> 
> I'd like to share the following paper.
> http://research.cs.wisc.edu/adsl/Publications/ibench-tocs12.pdf
> 

Excellent paper. Thank you. 

> In our experiments *also* on android phones, we've seen many random patterns with frequent fsync calls.
> We found that the main problem is database, and I think f2fs is beneficial to this.

I think that database is not main use-case on Android phones. The dominating use-case can be operation by multimedia information and operations with small files, from my point of view.

So, it is possible to extract such key points from the shared paper: (1) file has complex structure; (2) sequential access is not sequential; (3) auxiliary files dominate; (4) multiple threads perform I/O.

I am afraid that random modification of different part of files and I/O operations from multiple threads can lead to significant fragmentation as file fragments as directory meta-information because of garbage collection.

I think that Iozone can be not fully proper benchmarking suite for file system performance estimation in such case. Maybe it needs to use special synthetic benchmarking tool.

> As you mentioned, I agree that it is important to handle many small files too.
> It is right that this may cause additional cleaning overhead, and f2fs has some metadata payload overhead.
> In order to reduce the cleaning overhead, f2fs adopts static and dynamic hot and cold data separation.
> The main goal is to split the data according to their type (e.g., dir inode, file inode, dentry data, etc) as much as possible.
> Please see the document in detail.
> I think this approach is quite effective to achieve the goal.
> BTW, the payload overhead can be resolved by adopting embedding data in the inode likewise ext4.
> I think it is also good idea, and I hope to adopt it in future.
> 

As I can understand, f2fs uses old-fashioned (ext2/ext3 likewise) block-mapping scheme. This approach have significant metadata and performance payload. Extent approach can be more promising approach. But I am afraid that extent approach contradicts to f2fs internal techniques (Garbage Collector technique). So, it will be very hard to adopt extent approach in f2fs, from my point of view.


> > >
> > > As you can see the f2fs kernel document patch, I think one of the most important features is to
> > align operating units between f2fs and ftl.
> > > Specifically, f2fs has section and zone, which are cleaning unit and basic allocation unit
> > respectively.
> > > Through these configurable units in f2fs, I think f2fs is able to reduce the unnecessary operations
> > done by FTL.
> > > And, in order to avoid changing IO patterns by the block-layer, f2fs merges itself some bios
> > likewise ext4.
> > >
> > 
> > As I can understand, it is not so easy to create partition with f2fs volume which is aligned on
> > operating units (especially in the case of eMMC or SSD).
> 
> Could you explain why it is not so easy?
> 
> > Performance of unaligned volume can degrade
> > significantly because of FTL activity. What mechanisms has f2fs for excluding such situation and
> > achieving of the goal to reduce unnecessary FTL operations?
> 
> Could you please explain your concern more exactly?
> In the kernel doc, the start address of f2fs data structure is aligned to the segment size (i.e., 2MB).
> Do you mean that or another operating units (e.g., section and zone)?
> 

I mean that every volume is placed inside any partition (MTD or GPT). Every partition begins from any physical sector. So, as I can understand, f2fs volume can begin from physical sector that is laid inside physical erase block. Thereby, in such case of formating the f2fs's operation units will be unaligned in relation of physical erase blocks, from my point of view. Maybe, I misunderstand something but it can lead to additional FTL operations and performance degradation, from my point of view.

With the best regards,
Vyacheslav Dubeyko.

> Thanks,
> 
> > 
> > With the best regards,
> > Vyacheslav Dubeyko.
> > 
> > >>
> > >> With the best regards,
> > >> Vyacheslav Dubeyko.
> > >>
> > >>
> > >>>>
> > >>>> Marco
> > >>>
> > >>> ---
> > >>> Jaegeuk Kim
> > >>> Samsung
> > >>>
> > >>> --
> > >>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > >>> the body of a message to majordomo@vger.kernel.org
> > >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >>> Please read the FAQ at  http://www.tux.org/lkml/
> > >
> > >
> > > ---
> > > Jaegeuk Kim
> > > Samsung
> > >
> 
> 
> ---
> Jaegeuk Kim
> Samsung
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


