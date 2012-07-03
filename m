Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab2GCOp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:45:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab2GCOpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:45:54 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/8 v4] Flush all block devices on sync(2) and cleanup the code
Date: Tue,  3 Jul 2012 16:45:26 +0200
Message-Id: <1341326734-29881-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hello,

  this is a fourth iteration of my series improving handling of sync syscall.
Since previous submission I have slightly improved cleaned up iteration loops
so that we don't have to pass void * around. Christoph also asked about why
we do non-blocking ->sync_fs() pass. My answer to it was:

I did also measurements where non-blocking ->sync_fs was removed and I didn't
see any regression with ext3, ext4, xfs, or btrfs. OTOH I can imagine *some*
filesystem can do an equivalent of filemap_fdatawrite() on some metadata for
non-blocking ->sync_fs and filemap_fdatawrite_and_wait() on the blocking one
and if there are more such filesystems on different backing storages the
performance difference can be noticeable (actually, checking the filesystems,
JFS and Ceph seem to be doing something like this). So I that's why I didn't
include the change in the end...

So Christoph, if you think we should get rid of non-blocking ->sync_fs, I can
include the patch but personally I think it has some use. Arguably a cleaner
interface for the users will be something like two methods ->sync_fs_begin
and ->sync_fs_end. Filesystems that don't have much to optimize in ->sync_fs()
would just use one of these functions.

I have run three tests below to verify performance impact of the patch series.
Each test has been run with 1, 2, and 4 filesystems mounted; test with 2
filesystems was run with each filesystem on a different disk, test with 4
filesystems had 2 filesystems on the first disk and 2 filesystems on the second
disk.

Test 1: Run 200 times sync with filesystem mounted to verify overhead of
  sync when there are no data to write.
Test 2: For each filesystem run a process creating 40 KB files, sleep
  for 3 seconds, run sync.
Test 3: For each filesystem run a process creating 20 GB file, sleep for
  5 seconds, run sync.

I have performed 10 runs of each test for xfs, ext3, ext4, and btrfs
filesystems.

Results of test 1
-----------------
Numbers are time it took 200 syncs to complete.
Character in braces is + if the time increased with 2*STDDEV reliability,
- if it decreased with 2*STDDEV reliability, 0 otherwise.
		      BASE		      PATCHED
FS		AVG      STDDEV         AVG      STDDEV
Test xfs, 1 disks	0.783000 0.012689	1.628000 0.120316 (+)	
Test xfs, 2 disks	0.742000 0.011662	1.774000 0.135144 (+)	
Test xfs, 4 disks	0.823000 0.057280	1.034000 0.083690 (0)	
Test ext4, 1 disks	0.620000 0.000000	0.678000 0.004000 (+)	
Test ext4, 2 disks	0.629000 0.003000	0.672000 0.004000 (+)	
Test ext4, 4 disks	0.642000 0.004000	0.670000 0.004472 (+)	
Test ext3, 1 disks	0.625000 0.005000	0.662000 0.009798 (+)	
Test ext3, 2 disks	0.622000 0.004000	0.662000 0.004000 (+)	
Test ext3, 4 disks	0.639000 0.003000	0.661000 0.005385 (+)	
Test btrfs, 1 disks	7.901000 0.173807	7.635000 0.171712 (0)	
Test btrfs, 2 disks	19.690000 0.357379	18.630000 0.260000 (0)	
Test btrfs, 4 disks	42.113000 0.725438	41.440000 0.492016 (0)	

We see small increases in runtime, likely due to us having to process all block
devices in the system. XFS actually suffers a bit more, which has been caused
by the last patch dropping writeback_inodes_sb() and reordering ->sync_fs
calls. But still it seems to be OK for this no-so-important workload.

Results of test 2
-----------------
Numbers are time it took sync to complete.

		    BASE		    PATCHED
FS		AVG      STDDEV         AVG      STDDEV
Test xfs, 1 disks	0.391000 0.010440	0.408000 0.011662 (0)	
Test xfs, 2 disks	0.670000 0.014832	0.707000 0.038223 (0)	
Test xfs, 4 disks	2.800000 1.722202	1.818000 0.144900 (0)	
Test ext4, 1 disks	1.531000 0.778247	0.852000 0.109252 (0)	
Test ext4, 2 disks	9.313000 1.857375	10.671000 2.624806 (0)	
Test ext4, 4 disks	254.982000 88.016783	312.003000 30.387435 (0)	
Test ext3, 1 disks	11.751000 0.924472	1.855000 0.179736 (-)	
Test ext3, 2 disks	82.625000 12.903233	43.483000 0.493438 (-)	
Test ext3, 4 disks	79.826000 21.118762	91.593000 31.763338 (0)	
Test btrfs, 1 disks	0.407000 0.012689	0.423000 0.011874 (0)	
Test btrfs, 2 disks	0.790000 0.404252	1.387000 0.606829 (0)	
Test btrfs, 4 disks	2.069000 0.635460	2.273000 1.617641 (0)	

Changes are mostly in the (sometimes heavy) noise, only ext3 stands out with
some noticeable improvements.

Results of test 3
-----------------
Numbers are time it took sync to complete.

		    BASE		    PATCHED
FS		AVG      STDDEV         AVG      STDDEV
Test xfs, 1 disks	12.541000 1.875209	11.351000 0.824724 (0)	
Test xfs, 2 disks	14.858000 0.866162	12.114000 0.632743 (0)	
Test xfs, 4 disks	23.825000 2.020224	17.388000 1.641809 (0)	
Test ext4, 1 disks	39.697000 2.151465	14.987000 2.611670 (-)	
Test ext4, 2 disks	36.148000 1.231104	20.030000 0.656171 (-)	
Test ext4, 4 disks	33.326000 2.116559	19.864000 1.171829 (-)	
Test ext3, 1 disks	21.509000 1.944307	15.166000 0.115603 (-)	
Test ext3, 2 disks	26.694000 1.989750	21.465000 2.187219 (0)	
Test ext3, 4 disks	42.809000 5.220120	34.878000 5.011055 (0)	
Test btrfs, 1 disks	7.339000 2.299637	9.386000 0.631493 (0)	
Test btrfs, 2 disks	7.945000 3.100275	10.554000 0.073919 (0)	
Test btrfs, 4 disks	18.271000 2.669938	25.275000 2.682839 (0)	

Here we see ext3 & ext4 improved somewhat, XFS likely as well although it's
still in the noise. OTOH btrfs likely got slower although it's in the noise.
I didn't drill down into what caused this, I just now that it's not the last
patch.

								Honza
