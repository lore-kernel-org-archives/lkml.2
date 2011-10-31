Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1JaGPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 02:15:00 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42576 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab1JaGO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 02:14:59 -0400
MIME-Version: 1.0
In-Reply-To: <1320039564.22361.178.camel@sli10-conroe>
References: <CADAg6uxLj_ePPbcrVcqcE7y+CxGZfqWUA1zYOtm9e-TYShBDsQ@mail.gmail.com>
	<CANejiEWBpeiBKvg+_W5OC0onQQLpAFCsgADWW1mTutUWF9ZQfA@mail.gmail.com>
	<CADAg6uy7iDG1QxHd=5hX7J=9dYGLA+Ze1uE6WwF7Nfxc83T4hA@mail.gmail.com>
	<1319676161.22361.148.camel@sli10-conroe>
	<CADAg6uy2xOoAaAhVg07oYia+AZAuOGKywPGx8fvT0EF4ThuKCQ@mail.gmail.com>
	<1320039564.22361.178.camel@sli10-conroe>
Date: Mon, 31 Oct 2011 14:14:58 +0800
X-Google-Sender-Auth: e2VfE5rVJmfWEa-NHMY_wnX8E5g
Message-ID: <CANejiEVxdX7KC6MFqBZ2azPtETmwJXML6v1L5-kq+UrRTmf+Tg@mail.gmail.com>
Subject: Re: Multi-partition block layer behaviour
From: Shaohua Li <shaohua.li@intel.com>
To: Tiju Jacob <jacobtiju@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/31 Shaohua Li <shaohua.li@intel.com>:
> On Mon, 2011-10-31 at 12:35 +0800, Tiju Jacob wrote:
>> On Thu, Oct 27, 2011 at 6:12 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>> > On Wed, 2011-10-26 at 18:10 +0800, Tiju Jacob wrote:
>> >> >> 1. When an I/O request is made to the filesystem, process 'A' acquires
>> >> >> a mutex FS lock and a mutex block driver lock.
>> >> >>
>> >> >> 2. Process 'B' tries to acquire the mutex FS lock, which is not
>> >> >> available. Hence, it goes to sleep. Due to the new plugging mechanism,
>> >> >> before going to sleep, shcedule() is invoked which disables preemption
>> >> >> and the context becomes atomic. In schedule(), the newly added
>> >> >> blk_flush_plug_list() is invoked which unplugs the block driver.
>> >> >>
>> >> >> 3) During unplug operation the block driver tries to acquire the mutex
>> >> >> lock which fails, because the lock was held by process 'A'. Previous
>> >> >> invocation of scheudle() in step 2 has already made the context as
>> >> >> atomic, hence the error "Schedule while atomic" occured.
>> >> > if blk_flush_plug_list() is called in schedule(), it will use
>> >> > blk_run_queue_async
>> >> > to unplug the queue. This runs in a workqueue. So how could this happen?
>> >> >
>> >>
>> >> The call stack goes as follows:
>> >>
>> >> From schedule() it calls blk_schedule_flush_plug()  and
>> >> blk_flush_plug_list() gets invoked.
>> >>
>> >> In blk_flush_plug_list() queue_unplugged() does not get invoked. Hence
>> >>  blk_run_queue_async is not called.
>> >> Instead __elv_add_request() is invoked with ELEVATOR_INSERT_SORT_MERGE
>> >> flag and the flag gets reassigned to ELEVATOR_INSERT_BACK.
>> >>
>> >> In ELEVATOR_INSERT_BACK, __blk_run_queue() gets invoked and calls request_fn().
>>
>> > This doesn't make sense. why the flag is changed from
>> > ELEVATOR_INSERT_SORT_MERGE to ELEVATOR_INSERT_BACK?
>>
>> In  __elv_add_request() "where" gets reassigned as follows:
>>
>>       } else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
>>                   (where == ELEVATOR_INSERT_SORT ||
>>                    where == ELEVATOR_INSERT_SORT_MERGE))
>>               where = ELEVATOR_INSERT_BACK;
>>
> ok, thanks. So this means the elevator is switching in the test. How
> about below patch:
>
> diff --git a/block/elevator.c b/block/elevator.c
> index a3b64bc..e14824a 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -683,8 +683,13 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
>                 * - Usually, back inserted requests won't be merged
>                 *   with anything.  There's no point in delaying queue
>                 *   processing.
> +                * If elevator is switching, doesn't need run the queue.
> +                * elevator switching will run it anyway. And this could
> +                * cause warning since the code might run in atomic
> +                * environment(blk_flush_plug_list() callbed in schedule())
>                 */
> -               __blk_run_queue(q);
> +               if (!test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags))
> +                       __blk_run_queue(q);
>                break;
>
>        case ELEVATOR_INSERT_SORT_MERGE:
>
>
oh, wait. We should have no this issue with latest kernel, because
blk_schedule_flush_plug is moved out of schedule atomic environment. please
try a latest kernel, for example, 3.1.
