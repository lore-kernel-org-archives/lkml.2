Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0F3Vjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:39:47 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:50856 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944Ab0F3Vjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:39:46 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Chetan Loke <chetanloke@gmail.com>
Subject: Re: [PATCH] VMware balloon: force compiling as a module
Date: Wed, 30 Jun 2010 14:39:44 -0700
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3+; KDE/4.4.4; x86_64; ; )
Cc: "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <AANLkTimmIG6GF-hKBk7JsZpvZNEAj1Tlt4GrPXexN0_0@mail.gmail.com> <201006301227.08709.dtor@vmware.com> <AANLkTil6KfEHhQFwhPHRtb-dZHpDyttY09Kor_FQVFPK@mail.gmail.com>
In-Reply-To: <AANLkTil6KfEHhQFwhPHRtb-dZHpDyttY09Kor_FQVFPK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006301439.44456.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 30, 2010 02:26:40 pm Chetan Loke wrote:
> Hello Dmitry,
> 
> On Wed, Jun 30, 2010 at 3:27 PM, Dmitry Torokhov <dtor@vmware.com> wrote:
> > Hi Chetan,
> > 
> > On Wednesday, June 30, 2010 11:42:53 am Chetan Loke wrote:
> >> Q1)Does vmtools handle pvscsi correctly?
> > 
> > Yes, as long as it compiled as a module or installer will not overwrite
> > distribution-supplied version unless user explicitly requests installer
> > to clobber it.
> 
> perfect.
> 
> > So far distributions have not tried building their kernels with pvscsi
> > or vmxnet3 built-in, but did so with our ballon driver, which prompted
> > this particular change.
> 
> We are building iso's which will then be used to build/create an ESX
> appliance. So we would need the pvscsi driver from the start.

Well, with typical setup, even though pvscsi is a module, as long as it
is in initramfs it will still be loaded automatically. If you are building
truly custom appliance and require pvscsi built-in you'll have to modify
the tools installer script.

> vNICs
> will be populated post-install. At which point vmxnet[2/3] will
> kick-in via vmtools.

Depending on what you base your appliance vmxnet3 might be already in
the kernel along with pvscsi.

> 
> >> Q2)In case if a VM wants to be a good citizen, is there a way for a
> >> guest to know about the balloon-event?
> > 
> > I am not sure I follow. Ballooning supposed to be as transparent as
> > possible...
> 
> This is too product specific. I will send you an email separately.
> 

OK.

> >> Q3)What if an app mlock's its memory resources and driver's have
> >> pinned down their pages then how does inflation work?
> > 
> > We will inflate as much as we can. Obviously if there are no more
> > memory balloon may not grow to its full target size.
> > 
> > Balloon driver communicates to the hypervisor the total amount of
> > memory in the guest, we may want to adjust that number by subtracting
> > memory allocated by the kernel, mlocked memory and so on, but it is
> > not done currently.
> 
> Ok.
> 
> I'm stuck with one question -
> 
> A) Ballooning will trigger guest's native memory management policy.
>    A.1) So this could mean guest might swap it's pages on it's vdisk,
> correct?
>

Yes.
 
> Consider this setup -
> B) VM1..VMn have backing store(data and OS partitions) on LUNs(SAN).
> Further, data LUNs are mounted as RDMs. I chose RDMs just to keep it
> simple.
> C) Say there's memory pressure. How? Well, few VM's are blasting I/O
> to the LUNs. Plus, a backup triggered. Plus, whatever else happened.
>    C.1) VM's now seem to need more and more memory.
>    C.2) hypervisors block-layer/other-layers also need more memory.
>    C.3) Hypervisor's memory-management algorithm kicks-in.
>         ......
>         C.3.x) Ballooning triggers - now some VM's (excluding the ones
> from C.1) are giving up memory and if A.1) above is true then the
> guest's pages will be swapped out on the LUNs via
>                   hypervisor's SCSI-LLDD. But look at C.2) above. Is
> this a soft-deadlock?
>

If there is no memory something will have to give up. If you look at
the ballon driver you will see that when it switches from non-sleeping
to sleeping allocations or otherwise starts getting allocation errors
it will throttle the inflation rates to give the box a "breather" and
not choke it completely right then and there.
 
> Oh, it's a linux-guest and if C.1) timesout then the guest will send
> aborts and eventually a LUN reset ;).
> 
> In this particular case, if my suspicion is valid and if all the
> signatures match(swap is out on the SAN, block-congestion etc) then
> the balloon driver could just bail out.
> 

Yes, it is not guaranteed that ballon will reach this target, and in
this case host itself might start swapping causing severe performance
issues.

Realistically it all boils down to this: even though you may overcommit
you still have to adequately provision your hosts so they could handle
the load.

Thanks.

-- 
Dmitry
