Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab0I1BTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 21:19:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:31411 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab0I1BTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 21:19:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,244,1283756400"; 
   d="scan'208";a="841485334"
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
From: Huang Ying <ying.huang@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: huang ying <huang.ying.caritas@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100927133816.GP13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	 <1285549026-5008-6-git-send-email-ying.huang@intel.com>
	 <20100927100901.GC32222@erda.amd.com>
	 <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
	 <20100927133816.GP13563@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 09:19:21 +0800
Message-ID: <1285636761.20791.133.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 21:38 +0800, Robert Richter wrote:
> On 27.09.10 08:47:53, huang ying wrote:
> 
> > >>  arch/x86/kernel/hwerr.c    |   55 +++++++++++++++++++++++++++++++++++++++++++++
> > >
> > > Instead of creating this file the code should be implemented in
> > >
> > >  arch/x86/kernel/cpu/intel.c
> > >
> > > Similar AMD NB code is implemented in amd.c and k8.c.
> > 
> > Why? This file is not vendor specific.
> 
> No, it only implements an Intel specific PCI device, nothing else.

You can add AMD specific PCI device here too. We will add more device ID
in the future.

> > >> +late_initcall(check_unknown_nmi_for_hwerr);
> > >
> > > Maybe you can use early pci functions like read_pci_config() to avoid
> > > late init.
> > 
> > I don't think late init is a big issue. Hardware error is rare after all.
> 
> Just want to let you know this as an option.
> 
> > >> --- a/arch/x86/kernel/traps.c
> > >> +++ b/arch/x86/kernel/traps.c
> > >> @@ -83,6 +83,8 @@ EXPORT_SYMBOL_GPL(used_vectors);
> > >>
> > >>  static int ignore_nmis;
> > >>
> > >> +int unknown_nmi_for_hwerr;
> > >
> > > If it is an nmi for hwerr, it is no longer an unknown nmi. So we
> > > should drop 'unknow' in the naming.
> > 
> > I think unkown NMI is the one we can not identify the source.
> > Something like anonymous.
> > 
> > >> +
> > >>  /*
> > >>   * Prevent NMI reason port (0x61) being accessed simultaneously, can
> > >>   * only be used in NMI handler.
> > >> @@ -360,6 +362,14 @@ io_check_error(unsigned char reason, str
> > >>  static notrace __kprobes void
> > >>  unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
> > >>  {
> > >> +     /*
> > >> +      * On some platforms, hardware errors may be notified via
> > >> +      * unknown NMI
> > >> +      */
> > >> +     if (unknown_nmi_for_hwerr)
> > >> +             panic("NMI for hardware error without error record: "
> > >> +                   "Not continuing");
> > >> +
> > >
> > > Instead of checking this flag you should implement and register an nmi
> > > handler for this case.
> > 
> > I think explicit function calls have better readability than notifier chains.
> 
> What is different to unknown_nmi() then?
> 
> So no, in your case you want to catch unknown nmis for a certain
> hardware and then throw a panic.

No. We do NOT catch unknown NMIs for a certain hardware here. We put the
code here because we think it is general instead of hardware specific.

It should be a general rule to treat unknown NMI as hardware error. But
to avoid to confuse some users have broken hardware (which will generate
unknown NMI not for hardware error), we use a white list (machines with
HEST or workable chipset via PCI ID).

Best Regards,
Huang Ying


