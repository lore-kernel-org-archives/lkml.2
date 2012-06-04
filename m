Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180Ab2FDLBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:01:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12379 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2FDLBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:01:46 -0400
X-AuditID: cbfee61b-b7f0b6d000000f04-c0-4fcc9598bce8
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
References: <7155413ec18f57c1151a29992be32b1f.squirrel@www.codeaurora.org>
 <000201cd3fba$942df840$bc89e8c0$%jun@samsung.com>
 <f1ad97e8655631c46afd7084ef6266fd.squirrel@www.codeaurora.org>
In-reply-to: <f1ad97e8655631c46afd7084ef6266fd.squirrel@www.codeaurora.org>
Subject: RE: [PATCH v6 2/3] mmc: core: Support packed write command for eMMC4.5
 device
Date: Mon, 04 Jun 2012 20:01:44 +0900
Message-id: <001d01cd4241$6dd25220$4976f660$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1AFfTZSQIdZgaSTQqPMSTDtNiK/gCDZGUw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd0ZU8/4G7zZY2BxedccNosj//sZ
	HZg8Pm+SC2CM4rJJSc3JLEst0rdL4MrYdT6j4K1wxav9newNjF/4uxg5OSQETCQe/b3BAmGL
	SVy4t56ti5GLQ0hgOqNE+9mrTBDOH0aJ/mUNYFVsAloSf9+8YQaxRQQkJGbs/cQKYjMLxEjM
	bz3AAtGwn1HiZs9GsCJOAW+Jibt+ACU4OIQFIiQWnNYGCbMIqErceXGUDcTmFbCVuPl3O5Qt
	KPFj8j0WiJl6Eh//3GaEsOUlNq95ywwyRkJAHehqXYgTjCSeLZnNBFEiIrHvxTvGCYxCs5BM
	moVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzign0nvYFzVYHGIUYCD
	UYmHd0bUGX8h1sSy4srcQ4wSHMxKIrxPJgKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8z5ZssNf
	SCA9sSQ1OzW1ILUIJsvEwSnVwJiy1uvnt6VZEibHpMUDlMvd+LQ//Dhc1amU6/lvD4vPS5k6
	/9N84kwrH3Bx29w50sdQ58x2t1MpPC06OuG2zetzMfl/P87tLwiPt1nqn+2a9H66xcOTwU5W
	m12+OP/RPP7a9er34mf/JaxeyHe7dlaVXT50aqXDltVWvLeZmHc8+lRcbt8kosRSnJFoqMVc
	VJwIAIVs0hFkAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:
> > Maya Erez <merez@codeaurora.org> wrote:
> >> > @@ -1313,10 +1609,17 @@ static int mmc_blk_issue_rw_rq(struct
> >> mmc_queue
> >> *mq, struct request *rqc)
> >> >  			 * A block was successfully transferred.
> >> >  			 */
> >> >  			mmc_blk_reset_success(md, type);
> >> > -			spin_lock_irq(&md->lock);
> >> > -			ret = __blk_end_request(req, 0,
> >> > +
> >> > +			if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
> >> > +				ret = mmc_blk_end_packed_req(mq, mq_rq);
> >> If a specific request in the packed request consistantly fails, there is
> >> nothing to stop us from sending the same packed request in an endless
> >> loop.
> > There is various error case. This patch reused the existing error
> > handling.
> > What is that case we need to consider?
> >
> > Best regards,
> > Seungwon Jeon
> 
> This is different from unpacked requests handling since in the packed err
> check function you don't always return the error returned from
> mmc_blk_err_check. In case the EXT_CSD_PACKED_INDEXED_ERROR is set you
> return MMC_BLK_PARTIAL which is handled differently in the
> mmc_blk_issue_rw_rd.
> In our tests we set to 1 the packed bit in CMD23 arg of the first req (in
> the header). As a result, mmc_blk_err_check returned MMC_BLK_CMD_ERR.
> However, mmc_blk_packed_err_check returned MMC_BLK_PARTIAL (since the card
> indicated the index of the first request as the failed request).
> mmc_blk_issue_rw_rd handles MMC_BLK_PARTIAL by sending the packed command
> from the failed index and on, but since the packed bit was still set, the
> same error occurred and was handled the same way and we ended up with an
> endless loop.
> I hope my description is clear, let me know if you have further questions.
I tested your test case equally.
Even though your test makes the header parameter incorrect artificially
and keeps going with wrong setting repeatedly, we need to assure that
the similar result can be found practically with normal running.
I'll test it heavily and check more.
And if you have more review about this version, please let me know.

Thanks for your review.
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

