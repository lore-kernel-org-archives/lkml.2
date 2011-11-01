Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934888Ab1KAAVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:21:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:38815 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934140Ab1KAAVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:21:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="69805691"
Subject: Re: Multi-partition block layer behaviour
From: Shaohua Li <shaohua.li@intel.com>
To: Tiju Jacob <jacobtiju@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CADAg6uwi8bgo3gQuWPeTHeD44biRR4=0E0BjvZradQMtfMCigA@mail.gmail.com>
References: <CADAg6uxLj_ePPbcrVcqcE7y+CxGZfqWUA1zYOtm9e-TYShBDsQ@mail.gmail.com>
	 <CANejiEWBpeiBKvg+_W5OC0onQQLpAFCsgADWW1mTutUWF9ZQfA@mail.gmail.com>
	 <CADAg6uy7iDG1QxHd=5hX7J=9dYGLA+Ze1uE6WwF7Nfxc83T4hA@mail.gmail.com>
	 <1319676161.22361.148.camel@sli10-conroe>
	 <CADAg6uy2xOoAaAhVg07oYia+AZAuOGKywPGx8fvT0EF4ThuKCQ@mail.gmail.com>
	 <1320039564.22361.178.camel@sli10-conroe>
	 <CANejiEVxdX7KC6MFqBZ2azPtETmwJXML6v1L5-kq+UrRTmf+Tg@mail.gmail.com>
	 <CADAg6uwi8bgo3gQuWPeTHeD44biRR4=0E0BjvZradQMtfMCigA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 08:29:22 +0800
Message-ID: <1320107362.22361.185.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 18:21 +0800, Tiju Jacob wrote:
> >> ok, thanks. So this means the elevator is switching in the test. How
> >> about below patch:
> >>
> >> diff --git a/block/elevator.c b/block/elevator.c
> >> index a3b64bc..e14824a 100644
> >> --- a/block/elevator.c
> >> +++ b/block/elevator.c
> >> @@ -683,8 +683,13 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
> >>                 * - Usually, back inserted requests won't be merged
> >>                 *   with anything.  There's no point in delaying queue
> >>                 *   processing.
> >> +                * If elevator is switching, doesn't need run the queue.
> >> +                * elevator switching will run it anyway. And this could
> >> +                * cause warning since the code might run in atomic
> >> +                * environment(blk_flush_plug_list() callbed in schedule())
> >>                 */
> >> -               __blk_run_queue(q);
> >> +               if (!test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags))
> >> +                       __blk_run_queue(q);
> >>                break;
> >>
> >>        case ELEVATOR_INSERT_SORT_MERGE:
> >>
> >>
> > oh, wait. We should have no this issue with latest kernel, because
> > blk_schedule_flush_plug is moved out of schedule atomic environment. please
> > try a latest kernel, for example, 3.1.
> >
> 
> Even after applying the above patch, I am getting the same error. We
> have to use the linux 3.0.* kernel series. So is there a fix for the
> 3.0 series?
> We'll defenetly check with the 3.1 kernel and let know.
please ignore the patch. There is a fix in upstream:
9c40cef2b799f9b5e7fa5de4
and it's marked -stable, so it will go to 3.0 stable.
if 3.1 kernel doesn't work, please report back with a log.

Thanks,
Shaohua

