Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab2AOUdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 15:33:44 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44248 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab2AOUdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 15:33:43 -0500
MIME-Version: 1.0
In-Reply-To: <4F12A025.2090207@kernel.dk>
References: <4F12A025.2090207@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Jan 2012 12:33:20 -0800
X-Google-Sender-Auth: Yz9vOD7_798VGPR793kTwv2wvOs
Message-ID: <CA+55aFxyiMXg0BHrZ0LJtCeE+u+pNSM1n=zDbW5-7CtZnh2O=Q@mail.gmail.com>
Subject: Re: [GIT PULL] Block IO bits for 3.3-rc
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 1:45 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> See below for the initial 3.3-rc1 git pull request in the block IO area.
> Not too much queued up for this round, mostly some code churn to improve
> some of the existing functionality.
>
> It has the following changes:
>
> - The big io context cleanup from Tejun.

Ok. This got some conflicts that I think I got right, but I'd really
like Tejun to check it out. There were changes mainly to things he had
removed, and I think all the changes were made irrelevant by his
cleanups, but...

Tejun?

                        Linus

>
> - Remove duplicated block plug in mpage_readpages(). read_pages()
>  already does the plugging, and it's the only call path to
>  mpage_readpages().
>
> - ioctl to query rotational nature of a device from Martin.
>
> - Getting rid of the bio integrity macros, use proper functions instead.
>
> - Recursive merging was added and then disabled, it's suspected to be
>  our cause for empty cfqq crashes. It'll be re-enabled once we get to
>  the bottom of this.
>
>
> Please pull!
>
>
>  git://git.kernel.dk/linux-block.git for-3.3/core
>
>
> Jens Axboe (2):
>      block: ioc_cgroup_changed() needs to be exported
>      Revert "block: recursive merge requests"
>
> Martin K. Petersen (3):
>      block: Introduce blk_set_stacking_limits function
>      block: Add BLKROTATIONAL ioctl
>      block: Stop using macro stubs for the bio data integrity calls
>
> Namjae Jeon (1):
>      fs: remove unneeded plug in mpage_readpages()
>
> Shaohua Li (2):
>      block, cfq: fix empty queue crash caused by request merge
>      block: recursive merge requests
>
> Stephen Rothwell (1):
>      blockdev: convert some macros to static inlines
>
> Tejun Heo (28):
>      block, sx8: kill blk_insert_request()
>      block: add blk_queue_dead()`
>      block: fix drain_all condition in blk_drain_queue()
>      block: add missing blk_queue_dead() checks
>      block, cfq: move cfqd->cic_index to q->id
>      block: misc ioc cleanups
>      block: make ioc get/put interface more conventional and fix race on alloction
>      block: misc updates to blk_get_queue()
>      block, cfq: misc updates to cfq_io_context
>      block, cfq: move ioc ioprio/cgroup changed handling to cic
>      block, cfq: fix race condition in cic creation path and tighten locking
>      block, cfq: fix cic lookup locking
>      block, cfq: unlink cfq_io_context's immediately
>      block, cfq: remove delayed unlink
>      block, cfq: kill ioc_gone
>      block, cfq: kill cic->key
>      block, cfq: replace current_io_context() with create_io_context()
>      block: reorder elevator switch sequence
>      block: remove elevator_queue->ops
>      block, cfq: reorganize cfq_io_context into generic and cfq specific parts
>      block, cfq: move cfqd->icq_list to request_queue and add request->elv.icq
>      block, cfq: move io_cq lookup to blk-ioc.c
>      block, cfq: move icq cache management to block core
>      block, cfq: move io_cq exit/release to blk-ioc.c
>      block, cfq: restructure io_cq creation path for io_context interface cleanup
>      block, cfq: move icq creation and rq->elv.icq association to block core
>      block: an exiting task should be allowed to create io_context
>      block: remove WARN_ON_ONCE() in exit_io_context()
>
>  block/blk-cgroup.c        |   11 +-
>  block/blk-core.c          |  203 +++++++++------
>  block/blk-exec.c          |    8 +-
>  block/blk-ioc.c           |  485 +++++++++++++++++++++++++++++------
>  block/blk-settings.c      |   32 ++-
>  block/blk-sysfs.c         |   12 +-
>  block/blk-throttle.c      |    4 +-
>  block/blk.h               |   58 ++++-
>  block/bsg.c               |    4 +-
>  block/cfq-iosched.c       |  619 +++++++++------------------------------------
>  block/compat_ioctl.c      |    3 +
>  block/deadline-iosched.c  |    4 +-
>  block/elevator.c          |  217 ++++++++--------
>  block/genhd.c             |    2 +-
>  block/ioctl.c             |    2 +
>  block/noop-iosched.c      |    4 +-
>  drivers/block/sx8.c       |   12 +-
>  drivers/md/dm-table.c     |    6 +-
>  drivers/md/md.c           |    1 +
>  drivers/scsi/scsi_scan.c  |    2 +-
>  fs/ioprio.c               |   24 +--
>  fs/mpage.c                |    4 -
>  include/linux/bio.h       |   66 ++++-
>  include/linux/blkdev.h    |  101 ++++++--
>  include/linux/elevator.h  |   41 ++--
>  include/linux/fs.h        |    1 +
>  include/linux/iocontext.h |  136 +++++++---
>  kernel/fork.c             |    8 +-
>  28 files changed, 1133 insertions(+), 937 deletions(-)
>
> --
> Jens Axboe
>
