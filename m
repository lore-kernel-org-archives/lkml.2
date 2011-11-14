Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1KNJoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 04:44:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:33457 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab1KNJoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 04:44:10 -0500
X-AuditID: cbfee61b-b7b7fae000005864-cf-4ec0e2e8b9b2
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'S, Venkatraman'" <svenkatr@ti.com>
Cc: merez@codeaurora.org, linux-mmc@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        dh.han@samsung.com
References: <620ec9ffa6bdbba9ae5f76998e36f8dc.squirrel@www.codeaurora.org>
 <001001cca043$395dbfc0$ac193f40$%jun@samsung.com>
 <CANfBPZ-Zn+R4GosEL-RJxh8gduAr8e+qN876uPwDkHfiEpdERw@mail.gmail.com>
In-reply-to: <CANfBPZ-Zn+R4GosEL-RJxh8gduAr8e+qN876uPwDkHfiEpdERw@mail.gmail.com>
Subject: RE: [PATCH 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Mon, 14 Nov 2011 18:44:08 +0900
Message-id: <001d01cca2b1$f4921ff0$ddb65fd0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcygVc5CNYxgfs4BTfOjhBaQxl9LUABSBkyA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S, Venkatraman <svenkatr@ti.com> wrote:
> On Fri, Nov 11, 2011 at 12:56 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > Maya Erez wrote:
> >> On Thu, Nov 10, 2011 Maya Erez wrote:
> >> > S, Venkatraman <svenkatr@ti.com> wrote:
> >> >> On Thu, Nov 3, 2011 at 7:23 AM, Seungwon Jeon <tgih.jun@samsung.com>
> >> wrote:
> >> >> >> > +static u8 mmc_blk_chk_packable(struct mmc_queue *mq, struct
> >> >> request *req)
> >>
> >> The function prepares the checkable list and not only checks if packing is
> >> possible, therefore I think its name should change to reflect its real
> >> action
> > I labored at naming. Isn't it proper? :)
> > Do you have any recommendation?
> > group_pack_req?
> >
> >>
> >> >> >> > +       if (!(md->flags & MMC_BLK_CMD23) &&
> >> >> >> > +                       !card->ext_csd.packed_event_en)
> >> >> >> > +               goto no_packed;
> >>
> >> Having the condition with a && can lead to cases where CMD23 is not
> >> supported and we send packed commands. Therfore the condition should be
> >> changed to || or be splitted to 2 separate checks.
> >> Also, according to the standard the generic error flag in
> >> PACKED_COMMAND_STATUS is set in case of any error and having
> >> PACKED_EVENT_EN is only optional. Therefore, I don't think that setting
> >> the packed_event_en should be a mandatory condition for using packed
> >> coammnds.
> > ... cases where CMD23 is not supported and we send packed commands?
> > Packed command must not be allowed in such a case.
> > It works only with predefined mode which is essential fator.
> > And spec doesn't mentioned PACKED_EVENT_EN must be set.
> > So Packed command can be sent regardless PACKED_EVENT_EN,
> > but it's not complete without reporting of error.
> > Then host driver may suffer error recovery.
> > Why packed command is used without error reporting?
> >
> >>
> >> >> >> > +       if (mmc_req_rel_wr(cur) &&
> >> >> >> > +                       (md->flags & MMC_BLK_REL_WR) &&
> >> >> >> > +                       !en_rel_wr) {
> >> >> >> > +               goto no_packed;
> >> >> >> > +       }
> >>
> >> Can you please explain this condition and its purpose?
> >>
> > In the case where reliable write is request but enhanced reliable write
> > is not supported, write access must be partial according to
> > reliable write sector count. Because even a single request can be split,
> > packed command is not allowed in this case.
> >
> >> >> >> > +               phys_segments +=  next->nr_phys_segments;
> >> >> >> > +               if (phys_segments > max_phys_segs) {
> >> >> >> > +                       blk_requeue_request(q, next);
> >> >> >> > +                       break;
> >> >> >> > +               }
> >> >> >> I mentioned this before - if the next request is not packable and
> >> >> requeued,
> >> >> >> blk_fetch_request will retrieve it again and this while loop will
> >> never terminate.
> >> >> >>
> >> >> > If next request is not packable, it is requeued and 'break'
> >> terminates
> >> >> this loop.
> >> >> > So it not infinite.
> >> >> Right !! But that doesn't help finding the commands that are packable.
> >> Ideally, you'd need to pack all neighbouring requests into one packed
> >> command.
> >> >> The way CFQ works, it is not necessary that the fetch would return all
> >> outstanding
> >> >> requests that are packable (unless you invoke a forced dispatch) It
> >> would be good to see some numbers on the number of pack hits /
> >> misses
> >> >> that
> >> >> you would encounter with this logic, on a typical usecase.
> >> > Is it considered only for CFQ scheduler? How about other I/O scheduler?
> >> If all requests are drained from scheduler queue forcedly,
> >> > the number of candidate to be packed can be increased.
> >> > However we may lose the unique CFQ's strength and MMC D/D may take the
> >> CFQ's duty.
> >> > Basically, this patch accommodates the origin order requests from I/O
> >> scheduler.
> >> >
> >>
> >> In order to better utilize the packed commands feature and achieve the
> >> best performance improvements I think that the command packing should be
> >> done in the block layer, according to the scheduler policy.
> >> That is, the scheduler should be aware of the capability of the device to
> >> receive a request list and its constrains (such as maximum number of
> >> requests, max number of sectors etc) and use this information as a  factor
> >> to its algorithm.
> >> This way you keep the decision making in the hands of the scheduler while
> >> the MMC layer will only have to send this list as a packed command.
> >>
> > Yes, it would be another interesting approach.
> > Command packing you mentioned means gathering request among same direction(read/write)?
> > Currently I/O scheduler may know device constrains which MMC driver informs
> > with the exception of order information for packed command.
> > But I think the dependency of I/O scheduler may be able to come up.
> > How can MMC layer treat packed command with I/O scheduler which doesn't support this?
> 
> The very act of packing presumes some sorting and re-ordering at the
> I/O scheduler level.
> When no such sorting is done (ex. noop), MMC should resort to
> non-packed execution, respecting the system configuration choice.
> 
> Looking deeper into this, I think a better approach would be to set
> the prep_rq_fn of the request_queue, with a custom mmc function that
> decides if the requests are packable or not, and return a
> BLKPREP_DEFER for those that can't be packed.

MMC layer anticipates the favorable requests for packing from I/O scheduler.
Obviously request order from I/O scheduler might be poor for packing and requests can't be packed.
But that doesn't mean mmc layer need to wait a better pack-case.
BLKPREP_DEFER may give rise to I/O latency. Top of request will be deferred next time. 
If request can't be packed, it'd rather be sent at once than delayed
by returning a BLKPREP_DEFER for better responsiveness.

Thanks.
Seungwon Jeon.
> 
> >
> >> >> >> > +       if (rqc)
> >> >> >> > +               reqs = mmc_blk_chk_packable(mq, rqc);
> >>
> >> It would be best to keep all the calls to blk_fetch_request in the same
> >> location. Therefore, I suggest to move the call to mmc_blk_chk_packable to
> >> mmc/card/queue.c after the first request is fetched.
> >
> > At the first time, I considered that way.
> > I'll do more, if possible.
> >>
> >> >> >> >  cmd_abort:
> >> >> >> > -       spin_lock_irq(&md->lock);
> >> >> >> > -       while (ret)
> >> >> >> > -               ret = __blk_end_request(req, -EIO,
> >> >> blk_rq_cur_bytes(req));
> >> >> >> > -       spin_unlock_irq(&md->lock);
> >> >> >> > +       if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
> >>
> >> This should be the case for MMC_PACKED_NONE.
> > Right, I missed it.
> >>
> >> >> >> > +               spin_lock_irq(&md->lock);
> >> >> >> > +               while (ret)
> >> >> >> > +                       ret = __blk_end_request(req, -EIO,
> >> >> blk_rq_cur_bytes(req));
> >>
> >> Do we need the while or should it be an if? In other cases where
> >> __blk_end_request is called there is no such while.
> > This part is not only the new but also origin code which is moved in this patch.
> > Maybe...,'If' case is used  for a whole of remained bytes and
> > 'while' case is used for partial report of remained bytes.
> >
> > Thank you for review.
> >
> > Best regards,
> > Seugwon Jeon.
> >>
> >> Thanks,
> >> Maya Erez
> >> Consultant for Qualcomm Innovation Center, Inc.
> >> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
> >>
> >>
> >>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

