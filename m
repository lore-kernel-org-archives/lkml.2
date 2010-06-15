Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab0FOKAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:00:30 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45622 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab0FOKA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:00:28 -0400
Date: Tue, 15 Jun 2010 12:01:17 +0200
From: Borislav Petkov <bp@amd64.org>
To: Nils Carlson <nils.carlson@ludd.ltu.se>
Cc: Andi Kleen <andi@firstfloor.org>, Doug Thompson <norsk5@yahoo.com>,
       Tony Luck <tony.luck@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       BrentYoung <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Nils Carlson <nils.carlson@ericsson.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100615100117.GA17953@aftab>
References: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com>
 <35525.41387.qm@web50105.mail.re2.yahoo.com>
 <20100615065630.GC6727@basil.fritz.box>
 <Pine.GSO.4.58.1006150951150.17579@dexter.ludd.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.58.1006150951150.17579@dexter.ludd.ltu.se>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Alberto_Bozzo=2C_Andrew_Bowd=2C_Sitz=3A?=
	=?iso-8859-1?Q?_Dornach=2C_Gemeinde_Aschheim=2C_Landkreis_M=FCnchen=2C_Re?=
	=?iso-8859-1?Q?gistergericht_M=FCnchen=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nils Carlson <nils.carlson@ludd.ltu.se>
Date: Tue, Jun 15, 2010 at 04:06:33AM -0400

> On Tue, 15 Jun 2010, Andi Kleen wrote:
> 
> > On Mon, Jun 14, 2010 at 04:46:40PM -0700, Doug Thompson wrote:
> >
> > Hi Doug,
> >
> > >
> > > Maybe I didn't see it covered (or I missed it), but EDAC is used on more than just x86 based machines, though they are the majority by volume. We should have an abstraction that covers all the archs, like we do with other subsystems of Linux.
> >
> > The way I envision it to working is that a abstracted dimm interface
> > (or edac2 or whatever you want to call it) can be fed from any reasonable
> > DIMM layout driver. This could be either DMI on x86 or some other
> > driver. There would be nothing really x86 specific about that.
> 
> Could you maybe provide some references on how DIMM layout
> could be read from DMI? I can't find anything nearly this specific,
> or is it something we're expecting to happen in future BIOS's?
> 
> Also, there would probably need to be some standard describing
> different DIMM layouts in general, though maybe such a thing exists.
> 
> In other words, there would be have to be some way of ascertaining
> that the info you read from DMI is sufficient to decode MCEs so that
> a faulting DIMM can be identified. In an ideal world, this could
> be tested by some simple tool that could be run by the BIOS writers
> to test that they're providing the OS with sufficient info.

You cannot decode an ECC to a DIMM only using DMI info - at least on AMD
you cannot. The MCE contains the physical address where the ECC happened
and you need EDAC to convert this to a chip select row. Additionally,
you need the error syndrome depending on the dram controllers addressing
mode used.

Now, after you have the chip select row, you need to map this to a DIMM
rank and in order to do that, you need the DIMM info which is in the
SPD ROM (one of the data in the SPD is the DIMM rank which is needed
to unambiguously pinpoint which DIMM is generating those errors). Then
you can use the DMI info - assuming it contains the correct silk screen
labels on the motherboard - to map to a DIMM.

What currently EDAC does is decode the ECC to a chip select - what we
need is some I2C/SMBus code which can read the SPD ROM. I haven't had
the time to look into it yet, though.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
