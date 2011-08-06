Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab1HFHBY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 03:01:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1HFHBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 03:01:23 -0400
Date: Sat, 6 Aug 2011 09:00:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Prarit Bhargava <prarit@redhat.com>, "trenn@suse.de" <trenn@suse.de>
Subject: Re: [patch] x86, x2apic: enable the bios request for x2apic optout
Message-ID: <20110806070019.GG13220@elte.hu>
References: <1311987173.12777.7.camel@sbsiddha-mobl2>
 <1312067391.22074.58.camel@i7.infradead.org>
 <1312167661.17578.4.camel@sbsiddha-mobl2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312167661.17578.4.camel@sbsiddha-mobl2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Sat, 2011-07-30 at 16:09 -0700, David Woodhouse wrote:
> > On Fri, 2011-07-29 at 17:52 -0700, Suresh Siddha wrote:
> > > 
> > > +               WARN(!eim, KERN_WARNING "Your BIOS is broken and requested that"
> > > +                          " x2apic be disabled\n This will leave your machine"
> > > +                          " vulnerable to irq-injection attacks\n Use"
> > > +                          " 'intremap=no_x2apic_optout' to override BIOS "
> > > +                          "request\n"); 
> > 
> > Please don't break strings, except at the \n. I think checkpatch.pl even
> > has an exception to its 80-column rule for this, these days?
> > 
> > If I see this message and search in the kernel source for the string
> > 'requested that x2apic be disabled', I should be able to find it.
> 
> Sure. Updated patch appended. Thanks.
> ---
> 
> From: Youquan Song <youquan.song@intel.com>
> Subject: x86, x2apic: enable the bios request for x2apic optout
> 
> On the platforms which are x2apic and interrupt-remapping capable, Linux
> kernel is enabling x2apic even if the BIOS doesn't. This is to take
> advantage of the features that x2apic brings in.
> 
> Some of the OEM platforms are running into issues because of this, as their
> bios is not x2apic aware. For example, this was resulting in interrupt migration
> issues on one of the platforms. Also if the BIOS SMI handling uses APIC
> interface to send SMI's, then the BIOS need to be aware of x2apic mode
> that OS has enabled.
> 
> On some of these platforms, BIOS doesn't have a HW mechanism to turnoff
> the x2apic feature to prevent OS from enabling it.
> 
> To resolve this mess, recent changes to the VT-d2 specification
> (http://download.intel.com/technology/computing/vptech/Intel(r)_VT_for_Direct_IO.pdf)
> includes a mechanism that provides BIOS a way to request system software
> to opt out of enabling x2apic mode.
> 
> Look at the x2apic optout flag in the DMAR tables before enabling the x2apic
> mode in the platform. Also print a warning that we have disabled x2apic
> based on the BIOS request.
> 
> Kernel boot parameter "intremap=no_x2apic_optout" can be used to override
> the BIOS x2apic optout request.
> 
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  Documentation/kernel-parameters.txt |    3 +-
>  arch/x86/kernel/apic/apic.c         |   31 ++++++++++++------------
>  drivers/iommu/dmar.c                |    2 +-
>  drivers/iommu/intr_remapping.c      |   44 ++++++++++++++++++++++++++++------
>  include/linux/dmar.h                |   14 +++++++++-
>  5 files changed, 66 insertions(+), 28 deletions(-)

Guys, mind doing this on top of the DMAR cleanup patches Yinghai 
posted? (if those patches are fine - i have not checked them in 
detail yet)

Really, if we need to do silly BIOS workarounds then we might as well 
use the opportunity to clean up this mess.

Thanks,

	Ingo
