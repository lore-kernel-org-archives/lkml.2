Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3ADOFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 09:05:20 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21558 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3ADOFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 09:05:18 -0500
Date: Fri, 4 Jan 2013 15:04:26 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: ebiederm@xmission.com
Cc: kexec@lists.infradead.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, tglx@linutronix.de, maxim.uvarov@oracle.com,
        andrew.cooper3@citrix.com, hpa@zytor.com, jbeulich@suse.com,
        mingo@redhat.com, x86@kernel.org,
        virtualization@lists.linux-foundation.org, vgoyal@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/11] kexec: introduce kexec firmware support
Message-ID: <20130104140122.GA3346@host-192-168-1-59.local.net-space.pl>
References: <2f3acfe3-c608-43d8-b76a-6ba69a872692@default>
 <874nj6ooyi.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nj6ooyi.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 07:06:13PM -0800, ebiederm@xmission.com wrote:
> Daniel Kiper <daniel.kiper@oracle.com> writes:
>
> >> Daniel Kiper <daniel.kiper@oracle.com> writes:
> >>
> >> > Some kexec/kdump implementations (e.g. Xen PVOPS) could not use default
> >> > Linux infrastructure and require some support from firmware and/or hypervisor.
> >> > To cope with that problem kexec firmware infrastructure was introduced.
> >> > It allows a developer to use all kexec/kdump features of given firmware
> >> > or hypervisor.
> >>
> >> As this stands this patch is wrong.
> >>
> >> You need to pass an additional flag from userspace through /sbin/kexec
> >> that says load the kexec image in the firmware.  A global variable here
> >> is not ok.
> >>
> >> As I understand it you are loading a kexec on xen panic image.  Which
> >> is semantically different from a kexec on linux panic image.  It is not
> >> ok to do have a silly global variable kexec_use_firmware.
> >
> > Earlier we agreed that /sbin/kexec should call kexec syscall with
> > special flag. However, during work on Xen kexec/kdump v3 patch
> > I stated that this is insufficient because e.g. crash_kexec()
> > should execute different code in case of use of firmware support too.
>
> That implies you have the wrong model of userspace.
>
> Very simply there is:
> linux kexec pass through to xen kexec.
>
> And
> linux kexec (ultimately pv kexec because the pv machine is a slightly
> different architecture).

As I understand in Xen dom0 kexec/kdump case machine_kexec() should call
stub which should call relevant hypercall to initiate kexec/kdump in
Xen itself. Right?

> > Sadly syscall does not save this flag anywhere.
>
> > Additionally, I stated
> > that kernel itself has the best knowledge which code path should be
> > used (firmware or plain Linux). If this decision will be left to userspace
> > then simple kexec syscall could crash system at worst case (e.g. when
> > plain Linux kexec will be used in case when firmware kaxec should be
> > used).
>
> And that path selection bit is strongly non-sense.  You are advocating
> hardcoding unnecessary policy in the kernel.
>
> If for dom0 you need crash_kexec to do something different from domU
> you should be able to load a small piece of code via kexec that makes
> the hypervisor calls you need.
>
> > However, if you wish I could add this flag to syscall.
>
> I do wish.  We need to distinguish between the kexec firmware pass
> through, and normal kexec.

OK.

> > Additionally, I could
> > add function which enables firmware support and then kexec_use_firmware
> > variable will be global only in kexec.c module.
>
> No.  kexec_use_firmware is the wrong mental model.
>
> Do not mix the kexec pass through and the normal kexec case.
>
> We most definitely need to call different code in the kexec firmware
> pass through case.
>
> For normal kexec we just need to use a paravirt aware version of
> machine_kexec and machine_kexec_shutdown.

OK, but this solves problem in crash_kexec() only. However, kernel_kexec()
still calls machine_shutdown() which breaks kexec on Xen dom0 (to be precise
it shutdown machine via hypercall). Should I add machine_kexec_shutdown()
(like machine_crash_shutdown()) which would call, let's say,
machine_ops.kexec_shutdown()?

Additionally, crash_shrink_memory() does not make sens in Xen dom0 case.
How do you wish disable it if kexec_use_firmware is the wrong mental model?

> >> Furthermore it is not ok to have a conditional
> >> code outside of header files.
> >
> > I agree but how to dispatch execution e.g. in crash_kexec()
> > if we would like (I suppose) compile kexec firmware
> > support conditionally?
>
> The classic pattern is to have the #ifdefs in the header and have an
> noop function that is inlined when the functionality is compiled out.
> This allows all of the logic to always be compiled.

OK.

Daniel
