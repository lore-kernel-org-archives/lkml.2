Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab1ERK0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:26:46 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44709 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932680Ab1ERK0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:26:45 -0400
Message-ID: <4DD39EE1.7080006@kernel.dk>
Date: Wed, 18 May 2011 12:26:41 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Borislav Petkov <bp@alien8.de>, Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/3 v2.6.39-rc7] block: make disk_block_events()
  properly wait for work cancellation
References: <20110517102713.GJ20624@htj.dyndns.org> <20110517102824.GK20624@htj.dyndns.org> <20110517102853.GL20624@htj.dyndns.org> <BANLkTimj2guK6kw7QSijYZyvoRY+JKgbTg@mail.gmail.com> <20110517151107.GQ20624@htj.dyndns.org> <BANLkTikpwk-hJs+TF7TJB38JsvOvHk2UMQ@mail.gmail.com> <20110517152742.GR20624@htj.dyndns.org> <BANLkTi=-Ak5vhCFxgc2rt2rft0PE9XJiTA@mail.gmail.com> <20110518050729.GA16870@mtj.dyndns.org> <BANLkTi=0_bv7s6=i2v-iP0vQmHHT3=tm8w@mail.gmail.com>
In-Reply-To: <BANLkTi=0_bv7s6=i2v-iP0vQmHHT3=tm8w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-18 11:46, Linus Torvalds wrote:
> On Tue, May 17, 2011 at 10:07 PM, Tejun Heo <tj@kernel.org> wrote:
>>
>>> Just make the semaphore protect the count - and you're done.
>>
>> Yeah, with that gone, we don't even need the open-coding inside
>> disk_check_events().  It can simply call syncing block and unblock.
>> But, do you want that in -rc7?  Unnecessarily complicated as the
>> current code may be, converting the lock to mutex is a larger change
>> than adding an outer mutex and I think it would be better to do that
>> during the next cycle.
> 
> Quite frankly. right now I think I need to just release 2.6.39, and
> then for 2.6.40 merge the trivial
> 
>   mutex_lock(&ev->mutex);
>   if (!ev->block++)
>     cancel_delayed_work_sync(&ev->dwork);
>   mutex_unlock(&ev->mutex);
> 
> with a cc: stable for backporting.

With these changes pushed to 2.6.40, I have the following sitting queued
up for 2.6.39, of which at least the performance regression and
blk-throttle fix really should go in. I'll let Tejun voice in on his
three changes. I would have pushed this a few days ago, but this thread
had it postponed a bit.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (1):
      scsi: remove performance regression due to async queue run

Shaohua Li (1):
      block: don't delay blk_run_queue_async

Tejun Heo (3):
      block: unexport DISK_EVENT_MEDIA_CHANGE for legacy/fringe drivers
      cdrom: always check_disk_change() on open
      block: rescan partitions on invalidated devices on -ENOMEDIA too

Vivek Goyal (1):
      blk-throttle: Use task_subsys_state() to determine a task's blkio_cgroup

 block/blk-cgroup.c              |    7 +++++++
 block/blk-cgroup.h              |    3 +++
 block/blk-core.c                |    4 +++-
 block/blk-throttle.c            |    9 ++++-----
 block/cfq-iosched.c             |   11 +++++------
 drivers/block/DAC960.c          |    1 -
 drivers/block/amiflop.c         |    1 -
 drivers/block/ataflop.c         |    1 -
 drivers/block/floppy.c          |    1 -
 drivers/block/paride/pcd.c      |    1 -
 drivers/block/paride/pd.c       |    1 -
 drivers/block/paride/pf.c       |    1 -
 drivers/block/swim.c            |    1 -
 drivers/block/swim3.c           |    1 -
 drivers/block/ub.c              |    1 -
 drivers/block/xsysace.c         |    1 -
 drivers/cdrom/cdrom.c           |    6 +++---
 drivers/cdrom/gdrom.c           |    1 -
 drivers/cdrom/viocd.c           |    1 -
 drivers/message/i2o/i2o_block.c |    1 -
 drivers/s390/char/tape_block.c  |    1 -
 drivers/scsi/scsi_lib.c         |   20 ++++++++++++++++----
 drivers/scsi/scsi_scan.c        |    2 ++
 fs/block_dev.c                  |   27 ++++++++++++++++++---------
 include/scsi/scsi_device.h      |    1 +
 25 files changed, 62 insertions(+), 43 deletions(-)

-- 
Jens Axboe

