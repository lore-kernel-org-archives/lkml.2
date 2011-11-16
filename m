Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab1KPLvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:51:44 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35930 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab1KPLvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:51:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6531"; a="135767758"
Message-ID: <e56e6a44db4d8a0103825c1cc909f125.squirrel@www.codeaurora.org>
Date: Wed, 16 Nov 2011 03:51:26 -0800 (PST)
Subject: Re: [PATCH] mmc: core: Add packed command for eMMC4.5 device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: svenkatr@ti.com, linux-mmc@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        dh.han@samsung.com
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +			if (reqs >= 2) {
> +				mmc_blk_packed_hdr_wrq_prep(mq->mqrq_cur, card, mq, reqs);
> +				if (rq_data_dir(rqc) == READ) {
> +					areq = &mq->mqrq_cur->mmc_active;
> +					mmc_wait_for_req(card->host, areq->mrq);
Packing read requests requires preparation of two requests. After sending
the header we wait for its completion before sending the next request
(mmc_wait_for_req is used). Therefore, if we try to pack 2 read requests
we might end up with worse performance in comparison to sending each
request by itself (which allows the preparation of one request while the
other is sent).
I suggest to check the size of the packed commands list and in case it is
less than 3 send the requests one by one. If you move mmc_blk_chk_packable
to queue.c after the first fetch this change should be very easy and can
be done by removing the requests from the packed_list and calling issue_fn
for each one of them.

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum






