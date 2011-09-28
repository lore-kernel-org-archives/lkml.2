Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1I1Gq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:46:27 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:56989 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170Ab1I1GqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:46:25 -0400
Message-ID: <4E82C294.7000308@st.com>
Date: Wed, 28 Sep 2011 12:15:40 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
Cc: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Deepak Sikri <deepak.sikri79@gmail.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>, Amit VIRDI <Amit.VIRDI@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>
Subject: Re: [linux-pm Query] Power Management Device Suspend/ Resume
References: <CAO1yOm2pbApTwa0gj3Q9RsC1mxNGGirxm6FzaDC7zbgjHdkKDw@mail.gmail.com>  <4E8293C4.5090009@st.com> <1317181365.1573.1636.camel@vkoul-udesk3>
In-Reply-To: <1317181365.1573.1636.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vinod,

Thanks for mailing us back.

On 9/28/2011 9:12 AM, Vinod Koul wrote:
> On Wed, 2011-09-28 at 08:55 +0530, Viresh Kumar wrote:
>> On 9/22/2011 4:19 PM, Deepak Sikri wrote:
> are you trying to do runtime power management or traditional suspend and
> resume? IMO both should be done...

We will first be testing traditional suspend/resume, but obviously we would
try to design drivers in order to support runtime PM too.

>>> *Query- 1*. Suppose my platform has a ADC driver under char framework, which internally uses the
>>> DMA driver (channels). Now, ADC driver can be used by other kernel drivers or directly from user application.
>>>  
>>> *1. a.* What are the expectations from the suspend and resume routines of both the devices, DMA & ADC ?
>>>  
>>> */-- Given that few of the options are/*
>>> */1.a.1. On suspend,/*
>>> In ADC suspend function: ADC releases all the DMA channels, latches its registers; and
>>> DMA suspend function: DMA does nothing except for lataching of registers if required.
>>>  
>>> */1.a.2. On suspend, /*
>>> ADC suspend function: ADC just latches its registers and stops R/W through DMA, no DMA channel release;
>>> DMA suspend function: DMA halts its operating channels, and latches its registers if required.
> Well channel release/alloc is not really required. You can goto suspend
> in between as well. if you have queued but not active descriptors on all
> channels then dmac is idle and you can use this time to goto suspend.

But the time suspend is called for DMA, we may in middle of DMA transfers
on few channels. So should we wait for them to finish or simply disable
channel transfer? And in case of resume what will happen to transfers that
were active during suspend?

>>> *1.b* Will the suspend resume for the dependent drivers follow sequencing, i.e. Suspend of ADC followed by
>>> Suspend of DMA? (Assume both of these devices are hooked on to Platform bus, given that ADC uses DMA)
> why do you care?

Suppose suspend of DMA occurs first and we disable its clock in the suspend
routine. Now before the suspend of ADC is called, ADC requests for DMA
transfers and because not every routine of DMA keeps track of clk is on/off,
it may try to access DMA register.

So, we must ensure that all children are suspended before the parent is
requested to suspend. And probably this is the correct way.
So, here we need ADC to suspend before DMA. How is this sequencing ensured?

>>> 2.1 The user space threads freeze first followed by kernel space.  In case the user space process issues a a system
>>> call (lets assume an ioctl system call), how will the user space thread respond in case of suspend to ram?
> all user space processes are frozen on STR

Yes, but what will be its state. Will the system calls complete? Will it
close all devices opened by it before freezing?

Suppose a user applications is accessing few ADC channels. ADC controller
and its channel are all configured. Now, suspend is requested. What should
ADC driver do? As power will be turned off, its register will loose their
value.

Should ADC reconfigure all its channel registers by keeping their state?
Also it is not very straight forward to reconfigure channels directly, as
registers are required to be programmed in certain sequence, so there
needs to be good amount of intelligence put into driver for that.

IIRC, i couldn't find any such stuff in other mainline drivers. And that's
why we are confused on this topic.

-- 
viresh
