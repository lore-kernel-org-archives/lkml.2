Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab1IGXBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:01:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51744 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab1IGXBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:01:17 -0400
MIME-Version: 1.0
In-Reply-To: <438BB0150E931F4B9CE701519A4463010871804A4C@bgsmsx502.gar.corp.intel.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com>
	<20110814083618.GE4986@n2100.arm.linux.org.uk>
	<4E4CCF7B.8060704@st.com>
	<20110821083306.GA12028@n2100.arm.linux.org.uk>
	<4E532B19.6000103@st.com>
	<4E5715CE.2070806@st.com>
	<CACRpkdapSvW=eMSoXTOOA2GyhfBLzq2OuyQcDctPxsnVzvr-4g@mail.gmail.com>
	<4E575E75.40603@st.com>
	<4E5F594D.10203@st.com>
	<438BB0150E931F4B9CE701519A4463010871804A4C@bgsmsx502.gar.corp.intel.com>
Date: Thu, 8 Sep 2011 01:01:15 +0200
X-Google-Sender-Auth: 5oxau5YipnkXSNGM_SOM4f-EyzQ
Message-ID: <CAKnu2Mp3Ui7jZS2kjJykjuzcTzJhiAkoaVxZ2+tQX0banGh6mw@mail.gmail.com>
Subject: Re: [PATCH 16/18] dmaengine/amba-pl08x: Add support for sg len
 greater than one for slave transfers
From: Linus Walleij <linus.walleij@linaro.org>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "viresh.kumar@st.com" <viresh.kumar@st.com>,
        "pratyush.anand@st.com" <pratyush.anand@st.com>,
        "rajeev-dlh.kumar@st.com" <rajeev-dlh.kumar@st.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "bhupesh.sharma@st.com" <bhupesh.sharma@st.com>,
        "armando.visconti@st.com" <armando.visconti@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vipin.kumar@st.com" <vipin.kumar@st.com>,
        "shiraz.hashim@st.com" <shiraz.hashim@st.com>,
        "Amit.VIRDI@st.com" <Amit.VIRDI@st.com>,
        "vipulkumar.samar@st.com" <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "deepak.sikri@st.com" <deepak.sikri@st.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/7 Koul, Vinod <vinod.koul@intel.com>:
> On Thu, 2011-09-01 at 15:37 +0530, Viresh Kumar wrote:
>> On 8/26/2011 2:21 PM, Viresh Kumar wrote:
>> > I just wanted to know, whether i need to do any other modification in this patch or not?
>>
>> Hello,
>>
>> Do i need to update anything in this patch? Or can this be pushed as it is?
>>
> I thought Linus W, and Russell had some comments on this.

I think the patch brings valuable functionality we don't want to loose when
there is a solution. Basically the dmaengine has a contract to handle
sglists of any lengths and it's a pity that we don't, and I suspect Viresh
cannot use the driver for MMC unless something like this is added, so
Acked-by: Linus Walleij <linus.walleij@linaro.org>

BUT I think it is possible to rewrite it a bit later so as to get a better
handling of this. Isn't Russells initial remark that the LLI:s can simply just
take in the entire sglist at once true?

Check for example in drivers/dma/coh901318.c which evidently has
a LLI format similar or identical to what pl08x use (which is another
reason to refactor this later):

It will just fill in LLIs for all the elements of the sglist, and off you go.

Like this:

       /* The dma only supports transmitting packages up to
         * MAX_DMA_PACKET_SIZE. Calculate to total number of
         * dma elemts required to send the entire sg list
         */
        for_each_sg(sgl, sg, sg_len, i) {
                unsigned int factor;
                size = sg_dma_len(sg);

                if (size <= MAX_DMA_PACKET_SIZE) {
                        len++;
                        continue;
                }

                factor = size >> MAX_DMA_PACKET_SIZE_SHIFT;
                if ((factor << MAX_DMA_PACKET_SIZE_SHIFT) < size)
                        factor++;

                len += factor;
        }

        pr_debug("Allocate %d lli:s for this transfer\n", len);
        lli = coh901318_lli_alloc(&cohc->base->pool, len);

        if (lli == NULL)
                goto err_dma_alloc;

        /* initiate allocated lli list */
        ret = coh901318_lli_fill_sg(&cohc->base->pool, lli, sgl, sg_len,
                                    cohc_dev_addr(cohc),
                                    ctrl_chained,
                                    ctrl,
                                    ctrl_last,
                                    direction, COH901318_CX_CTRL_TC_IRQ_ENABLE);
        if (ret)
                goto err_lli_fill;


The rest of interesting code is in coh901318_lli_fill_sg() as you can
see.

Evidently this need to be fixed as part of factoring out the LLI handling
from PL08x and coh901318 into a single one. If we ever get to it.

Yours,
Linus Walleij
