Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0ELI5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:57:37 -0400
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:43802 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355Ab0ELI5f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:57:35 -0400
Subject: Re: Tracing of power:power_start events doesn't work
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: rostedt@goodmis.org,
       Ronny =?ISO-8859-1?Q?Tsch=FCter?= <Ronny.Tschueter@tu-dresden.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4BE181BD.8010804@linux.intel.com>
References: <4BDECD66.2010906@tu-dresden.de>
	 <1273019517.22438.10.camel@gandalf.stny.rr.com>
	 <4BE17C90.2020205@tu-dresden.de>
	 <1273069881.22438.17.camel@gandalf.stny.rr.com>
	 <4BE181BD.8010804@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 10:57:26 +0200
Message-ID: <1273654646.3598.227.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8BIT
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 05.05.2010, 07:33 -0700 schrieb Arjan van de Ven:
> On 5/5/2010 7:31, Steven Rostedt wrote:
> > On Wed, 2010-05-05 at 16:11 +0200, Ronny Tsch�ter wrote:
> >
> >>    /*
> >>     * Include the apic definitions for x86 to have the APIC timer related
> >> defines
> >> @@ -796,6 +797,18 @@ static int acpi_idle_bm_check(void)
> >>     */
> >>    static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
> >>    {
> >> +    switch (cx->type) {
> >> +    case ACPI_STATE_C1:
> >> +        trace_power_start(POWER_CSTATE, 1);
> >> +        break;
> >> +    case ACPI_STATE_C2:
> >> +        trace_power_start(POWER_CSTATE, 2);
> >> +        break;
> >> +    case ACPI_STATE_C3:
> >> +        trace_power_start(POWER_CSTATE, 3);
> >> +        break;
> >> +    }
> >> +
> >
> > Depending on gcc, the above can bloat the code since each call to
> > trace_power_start() is a macro expanded. Try to call it just once.
> > Perhaps one of the following:
> 
> the code is also incorrect fundamentally.
> You need to pass in the mwait value or equivalent; the ACPI STATE type is
> pretty much useless random garbage and should completely be ignored.

You're correct for your case (switching to c-state via monitor/mwait).
But the current implementation is broken too. It works only if your
kernel uses processor_idle AND monitor/mwait. For all other cases it
fails - may it be on Ronnys system, that uses IO port based C-states or
my system, that uses cpu_idle (not processor_idle).

I'd suggest, that it should work for IO port based switches and could be
included in the syntactic block of that case.
Afaik, halt means that the processor goes to C1. So in this block, there
could be a power_start event too with 1 as new state. (Maybe there are
problems with AMDs C1E which would be reported as C1.)

Robert



> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Robert Schoene
Technische Universitaet Dresden
Zentrum fuer Informationsdienste und Hochleistungsrechnen
01062 Dresden

Tel.: (0351) 463-42483, Fax: (0351) 463-37773
E-Mail: Robert.Schoene@tu-dresden.de

