Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005Ab1IINa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:30:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758781Ab1IINa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:30:27 -0400
Date: Fri, 9 Sep 2011 10:29:55 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: emunson@mgebm.net
Cc: Anthony Liguori <anthony@codemonkey.ws>, avi@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm-ppc@vger.kernel.org,
        aliguori@us.ibm.com, raharper@us.ibm.com, kvm-ia64@vger.kernel.org,
        Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 0/4] Avoid soft lockup message when KVM is stopped by host
Message-ID: <20110909132955.GA19459@amt.cnet>
References: <1314660435-23293-1-git-send-email-emunson@mgebm.net>
 <20110830122630.GA19450@amt.cnet>
 <4E5FDBDC.2030302@codemonkey.ws>
 <6c387b0ab0b091253c1a1488dd625b94@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c387b0ab0b091253c1a1488dd625b94@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 02:27:49PM -0600, emunson@mgebm.net wrote:
> On Thu, 01 Sep 2011 14:24:12 -0500, Anthony Liguori wrote:
> >On 08/30/2011 07:26 AM, Marcelo Tosatti wrote:
> >>On Mon, Aug 29, 2011 at 05:27:11PM -0600, Eric B Munson wrote:
> >>>Currently, when qemu stops a guest kernel that guest will
> >>>issue a soft lockup
> >>>message when it resumes.  This set provides the ability for
> >>>qemu to comminucate
> >>>to the guest that it has been stopped.  When the guest hits
> >>>the watchdog on
> >>>resume it will check if it was suspended before issuing the
> >>>warning.
> >>>
> >>>Eric B Munson (4):
> >>>   Add flag to indicate that a vm was stopped by the host
> >>>   Add functions to check if the host has stopped the vm
> >>>   Add generic stubs for kvm stop check functions
> >>>   Add check for suspended vm in softlockup detector
> >>>
> >>>  arch/x86/include/asm/pvclock-abi.h |    1 +
> >>>  arch/x86/include/asm/pvclock.h     |    2 ++
> >>>  arch/x86/kernel/kvmclock.c         |   14 ++++++++++++++
> >>>  include/asm-generic/pvclock.h      |   14 ++++++++++++++
> >>>  kernel/watchdog.c                  |   12 ++++++++++++
> >>>  5 files changed, 43 insertions(+), 0 deletions(-)
> >>>  create mode 100644 include/asm-generic/pvclock.h
> >>>
> >>>--
> >>>1.7.4.1
> >>
> >>How is the host supposed to set this flag?
> >>
> >>As mentioned previously, if you save save/restore the offset
> >>added to
> >>kvmclock on stop/cont (and the TSC MSR, forgot to mention that), no
> >>paravirt infrastructure is required. Which means the issue is
> >>also fixed
> >>for older guests.
> >
> >IIRC, the steal time patches have some logic that basically say:
> >
> >if there was steal time:
> >   kick soft lockup detector
> >
> >I wonder if that serves this purpose provided that time spent in stop
> >is accounted as steal time.  If it isn't, perhaps it should be?

Accounting "in userspace (qemu)" as stolen time is problematic. Think
irqchip in userspace (halt emulation), excessive time spent in device
emulation that would trigger genuine watchdog warnings.

The latest patches from Glauber dropped this logic.


> >
> >Regards,
> >
> >Anthony Liguori
> >
> 
> I could be missing it, but I don't see anywhere in the steal time
> patches that kicks the watchdog.
> 
> Accounting stopped time as stolen time opens a possible problem when
> the accounting (CPU power modification) part is turned on.  As a
> process accumulates steal time its CPU power is increased.  If we
> account stopped time as stolen, it will do strange things with CPU
> power for that process.  I believe that it is for this reason that
> patch 4 of Glauber's series explicitly states that halted time is
> not stolen time.  Stolen time is only accumulated when a vCPU
> actually has work to do.
> 
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
