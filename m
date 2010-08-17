Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762809Ab0HQS4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:56:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34833 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650Ab0HQS4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:56:39 -0400
Date: Tue, 17 Aug 2010 20:56:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alok Kataria <akataria@vmware.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "borislav.petkov@amd.com" <borislav.petkov@amd.com>
Subject: Re: [Patch] Skip cpu_calibrate for kernel running under
 hypervisors.
Message-ID: <20100817185634.GA10597@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alok Kataria <akataria@vmware.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
	"greg@kroah.com" <greg@kroah.com>,
	"ksrinivasan@novell.com" <ksrinivasan@novell.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"borislav.petkov@amd.com" <borislav.petkov@amd.com>
References: <1281986754.23253.32.camel@ank32.eng.vmware.com>
 <4C69D02F.6090601@zytor.com>
 <1282024311.20786.2.camel@ank32.eng.vmware.com>
 <4C6A2C98.4060605@zytor.com>
 <20100817070520.GD32714@liondog.tnic>
 <1282063532.4388.8.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1282063532.4388.8.camel@ank32.eng.vmware.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alok Kataria <akataria@vmware.com>
Date: Tue, Aug 17, 2010 at 09:45:32AM -0700

Hi Alok,

> > > I know it was... and calibrate_cpu() seems to be an AMD-specific
> > > function, but that's rather crappy.  I'm thinking that perhaps we should
> > > make it an x86_init function, then the AMD CPU detection can install it
> > > and the vmware hypervisor detection can uninstall it.
> > 
> > Btw, can we revisit this AMD-specific issue? IIUC, Alok you're seeing
> > a mismatch between the calibrated TSC value and the cpu frequency even
> > on cpus which have the CONSTANT_TSC bit set, i.e. their TSC is counting
> > with P0 frequency. Can you please elaborate more on what systems you're
> > seeing this (cpu family, chipset, etc)?
> 
> We have seen these issues when running inside a Virtual Machine on
> VMware's platform. Please look at the vmware_set_cpu_features function,
> it relies on the hypervisor to provide a constant/reliable TSC. Though
> still when running the kernel on virtual cpus, as compared to
> running on physical cpus, the timing characteristics are different,
> since virtual cpus have to time share physical cpus with each other,
> which may result in errors during calibration. As a result its better to
> get these values directly from the hypervisor rather than trying to
> calibrate them.

Thanks for clarifying this. I kinda stumbled over "AMD hardware" in your
previous email but now its perfectly clear.

> And just to clarify, we have never seen this on a physical machine.

Anyway, your patch got me looking into the code and currently we do
calibrate_cpu() on all AMD systems with invariant TSC. However, machines
starting with F10h revB have a setting in MSRC001_0015[24] which, when
set, denotes that the TSC counts with P0 frequency and thus equals the
core frequency. So for those machines we won't need to calibrate the cpu
frequency. I'm figuring out some additional details internally and will
be sending a fix soon.

Thanks.

-- 
Regards/Gruss,
    Boris.
