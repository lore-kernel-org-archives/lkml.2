Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0FVPkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:40:36 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50040 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0FVPkf (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com:0:0>);
	Tue, 22 Jun 2010 11:40:35 -0400
From: Suresh Jayaraman <sjayaraman@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [RFC][PATCH 00/10] cifs: local caching support using FS-Cache
Date: Tue, 22 Jun 2010 20:50:05 +0530
Message-Id: <1277220005-3322-1-git-send-email-sjayaraman@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <yes>
References: <yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a first stab at adding persistent, local caching facility for
CIFS using the FS-Cache interface.

The index hierarchy which is mainly used to locate a file object or discard
a certain subset of the files cached, currently has three levels:
	- Server
	- Share 
	- File

The server index object is keyed by hostname of the server. The superblock
index object is keyed by the sharename and the inode object is keyed by the
UniqueId. The cache coherency is ensured by checking the 'LastWriteTime' and
size of file.

To use this, apply this patchset in order, mount the share with rsize=4096 and
try copying a huge file (say few hundred MBs) from mount point to local
filesystem. During the first time, the cache will be initialized. When you copy
the second time, it should read from the local cache.

To reduce the impact of page cache and see the local caching in action
readily, try doing a sync and drop the caches by doing:
	sync; echo 3 > /proc/sys/vm/drop_caches

Known issues
-------------
	- the cache coherency check may not be reliable always as some
	  CIFS servers are known not to update mtime until the filehandle is
	  closed.
	- not all the Servers under all circumstances provide a unique
	  'UniqueId'.

Todo's
-------
	- improvements to avoid potential key collisions
	- address the above known issues

This set is lightly tested and all the bugs seen during my testing have been
fixed. However, this can be considered as an RFC for now.

Any Comments or Suggestions are welcome.

Suresh Jayaraman (10)
  cifs: add kernel config option for CIFS Client caching support
  cifs: guard cifsglob.h against multiple inclusion
  cifs: register CIFS for caching
  cifs: define server-level cache index objects and register them with FS-Cache
  cifs: define superblock-level cache index objects and register them
  cifs: define inode-level cache object and register them
  cifs: FS-Cache page management
  cifs: store pages into local cache
  cifs: read pages from FS-Cache
  cifs: add mount option to enable local caching

 Kconfig      |    9 ++
 Makefile     |    2 
 cache.c      |  251 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cifs_fs_sb.h |    1 
 cifsfs.c     |   15 +++
 cifsglob.h   |   14 +++
 connect.c    |   16 +++
 file.c       |   51 +++++++++++
 fscache.c    |  244 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fscache.h    |  135 +++++++++++++++++++++++++++++++
 inode.c      |    4 
 11 files changed, 742 insertions(+)

