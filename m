Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1I1JAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:00:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:7787 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab1I1JAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:00:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="57455304"
Subject: Re: [linux-pm Query] Power Management Device Suspend/ Resume
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
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
In-Reply-To: <4E82C294.7000308@st.com>
References: <CAO1yOm2pbApTwa0gj3Q9RsC1mxNGGirxm6FzaDC7zbgjHdkKDw@mail.gmail.com>
	 <4E8293C4.5090009@st.com> <1317181365.1573.1636.camel@vkoul-udesk3>
	 <4E82C294.7000308@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 14:24:26 +0530
Message-ID: <1317200066.1573.1758.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 12:15 +0530, Viresh Kumar wrote:
> Vinod,
> 
> Thanks for mailing us back.
> 
> On 9/28/2011 9:12 AM, Vinod Koul wrote:
> > On Wed, 2011-09-28 at 08:55 +0530, Viresh Kumar wrote:
> >> On 9/22/2011 4:19 PM, Deepak Sikri wrote:
> > are you trying to do runtime power management or traditional suspend and
> > resume? IMO both should be done...
> 
> We will first be testing traditional suspend/resume, but obviously we would
> try to design drivers in order to support runtime PM too.
> 
> >>> *Query- 1*. Suppose my platform has a ADC driver under char framework, which internally uses the
> >>> DMA driver (channels). Now, ADC driver can be used by other kernel drivers or directly from user application.
> >>>  
> >>> *1. a.* What are the expectations from the suspend and resume routines of both the devices, DMA & ADC ?
> >>>  
> >>> */-- Given that few of the options are/*
> >>> */1.a.1. On suspend,/*
> >>> In ADC suspend function: ADC releases all the DMA channels, latches its registers; and
> >>> DMA suspend function: DMA does nothing except for lataching of registers if required.
> >>>  
> >>> */1.a.2. On suspend, /*
> >>> ADC suspend function: ADC just latches its registers and stops R/W through DMA, no DMA channel release;
> >>> DMA suspend function: DMA halts its operating channels, and latches its registers if required.
> > Well channel release/alloc is not really required. You can goto suspend
> > in between as well. if you have queued but not active descriptors on all
> > channels then dmac is idle and you can use this time to goto suspend.
> 
> But the time suspend is called for DMA, we may in middle of DMA transfers
> on few channels. So should we wait for them to finish or simply disable
> channel transfer? And in case of resume what will happen to transfers that
> were active during suspend?
In traditional suspend, you should pause the channel, go to suspend.
Basically any active work needs to paused while you suspend to disk/ram.
But in case of embedded devices I would be surprised to see this even
being the case.
> 
> >>> *1.b* Will the suspend resume for the dependent drivers follow sequencing, i.e. Suspend of ADC followed by
> >>> Suspend of DMA? (Assume both of these devices are hooked on to Platform bus, given that ADC uses DMA)
> > why do you care?
> 
> Suppose suspend of DMA occurs first and we disable its clock in the suspend
> routine. Now before the suspend of ADC is called, ADC requests for DMA
> transfers and because not every routine of DMA keeps track of clk is on/off,
> it may try to access DMA register.
> 
> So, we must ensure that all children are suspended before the parent is
> requested to suspend. And probably this is the correct way.
> So, here we need ADC to suspend before DMA. How is this sequencing ensured?
No your driver should handle it well
Btw if you do runtime_pm implementation first, things will be lot easier
for you


> >>> 2.1 The user space threads freeze first followed by kernel space.  In case the user space process issues a a system
> >>> call (lets assume an ioctl system call), how will the user space thread respond in case of suspend to ram?
> > all user space processes are frozen on STR
> 
> Yes, but what will be its state. Will the system calls complete? Will it
> close all devices opened by it before freezing?
See the talks by Rafael in various conferences, they have lot of info
covering these questions.
IMO all processes are frozen on traditional suspend and later thawed on
resume. 
> 
> Suppose a user applications is accessing few ADC channels. ADC controller
> and its channel are all configured. Now, suspend is requested. What should
> ADC driver do? As power will be turned off, its register will loose their
> value.
It need to pause/stop current operation or return EBUSY/EAGAIN. Btw does
it happen for you while system is trying to do suspend.

> 
> Should ADC reconfigure all its channel registers by keeping their state?
> Also it is not very straight forward to reconfigure channels directly, as
> registers are required to be programmed in certain sequence, so there
> needs to be good amount of intelligence put into driver for that.
yup, you should be doing that on device probe anyway
> 
> IIRC, i couldn't find any such stuff in other mainline drivers. And that's
> why we are confused on this topic.

-- 
~Vinod

