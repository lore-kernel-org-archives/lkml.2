Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1CVA1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 20:27:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7852 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab1CVA1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 20:27:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6292"; a="81270884"
Message-ID: <2f8cf83e58884833fa8c67e536dd5620.squirrel@www.codeaurora.org>
In-Reply-To: <20110320092215.GA16646@n2100.arm.linux.org.uk>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
    <1300485423-27281-1-git-send-email-carlv@codeaurora.org>
    <20110320092215.GA16646@n2100.arm.linux.org.uk>
Date: Mon, 21 Mar 2011 17:26:37 -0700 (PDT)
Subject: Re: [PATCH 09/20] video: msm: Split out MDP2.2 HW specific code.
From: "Carl Vanderlip" <carlv@codeaurora.org>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: "Carl Vanderlip" <carlv@codeaurora.org>,
        "David Brown" <davidb@codeaurora.org>,
        "Daniel Walker" <dwalker@fifo99.com>,
        "Bryan Huntsman" <bryanh@codeaurora.org>,
        "Brian Swetland" <swetland@google.com>,
        "Dima Zavin" <dima@android.com>,
        "Rebecca Schultz Zavin" <rebecca@android.com>,
        "Colin Cross" <ccross@android.com>, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Mar 18, 2011 at 02:57:03PM -0700, Carl Vanderlip wrote:
>> +int mdp_ppp_cfg_edge_cond(struct mdp_blit_req *req, struct ppp_regs
>> *regs)
>> +{
>> +	int32_t luma_interp[4];
>> +	int32_t luma_repeat[4];
>> +	int32_t chroma_interp[4];
>> +	int32_t chroma_bound[4];
>> +	int32_t chroma_repeat[4];
>> +	uint32_t dst_w, dst_h;
>> +
>> +	memset(&luma_interp, 0, sizeof(int32_t) * 4);
>> +	memset(&luma_repeat, 0, sizeof(int32_t) * 4);
>> +	memset(&chroma_interp, 0, sizeof(int32_t) * 4);
>> +	memset(&chroma_bound, 0, sizeof(int32_t) * 4);
>> +	memset(&chroma_repeat, 0, sizeof(int32_t) * 4);
>> +	regs->edge = 0;
>> +
>> +	if (req->flags & MDP_ROT_90) {
>> +		dst_w = req->dst_rect.h;
>> +		dst_h = req->dst_rect.w;
>> +	} else {
>> +		dst_w = req->dst_rect.w;
>> +		dst_h = req->dst_rect.h;
>> +	}
>> +
>> +	if (regs->op & (PPP_OP_SCALE_Y_ON | PPP_OP_SCALE_X_ON)) {
>> +		get_edge_info(req->src_rect.h, req->src_rect.y, dst_h,
>> +			      &luma_interp[IMG_TOP], &luma_interp[IMG_BOTTOM],
>> +			      &luma_repeat[IMG_TOP], &luma_repeat[IMG_BOTTOM]);
>> +		get_edge_info(req->src_rect.w, req->src_rect.x, dst_w,
>> +			      &luma_interp[IMG_LEFT], &luma_interp[IMG_RIGHT],
>> +			      &luma_repeat[IMG_LEFT], &luma_repeat[IMG_RIGHT]);
>> +	} else {
>> +		luma_interp[IMG_LEFT] = req->src_rect.x;
>> +		luma_interp[IMG_RIGHT] = req->src_rect.x + req->src_rect.w - 1;
>> +		luma_interp[IMG_TOP] = req->src_rect.y;
>> +		luma_interp[IMG_BOTTOM] = req->src_rect.y + req->src_rect.h - 1;
>> +		luma_repeat[IMG_LEFT] = 0;
>> +		luma_repeat[IMG_TOP] = 0;
>> +		luma_repeat[IMG_RIGHT] = 0;
>> +		luma_repeat[IMG_BOTTOM] = 0;
>> +	}
>> +
>> +	chroma_interp[IMG_LEFT] = luma_interp[IMG_LEFT];
>> +	chroma_interp[IMG_RIGHT] = luma_interp[IMG_RIGHT];
>> +	chroma_interp[IMG_TOP] = luma_interp[IMG_TOP];
>> +	chroma_interp[IMG_BOTTOM] = luma_interp[IMG_BOTTOM];
>> +
>> +	chroma_bound[IMG_LEFT] = req->src_rect.x;
>> +	chroma_bound[IMG_RIGHT] = req->src_rect.x + req->src_rect.w - 1;
>> +	chroma_bound[IMG_TOP] = req->src_rect.y;
>> +	chroma_bound[IMG_BOTTOM] = req->src_rect.y + req->src_rect.h - 1;
>> +
>> +	if (IS_YCRCB(req->src.format)) {
>> +		chroma_interp[IMG_LEFT] = chroma_interp[IMG_LEFT] >> 1;
>> +		chroma_interp[IMG_RIGHT] = (chroma_interp[IMG_RIGHT] + 1) >> 1;
>> +
>> +		chroma_bound[IMG_LEFT] = chroma_bound[IMG_LEFT] >> 1;
>> +		chroma_bound[IMG_RIGHT] = chroma_bound[IMG_RIGHT] >> 1;
>> +	}
>> +
>> +	if (req->src.format == MDP_Y_CBCR_H2V2 ||
>> +	    req->src.format == MDP_Y_CRCB_H2V2) {
>> +		chroma_interp[IMG_TOP] = (chroma_interp[IMG_TOP] - 1) >> 1;
>> +		chroma_interp[IMG_BOTTOM] = (chroma_interp[IMG_BOTTOM] + 1)
>> +					    >> 1;
>> +		chroma_bound[IMG_TOP] = (chroma_bound[IMG_TOP] + 1) >> 1;
>> +		chroma_bound[IMG_BOTTOM] = chroma_bound[IMG_BOTTOM] >> 1;
>> +	}
>> +
>> +	chroma_repeat[IMG_LEFT] = chroma_bound[IMG_LEFT] -
>> +				  chroma_interp[IMG_LEFT];
>> +	chroma_repeat[IMG_RIGHT] = chroma_interp[IMG_RIGHT] -
>> +				  chroma_bound[IMG_RIGHT];
>> +	chroma_repeat[IMG_TOP] = chroma_bound[IMG_TOP] -
>> +				  chroma_interp[IMG_TOP];
>> +	chroma_repeat[IMG_BOTTOM] = chroma_interp[IMG_BOTTOM] -
>> +				  chroma_bound[IMG_BOTTOM];
>> +
>> +	if (chroma_repeat[IMG_LEFT] < 0 || chroma_repeat[IMG_LEFT] > 3 ||
>> +	    chroma_repeat[IMG_RIGHT] < 0 || chroma_repeat[IMG_RIGHT] > 3 ||
>> +	    chroma_repeat[IMG_TOP] < 0 || chroma_repeat[IMG_TOP] > 3 ||
>> +	    chroma_repeat[IMG_BOTTOM] < 0 || chroma_repeat[IMG_BOTTOM] > 3 ||
>> +	    luma_repeat[IMG_LEFT] < 0 || luma_repeat[IMG_LEFT] > 3 ||
>> +	    luma_repeat[IMG_RIGHT] < 0 || luma_repeat[IMG_RIGHT] > 3 ||
>> +	    luma_repeat[IMG_TOP] < 0 || luma_repeat[IMG_TOP] > 3 ||
>> +	    luma_repeat[IMG_BOTTOM] < 0 || luma_repeat[IMG_BOTTOM] > 3)
>> +		return -1;
>
> Lazy programming strikes again.  Public functions really should not
> return things that look like errno codes, rather they should return
> real errno codes.
>
> Secondly, why is this stuff, which looks very driver like, under arch/arm
> and not in drivers/ somewhere?
>

Fixed.

Secondly, I think this code in particular is in drivers/video/msm; I think
you've been included since there are some Kconfig updates under arch/arm
(additionally, I think David B. will be pulling this into his for-next
tree if approved).

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

