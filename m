Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab0I0NjC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:39:02 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:19288
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755067Ab0I0Ni7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:38:59 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L9ER7R-01-D1Q-02
X-M-MSG: 
Date: Mon, 27 Sep 2010 15:38:16 +0200
From: Robert Richter <robert.richter@amd.com>
To: huang ying <huang.ying.caritas@gmail.com>
CC: Huang Ying <ying.huang@intel.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
Message-ID: <20100927133816.GP13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-6-git-send-email-ying.huang@intel.com>
 <20100927100901.GC32222@erda.amd.com>
 <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.09.10 08:47:53, huang ying wrote:

> >>  arch/x86/kernel/hwerr.c    |   55 +++++++++++++++++++++++++++++++++++++++++++++
> >
> > Instead of creating this file the code should be implemented in
> >
> >  arch/x86/kernel/cpu/intel.c
> >
> > Similar AMD NB code is implemented in amd.c and k8.c.
> 
> Why? This file is not vendor specific.

No, it only implements an Intel specific PCI device, nothing else.

> >> +late_initcall(check_unknown_nmi_for_hwerr);
> >
> > Maybe you can use early pci functions like read_pci_config() to avoid
> > late init.
> 
> I don't think late init is a big issue. Hardware error is rare after all.

Just want to let you know this as an option.

> >> --- a/arch/x86/kernel/traps.c
> >> +++ b/arch/x86/kernel/traps.c
> >> @@ -83,6 +83,8 @@ EXPORT_SYMBOL_GPL(used_vectors);
> >>
> >>  static int ignore_nmis;
> >>
> >> +int unknown_nmi_for_hwerr;
> >
> > If it is an nmi for hwerr, it is no longer an unknown nmi. So we
> > should drop 'unknow' in the naming.
> 
> I think unkown NMI is the one we can not identify the source.
> Something like anonymous.
> 
> >> +
> >>  /*
> >>   * Prevent NMI reason port (0x61) being accessed simultaneously, can
> >>   * only be used in NMI handler.
> >> @@ -360,6 +362,14 @@ io_check_error(unsigned char reason, str
> >>  static notrace __kprobes void
> >>  unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
> >>  {
> >> +     /*
> >> +      * On some platforms, hardware errors may be notified via
> >> +      * unknown NMI
> >> +      */
> >> +     if (unknown_nmi_for_hwerr)
> >> +             panic("NMI for hardware error without error record: "
> >> +                   "Not continuing");
> >> +
> >
> > Instead of checking this flag you should implement and register an nmi
> > handler for this case.
> 
> I think explicit function calls have better readability than notifier chains.

What is different to unknown_nmi() then?

So no, in your case you want to catch unknown nmis for a certain
hardware and then throw a panic. This should be clearly implemented in
a separate handler for this piece of hardware.

We want to cleanup this code and throw out all hardware specific
snippets, and not introduce new special cases here.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

