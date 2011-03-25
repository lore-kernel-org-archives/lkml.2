Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab1CYJ15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 05:27:57 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:60458 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab1CYJ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 05:27:55 -0400
Date: Fri, 25 Mar 2011 10:27:53 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
Message-ID: <20110325092753.GA1752@gentoo.trippels.de>
References: <20110324193441.GA1723@gentoo.trippels.de>
 <4D8B9D2F.4010504@fusionio.com>
 <20110324194546.GA1741@gentoo.trippels.de>
 <4D8BA235.7060904@fusionio.com>
 <20110324200613.GA1724@gentoo.trippels.de>
 <4D8BB114.2070002@fusionio.com>
 <20110324214150.GA1739@gentoo.trippels.de>
 <4D8C4304.3050101@fusionio.com>
 <20110325083757.GA1754@gentoo.trippels.de>
 <4D8C55D9.1060903@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8C55D9.1060903@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.03.25 at 09:44 +0100, Jens Axboe wrote:
> On 2011-03-25 09:37, Markus Trippelsdorf wrote:
> > On 2011.03.25 at 08:23 +0100, Jens Axboe wrote:
> >> On 2011-03-24 22:41, Markus Trippelsdorf wrote:
> >>> On 2011.03.24 at 22:01 +0100, Jens Axboe wrote:
> >>>> On 2011-03-24 21:06, Markus Trippelsdorf wrote:
> >>>>> On 2011.03.24 at 20:57 +0100, Jens Axboe wrote:
> >>>>>>
> >>>>>> OK, still a data point. What was the last -git kernel you used?
> >>>>>
> >>>>> This one was the last and gave me no problems:
> >>>>>
> >>>>> commit b81a618dcd3ea99de292dbe624f41ca68f464376
> >>>>> Merge: 2f284c8 a9712bc
> >>>>> Author: Linus Torvalds <torvalds@linux-foundation.org>
> >>>>> Date:   Wed Mar 23 20:51:42 2011 -0700
> >>>>>
> >>>>>     Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6
> >>>>
> >>>> Puzzling... Poking at straws here so far. Does this make any difference
> >>>> whatsoever?
> >>>
> >>> I will test your patch later.
> >>>
> >>> Git-bisect gave me this result thus far:
> >>>
> >>> 9026e521c0da0731eb31f9f9022dd00cc3cd8885 is bad
> >>> 82f04ab47e1d94d78503591a7460b2cad9601ede is good
> >>>
> >>> When I continue the bisection with 4345caba340f051e10847924fc078ae18ed6695c
> >>> the system will start normally, but it then silently corrupts my xfs
> >>> partitions. And on next (re)boot I get this (only fixable with
> >>> xfs_repair):
> >>>
> >> How confident are you in those bisection results? Not trying to put you
> >> on the spot, just wondering whether you tested and it's completely
> >> consistent, or whether it was a one-off.
> > 
> > Just double checked and 82f04ab47e1d94d78503591a7460b2cad9601ede is also
> > bad. It just silently corrupts the file system (without a BUG) and I
> > didn't notice.
> > So back to square one. 
> > 
> > How can I tell git-bisect just to try the commits in the block merge and
> > not to take wild swings in history?
> 
> Something like:
> 
> $ git bisect start
> $ git bisect good 3dab04e6978e358ad2307bca563fabd6c5d2c58b
> $ git bisect bad 6c5103890057b1bb781b26b7aae38d33e4c517d8

Thanks. To give you a flavor of the corruption here is the output of a
xfs_repair run:

# xfs_repair /dev/sda1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
out-of-order bno btree record 14 (132755 23) block 0/146613
block (0,132756-132756) multiply claimed by bno space tree, state - 1
agf_freeblks 8432187, counted 8432188 in ag 0
agf_freeblks 9784880, counted 9784881 in ag 3
sb_fdblocks 39149623, counted 39149625
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
imap claims a free inode 2106112 is in use, correcting imap and clearing inode
cleared inode 2106112
imap claims a free inode 2106114 is in use, correcting imap and clearing inode
cleared inode 2106114
imap claims a free inode 2106115 is in use, correcting imap and clearing inode
cleared inode 2106115
        - agno = 1
imap claims a free inode 268641903 is in use, correcting imap and clearing inode
cleared inode 268641903
imap claims a free inode 268711919 is in use, correcting imap and clearing inode
cleared inode 268711919
data fork in ino 289942300 claims free block 34476047
data fork in ino 289942300 claims free block 34476048
data fork in ino 295265710 claims free block 34469734
data fork in ino 295265735 claims free block 34469461
        - agno = 2
imap claims a free inode 548585504 is in use, correcting imap and clearing inode
cleared inode 548585504
imap claims a free inode 548585509 is in use, correcting imap and clearing inode
cleared inode 548585509
imap claims a free inode 548585510 is in use, correcting imap and clearing inode
cleared inode 548585510
imap claims a free inode 548923508 is in use, correcting imap and clearing inode
cleared inode 548923508
imap claims a free inode 548923509 is in use, correcting imap and clearing inode
cleared inode 548923509
imap claims a free inode 570640866 is in use, correcting imap and clearing inode
cleared inode 570640866
        - agno = 3
imap claims a free inode 845126191 is in use, correcting imap and clearing inode
cleared inode 845126191
imap claims a free inode 845130982 is in use, correcting imap and clearing inode
cleared inode 845130982
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 3
        - agno = 1
        - agno = 0
        - agno = 2
entry "fcron.pid" at block 0 offset 1144 in directory inode 199
references free inode 2106112
	clearing inode number in entry at offset 1144...
entry "fcron.fifo" at block 0 offset 1168 in directory inode 199
references free inode 2106114
	clearing inode number in entry at offset 1168...
entry "syslog-ng.pid" at block 0 offset 1192 in directory inode 199
references free inode 2106115
	clearing inode number in entry at offset 1192...
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
bad hash table for directory inode 199 (no data entry): rebuilding
rebuilding directory inode 199
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done


-- 
Markus
