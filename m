Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2ALOYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:24:18 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:24066
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798Ab2ALOYO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:24:14 -0500
X-SpamScore: -10
X-BigFish: VS-10(zz9371I1432N98dKzz1202hzz8275bh8275dhz2dhc1ahc1bh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 12 Jan 2012 22:23:47 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Richard Zhao <richard.zhao@linaro.org>
CC: <patches@linaro.org>, <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>, Eric Miao <eric.miao@linaro.org>,
        <kernel@pengutronix.de>, <dan.j.williams@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/6] dma/imx-sdma: check whether event_id0 < 32 when set
 event_mask
Message-ID: <20120112142346.GA28968@b20223-02.ap.freescale.net>
References: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org>
 <1326178910-14044-6-git-send-email-richard.zhao@linaro.org>
 <20120110142008.GE26599@S2101-09.ap.freescale.net>
 <20120110142939.GB2019@richard-laptop>
 <20120110153836.GA27831@S2101-09.ap.freescale.net>
 <20120111005322.GB2414@b20223-02.ap.freescale.net>
 <20120111014730.GE2414@b20223-02.ap.freescale.net>
 <CAMPhdO9sGWTomtyMSTe_jC2GfvtdLR=M-z3Uzpesm9efBzhSqA@mail.gmail.com>
 <20120111123555.GA1916@richard-laptop>
 <20120111125337.GA27484@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20120111125337.GA27484@b20223-02.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 08:53:38PM +0800, Richard Zhao wrote:
> On Wed, Jan 11, 2012 at 08:35:57PM +0800, Richard Zhao wrote:
> > On Wed, Jan 11, 2012 at 02:37:08PM +0800, Eric Miao wrote:
> > > On Wed, Jan 11, 2012 at 9:47 AM, Richard Zhao
> > > <richard.zhao@freescale.com> wrote:
> > > > On Wed, Jan 11, 2012 at 08:53:23AM +0800, Richard Zhao wrote:
> > > >> On Tue, Jan 10, 2012 at 11:38:39PM +0800, Shawn Guo wrote:
> > > >> > On Tue, Jan 10, 2012 at 10:29:42PM +0800, Richard Zhao wrote:
> > > >> > > On Tue, Jan 10, 2012 at 10:20:10PM +0800, Shawn Guo wrote:
> > > >> > > > On Tue, Jan 10, 2012 at 03:01:50PM +0800, Richard Zhao wrote:
> > > >> > > > > Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
> > > >> > > > > ---
> > > >> > > >
> > > >> > > > I think it deserves a sensible commit message explaining why the patch
> > > >> > > > is needed.
> > > >> > > If event_id0 < 32, 1 << (sdmac->event_id0 - 32) is not zero.
> > > >> This meant to make you clear about the patch. I'll add it in commit
> > > >> message.
> > > > unsigned int t = 31;
> > > > printf("%d %08x\n", t, 1 << (t-32));
> > > >
> > > > I test above code on both x86 and arm. They shows different results.
> > > > x86: 31 80000000
> > > > arm: 31 00000000
> > > >
> > > > I think we still need this patch. we shoud not let it depends on gcc's
> > > > behavior.
> > > >
> > > > Thanks
> > > > Richard
> > > >> > >
> > > >> > My point is you may explain the exact problem you are seeing without
> > > >> > this patch
> > > >> The kernel don't have event_id < 32 case yet. I found the bug when
> > > >> I review the code.
> > > >> > and how the patch helps here.  In general, doing so would
> > > >> > win a warm feeling from reviewers much more easily than leaving the
> > > >> > commit message empty there.
> > > >> I understand your point that comment as much as possible.
> > > >>
> > > 
> > > Shawn,
> > > 
> > > I think Richard has made the issue quite clear here, the original
> > > code does seem to have some problems even to me, who do not
> > > understand the very details of the SDMA:
> > > 
> > > -                       sdmac->event_mask0 = 1 << sdmac->event_id0;
> > > -                       sdmac->event_mask1 = 1 << (sdmac->event_id0 - 32);
> > > 
> > > 1. if sdmac->event_id0 >= 32, which will cause event_mask0 to be incorrect
> > > 2. if sdmac->event_id < 32, sdmac->event_mask1 will be incorrect
> > > 
> > > An alternate way is to use the standard bit operations:
> > > 
> > > struct sdma_channel {
> > > 
> > > 	...
> > > 
> > > 	unsigned long event_mask[2];
> > > 
> > > 	...
> > > };
> > > 
> > > 	set_bit(sdmac->event_id0, event_mask);
> > > 
> > > Which avoids branch instructions and add a bit protection for the operation
> > > to be atomic enough (event_mask0/1 won't be inconsistent).
> > It's a good idea.
> I'm not sure whether I can always use bitops for every bit operation case,
> event it don't need atomic. bitops has locks to be atomic. 
I'll use non-atomic bit ops, __set_bit etc.
> 
> Thanks
> Richard
> > Thanks
> > Richard
> > 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

