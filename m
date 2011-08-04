Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1HDFzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 01:55:19 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:41549 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab1HDFzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 01:55:16 -0400
Message-ID: <4E3A342E.5080503@st.com>
Date: Thu, 4 Aug 2011 11:24:54 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: viresh kumar <viresh.linux@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 09/18] dmaengine/amba-pl08x: Schedule tasklet in case
 of error interrupt
References: <cover.1311936523.git.viresh.kumar@st.com>	 <9c81beb9cd84f84b58abbd24ebfae85dfe8d8ee1.1311936524.git.viresh.kumar@st.com>	 <1311941799.1536.532.camel@vkoul-udesk3>	 <CAOh2x==_g+JQzTizgVTdH8Dyg_5+KpyYm+G_Ddu5mO15N6n-tw@mail.gmail.com> <1312431918.1536.559.camel@vkoul-udesk3>
In-Reply-To: <1312431918.1536.559.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 09:55 AM, Koul, Vinod wrote:
> Yes that's the whole point, today callback mechanism doesn't tell the
> _status_ of the transfer (which if we need change can be discussed as
> well), but to counter argue I have never been able to generate the error
> interrupt, are you able to do on your controller?

Yes, if we supply unaligned address, with access width as word, then it gives
error interrupt.

Regarding your point of updating callback for reporting errors,
I think it is required and should be a common issue.

> 
> One more point wrt this patch, what do we gain here from calling
> tasklet, are you cleaning up your queue for the error descriptor or
> something, I think not. so just calling to print doesn't make sense to
> me, comments?

Tasklet does following:
- If any other transfer request is queued up, then it is started
- else, it releases physical channel, by clearing it completely.

Finally it unmap buffers, frees txd, and call callback.

This probably is enough to end transfer for which user was waiting.
If user hasn't used any timeout mechanisms then he will never come
to know that an error occurred. So its better to call its callback,
to tell him, transfer has completed, successfully or unsuccessfully.

-- 
viresh
