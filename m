Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab0LOOGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:06:01 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36164 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab0LOOF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:05:59 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6197"; a="66925382"
Date: Wed, 15 Dec 2010 06:05:58 -0800
From: David Brown <davidb@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/5] msm: Secure Channel Manager (SCM) support
Message-ID: <20101215140558.GA9736@huya.qualcomm.com>
References: <1291619778-30289-1-git-send-email-johlstei@codeaurora.org>
 <1291619778-30289-2-git-send-email-johlstei@codeaurora.org>
 <20101215074811.GA2483@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101215074811.GA2483@ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 08:48:11AM +0100, Pavel Machek wrote:

> > +static u32 smc(dma_addr_t cmd_addr)
> > +{
> > +	int context_id;
> > +	register u32 r0 asm("r0") = 1;
> > +	register u32 r1 asm("r1") = (u32)&context_id;
> > +	register u32 r2 asm("r2") = (u32)cmd_addr;
> 
> Are these neccessary?

The values have to be in specific registers.  Without them it doesn't
generate the right code.

> > +	asm(
> > +		__asmeq("%0", "r0")
> > +		__asmeq("%1", "r0")
> > +		__asmeq("%2", "r1")
> > +		__asmeq("%3", "r2")
> > +		"smc	#0	@ switch to secure world\n"
> > +		: "=r" (r0)
> > +		: "r" (r0), "r" (r1), "r" (r2)
> > +		: "r3");
> > +	return r0;
> > +}
> 
> > +u32 scm_get_version(void)
> > +{
> > +	int context_id;
> > +	static u32 version = -1;
> > +	register u32 r0 asm("r0") = 0x1 << 8;
> > +	register u32 r1 asm("r1") = (u32)&context_id;
> 
> And does this even work?

In what sense?  It generates the desired code.

> > +	if (version != -1)
> > +		return version;
> > +
> > +	mutex_lock(&scm_lock);
> > +	asm(
> > +		__asmeq("%0", "r1")
> > +		__asmeq("%1", "r0")
> > +		__asmeq("%2", "r1")
> > +		"smc	#0	@ switch to secure world\n"
> > +		: "=r" (r1)
> > +		: "r" (r0), "r" (r1)
> > +		: "r2", "r3");
> > +	version = r1;
> > +	mutex_unlock(&scm_lock);
> > +
> > +	return version;
> > +}

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
