Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2AQJHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:07:49 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:35673 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab2AQJHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:07:45 -0500
Message-ID: <4F153A3A.7060902@st.com>
Date: Tue, 17 Jan 2012 14:37:06 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>
Subject: Re: [PATCH 2/8] dmaengine: Add flow controller information to dma_slave_config
References: <cover.1326707233.git.viresh.kumar@st.com> <5f9ec59562e86536c4123f61891b95590293030f.1326707233.git.viresh.kumar@st.com> <CACRpkdY4QQK6wtB5aPU+FwdyyGq-owsDxMmxdwJVnkzdJTRs_Q@mail.gmail.com>
In-Reply-To: <CACRpkdY4QQK6wtB5aPU+FwdyyGq-owsDxMmxdwJVnkzdJTRs_Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/2012 2:07 PM, Linus Walleij wrote:
>> > Perhaps, this should be a part of struct dma_slave_config. This patch adds
>> > another field device_fc to this structure. User drivers must pass this as true
>> > if they want to be flow controller of certain transfers.
> I dma_slave_config is supposed to be about info that
> 
> 1) Must to be set-up at runtime

Hmmm.. Currently if i check the comments in dmaengine.h, it is written
as you said. But i believe its usage could be more than that.

For example, how amba-pl011 use it today. Nothing dynamic, all static.

Actually the problem scenario is: pl011 is going to use separate DMA drivers
(for ex: dw_dmac and pl08x) for separate platforms. Now, pl011's code shouldn't
be dependent at all on these controllers. So, we have to pass separate data to
these drivers using dma driver specific platform data.

DMA driver's platform data contains two type of stuff: platform specific
(request line, master, etc) and user driver specific (like pl011) (reg address,
burst, width, direction, flow_controller, etc)

Now, its better to have some common struct in dmaengine which can fulfill
requirement of various DMA driver's data.

I find struct dma_slave_config fitting there. All user driver (pl011) specific
data can be passed using this structure. You can call dma_slave_config()
onetime after you got the channel. And after that just submit transfers.

With this i get rid of half of the dw_dmac specific platform data struct and
used already defined struct dma_slave_config.

> 2) All DMA controllers need to know
> 

Sorry i didn't understood it well.

One more thing. I missed few things in this patch:
- Need to update all instances of struct dma_slave_config with
	.device_fc = false

If, this field is not getting initialized to false by default, then these users
will find their code not working atleast with dw_dmac and amba-pl08x.
Can't say about other drivers.

- Also i need to fixup few atmel drivers which are using dw_dmac.

> So if it doesn't *have* to be set up by drivers at runtime, please keep it in
> platform data.
> 
> If it is (1), so you have a use case where you have to switch a certain channel
> between DMA master and device flow control at run-time it looks like it could
> be useful for others as well, but I doubt this so I'd like some back-up on
> that.

I don't have that crazy usecase :)

-- 
viresh
