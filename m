Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab0D0H0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 03:26:54 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:33634 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab0D0H0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 03:26:53 -0400
Date: Tue, 27 Apr 2010 03:26:34 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Philip Langdale <philipl@overt.org>
Cc: Jeff Garrett <jeff@jgarrett.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
In-reply-to: <20100426194002.586fbaa5@fido5>
Message-id: <alpine.LFD.2.00.1004270319560.3999@localhost.localdomain>
References: <20100126084740.GA5265@jgarrett.org>
 <87y6jkee1b.fsf@basil.nowhere.org> <20100205160900.GA2736@jgarrett.org>
 <alpine.LFD.2.00.1002051238280.4050@localhost.localdomain>
 <20100426194002.586fbaa5@fido5>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 26 Apr 2010, Philip Langdale wrote:

> On Fri, 05 Feb 2010 12:45:21 -0500 (EST)
> Len Brown <lenb@kernel.org> wrote:
> 
> > Jeff,
> > What do you see if you apply just the patch below?
> > 
> > Also, in addition to "powertop -d" to show what the kernel requests,
> > please run turbostat to show what the hardware actually did:
> > 
> > http://userweb.kernel.org/~lenb/acpi/utils/pmtools-latest/turbostat/turbostat.c
> > 
> > eg.
> > # turbostat -d -v sleep 5
> > 
> > thanks,
> > -Len Brown, Intel Open Source Technology Center
> > ---
> 
> To resurrect this thread...
> 
> I have a giga-byte GA-P55M-UD4 motherboard and I have this same problem
> as well. Len's patch "works" in that I see C6 being used, but it also
> cripples the system - if I do a make -j16 kernel build, I see most jobs
> serialized onto one or two cores. Without the patch, I see the
> full utilization of all 8 hyper-threads as expected.

Curious failure.
I could imagine that there is something in the design of this board
where we want to not enter a deep C-state, and thus the board and
Linux are doing the right thing by avoiding the C-state.
However, ignoring the bm-status check and blindly going to that state
I would expect to impact throughput and latency, but don't see
how that might 'serialize' the workload or otherwise cause it
to use some cores and not others.

It is possible that we jump into those deep states just to be
immediately forced to jump right back out.  You'd see this in
high usage counts under /sys/devices/system/cpu/cpu*/cpuidle

turbostat, of course, would tell you the actual residency in those states.
Of course there is a twist...  The hardware has a feature to recognize
thrashing and may demote an OS request for a deep state into
an actual hardware request for a shallower state.  this is one reason
that the output of powertop (request) and turbostat (result)
may be different.

cheers,
-Len


> Now, gigabyte have already b0rked these boards up by using the UHCI
> controllers on the PCH instead of the rate matching hubs. Maybe that's
> directly the cause of BM activity - maybe they screwed something else
> up - is it possible for BIOS/ACPI mistakes to lead to this behaviour?
>
> Jeff - is your board gigabyte too?
> 
> --phil
> 
> > diff --git a/drivers/acpi/processor_idle.c
> > b/drivers/acpi/processor_idle.c index 7c0441f..f528625 100644
> > --- a/drivers/acpi/processor_idle.c
> > +++ b/drivers/acpi/processor_idle.c
> > @@ -763,7 +763,7 @@ static const struct file_operations
> > acpi_processor_power_fops = { static int acpi_idle_bm_check(void)
> >  {
> >  	u32 bm_status = 0;
> > -
> > +return bm_status;
> >  	acpi_read_bit_register(ACPI_BITREG_BUS_MASTER_STATUS,
> > &bm_status); if (bm_status)
> >  		acpi_write_bit_register(ACPI_BITREG_BUS_MASTER_STATUS,
> > 1);
> > 
