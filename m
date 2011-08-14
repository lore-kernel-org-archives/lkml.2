Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab1HNIaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 04:30:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52389 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1HNIaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 04:30:04 -0400
Date: Sun, 14 Aug 2011 09:29:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: viresh kumar <viresh.kumar@st.com>, Dan <dan.j.williams@intel.com>,
        viresh kumar <viresh.linux@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 09/18] dmaengine/amba-pl08x: Schedule tasklet in case
	of error interrupt
Message-ID: <20110814082928.GD4986@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <9c81beb9cd84f84b58abbd24ebfae85dfe8d8ee1.1311936524.git.viresh.kumar@st.com> <1311941799.1536.532.camel@vkoul-udesk3> <CAOh2x==_g+JQzTizgVTdH8Dyg_5+KpyYm+G_Ddu5mO15N6n-tw@mail.gmail.com> <1312431918.1536.559.camel@vkoul-udesk3> <4E3A342E.5080503@st.com> <1312435962.1536.566.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312435962.1536.566.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 11:02:42AM +0530, Koul, Vinod wrote:
> On Thu, 2011-08-04 at 11:24 +0530, viresh kumar wrote:
> > On 08/04/2011 09:55 AM, Koul, Vinod wrote:
> > > Yes that's the whole point, today callback mechanism doesn't tell the
> > > _status_ of the transfer (which if we need change can be discussed as
> > > well), but to counter argue I have never been able to generate the error
> > > interrupt, are you able to do on your controller?
> > 
> > Yes, if we supply unaligned address, with access width as word, then it gives
> > error interrupt.
> > 
> > Regarding your point of updating callback for reporting errors,
> > I think it is required and should be a common issue.
> Okay till now no one has asked for it. We can add to callback arguments
> either a bool to indicate what is the transfer status or usual error
> code to also indicate what type of failure.
> I would prefer latter, if there is consensus on this, we can go thru
> with this approach, Dan your comments?

If we are concerned about unaligned addresses, then that's something which
should be checked for at prepare time, to avoid failing DMA transfers.  A
failed DMA transfer is potentially a data loss situation, one that we want
to avoid.

Consider for instance a UART driver using DMA for TX/RX.  We want to know
when we prepare the RX DMA whether the DMA engine is going to be able to
perform the requested transfer.  We don't want to know when characters
start coming in, because not only would we have to undo the DMA setup,
but we'd also need to ensure that we start reading the characters via PIO
as quickly as possible to avoid overruns.

So, what I'd say is if you receive an error interrupt, either the prep
code isn't robust enough - it's like a BUG() telling us that something
needs fixing.  So, I think printing a warning and stalling makes sense -
and hopefully we get a bug report to investigate the causes.
