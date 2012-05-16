Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2EPPr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:47:28 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:58116 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2EPPrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:47:25 -0400
Date: Wed, 16 May 2012 17:47:08 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
Message-ID: <20120516154708.GC2202@aftab.osrc.amd.com>
References: <20120511172430.GB17299@aftab.osrc.amd.com>
 <4FAD5CAD.90508@redhat.com>
 <20120514133404.GE4231@aftab.osrc.amd.com>
 <4FB1163D.3010302@redhat.com>
 <20120515150957.GC27806@aftab.osrc.amd.com>
 <4FB27EDC.8040001@redhat.com>
 <20120515163855.GE27806@aftab.osrc.amd.com>
 <4FB38DDF.7030009@redhat.com>
 <20120516131656.GA2202@aftab.osrc.amd.com>
 <4FB3C4D3.7000802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FB3C4D3.7000802@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 12:16:35PM -0300, Mauro Carvalho Chehab wrote:
> > This doesn't answer my question. My question was: "why can't 'detail'
> > and 'driver_detail' be a single parameter, i.e. 'detail' and this way
> > solve both pretty printing and getting binary data problems?
> 
> This is the 24th version of this very same patch...

This would have been the case if you'd split your patches and sent them
in 10-15 patches sets like normal people, _after_ gathering all review feedback.

But, you wanted to fix EDAC and the whole world while at it and besides,
your patches caused boot errors here and there.

Then, you went and rebased the whole patchset after me reviewing one or
two and incremented for that rebase the version number.

So v24 means nothing to me - you might just as well use it for your
internal tracking.

> In summary: all edac messages provide "detail" as this contains the
> error location in terms of channel/slot. So, any MIB for EDAC could
> handle those parameters properly. With regards to driver_detail, this
> have per-driver details. So, per-driver MIB is required for them, if
> some userspace program wants to properly store that information.
>
> Merging those two separate fields together only makes harder for
> userspace to store the error detail information on their MIB.

There's that MIB crap again.

And it doesn't make it harder for anything because in userspace you can
do everything with those strings, cut them, replace them, whatever your
heart desires, even store the correct error detail information "on their
MIB." Basically, you have one string in userspace and you can massage
the hell out of it and even fit it to the MIB or whatever...

[ … ]

> >>>>>        mcegen.py-2868  [007] .N..   178.261607: mc_event: Corrected error:amd64_edac on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed )
> >>
> >> CE/UE is there. The only change is that, instead of using acronyms, it is now
> >> saying "Corrected error"/"Uncorrected error", as the idea is to provide something
> >> that the user will better understand.
> > 
> > Ok, so let's change the string output from the above version to:
> > 
> >  "mcegen.py-2868  [007] .N..   178.261607: mc_event: amd64_edac: Corrected error on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed)"
> > 
> > I.e., "mc_event" [DRIVER] [ERROR TYPE] [DETAIL].
> 
> As I've explained, there is a consistency issue with the [ERROR MSG]. On the ones
> that properly implement it, [ERROR MSG] is "read error", "spare copy", "bus error", ...
> 
> If you think we need to add an extra field for the driver name, then let's add a
> "driver_name" field there, but a driver's name shouldn't be merged with an
> error type message, as it is abusing the syntax, and the syntax of each field
> should be clear enough to allow it to be stored on a MIB.
> 
> In any case, those drivers that fill the error msg with something else should
> be changes to write there something like "ECC error" instead of "amd64_edac:".
> 
> Btw, I'm almost convinced that we should break the "detail" into its components,
> e. g., instead of one string, it should be:
> 	int layer0, layer1, layer2;		/* Location */
> 	unsigned long memory_address; 		/* or maybe page/offset */
> 	u32 grain;
> 	unsigned syndrome;
> 
> That would be better from MIB point of view.

Dude, enough with this MIB crap already!

Simply move the EDAC_MOD_STR thing earlier in the tracepoint so that you
can get:

"mc_event:" EDAC_MOD_STR [ERROR_TYPE] [DETAIL]

EDAC_MOD_STR is _always_ the driver name:

0 amd64_edac.h      148 #define EDAC_MOD_STR   "amd64_edac"
1 amd76x_edac.c      23 #define EDAC_MOD_STR "amd76x_edac"
2 amd8111_edac.c     37 #define AMD8111_EDAC_MOD_STR "amd8111_edac"
3 amd8131_edac.c     37 #define AMD8131_EDAC_MOD_STR "amd8131_edac"
4 cpc925_edac.c      34 #define CPC925_EDAC_MOD_STR "cpc925_edac"
5 e752x_edac.c       28 #define EDAC_MOD_STR "e752x_edac"
6 e7xxx_edac.c       33 #define EDAC_MOD_STR "e7xxx_edac"
7 i3000_edac.c       21 #define EDAC_MOD_STR  "i3000_edac"
8 i3200_edac.c       22 #define EDAC_MOD_STR        "i3200_edac"
9 i5000_edac.c       31 #define EDAC_MOD_STR      "i5000_edac"
a i5400_edac.c       38 #define EDAC_MOD_STR      "i5400_edac"
b i7300_edac.c       36 #define EDAC_MOD_STR      "i7300_edac"
c i7core_edac.c      65 #define EDAC_MOD_STR      "i7core_edac"
d i82443bxgx_edac.c  36 #define EDAC_MOD_STR    "i82443bxgx_edac"
e i82860_edac.c      20 #define EDAC_MOD_STR "i82860_edac"
f i82875p_edac.c     24 #define EDAC_MOD_STR  "i82875p_edac"
g i82975x_edac.c     20 #define EDAC_MOD_STR  "i82975x_edac"
h mpc85xx_edac.h     15 #define EDAC_MOD_STR "MPC85xx_edac"
i mv64x60_edac.h     16 #define EDAC_MOD_STR "MV64x60_edac"
j r82600_edac.c      26 #define EDAC_MOD_STR "r82600_edac"
k sb_edac.c          38 #define EDAC_MOD_STR      "sbridge_edac"
l x38_edac.c         21 #define EDAC_MOD_STR  "x38_edac"

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
