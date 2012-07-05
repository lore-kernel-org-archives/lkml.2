Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab2GEKpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:45:34 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:49861 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab2GEKpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:45:32 -0400
X-AuditID: b753bd60-9aaf3ba000000f6c-ab-4ff56fc7a1a4
X-AuditID: b753bd60-9aaf3ba000000f6c-ab-4ff56fc7a1a4
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH 0/5] fuse: make maximum read/write request size tunable
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Thu, 05 Jul 2012 19:50:17 +0900
Message-ID: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series make maximum read/write request size tunable in FUSE.
Currently, it is limited to FUSE_MAX_PAGES_PER_REQ which is equal
to 32 pages. It is required to change it in order to improve the
throughput since optimized value depends on various factors such
as type and version of local filesystems used and HW specs, etc.

In addition, recently FUSE is widely used as a gateway to connect
cloud storage services and distributed filesystems. Larger data
might be stored in them over networking via FUSE and the overhead
might affect the throughput.

It seems there were many requests to increase FUSE_MAX_PAGES_PER_REQ
to improve the throughput, as follows.

http://sourceforge.net/mailarchive/forum.php?thread_name=4FC2F7A1.4010609%40gmail.com&forum_name=fuse-devel

http://old.nabble.com/-Fuse-2.8--big_write-option---%3E-128kb-write-syscall-...-howto-set-higher-value-td22292589.html

http://old.nabble.com/Block-size-%3E128k-td18675772.html

These discussions mention how to change both FUSE kernel and libfuse
sources such as FUSE_MAX_PAGES_PER_REQ and MIN_BUFSIZE, but the
changed and increased values have not been default yet. We guess this
is because it will be applied to the FUSE filesystems that do not need
the increased value.

One of the ways to solve this is to make them tunable.
In this series, the new sysfs parameter max_pages_per_req is introduced.
It limits the maximum read/write size in fuse request and it can be
changed from 32 to 256 pages in current implementations. When the
max_read/max_write mount option is specified, FUSE request size is set
per mount. (The size is rounded-up to page size and limited up to
max_pages_per_req.)

We think the sysfs parameter control is required, as follows.

- The libfuse should change the current MIN_BUFSIZE limitation according
  to this value. If not, The libfuse must always set it to the maximum
  request limit (= [256 pages * 4KB + 0x1000] in current implementation),
  which leads to waste of memory.

The 32 pages are set by default. Here, we use 256 pages as the hardlimit
in order to make maximum size of struct fuse_req within a page size (4KB).
However, we don't think it is the best value. Any comments are appreciated.

Also, the patch set for libfuse to change current MIN_BUFSIZE limitation
according to the sysfs parameter will be sent soon.


* Performance example

We evaluated the performance improvement due to this patch series.
FUSE filesystems are mounted on tmpfs and we measured the read/write
throughput using 512MB random data.

The results of average read/write throughtput are shown as follows.
 - we measured 10 times throughput for read and write operations,
   and calculated their average.

** write

For without direct_io option,
# of pages   |original(32)|tuning(32)|(64)  |(128) |(256)
---------------------------------------------------------
thruput(MB/s)|402.43      | 398.23   |441.86|485.41|525.78


For with direct_io option,
# of pages   |original(32)|tuning(32)|(64)  |(128) |(256)
---------------------------------------------------------
thruput(MB/s)|556.48      | 562.90   |611.74|722.18|743.43


** read

For without direct_io option, there is no deference between
original 32 pages and tuning patches since the read request size
does not changed even if changing the sysfs parameter.


For with direct_io option,
# of pages   |original(32)|tuning(32)|(64)  |(128) |(256)
---------------------------------------------------------
thruput(MB/s)|509.58      | 509.46   |592.43|640.04|677.26


 From these evaluations, this patch series can improve the
performance with an increase of the sysfs parameter. In
particular, the read/write throughput with direct_io achieves
a high improvement. These are just an exmaple and the results
may be changed in different systems. Therefore, we think
a tunable functionality of read/write request size is useful.

Thanks,

---

Mitsuo Hayasaka (5):
      fuse: add documentation of sysfs parameter to limit maximum fuse request size
      fuse: add a sysfs parameter to control maximum request size
      fuse: make default global limit minimum value
      fuse: do not create cache for fuse request allocation
      fuse: make maximum read/write request size tunable


 Documentation/filesystems/fuse.txt |   17 ++++++-
 fs/fuse/dev.c                      |   48 ++++++-------------
 fs/fuse/file.c                     |   32 +++++++------
 fs/fuse/fuse_i.h                   |   34 +++++++++----
 fs/fuse/inode.c                    |   91 +++++++++++++++++++++++++++++++++---
 5 files changed, 155 insertions(+), 67 deletions(-)

-- 
Mitsuo Hayasaka (mitsuo.hayasaka.hu@hitachi.com)
