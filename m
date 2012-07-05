Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2GEKhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:37:55 -0400
Received: from ozlabs.org ([203.10.76.45]:50325 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289Ab2GEKhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:37:53 -0400
From: Michael Neuling <mikey@neuling.org>
To: Kay Sievers <kay@vrfy.org>
cc: linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
In-reply-to: <CAPXgP13u769nSvUdS1iqiVCsxG5nsQd7bNT1=-eNw156U-kPkQ@mail.gmail.com>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com> <20120625150722.8cd4f45d.akpm@linux-foundation.org> <20120625235531.GB3652@kroah.com> <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com> <20120626002307.GA4389@kroah.com> <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com> <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com> <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com> <1340726856.977.6.camel@mop> <22482.1341471787@neuling.org> <CAPXgP11=o5WB4WejaQCSCL-+5e4sL7tfVz_r3Khyrq3SyrMvsA@mail.gmail.com> <CAPXgP13u769nSvUdS1iqiVCsxG5nsQd7bNT1=-eNw156U-kPkQ@mail.gmail.com>
Comments: In-reply-to Kay Sievers <kay@vrfy.org>
   message dated "Thu, 05 Jul 2012 10:53:56 +0200."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Thu, 05 Jul 2012 20:20:25 +1000
Message-ID: <16043.1341483625@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay@vrfy.org> wrote:

> On Thu, Jul 5, 2012 at 10:39 AM, Kay Sievers <kay@vrfy.org> wrote:
> > On Thu, Jul 5, 2012 at 9:03 AM, Michael Neuling <mikey@neuling.org> wrote:
> >>> On Mon, 2012-06-25 at 18:40 -0700, Linus Torvalds wrote:
> >
> >>> > I think it might be a great idea to buffer for logging in order to
> >>> > generate one individual buffer record there.
> >>> >
> >>> > But it needs to be printed as it is generated.
> >>>
> >>> That's a good idea.
> >>>
> >>> Something like this could work - only minimally tested at this moment.
> >>
> >> This breaks some powerpc configs and is in Linus' tree now as
> >> 084681d14e.
> >>
> >> When we have printks without a newline (like show_regs()), it
> >> sometimes:
> >
> > x86 has that a lot too.
> >
> >> 1) drops the console output for that line (dmesg is fine).  Patch to fix
> >>    this below.
> >
> > That doesn't look right. We should already have put that out to the
> > console, and we only want to store it away. Your patch, as expected,
> > duplicates all the continuation lines on the console here:
> > [    0.674957] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> > [    0.674957] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> >
> >> 2) adds a newline unnecessary to both console and dmesg.  I have no fix
> >>    for this currently.
> >> Reverting this patch fixes both problems.
> >
> > Not here. I can't reproduce any of this here, it all looks fine.
> >
> > Is that possibly some early printk() or other console trickery on ppc
> > that produces the issue?
> 
> Or, are you really sure this isn't just a race with another printk and
> the content got merged with some other line of the output? The added
> newline you mention could suggest that.

I can make 1) happen on UP or SMP.

I can only make 2) happen on SMP.  It's when the second CPU is coming up
and it's printing something.  The first CPU isn't printing anything at
this stage (there is no garbled console here) so I don't think it's a
race.  I see it consistently in show_regs().  Every printk without a
newline.  ie I get this:
---
NIP: c000000000048164 LR: c000000000048160 CTR: 0000000000000000
REGS: c00000007e59fb50 TRAP: 0700   Tainted: G        W     (3.5.0-rc5-mikey)
MSR: 9000000000021032 
<
SF
,HV
,ME
,IR
,DR
,RI
>
  CR: 28000042  XER: 22000000
SOFTE: 0
CFAR: c0000000007402f8
TASK = c00000007e56bb40[0] 'swapper/1' THREAD: c00000007e59c000
 CPU: 1
---

It's consistent for printks without newlines in show_regs().  MSR
through to XER should all be on the same line.

Mikey

> With the buffering for the console output removed, I see garbled
> console output here too (like we always had before the new kmsg) when
> continuation printks race against printks from any other process. That
> was all gone with the buffering (only two continuation prints would
> race, not any other), but we needed to skip buffering the console
> output for other, more important reasons.
