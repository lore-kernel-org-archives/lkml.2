Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0H3Jbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 05:31:33 -0400
Received: from plane.gmane.org ([80.91.229.3]:48627 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836Ab0H3Jbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 05:31:31 -0400
Date: Mon, 30 Aug 2010 11:31:12 +0200
From: Florian Mickler <florian@mickler.org>
To: public-ebiederm-aS9lmoZGLiVWk0Htik3J/w@plane.gmane.org (Eric W.
	Biederman)
Newsgroups: gmane.linux.kernel.kernel-testers,gmane.linux.kernel
Cc: "Rafael J. Wysocki" <public-rjw-KKrjLPT3xs0@plane.gmane.org>,
        Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>,
        Kernel Testers List 
	<public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>,
        Maciej Rutecki 
	<public-maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        "David Hill" <public-hilld-HTiBYHdybX7UkGsOFmftXw@plane.gmane.org>,
        "H. Peter Anvin" <public-hpa-VuQAYsv1563Yd54FQh9/CA@plane.gmane.org>,
        "H. Peter Anvin" <public-hpa-YMNOUZJC4hwAvxtiuMwx3w@plane.gmane.org>
Subject: Re: [Bug #16173] After uncompressing the kernel, at boot time, the
 server hangs.
Message-ID: <20100830113112.29b670c0@schatten.dmk.lab>
In-Reply-To: <m1wrr9asjx.fsf@fess.ebiederm.org>
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
	<ByD_7B96czP.A.vDE.diueMB@chimera>
	<m11v9hc8a1.fsf@fess.ebiederm.org>
	<201008300128.34970.rjw@sisk.pl>
	<m1wrr9asjx.fsf@fess.ebiederm.org>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Aug 2010 16:49:06 -0700
ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
wrote:

> "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org> writes:
> 
> > On Monday, August 30, 2010, Eric W. Biederman wrote:
> >> "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org> writes:
> >> 
> >> > This message has been generated automatically as a part of a report
> >> > of regressions introduced between 2.6.34 and 2.6.35.
> >> >
> >> > The following bug entry is on the current list of known regressions
> >> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> >> > be listed and let the tracking team know (either way).
> >> >
> >> 
> >> Looks like it's fixed.
> >
> > Good.  What mainlne commit is that?
> 
> commit 910081322bf9c4ed392dc8f2ecbc33fdb42a2958
> Author: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> Date:   Wed Aug 4 12:51:11 2010 -0700
> 
>     x86/apic: Map the local apic when parsing the MP table.
>     
>     This fixes a regression in 2.6.35 from 2.6.34, that is
>     present for select models of Intel cpus when people are
>     using an MP table.
>     
>     The commit cf7500c0ea133d66f8449d86392d83f840102632
>     "x86, ioapic: In mpparse use mp_register_ioapic" started
>     calling mp_register_ioapic from MP_ioapic_info.  An extremely
>     simple change that was obviously correct.  Unfortunately
>     mp_register_ioapic did just a little more than the previous
>     hand crafted code and so we gained this call path.
>     
>     The problem call path is:
>     MP_ioapic_info()
>       mp_register_ioapic()
>        io_apic_unique_id()
>          io_apic_get_unique_id()
>            get_physical_broadcast()
>              modern_apic()
>                lapic_get_version()
>                  apic_read(APIC_LVR)
>     
>     Which turned out to be a problem because the local apic
>     was not mapped, at that point, unlike the similar point
>     in the ACPI parsing code.
>     
>     This problem is fixed by mapping the local apic when
>     parsing the mptable as soon as we reasonably can.
>     
>     Looking at the number of places we setup the fixmap for
>     the local apic, I see some serious simplification opportunities.
>     For the moment except for not duplicating the setting up of the
>     fixmap in init_apic_mappings, I have not acted on them.
>     
>     The regression from 2.6.34 is tracked in bug
>     https://bugzilla.kernel.org/show_bug.cgi?id=16173
>     
>     Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>     Reported-by: David Hill <hilld-HTiBYHdybX7UkGsOFmftXw@public.gmane.org>
>     Reported-by: Tvrtko Ursulin <tvrtko.ursulin-j34lQMj1tz/QT0dZR+AlfA@public.gmane.org>
>     Tested-by: Tvrtko Ursulin <tvrtko.ursulin-j34lQMj1tz/QT0dZR+AlfA@public.gmane.org>
>     Signed-off-by: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

Closed, thx.

Guan Xin reported a stable regression from 2.6.35.1->2.6.35.2
in this bugreport which I moved to
https://bugzilla.kernel.org/show_bug.cgi?id=17411 .


Cheers,
Flo

