Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2HaN47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:56:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43912 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2HaN46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:56:58 -0400
Message-ID: <5040C11C.4060505@gmail.com>
Date: Fri, 31 Aug 2012 15:50:20 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/21] drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

with this patch series I try to clean the vmtruncate code. The theory of 
operation:

old               new
vmtruncate() =>   inode_newsize_ok+truncate_setsize+fs truncate

Where vmtruncate was used without any error check, the code now is:

if (inode_newsize_ok() == 0) {
	truncate_setsize();
	fs truncate();
}

So, performance and semantic nothing change at all. I think that maybe 
in some point we can skip inode_newsize_ok (where the error check of 
vmtruncate wasn't used) but since there is a swap check in case of 
no-extension, maybe it's better to avoid regressions. After this clean, 
of course, each fs can clean in a deeply way.

With these patches even the inode truncate callback is deleted.

Any comments/feedback/bugs are welcome.

Marco Stornelli (21):
   ufs: drop vmtruncate
   sysv: drop vmtruncate
   reiserfs: drop vmtruncate
   procfs: drop vmtruncate
   omfs: drop vmtruncate
   ocfs2: drop vmtruncate
   adfs: drop vmtruncate
   affs: drop vmtruncate
   bfs: drop vmtruncate
   hfs: drop vmtruncate
   hpfs: drop vmtruncate
   jfs: drop vmtruncate
   hfsplus: drop vmtruncate
   hostfs: drop vmtruncate
   logfs: drop vmtruncate
   minix: drop vmtruncate
   ncpfs: drop vmtruncate
   nilfs2: drop vmtruncate
   ntfs: drop vmtruncate
   vfs: drop vmtruncate
   mm: drop vmtruncate

  fs/adfs/inode.c         |    5 +++--
  fs/affs/file.c          |    8 +++++---
  fs/affs/inode.c         |    5 ++++-
  fs/bfs/file.c           |    5 +++--
  fs/hfs/inode.c          |   19 +++++++++++++------
  fs/hfsplus/inode.c      |   19 +++++++++++++------
  fs/hostfs/hostfs_kern.c |    8 +++++---
  fs/hpfs/file.c          |    8 +++++---
  fs/hpfs/inode.c         |    5 ++++-
  fs/jfs/file.c           |    6 ++++--
  fs/jfs/inode.c          |   13 +++++++++----
  fs/libfs.c              |    2 --
  fs/logfs/readwrite.c    |   10 ++++++++--
  fs/minix/file.c         |    6 ++++--
  fs/minix/inode.c        |    7 +++++--
  fs/ncpfs/inode.c        |    4 +++-
  fs/nilfs2/file.c        |    1 -
  fs/nilfs2/inode.c       |   18 +++++++++++++-----
  fs/nilfs2/recovery.c    |    7 +++++--
  fs/ntfs/file.c          |    8 +++++---
  fs/ntfs/inode.c         |   11 +++++++++--
  fs/ntfs/inode.h         |    4 ++++
  fs/ocfs2/file.c         |    3 ++-
  fs/omfs/file.c          |   12 ++++++++----
  fs/proc/base.c          |    3 ++-
  fs/proc/generic.c       |    3 ++-
  fs/proc/proc_sysctl.c   |    3 ++-
  fs/reiserfs/file.c      |    3 +--
  fs/reiserfs/inode.c     |   15 +++++++++++----
  fs/reiserfs/reiserfs.h  |    1 +
  fs/sysv/file.c          |    5 +++--
  fs/sysv/itree.c         |    7 +++++--
  fs/ufs/inode.c          |    5 +++--
  include/linux/fs.h      |    1 -
  include/linux/mm.h      |    1 -
  mm/truncate.c           |   23 -----------------------
  36 files changed, 164 insertions(+), 100 deletions(-)

-- 
1.7.3.4
---

