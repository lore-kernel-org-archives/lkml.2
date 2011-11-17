Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab1KQCVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 21:21:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50890 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1KQCVJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 21:21:09 -0500
X-AuditID: cbfee61b-b7b7fae000005864-f7-4ec46f935b49
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org
Cc: "'S, Venkatraman'" <svenkatr@ti.com>, linux-mmc@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        dh.han@samsung.com
References: <620ec9ffa6bdbba9ae5f76998e36f8dc.squirrel@www.codeaurora.org>
 <001001cca043$395dbfc0$ac193f40$%jun@samsung.com>
 <CANfBPZ-Zn+R4GosEL-RJxh8gduAr8e+qN876uPwDkHfiEpdERw@mail.gmail.com>
 <001d01cca2b1$f4921ff0$ddb65fd0$%jun@samsung.com>
 <4108533d3f51753179703e04299ecab7.squirrel@www.codeaurora.org>
In-reply-to: <4108533d3f51753179703e04299ecab7.squirrel@www.codeaurora.org>
Subject: RE: [PATCH 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Thu, 17 Nov 2011 11:21:06 +0900
Message-id: <004a01cca4cf$9081e840$b185b8c0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acyjmk7YI1NGirTeR3+UMfZWz4HKBABMsjgA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez wrote:
> >> >> >> >> > +               phys_segments +=  next->nr_phys_segments;
> >> >> >> >> > +               if (phys_segments > max_phys_segs) {
> >> >> >> >> > +                       blk_requeue_request(q, next);
> >> >> >> >> > +                       break;
> >> >> >> >> > +               }
> >> >> >> >> I mentioned this before - if the next request is not packable
> >> and
> >> >> >> requeued,
> >> >> >> >> blk_fetch_request will retrieve it again and this while loop
> >> will
> >> >> never terminate.
> >> >> >> >>
> >> >> >> > If next request is not packable, it is requeued and 'break'
> >> >> terminates
> >> >> >> this loop.
> >> >> >> > So it not infinite.
> >> >> >> Right !! But that doesn't help finding the commands that are
> >> packable.
> >> >> Ideally, you'd need to pack all neighbouring requests into one packed
> >> >> command.
> >> >> >> The way CFQ works, it is not necessary that the fetch would return
> >> all
> >> >> outstanding
> >> >> >> requests that are packable (unless you invoke a forced dispatch)
> >> It
> >> >> would be good to see some numbers on the number of pack hits /
> >> >> misses
> >> >> >> that
> >> >> >> you would encounter with this logic, on a typical usecase.
> >> >> > Is it considered only for CFQ scheduler? How about other I/O
> >> scheduler?
> >> >> If all requests are drained from scheduler queue forcedly,
> >> >> > the number of candidate to be packed can be increased.
> >> >> > However we may lose the unique CFQ's strength and MMC D/D may take
> >> the
> >> >> CFQ's duty.
> >> >> > Basically, this patch accommodates the origin order requests from
> >> I/O
> >> >> scheduler.
> >> >> >
> >> >>
> >> >> In order to better utilize the packed commands feature and achieve
> >> the
> >> >> best performance improvements I think that the command packing should
> >> be
> >> >> done in the block layer, according to the scheduler policy.
> >> >> That is, the scheduler should be aware of the capability of the
> >> device to
> >> >> receive a request list and its constrains (such as maximum number of
> >> >> requests, max number of sectors etc) and use this information as a
> >>  factor
> >> >> to its algorithm.
> >> >> This way you keep the decision making in the hands of the scheduler
> >> while
> >> >> the MMC layer will only have to send this list as a packed command.
> >> >>
> >> > Yes, it would be another interesting approach.
> >> > Command packing you mentioned means gathering request among same
> >> direction(read/write)?
> >> > Currently I/O scheduler may know device constrains which MMC driver
> >> informs
> >> > with the exception of order information for packed command.
> >> > But I think the dependency of I/O scheduler may be able to come up.
> >> > How can MMC layer treat packed command with I/O scheduler which
> >> doesn't support this?
> >>
> >> The very act of packing presumes some sorting and re-ordering at the
> >> I/O scheduler level.
> >> When no such sorting is done (ex. noop), MMC should resort to
> >> non-packed execution, respecting the system configuration choice.
> >>
> >> Looking deeper into this, I think a better approach would be to set
> >> the prep_rq_fn of the request_queue, with a custom mmc function that
> >> decides if the requests are packable or not, and return a
> >> BLKPREP_DEFER for those that can't be packed.
> >
> > MMC layer anticipates the favorable requests for packing from I/O
> > scheduler.
> > Obviously request order from I/O scheduler might be poor for packing and
> > requests can't be packed.
> > But that doesn't mean mmc layer need to wait a better pack-case.
> > BLKPREP_DEFER may give rise to I/O latency. Top of request will be
> > deferred next time.
> > If request can't be packed, it'd rather be sent at once than delayed
> > by returning a BLKPREP_DEFER for better responsiveness.
> >
> > Thanks.
> > Seungwon Jeon.
> The decision whether a request is packable or not should not be made per
> request, therefore I don't see the need for using req_prep_fn. The MMC
> layer can peek each request and decide if to pack it or not when preparing
> the packed list (as suggested in this patch). The scheduler changes will
> improve the probability of getting a list that can be packed.
> My suggestion for the scheduler change is:
> The block layer will be notified of the packing limits via new queue
> limits (in blk-settings). We can make it generic to allow all kinds of
> requests lists. Example for the new queue limits can be:
> Is_reqs_list_supported
> Max_num_of_read_reqs_in_list
> Max_num_of_write_reqs_in_list
> max_blk_cnt_in_list
> Is_list_interleaved (optional - to support read and write requests to be
> linked together, not the case for eMMC4.5)
> The scheduler, that will have all the required info in the queue limits,
> will be able to decide which requests can be in the same list and move all
> of them to the dispatch queue (in one elevator_dispatch_fn call).

If probability of packing gets higher, it would be nice.
We need to think more.
> 
> I see 2 options for preparing the list:
> 
> Option 1. blk_fetch_request will prepare the list and return a list of
> requests (will require a change in struct request to include the list but
> can be more generic).
> 
> Option 2. The MMC layer will prepare the list. After fetching one request
> the MMC layer can call blk_peek_request and check if the next request is
> packable or not. By keeping all the calls to blk_peek_request under the
> same queue lock we can guarantee to get the requests that the scheduler
> pushed to the dispatch queue (this requires mmc_blk_chk_packable to move
> to block.c). If the request is packable the MMC layer will call
> blk_start_request to dequeue the request. This way there is no need to
> re-queue the requests that cannot be packed.
> 
> Going back to this patch - the usage of blk_peek_request+blk_start_request
> instead of blk_fetch_request can be done in mmc_blk_chk_packable in order
> to eliminate the need to requeue commands and loose performance.

Do you think blk_requeue_request() is heavy work?
Currently queue_lock was missed using blk_fetch_request. It will be fixed.
Anyway, if we use a set of blk_peek_request+blk_start_request,
there is no necessity for requeuing the request.
But during preparing several request for the list, queue_lock will be held in mmc layer.
Then queue_lock time of mmc layer might be more increased than before.

Thank you for suggestion.
Seungwon Jeon.
> 
> Thanks,
> Maya Erez
> Consultant for Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

