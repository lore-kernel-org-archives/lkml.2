Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab2GSMl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:41:56 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37426 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2GSMlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:41:49 -0400
X-AuditID: 0ac90646-9b4c8ba000003485-05-5008008a3615
X-AuditID: 0ac90646-9b4c8ba000003485-05-5008008a3615
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 0/6] fuse: make maximum read/write request size tunable
To: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muthukumar R <muthur@gmail.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 19 Jul 2012 21:48:51 +0900
Message-ID: <20120719124851.6250.43316.stgit@ltc137.sdl.hitachi.co.jp>
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
changed to arbitrary number between 32 pages and nr_pages equivalent to
the maximum pipe size. When the max_read/max_write mount option is
specified, FUSE request size is set per mount. (The size is rounded-up
to page size and limited up to max_pages_per_req.)

We think the sysfs parameter control is required, as follows.

- The libfuse should change the current MIN_BUFSIZE limitation according
  to this value. If not, The libfuse must always set it to the maximum
  request limit (= [nr_pages (equivalent to pipe_max_size) * 4KB + 0x1000]),
  which leads to waste of memory.

- It is easy to find and set it to the optimized value in order to
  improve the throughput.

The 32 pages are set by default and the minimum value. The upper limit
is the number of pages equivalent to the maximum pipe size that can
be changed by only privileged user. So, we can flexibly set it to the
optimized value considering the system configuration. 

Also, the patch set for libfuse to change current MIN_BUFSIZE limitation
according to the sysfs parameter will be sent soon.


* Performance example

We evaluated the performance improvement due to this patch series.
FUSE filesystems are mounted on tmpfs and we measured the read/write
throughput using 512MB random data.

The results of average read/write throughtput are shown as follows.
 - we measured 10 times throughput for read and write operations,
   and calculated their average.
 - the results in 512 and 1024 pages are measured after changing and
   increasing both the maximum pipe size via /proc/sys/fs/pipe-max-size
   and the max_pages_per_req.

** write

For without direct_io option,
# of pages   |original(32)|tuning(32)|(64) |(128)|(256)|(512)|(1024)
--------------------------------------------------------------------
thruput(MB/s)|305.4       |303.9     |364.6|414.4|441.5|442.4|437.4


For with direct_io option,
# of pages   |original(32)|tuning(32)|(64) |(128)|(256)|(512)|(1024)
---------------------------------------------------------------------
thruput(MB/s)|391.6       |387.7     |502.6|595.4|675.7|762.4|743.9


** read

For without direct_io option, there is no deference between
original 32 pages and tuning patches since the read request size
are not changed even if changing the sysfs parameter.


For with direct_io option,
# of pages   |original(32)|tuning(32)|(64) |(128)|(256)|(512)|(1024)
---------------------------------------------------------------------
thruput(MB/s)|484.6       |485.1     |567.7|611.9|653.5|794.5|788.2


 From these evaluations, this patch series can improve the
performance with an increase of the sysfs parameter. In
particular, the read/write throughput with direct_io achieves
a high improvement. However, it is clear that the results for
1024 pages do not always lead to the highest improvement.
These are just an exmaple and the results may be changed in
different systems. Therefore, we think a tunable functionality
of read/write request size is useful.

Changed in v2:
 - add a functionality to get the maximum pipe size from kernel
   module.
 - change the upper limit of fuse request size from 256 to
   nr_pages equivalent to the maximum pipe size.
 - revise the documentation in /Documentation/filesystems/
   fuse.txt

Thanks,

---

Mitsuo Hayasaka (6):
      fuse: add documentation of sysfs parameter to limit maximum fuse request size
      fuse: set default global limit considering tunable request size
      fuse: add a sysfs parameter to control the maximum request size
      fuse: remove cache for fuse request allocation
      fuse: make the maximum read/write request size tunable
      pipe: make the maximum pipe size referable from kernel module


 Documentation/filesystems/fuse.txt |   15 +++-
 fs/fuse/dev.c                      |   48 ++++-------
 fs/fuse/file.c                     |   32 ++++---
 fs/fuse/fuse_i.h                   |   31 +++++--
 fs/fuse/inode.c                    |  154 ++++++++++++++++++++++++++++++++----
 fs/pipe.c                          |    7 ++
 include/linux/pipe_fs_i.h          |    3 +
 7 files changed, 213 insertions(+), 77 deletions(-)

-- 
Mitsuo Hayasaka (mitsuo.hayasaka.hu@hitachi.com)
