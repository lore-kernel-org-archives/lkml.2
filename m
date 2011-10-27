Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1J0Aez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 20:34:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:20440 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab1J0Aez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 20:34:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="67922223"
Subject: Re: Multi-partition block layer behaviour
From: Shaohua Li <shaohua.li@intel.com>
To: Tiju Jacob <jacobtiju@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CADAg6uy7iDG1QxHd=5hX7J=9dYGLA+Ze1uE6WwF7Nfxc83T4hA@mail.gmail.com>
References: <CADAg6uxLj_ePPbcrVcqcE7y+CxGZfqWUA1zYOtm9e-TYShBDsQ@mail.gmail.com>
	 <CANejiEWBpeiBKvg+_W5OC0onQQLpAFCsgADWW1mTutUWF9ZQfA@mail.gmail.com>
	 <CADAg6uy7iDG1QxHd=5hX7J=9dYGLA+Ze1uE6WwF7Nfxc83T4hA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Oct 2011 08:42:41 +0800
Message-ID: <1319676161.22361.148.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-26 at 18:10 +0800, Tiju Jacob wrote:
> >> 1. When an I/O request is made to the filesystem, process 'A' acquires
> >> a mutex FS lock and a mutex block driver lock.
> >>
> >> 2. Process 'B' tries to acquire the mutex FS lock, which is not
> >> available. Hence, it goes to sleep. Due to the new plugging mechanism,
> >> before going to sleep, shcedule() is invoked which disables preemption
> >> and the context becomes atomic. In schedule(), the newly added
> >> blk_flush_plug_list() is invoked which unplugs the block driver.
> >>
> >> 3) During unplug operation the block driver tries to acquire the mutex
> >> lock which fails, because the lock was held by process 'A'. Previous
> >> invocation of scheudle() in step 2 has already made the context as
> >> atomic, hence the error "Schedule while atomic" occured.
> > if blk_flush_plug_list() is called in schedule(), it will use
> > blk_run_queue_async
> > to unplug the queue. This runs in a workqueue. So how could this happen?
> >
> 
> The call stack goes as follows:
> 
> From schedule() it calls blk_schedule_flush_plug()  and
> blk_flush_plug_list() gets invoked.
> 
> In blk_flush_plug_list() queue_unplugged() does not get invoked. Hence
>  blk_run_queue_async is not called.
> Instead __elv_add_request() is invoked with ELEVATOR_INSERT_SORT_MERGE
> flag and the flag gets reassigned to ELEVATOR_INSERT_BACK.
> 	
> In ELEVATOR_INSERT_BACK, __blk_run_queue() gets invoked and calls request_fn().
This doesn't make sense. why the flag is changed from
ELEVATOR_INSERT_SORT_MERGE to ELEVATOR_INSERT_BACK?

can you post a full log? or did your driver have something special?


