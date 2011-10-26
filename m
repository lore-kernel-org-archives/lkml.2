Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab1JZKKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 06:10:42 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40768 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1JZKKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 06:10:41 -0400
MIME-Version: 1.0
In-Reply-To: <CANejiEWBpeiBKvg+_W5OC0onQQLpAFCsgADWW1mTutUWF9ZQfA@mail.gmail.com>
References: <CADAg6uxLj_ePPbcrVcqcE7y+CxGZfqWUA1zYOtm9e-TYShBDsQ@mail.gmail.com>
	<CANejiEWBpeiBKvg+_W5OC0onQQLpAFCsgADWW1mTutUWF9ZQfA@mail.gmail.com>
Date: Wed, 26 Oct 2011 15:40:40 +0530
Message-ID: <CADAg6uy7iDG1QxHd=5hX7J=9dYGLA+Ze1uE6WwF7Nfxc83T4hA@mail.gmail.com>
Subject: Re: Multi-partition block layer behaviour
From: Tiju Jacob <jacobtiju@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 1. When an I/O request is made to the filesystem, process 'A' acquires
>> a mutex FS lock and a mutex block driver lock.
>>
>> 2. Process 'B' tries to acquire the mutex FS lock, which is not
>> available. Hence, it goes to sleep. Due to the new plugging mechanism,
>> before going to sleep, shcedule() is invoked which disables preemption
>> and the context becomes atomic. In schedule(), the newly added
>> blk_flush_plug_list() is invoked which unplugs the block driver.
>>
>> 3) During unplug operation the block driver tries to acquire the mutex
>> lock which fails, because the lock was held by process 'A'. Previous
>> invocation of scheudle() in step 2 has already made the context as
>> atomic, hence the error "Schedule while atomic" occured.
> if blk_flush_plug_list() is called in schedule(), it will use
> blk_run_queue_async
> to unplug the queue. This runs in a workqueue. So how could this happen?
>

The call stack goes as follows:

>From schedule() it calls blk_schedule_flush_plug()  and
blk_flush_plug_list() gets invoked.

In blk_flush_plug_list() queue_unplugged() does not get invoked. Hence
 blk_run_queue_async is not called.
Instead __elv_add_request() is invoked with ELEVATOR_INSERT_SORT_MERGE
flag and the flag gets reassigned to ELEVATOR_INSERT_BACK.
	
In ELEVATOR_INSERT_BACK, __blk_run_queue() gets invoked and calls request_fn().

Thanks,
--TJ
