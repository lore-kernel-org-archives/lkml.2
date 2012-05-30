Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2E3Iyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 04:54:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65116 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab2E3Iyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 04:54:37 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
Date: Wed, 30 May 2012 16:54:37 +0800
Message-ID: <CAEH94LgZOkAKLOtX5pE0FQevVpEKe=zBEvojzXbX4dMkUyj2OA@mail.gmail.com>
Subject: Re: [Bcache v13 00/16]
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:07 AM, Kent Overstreet
<koverstreet@google.com> wrote:
> bcache: a cache for arbitrary block devices using an SSD.
>
> Short overview:
> Bcache does both writethrough and writeback caching. It presents itself as a
> new block device, a bit like say md. You can cache an arbitrary number of
> block devices with a single cache device, and attach and detach things at
> runtime - it's quite flexible.
>
> It's very fast. It uses a b+ tree for the index, along with a journal to
> coalesce index updates, and a bunch of other cool tricks like auxiliary binary
> search trees with software floating point keys for searching within btree
> nodes.
>
> Bcache is solid, production ready code. There are still bugs being found that
> affect specific configurations, but there haven't been any major issues found
> in awhile - it's well past time I started working on getting it into mainline.
>
> It's a lot of code - I tried to split it out so that it'd make some sort of
> sense for reviewing. Let me know if there's anything else I can do to make
This feature is so interesting; Do you have one clean public git tree
about this patchset? So that i can pull it to play with it.

> review easier.
>
> TODO/known issues:
>
> __up_write() needs to be exported for bcache to compile as a module - it's
> used for bypassing lockdep when traversing the btree during garbage
> collection. If someone else knows a better solution, please let me know.
>
> The userspace interface is going to change before it goes in. The general
> consensus at LSF was that we don't want yet another interface for
> probing/managing block devices, and dm exists so we may as well use that. I
> don't think anyone's started on that yet, though.
>
> Documentation needs to be updated. That's being actively worked on, though.
>
> Kent Overstreet (16):
>  Only clone bio vecs that are in use
>  Bio pool freeing
>  Revert "rw_semaphore: remove up/down_read_non_owner"
>  Fix ratelimit macro to compile in c99 mode
>  Export get_random_int()
>  Export blk_fill_rwbs()
>  Closures
>  bcache: Documentation, and changes to generic code
>  Bcache: generic utility code
>  bcache: Superblock/initialization/sysfs code
>  bcache: Core btree code
>  bcache: Bset code (lookups within a btree node)
>  bcache: Journalling
>  bcache: Request, io and allocation code
>  bcache: Writeback
>  bcache: Debug and tracing code
>
>  Documentation/ABI/testing/sysfs-block-bcache |  156 ++
>  Documentation/bcache.txt                     |  255 +++
>  block/blk-core.c                             |    2 +-
>  drivers/block/Kconfig                        |    2 +
>  drivers/block/Makefile                       |    1 +
>  drivers/block/bcache/Kconfig                 |   42 +
>  drivers/block/bcache/Makefile                |    8 +
>  drivers/block/bcache/alloc.c                 |  591 +++++++
>  drivers/block/bcache/bcache.h                |  839 ++++++++++
>  drivers/block/bcache/bset.c                  | 1149 +++++++++++++
>  drivers/block/bcache/bset.h                  |  218 +++
>  drivers/block/bcache/btree.c                 | 2249 ++++++++++++++++++++++++++
>  drivers/block/bcache/btree.h                 |  272 ++++
>  drivers/block/bcache/debug.c                 |  574 +++++++
>  drivers/block/bcache/debug.h                 |   53 +
>  drivers/block/bcache/io.c                    |  198 +++
>  drivers/block/bcache/journal.c               |  722 +++++++++
>  drivers/block/bcache/journal.h               |  113 ++
>  drivers/block/bcache/request.c               | 1470 +++++++++++++++++
>  drivers/block/bcache/request.h               |   58 +
>  drivers/block/bcache/stats.c                 |  243 +++
>  drivers/block/bcache/stats.h                 |   58 +
>  drivers/block/bcache/super.c                 | 2000 +++++++++++++++++++++++
>  drivers/block/bcache/sysfs.c                 |  802 +++++++++
>  drivers/block/bcache/sysfs.h                 |   99 ++
>  drivers/block/bcache/trace.c                 |   26 +
>  drivers/block/bcache/util.c                  |  572 +++++++
>  drivers/block/bcache/util.h                  |  657 ++++++++
>  drivers/block/bcache/writeback.c             |  518 ++++++
>  drivers/block/rbd.c                          |    2 +-
>  drivers/char/random.c                        |    1 +
>  drivers/md/dm.c                              |   27 +-
>  drivers/md/md.c                              |    3 +-
>  fs/bio.c                                     |   55 +-
>  include/linux/bio.h                          |    7 +-
>  include/linux/blk_types.h                    |    2 +
>  include/linux/cgroup_subsys.h                |    6 +
>  include/linux/closure.h                      |  614 +++++++
>  include/linux/ratelimit.h                    |    2 +-
>  include/linux/rwsem.h                        |   10 +
>  include/linux/sched.h                        |    4 +
>  include/trace/events/bcache.h                |  257 +++
>  kernel/fork.c                                |    4 +
>  kernel/rwsem.c                               |   16 +
>  kernel/trace/blktrace.c                      |    1 +
>  lib/Kconfig                                  |    3 +
>  lib/Kconfig.debug                            |    9 +
>  lib/Makefile                                 |    2 +
>  lib/closure.c                                |  363 +++++
>  49 files changed, 15288 insertions(+), 47 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-block-bcache
>  create mode 100644 Documentation/bcache.txt
>  create mode 100644 drivers/block/bcache/Kconfig
>  create mode 100644 drivers/block/bcache/Makefile
>  create mode 100644 drivers/block/bcache/alloc.c
>  create mode 100644 drivers/block/bcache/bcache.h
>  create mode 100644 drivers/block/bcache/bset.c
>  create mode 100644 drivers/block/bcache/bset.h
>  create mode 100644 drivers/block/bcache/btree.c
>  create mode 100644 drivers/block/bcache/btree.h
>  create mode 100644 drivers/block/bcache/debug.c
>  create mode 100644 drivers/block/bcache/debug.h
>  create mode 100644 drivers/block/bcache/io.c
>  create mode 100644 drivers/block/bcache/journal.c
>  create mode 100644 drivers/block/bcache/journal.h
>  create mode 100644 drivers/block/bcache/request.c
>  create mode 100644 drivers/block/bcache/request.h
>  create mode 100644 drivers/block/bcache/stats.c
>  create mode 100644 drivers/block/bcache/stats.h
>  create mode 100644 drivers/block/bcache/super.c
>  create mode 100644 drivers/block/bcache/sysfs.c
>  create mode 100644 drivers/block/bcache/sysfs.h
>  create mode 100644 drivers/block/bcache/trace.c
>  create mode 100644 drivers/block/bcache/util.c
>  create mode 100644 drivers/block/bcache/util.h
>  create mode 100644 drivers/block/bcache/writeback.c
>  create mode 100644 include/linux/closure.h
>  create mode 100644 include/trace/events/bcache.h
>  create mode 100644 lib/closure.c
>
> --
> 1.7.9.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Regards,

Zhi Yong Wu
