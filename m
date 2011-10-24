Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1JXD6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 23:58:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:52596 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab1JXD6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 23:58:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,396,1315206000"; 
   d="scan'208";a="76706382"
Subject: RE: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552023672A3@CORPEXCH1.na.ads.idt.com>
References: <CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com>
	 <CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202321E20@CORPEXCH1.na.ads.idt.com>
	 <CAJe_ZhfWcUY2ctUFt0iUf2FOfjKj1Aa8hQH5LqFG+bZ+93CcNQ@mail.gmail.com>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202321F65@CORPEXCH1.na.ads.idt.com>
	 <CAJe_ZhfTg17YgyQ9TuKdhtXMu+8W_E2t3cBqZybfarxWu9Zasg@mail.gmail.com>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E552023220AC@CORPEXCH1.na.ads.idt.com>
	 <CAJe_ZhdBSxvH6Zd8JsoLrerapNbLn0a7Lv6KxwivbFuLaSavyg@mail.gmail.com>
	 <20111018074211.GA13483@flint.arm.linux.org.uk>
	 <CAJe_ZhdHcsBNT6iX7TJCqoGZMrPwE2BOt06e8M8PHzuDe3Z70w@mail.gmail.com>
	 <20111018094944.GA30644@flint.arm.linux.org.uk>
	 <CAJe_ZhcDJjP3t_XFG04or4WzwzPHEcHo2ThstGCVFrYvYqTaiQ@mail.gmail.com>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E552023672A3@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Oct 2011 09:19:09 +0530
Message-ID: <1319428149.9355.60.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 10:57 -0700, Bounine, Alexandre wrote:

Sorry for delayed response, been quite busy with upcoming festival, and
other stuff  :(
> > >
> > Thanks for the detailed explanation.
> > 
> > RapidIO is a packet switched interconnect with parallel or serial
> > interface.
> > Among other things, a packet contains 32, 48 or 64 bit offset into the
> > remote-endpoint's address space. So I don't get how any of the above
> > 6 points apply here.
> > 
> > Though I agree it is peculiar for a networking technology to expose a
> > DMAEngine interface. But I assume Alex has good reasons for it, who
> > knows RIO better than us.
> To keep it simple, look at this as a peer-to-peer networking with HW ability
> to directly address memory of the link partner.
> 
> RapidIO supports messaging which is closer to traditional networking and is
> supported by RIONET driver (pretending to be Ethernet). But in some situations
> messaging cannot be used. In these cases addressed memory read/write
> operations take place.
> 
> I would like to put a simple example of RIO based system that may help to
> understand our DMA requirements. 
> 
> Consider a platform with one host CPU and several DSP cards connected
> to it through a switched backplane (transparent for purpose of this example).
>  
> The host CPU has one or more RIO-capable DMA channel and runs device
> drivers for connected DSP cards. Each device driver is required to load
> an individual program code into corresponding DSP(s). Directly addressed
> writes have a lot of sense.
> 
> After DSP code is loaded device drivers start DSP program and may
> participate in data transfers between DSP cards and host CPU. Again
> messaging type transfers may add unnecessary overhead here compared
> to direct data reads/writes.
> 
> Configuration of each DSP card may be different but from host's
> POV is RIO spec compliant.

I think we all agree that this fits the dma_slave case :)

As for changing in dmaengine to u64, if we are thinking this as slave
usage, then ideally we should not make assumption of the address type of
peripheral so we should only move the dma_slave_config address fields to
u64, if that helps in RIO case. Moving other usages would be insane.
 
At this point we have two proposals
a) to make RIO exceptional case and add RIO specific stuff.
b) make dmaengine transparent and add additional argument
in .device_prep_slave_sg() callback which is subsystem dependent.
Current dmacs and those who don't need it will ignore it.

ATM, I am leaning towards the latter, for the main reason to keep
dmaengine away from subsystem details.

-- 
~Vinod

