Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab0I3E5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 00:57:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:12087 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab0I3E5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 00:57:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,257,1283756400"; 
   d="scan'208";a="842247934"
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100930043628.GE26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	 <1285549026-5008-6-git-send-email-ying.huang@intel.com>
	 <20100927100901.GC32222@erda.amd.com>
	 <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
	 <20100927133816.GP13563@erda.amd.com> <20100927152014.GY26290@redhat.com>
	 <1285634172.20791.92.camel@yhuang-dev> <20100928153247.GL26290@redhat.com>
	 <AANLkTinmhTgVhPsmGLC8Z-9Kx3xRovWy=9+R_5B4u6Cx@mail.gmail.com>
	 <20100930043628.GE26290@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 12:57:10 +0800
Message-ID: <1285822630.6944.69.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Don,

On Thu, 2010-09-30 at 12:36 +0800, Don Zickus wrote:
> On Wed, Sep 29, 2010 at 04:17:30PM +0800, huang ying wrote:
> > On Tue, Sep 28, 2010 at 11:32 PM, Don Zickus <dzickus@redhat.com> wrote:
> > 
> > > But the problem is you have to export all this platform specific stuff to
> > > traps.c and surround the code with #ifdef's, which start to look ugly.
> > 
> > There is no #ifdef in my final default_do_nmi(), so I think the code
> > can be cleaned up without converting everything into notifier block. I
> > think the rule can be: architecture specific thing should go direct
> > call, while device driver should be turned into notifier block.
> 
> That sounds like a good rule, but then my definition of architecture
> specific is whatever is written in the intel/amd x86_64 architecture
> manual (that sits on my desk, dated 2002), which wouldn't include any
> of the error handling you propose, nor MCE, nor perf.

MCE is at least in new version of Intel SDM vol 3A. But we do not need
to process MCE in NMI handler. Performance monitor counter is in Intel
SDM Vol 3B.

> I guess I look at all that stuff as cpu features because not all the cpus
> on the market have them.  Shouldn't traps.c just contain core architecture
> stuff and all those hardware error features could go under
> arch/x86/kernel/cpu with the rest of the features, no?

Yes. Both MCE and perf are CPU features. I think they can be thought as
optional architectural features. I think it is good to put similar
features into arch/x86/kernel/cpu instead of traps.c. But if necessary,
we can put direct call in traps.c instead of notifier block.

> > > Is there any reason why traps.c should know about MCA/HEST/<other hardware
> > > errors>?  Shouldn't it be abstracted away?
> > 
> > Yes. The device drivers should be abstracted away, leaving
> > architectural logic, such as port 0x61 as direct call. We need
> > notifier chain, but I just suggest reduce its usage if possible.
> > 
> > > Honestly, I would be interested in creating a southbridge driver and
> > > moving the port 0x61 code there and keeping the default_do_nmi() function
> > > stupidly simple (just a call to the die_chain and the
> > > unknown_nmi_error()).
> > 
> > I think the southbridge drivers should go notifier block, but the port
> > 0x61 code is architectural and should be kept in default_do_nmi().
> 
> Is port 0x61 architectural?  I thought it a southbridge thing.  In fact I
> thought with modern chipsets you can access the same thing through port
> 0x70 or 0x71 (I can't seem to figure out which Intel doc I saw that in).
> (Not that this conversation has any bearing on your patchset, just an idea
> I had).

At least until now, I think port 0x61 can be considered architectural
(just like we think PIT is architectural before). Maybe in the future it
will become deprecated and turned into something like a device driver.
But why not wait until it be.

Best Regards,
Huang Ying


