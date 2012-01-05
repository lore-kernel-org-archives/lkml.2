Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab2AEIt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 03:49:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40932 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2AEIt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 03:49:26 -0500
MIME-Version: 1.0
Date: Thu, 5 Jan 2012 17:49:25 +0900
Message-ID: <CAOAMb1AUHV6mHwkUbX4+0wfOJpnMuVj_vr9jvb=h-Q4+6HKFzg@mail.gmail.com>
Subject: RE: [PATCH] mm/backing-dev.c: fix crash when USB/SCSI device is detached
From: Chanho Min <chanho0207@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Tue, Jan 03, 2012 at 12:23:44PM +0900, Chanho Min wrote:
>> >On Mon, Jan 02, 2012 at 06:38:21PM +0900,wrote:
>> >> from Chanho Min <chanho.min@lge.com>
>> >>
>> >> System may crash in backing-dev.c when removal SCSI device is detached.
>> >> bdi task is killed by bdi_unregister()/'khubd', but task's point
>remains.
>> >> Shortly afterward, If 'wb->wakeup_timer' is expired before
>> >> del_timer()/bdi_forker_thread,
>> >> wakeup_timer_fn() may wake up the dead thread which cause the crash.
>> >> 'bdi->wb.task' should be NULL as this patch.
>> >
>> >Is it some race condition between del_timer() and del_timer_sync()?
>> >
>> >bdi_unregister() calls
>> >
>> >        del_timer_sync
>> >        bdi_wb_shutdown
>> >            kthread_stop
>> >
>> >in turn, and del_timer_sync() should guarantee wakeup_timer_fn() is
>> >no longer called to access the stopped task.
>> >
>>
>> It is not race condition. This happens when USB is removed during write-
>access.
>> bdi_wakeup_thread_delayed is called after kthread_stop, and timer is
>activated again.
>>
>> 	bdi_unregister
>> 		kthread_stop
>> 	bdi_wakeup_thread_delayed (sys_write mostly calls this)
>> 	timer fires
>
>Ah OK, the timer could be restarted in the mean while, which breaks
>the synchronization rule in del_timer_sync().
>
>I noticed a related fix is merged recently, does your test kernel
>contain this commit?
>

No, I will try to reproduce with this patch.
But, bdi_destroy is not called during write-access. Same result is expected.

>commit 7a401a972df8e184b3d1a3fc958c0a4ddee8d312
>Author: Rabin Vincent <rabin.vincent@stericsson.com>
>Date:   Fri Nov 11 13:29:04 2011 +0100
>
>    backing-dev: ensure wakeup_timer is deleted
>
>> Anyway,Is this safeguard to prevent from waking up killed thread?
>
>This patch makes no guarantee wakeup_timer_fn() will see NULL
>bdi->wb.task before the task is stopped, so there is still race
>conditions. And still, the complete fix would be to prevent
>wakeup_timer_fn() from being called at all.

If wakeup_timer_fn() see NULL bdi->wb.task, wakeup_timer_fn regards
task as killed
and wake up forker thread instead of the defined thread.
Is this intended behavior of the bdi?

>
>Thanks,
>Fengguang
>
>> >> Signed-off-by: Chanho Min <chanho.min@lge.com>
>> >> ---
>> >>  mm/backing-dev.c |    1 +
>> >>  1 files changed, 1 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
>> >> index 71034f4..4378a5e 100644
>> >> --- a/mm/backing-dev.c
>> >> +++ b/mm/backing-dev.c
>> >> @@ -607,6 +607,7 @@ static void bdi_wb_shutdown(struct backing_dev_info
>> >> *bdi)
>> >>         if (bdi->wb.task) {
>> >>                 thaw_process(bdi->wb.task);
>> >>                 kthread_stop(bdi->wb.task);
>> >> +               bdi->wb.task = NULL;
>> >>         }
>> >>  }
>> >>
>> >> --
>> >> 1.7.0.4
