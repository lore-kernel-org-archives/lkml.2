Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab0G0WBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:01:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54180 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab0G0WBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:01:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=o3RYEWAAWTxLxSa5GMzW5IBqos9yxhJSD0TowGG23XQx8OOOT0UhtvjUae0UzlxiL+
         WleEbyMlNSLPwRCXgJNpbQpAXia814A1TXFDdwSCxAzbsTQ47pQncq6bbhczPQIgSGXJ
         oMNBQa65/CVoRYD4l9o53AgJlgP+RW/Ye0pqg=
From: bchociej@gmail.com
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
        mrlupfer@us.ibm.com, crscott@us.ibm.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
Date: Tue, 27 Jul 2010 17:00:18 -0500
Message-Id: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

INTRODUCTION:

This patch series adds experimental support for tracking data
temperature in Btrfs. Essentially, this means maintaining some key
stats (like number of reads/writes, last read/write time, frequency of
reads/writes), then distilling those numbers down to a single
"temperature" value that reflects what data is "hot."

The long-term goal of these patches, as discussed in the Motivation
section at the end of this message, is to enable Btrfs to perform
automagic relocation of hot data to fast media like SSD. This goal has
been motivated by the Project Ideas page on the Btrfs wiki.

Of course, users are warned not to run this code outside of development
environments. These patches are EXPERIMENTAL, and as such they might
eat your data and/or memory.


MOTIVATION:

The overall goal of enabling hot data relocation to SSD has been
motivated by the Project Ideas page on the Btrfs wiki at
https://btrfs.wiki.kernel.org/index.php/Project_ideas. It is hoped that
this initial patchset will eventually mature into a usable hybrid
storage feature set for Btrfs.

This is essentially the traditional cache argument: SSD is fast and
expensive; HDD is cheap but slow. ZFS, for example, can already take
advantage of SSD caching. Btrfs should also be able to take advantage
of hybrid storage without any broad, sweeping changes to existing code.

With Btrfs's COW approach, an external cache (where data is *moved* to
SSD, rather than just cached there) makes a lot of sense. Though these
patches don't enable any relocation yet, they do lay an essential
foundation for enabling that functionality in the near future. We plan
to roll out an additional patchset introducing some of the automatic
migration functionality in the next few weeks.


SUMMARY:

- Hooks in existing Btrfs functions to track data access frequency
  (btrfs_direct_IO, btrfs_readpages, and extent_write_cache_pages)

- New rbtrees for tracking access frequency of inodes and sub-file
  ranges (hotdata_map.c)

- A hash list for indexing data by its temperature (hotdata_hash.c)

- A debugfs interface for dumping data from the rbtrees (debugfs.c)

- A foundation for relocating data to faster media based on temperature
  (future patchset)

- Mount options for enabling temperature tracking (-o hotdatatrack,
  -o hotdatamove; move implies track; both default to disabled)

- An ioctl to retrieve the frequency information collected for a certain
  file

- Ioctls to enable/disable frequency tracking per inode.


DIFFSTAT:

 fs/btrfs/Makefile       |    5 +-
 fs/btrfs/ctree.h        |   42 +++
 fs/btrfs/debugfs.c      |  500 +++++++++++++++++++++++++++++++++++
 fs/btrfs/debugfs.h      |   57 ++++
 fs/btrfs/disk-io.c      |   29 ++
 fs/btrfs/extent_io.c    |   18 ++
 fs/btrfs/hotdata_hash.c |  111 ++++++++
 fs/btrfs/hotdata_hash.h |   89 +++++++
 fs/btrfs/hotdata_map.c  |  660 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/hotdata_map.h  |  118 +++++++++
 fs/btrfs/inode.c        |   29 ++-
 fs/btrfs/ioctl.c        |  146 +++++++++++-
 fs/btrfs/ioctl.h        |   21 ++
 fs/btrfs/super.c        |   48 ++++-
 14 files changed, 1867 insertions(+), 6 deletions(-)


IMPLEMENTATION (in a nutshell):

Hooks have been added to various functions (btrfs_writepage(s),
btrfs_readpages, btrfs_direct_IO, and extent_write_cache_pages) in
order to track data access patterns. Each of these hooks calls a new
function, btrfs_update_freqs, that records each access to an inode,
possibly including some sub-file-level information as well. A data
structure containing some various frequency metrics gets updated with
the latest access information.

>From there, a hash list takes over the job of figuring out a total
"temperature" value for the data and indexing that temperature for fast
lookup in the future. The function that does the temperature
distilliation is rather sensitive and can be tuned/tweaked by altering
various #defined values in hotdata_hash.h.

Aside from the core functionality, there is a debugfs interface to spit
out some of the data that is collected, and ioctls are also introduced
to manipulate the new functionality on a per-inode basis.


Signed-off-by: Ben Chociej <bcchocie@us.ibm.com>
Signed-off-by: Matt Lupfer <mrlupfer@us.ibm.com>
Signed-off-by: Conor Scott <crscott@us.ibm.com>
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Steve French <sfrench@us.ibm.com>
