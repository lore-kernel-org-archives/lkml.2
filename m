Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573Ab1KJNlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:41:20 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33798 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab1KJNlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:41:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6525"; a="134036003"
Message-ID: <620ec9ffa6bdbba9ae5f76998e36f8dc.squirrel@www.codeaurora.org>
Date: Thu, 10 Nov 2011 05:41:17 -0800 (PST)
Subject: RE: [PATCH 2/2] mmc: core: Support packed command for eMMC4.5      
     device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: "'S, Venkatraman'" <svenkatr@ti.com>, linux-mmc@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        dh.han@samsung.com
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 Maya Erez wrote:
> S, Venkatraman <svenkatr@ti.com> wrote:
>> On Thu, Nov 3, 2011 at 7:23 AM, Seungwon Jeon <tgih.jun@samsung.com>
wrote:
>> >> > +static u8 mmc_blk_chk_packable(struct mmc_queue *mq, struct
>> request *req)

The function prepares the checkable list and not only checks if packing is
possible, therefore I think its name should change to reflect its real
action.

>> >> > +       if (!(md->flags & MMC_BLK_CMD23) &&
>> >> > +                       !card->ext_csd.packed_event_en)
>> >> > +               goto no_packed;

Having the condition with a && can lead to cases where CMD23 is not 
supported and we send packed commands. Therfore the condition should be
changed to || or be splitted to 2 separate checks.
Also, according to the standard the generic error flag in
PACKED_COMMAND_STATUS is set in case of any error and having
PACKED_EVENT_EN is only optional. Therefore, I don't think that setting
the packed_event_en should be a mandatory condition for using packed
coammnds.

>> >> > +       if (mmc_req_rel_wr(cur) &&
>> >> > +                       (md->flags & MMC_BLK_REL_WR) &&
>> >> > +                       !en_rel_wr) {
>> >> > +               goto no_packed;
>> >> > +       }

Can you please explain this condition and its purpose?

>> >> > +               phys_segments +=  next->nr_phys_segments;
>> >> > +               if (phys_segments > max_phys_segs) {
>> >> > +                       blk_requeue_request(q, next);
>> >> > +                       break;
>> >> > +               }
>> >> I mentioned this before - if the next request is not packable and
>> requeued,
>> >> blk_fetch_request will retrieve it again and this while loop will
never terminate.
>> >>
>> > If next request is not packable, it is requeued and 'break'
terminates
>> this loop.
>> > So it not infinite.
>> Right !! But that doesn't help finding the commands that are packable.
Ideally, you'd need to pack all neighbouring requests into one packed
command.
>> The way CFQ works, it is not necessary that the fetch would return all
outstanding
>> requests that are packable (unless you invoke a forced dispatch) It
would be good to see some numbers on the number of pack hits /
misses
>> that
>> you would encounter with this logic, on a typical usecase.
> Is it considered only for CFQ scheduler? How about other I/O scheduler?
If all requests are drained from scheduler queue forcedly,
> the number of candidate to be packed can be increased.
> However we may lose the unique CFQ's strength and MMC D/D may take the
CFQ's duty.
> Basically, this patch accommodates the origin order requests from I/O
scheduler.
>

In order to better utilize the packed commands feature and achieve the
best performance improvements I think that the command packing should be
done in the block layer, according to the scheduler policy.
That is, the scheduler should be aware of the capability of the device to
receive a request list and its constrains (such as maximum number of
requests, max number of sectors etc) and use this information as a  factor
to its algorithm.
This way you keep the decision making in the hands of the scheduler while
the MMC layer will only have to send this list as a packed command.

>> >> > +       if (rqc)
>> >> > +               reqs = mmc_blk_chk_packable(mq, rqc);

It would be best to keep all the calls to blk_fetch_request in the same
location. Therefore, I suggest to move the call to mmc_blk_chk_packable to
mmc/card/queue.c after the first request is fetched.

>> >> >  cmd_abort:
>> >> > -       spin_lock_irq(&md->lock);
>> >> > -       while (ret)
>> >> > -               ret = __blk_end_request(req, -EIO,
>> blk_rq_cur_bytes(req));
>> >> > -       spin_unlock_irq(&md->lock);
>> >> > +       if (mq_rq->packed_cmd != MMC_PACKED_NONE) {

This should be the case for MMC_PACKED_NONE.

>> >> > +               spin_lock_irq(&md->lock);
>> >> > +               while (ret)
>> >> > +                       ret = __blk_end_request(req, -EIO,
>> blk_rq_cur_bytes(req));

Do we need the while or should it be an if? In other cases where
__blk_end_request is called there is no such while.

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




