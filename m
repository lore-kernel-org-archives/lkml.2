Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab1ERXuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:50:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:64782 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab1ERXuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:50:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,234,1304319600"; 
   d="scan'208";a="4291791"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Thu, 19 May 2011 07:49:49 +0800
Subject: RE: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
Thread-Topic: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
Thread-Index: AcwORc6McB5lwtD3QfS40WLCK7YIiAAe45OgAbywMYA=
Message-ID: <625BA99ED14B2D499DC4E29D8138F1505C9BBF8D40@shsmsx502.ccr.corp.intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <alpine.LFD.2.02.1105061149330.3005@ionos>
 <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com>
 <alpine.DEB.2.00.1105061526120.10886@kaball-desktop>
 <625BA99ED14B2D499DC4E29D8138F1505C8ED7FB9F@shsmsx502.ccr.corp.intel.com>
 <alpine.DEB.2.00.1105091301040.10886@kaball-desktop>
 <alpine.LFD.2.02.1105091435350.2843@ionos>
 <625BA99ED14B2D499DC4E29D8138F1505C8F008B68@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F1505C8F008B68@shsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Tian, Kevin
> Sent: Tuesday, May 10, 2011 11:24 AM
> 
> > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > Sent: Monday, May 09, 2011 8:37 PM
> >
> > On Mon, 9 May 2011, Stefano Stabellini wrote:
> >
> > > On Mon, 9 May 2011, Tian, Kevin wrote:
> > > > yes, with your patch this issue disappears, since you explicitly
> > > > make mask/unmask as a nop for xen_percpu_chip, which effectively
> > > > avoids them from undesired unmask when doing the migration. Though
> > > > it works, it's not intuitive as to me it's an workaround to make
> > > > Xen chip
> > implementation adapting to specific fixup_irqs logic.
> > >
> > > I have been tring to follow the example of existing supported drivers.
> > > The only x86 driver I could find that uses handle_percpu_irq is
> > > uv_irq that does exatly the same thing.
> >
> > Which is a good enough argument to make that change at the common code
> > level instead of having fancy workarounds here and there.
> >
> 
> So Thomas, what's your suggestion to continue here? Is my original patch to
> skip percpu irq in common code a good option to go, or you want a cleaner code
> in other form? Once it's clear I'll discuss with Stefano e.g. possibly merge with
> his cleanup patch series. :-)
> 

Hi, Thomas,

any response on this? Sorry that you may explain your comments clearly in earlier
thread, but I may not catch all of them in one place.

I sent out two fixes here:
[1/2] don't move irq when it's percpu type
[2/2] don't unmask irq when it's disabled at irqchip level

for [2/2], as you explained it's legitimate to mask/unmask a disabled irq since from
irqchip level mask/disable actually means same thing. The only possible gain to
do that is to avoid a potential extra interrupt, which is a different purpose as what
I originally target. So for [2/2] I think it's not required now.

for [1/2] I think it's still necessary as it's meaningless to migrate a percpu type irq.
However Stefano has sent out a cleanup patch for Xen percpu irqchip which uses
nop mask/unmask hack borrowed from uv machine to work around the issue. As
you suggested it's better to consolidate into the common place instead of scattering
in different places. My view on this common logic is what [1/2] tries to address, is
it correct? If yes, would you consider taking this patch? Stefano told me that his
patches will go in in next merge window. So I think either you can take [1/2] now and
then I'll do cleanup after Stefano's patch is in, or I can rebase my [1/2] after Stefano's
patch to clean both xen and uv parts. 

Let me know your thought.

Thanks
Kevin
