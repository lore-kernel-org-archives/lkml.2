Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab1AMTmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:42:10 -0500
Received: from www.tglx.de ([62.245.132.106]:43208 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629Ab1AMTmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:42:08 -0500
Date: Thu, 13 Jan 2011 20:41:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@amd64.org>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Manoj Iyer <manoj.iyer@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
In-Reply-To: <20110113192825.GC30866@kryptos.osrc.amd.com>
Message-ID: <alpine.LFD.2.00.1101132032350.2678@localhost6.localdomain6>
References: <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6> <20110113172205.GA30866@kryptos.osrc.amd.com> <AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com> <20110113175531.GD2006@aftab> <AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com>
 <20110113183025.GE2006@aftab> <alpine.LFD.2.00.1101131946560.2678@localhost6.localdomain6> <20110113185807.GA24720@srcf.ucam.org> <20110113190700.GB30866@kryptos.osrc.amd.com> <alpine.LFD.2.00.1101132012140.2678@localhost6.localdomain6>
 <20110113192825.GC30866@kryptos.osrc.amd.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Borislav Petkov wrote:

> On Thu, Jan 13, 2011 at 08:13:42PM +0100, Thomas Gleixner wrote:
> > > Well, Andreas did boot with 'hpet=verbose' on an affected machine here
> > > and did a suspend/resume and the hpet config registers looked ok before
> > > suspend and after resume. It might be that the HPET is temporarily
> > > "insane" while resume lasts but we don't have any hard facts confirming
> > 
> > And you have no explanation at all why applying the irq pin routing
> > quirk makes HPETs temporal insanity go away magically :)
> 
> But after the HPET counter wraps around, the machine is alive again.
> Which means that the IRQ0 pin2 override is only temporarily needed after
> resume... Strange.

Thinking more about it:

Case 1:	IRQ0 pin2 override applied

     Resume hangs until HPET wraps around and issues another interrupt

Case 2: IRQ0 pin2 override ignored via quirk

     Resume just works

So the question is what is restored _AFTER_ the HPET is reprogrammed
in the resume path ?

The HPET reprogramming happens via timekeeping_resume() which is in
the sysdev part of resume. ioapic, apic, iommus etc. are also resumed
via the sysdev_class. So what makes sure that the ordering of these is
correct?

AFAICT nothing :)

We need information about the resume order of sysdev_class and the
difference of the pin routings in the quirk non/quirk case.

Thanks,

	tglx
