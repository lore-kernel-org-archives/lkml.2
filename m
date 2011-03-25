Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1CYONa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:13:30 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:48826 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab1CYON2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:13:28 -0400
Date: Fri, 25 Mar 2011 15:13:22 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly
 Report Mechanism (HARM)
Message-ID: <20110325141322.GB28313@gere.osrc.amd.com>
References: <cover.1300996141.git.mchehab@redhat.com>
 <20110324173257.36680b90@pedra>
 <20110324223907.GA10498@liondog.tnic>
 <4D8C6C80.8010600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8C6C80.8010600@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 07:20:48AM -0300, Mauro Carvalho Chehab wrote:

[..]

> > I think this is too fine-grained. You see, all those error records are
> > of type MCE so there's no need to have a trace event for corrected,
> > uncorrected, out of range etc. error types. You basically add a
> > flags argument to the trace_mce_record() tracepoint so that you can
> > differentiate between the different error records in the tracebuffer.
> > Then, you add additional fields like above for the MCEs which report a
> > DRAM ECC error.
> > 
> > IOW, what we need are two basic error records (tracepoints, etc.): MCEs
> > and PCI(e) errors which are derived from the hw_event_class.
> >
> > Btw, I've played with the MCE tracepoint extension a bit and it looks
> > doable: http://lkml.org/lkml/2010/5/15/40.
> > 
> 
> As discussed on LPC, those are some requirements for the subsystem:
> 
> *) Architecture independent (both power and arm are potentially interested)

I knew you'll play the arch-independent card :)

I don't know how well a single hw event would fit all architectures
though, since I don't know what error formats the others require.

We could make the hw_event different on every arch but use a superset of
arguments which we can wrap with a macro that picks up only the relevant
args on each arch.

> *) Report errors against human readable labels (e.g. using motherboard
>    labels to identify DIMM or PCI slots).  This is hard (will often need
>    some platform-specific mapping table to provide, or override, detailed
>    information).

That doesn't have anything to do with the hw event - a DRAM CE/UE error
is a MCE with certain bits set. You can have an additional field in the
MCE TP:

		__field(	const char *,	label			)

> *) General interface available for any kind of h/w error report (e.g.
>    device driver might use it for board level problems, or IPMI might
>    report fan speed problems or over-temperature events).

Those can be another tracepoint.

> *) Useful to make it easy to adapt existing EDAC drivers, machine-check
>    bank decoders and other existing error reporters to use this new
>    mechanism.
> 
> *) Robust - should not lose error information.  If the platform provides
>    some sort of persistent storage, should make use of it to preserve
>    details for fatal errors across reboot.  But may need some threshold
>    mechanism that copes with floods of errors from a failed object.

This can be done in userspace - a logging daemon which flushes the trace
buffers so that there's more room for new errors.

> *) Flexible: Errors may be discovered by polling, or reported by some
>    interrupt/exception

Although we should try to avoid polling as much as possible.

> People at the audience also commented that there are some other parts of the
> Kernel that produce hardware errors and may also be interesting to map them
> via perf, so grouping them together into just two types may not fit.
> 
> Also, as we want to have errors generated even for uncorrected errors that
> can be fatal, and the report system should provide user-friendly error
> reports, just printing a MCE code (and the MCE-specific data) is not enough:
> the error should be parsed on kernel to avoid loosing fatal errors.

This is already the case on AMD - we decode those. However, there's
another issue with fatal errors - you want to execute as less code as
possible in the wake of a fatal error. There are situations where an
MCE exception doesn't even call the MCE handler but simply stops the
machine completely. For such cases, persistent storage is our safest
bet. However, we still don't have a solution for clients like laptops
and desktops with no RAS features. We need to think about those too,
especially for debugging kernel oopses, suspend/resume, etc.

> Maybe the way I mapped is too fine-grained, and we may want to group some
> events together, but, on the other hand, having more events allow users
> to filter some events that may not be relevant to them. For example, some
> systems with i7300 memory controller, under certain circumstances (it seems
> to be related to a bug at BIOS quick boot implementation), don't properly 
> initialize the memory controller registers. The net result is that, on every 
> one second (the poll interval of the edac driver), a false error report is 
> produced. Having events fine-grained, users can just change the perf filter 
> to discard the false alarms, but keeping the other hardware errors enabled.
>  
> In the specific case of MCE errors, I think we should create a new
> hw_event pair that will provide the decoded info and the raw MCE info, on
> a format like:
> 
> 	Corrected Error %s at label "%s" (CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: % x)
> 	Uncorrected Error %s at label "%s" (CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: % x)

Why like this? This is the same tracepoint with almost all fields
repeated except a small difference which can be expressed with a single
bit: Corrected vs Uncorrected error.

> This way, the info that it is relevant to the system admin is clearly pointed
> (error type and label), while hardware vendors may use the MCE data to better
> analyse the issue.

So it all sounds like we need simply to expand the MCE tracepoint with
DIMM-related information and wrap it in an arch-agnostic macro in the
EDAC code. Other arches will hide their error sources behind it too
depending on how they read those errors from the hardware.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
