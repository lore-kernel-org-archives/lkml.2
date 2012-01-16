Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab2APRVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 12:21:14 -0500
Received: from mx2.gd-ms.com ([153.11.250.41]:46115 "EHLO mx2.gd-ms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab2APRVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 12:21:13 -0500
In-Reply-To: <OF8925048E.BDB4D255-ON85257987.005AFEB7-85257987.005C9188@LocalDomain>
References: <OFE7865F25.43E4BFD2-ON85257984.0057CD12-85257984.0058D31D@gdeb.com> <20120116075348.GF15641@elte.hu> <OF8925048E.BDB4D255-ON85257987.005AFEB7-85257987.005C9188@LocalDomain>
To: Michael D Labriola <mlabriol@gdeb.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Kushal Koolwal <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org,
        michael.d.labriola@gmail.com, Matthew Garrett <mjg@redhat.com>,
        support@versalogic.com, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
MIME-Version: 1.0
Subject: Re: Reboot hangs on VersaLogic Ocelot
X-KeepSent: FD8ED65D:E1B7CD3D-85257987:005EE0A9;
 type=4; name=$KeepSent
Message-ID: <OFFD8ED65D.E1B7CD3D-ON85257987.005EE0A9-85257987.005F48CD@gdeb.com>
From: Michael D Labriola <mlabriol@gdeb.com>
Date: Mon, 16 Jan 2012 12:20:45 -0500
X-GDMEncrypt: FALSE
X-GDMMarking: NOT_SENSITIVE
Content-Type: text/plain; charset="US-ASCII"
X-GDM-MESSAGE-ID: X-GDM-MESSAGE-ID mx2.gd-ms.com 1RmqEq-00082l-RX
X-GDM-EVAL: score: /30; hits: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael D Labriola/EB/GDYN wrote on 01/16/2012 11:51:05 AM:

> From: Michael D Labriola/EB/GDYN
> To: Ingo Molnar <mingo@elte.hu>
> Cc: "H. Peter Anvin" <hpa@zytor.com>, Kushal Koolwal 
> <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org, 
> michael.d.labriola@gmail.com, Ingo Molnar <mingo@redhat.com>, 
> Matthew Garrett <mjg@redhat.com>, support@versalogic.com, Thomas 
> Gleixner <tglx@linutronix.de>, x86@kernel.org
> Date: 01/16/2012 11:51 AM
> Subject: Re: Reboot hangs on VersaLogic Ocelot
> 
> Ingo Molnar <mingo@elte.hu> wrote on 01/16/2012 02:53:48 AM:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > To: Michael D Labriola <mlabriol@gdeb.com>, Matthew Garrett 
<mjg@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar 
> > <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, 
> > x86@kernel.org, linux-kernel@vger.kernel.org, Kushal Koolwal 
> > <kushalkoolwal@gmail.com>, support@versalogic.com, 
> > michael.d.labriola@gmail.com
> > Date: 01/16/2012 02:54 AM
> > Subject: Re: Reboot hangs on VersaLogic Ocelot
> > 
> > 
> > (Cc:-ed Matthew Garrett)
> > 
> > * Michael D Labriola <mlabriol@gdeb.com> wrote:
> > 
> > > I've been troubleshooting a VersaLogic Ocelot SBC that's been 
> > > hanging on reboot ever since I upgraded its BIOS.  The 
> > > conclusion I've come to is that commit e19e074 (x86: Fix 
> > > reboot problem on VersaLogic Menlow boards) needs to be 
> > > reverted.
> > >
> > > My system was rebooting fine (kernel v3.2) prior to upgrading 
> > > the BIOS, but it turns out that the DMI string being looked 
> > > for in the VersaLogic reboot quirk wasn't added until I 
> > > upgraded the BIOS.
> > > 
> > > Here's a summary of the behavior I encountered on my system 
> > > (VL-EPMs-21a rev 1.00 w/ BIOS 6.5.102)
> > > 
> > > - v2.6.37 reboot=bios is needed
> > > 
> > > - v2.6.38-rc1: behavior changed, reboot=acpi is needed, reboot=kbd 
and
> > >   reboot=bios result in system hang.
> > > 
> > > - v2.6.38: VersaLogic patch (e19e074 x86: Fix reboot problem on
> > >   VersaLogic Menlow boards) was applied prior to v2.6.38-rc7.  This
> > >   patch sets a quirk for VersaLogic Menlow boards that forces the 
use
> > >   of reboot=bios, which doesn't work anymore.  As far as I can tell,
> > >   there's no way to override this faulty quirk, as it seems to take
> > >   precedence over the reboot= argument.
> > 
> > That's another bug i'd argue - the user specifying something on 
> > the boot command line should *always* override the kernel's 
> > built-in defaults.

> Agreed.  This would have taken me about 5 mins to troubleshoot if 
> I'd realized up front that passing reboot= args on command line was 
> being overridden by this quirk.  The obvious first thing to do was 
> try all the available options... none of which had any effect.  I've
> got a patch to change this behavior as well (DMI scanning for quirks
> *only* happens if user didn't pass a reboot= option on the command 
line).
> 
> > > - v3.2: It seems that commit 660e34c (x86: Reorder reboot method
> > >   preferences) changed the default reboot method to acpi prior to
> > >   v3.0-rc1, which means the default behavior is appropriate for the
> > >   Ocelot.  After reverting commit e19e074, my system reboots 
perfectly
> > >   w/out passing any reboot= arguments.  I confirmed that this is a
> > >   true statement for all 3 versions of the Ocelot's BIOS.
> > 
> > And this works for the older BIOS version as well, the one which 
> > motivated commit e19e074?

> Versions of the BIOS prior to 6.5.102 set the DMI information to 
> something the quirk wasn't looking for, so that's actually the only 
> applicable BIOS rev.  Older versions can all be rebooted by passing 
> reboot=whatever_worked_in_that_version.
> 
> > Please send a patch that removes the quirk (not named a revert - 
> > as technically the old quirk did solve problems), with the 
> > changelog containing your (excellent) bug analysis and the test 
> > coverage above, plus a signoff?

> Will do, hopefully this afternoon.
> 
> > Matthew, do you concur? Looks like your reordering changes 
> > actively improved the default behavior and we can start removing 
> > quirks.
> > 
> > Thanks,
> > 
> >    Ingo
> 

Actually, assuming we fix the bios= argument ignored by DMI scan problem, 
would it be better to change the VersaLogic quirk to acpi even though it's 
not necessary right now?  If the default reboot method ever switches from 
acpi to kbd or bios, these boards will hang on reboot again...

---
Michael D Labriola
Electric Boat
mlabriol@gdeb.com
401-848-8871 (desk)
401-848-8513 (lab)
401-316-9844 (cell)




 


