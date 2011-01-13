Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348Ab1AMVri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:47:38 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41396 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1AMVrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:47:33 -0500
Date: Thu, 13 Jan 2011 22:48:41 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Manoj Iyer <manoj.iyer@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Message-ID: <20110113214841.GC4081@aftab>
References: <AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com>
 <20110113183025.GE2006@aftab>
 <alpine.LFD.2.00.1101131946560.2678@localhost6.localdomain6>
 <20110113185807.GA24720@srcf.ucam.org>
 <20110113190700.GB30866@kryptos.osrc.amd.com>
 <alpine.LFD.2.00.1101132012140.2678@localhost6.localdomain6>
 <20110113192825.GC30866@kryptos.osrc.amd.com>
 <alpine.LFD.2.00.1101132032350.2678@localhost6.localdomain6>
 <20110113210950.GA4081@aftab>
 <alpine.LFD.2.00.1101132210351.2678@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101132210351.2678@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 04:30:43PM -0500, Thomas Gleixner wrote:
> The more interesting info is there in Manoj's logs:
> 
> [    0.036455] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
> [    0.040000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [    0.040000] ...trying to set up timer (IRQ0) through the 8259A ...
> [    0.040000] ..... (found apic 0 pin 0) ...
> [    0.080021] ....... works.
> 
> versus
> 
> [    0.036460] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> 
> So the "working" state is using "apic 0 pin 0" while the non working
> state is using "vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1".
> 
> Something changes across suspend/resume which makes the BIOS
> advertised routing work with PIT but not with HPET. Further why does
> the apic 0/0 solution found by the kernel (when ignoring BIOS) works
> always (except that we don't know whether the "nohpet" case works as
> well, but I bet it does).

Yes, it does. With "nohpet" we use PIT and PIT obviously works.

> So we are back to the question I raised above: What changes and even
> more interesting what changes after the HPET expires - which we know
> for sure that it must happen as otherwise we wont get a HPET interrupt
> after the 32bit wraparound.
> 
> We need answers to these questions before applying any
> patch/workaround/quirk or whatever.

Well, this is easily answered in the theoretical sense, without the
actual details :):

1. HPET gets reinitialized first
2. Something programs it
3. Timer expires but timer IRQ routing is still wrong and "Something"
   doesn't get its IRQ.
4. Timer IRQ routing gets "fixed" as part of the resume path.

... we end up waiting for the counter to wraparound and get an IRQ which
gets delivered this time.

Does that make sense at all?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
