Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab2FAQp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:45:28 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13767 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab2FAQp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:45:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6729"; a="196842289"
Message-ID: <f1ad97e8655631c46afd7084ef6266fd.squirrel@www.codeaurora.org>
In-Reply-To: <000201cd3fba$942df840$bc89e8c0$%jun@samsung.com>
References: <7155413ec18f57c1151a29992be32b1f.squirrel@www.codeaurora.org>
    <000201cd3fba$942df840$bc89e8c0$%jun@samsung.com>
Date: Fri, 1 Jun 2012 09:45:26 -0700 (PDT)
Subject: RE: [PATCH v6 2/3] mmc: core: Support packed write command for 
     eMMC4.5 device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: merez@codeaurora.org, linux-mmc@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Maya Erez <merez@codeaurora.org> wrote:
>> > @@ -1313,10 +1609,17 @@ static int mmc_blk_issue_rw_rq(struct
>> mmc_queue
>> *mq, struct request *rqc)
>> >  			 * A block was successfully transferred.
>> >  			 */
>> >  			mmc_blk_reset_success(md, type);
>> > -			spin_lock_irq(&md->lock);
>> > -			ret = __blk_end_request(req, 0,
>> > +
>> > +			if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
>> > +				ret = mmc_blk_end_packed_req(mq, mq_rq);
>> If a specific request in the packed request consistantly fails, there is
>> nothing to stop us from sending the same packed request in an endless
>> loop.
> There is various error case. This patch reused the existing error
> handling.
> What is that case we need to consider?
>
> Best regards,
> Seungwon Jeon

This is different from unpacked requests handling since in the packed err
check function you don't always return the error returned from
mmc_blk_err_check. In case the EXT_CSD_PACKED_INDEXED_ERROR is set you
return MMC_BLK_PARTIAL which is handled differently in the
mmc_blk_issue_rw_rd.
In our tests we set to 1 the packed bit in CMD23 arg of the first req (in
the header). As a result, mmc_blk_err_check returned MMC_BLK_CMD_ERR.
However, mmc_blk_packed_err_check returned MMC_BLK_PARTIAL (since the card
indicated the index of the first request as the failed request).
mmc_blk_issue_rw_rd handles MMC_BLK_PARTIAL by sending the packed command
from the failed index and on, but since the packed bit was still set, the
same error occurred and was handled the same way and we ended up with an
endless loop.
I hope my description is clear, let me know if you have further questions.

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

