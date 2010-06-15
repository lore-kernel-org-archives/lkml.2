Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab0FOVN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 17:13:28 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48771 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab0FOVN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 17:13:27 -0400
Subject: Re: [PATCH 12/17] Add helper function get_kernel_ns
From: john stultz <johnstul@us.ibm.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4C17EAA5.90009@redhat.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
	 <1276587259-32319-13-git-send-email-zamsden@redhat.com>
	 <4C173CC3.8000506@redhat.com>  <4C17EAA5.90009@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 15 Jun 2010 14:13:20 -0700
Message-ID: <1276636400.1703.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 11:03 -1000, Zachary Amsden wrote:
> On 06/14/2010 10:41 PM, Avi Kivity wrote:
> > On 06/15/2010 10:34 AM, Zachary Amsden wrote:
> >> Add a helper function for the multiple places this is used.  Note 
> >> that it
> >> must not be called in preemptible context, as that would mean the kernel
> >> could enter software suspend state, which would cause non-atomic 
> >> operation
> >> of the monotonic_to_bootbased computation.
> >>
> >> Open question: should the KVM_SET_CLOCK / KVM_GET_CLOCK ioctls use this
> >> as well?  Currently, they are not bootbased (but perhaps should be).
> >>
> >> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
> >> ---
> >>   arch/x86/kvm/x86.c |   26 +++++++++++++-------------
> >>   1 files changed, 13 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index 703ea43..15c7317 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -915,6 +915,16 @@ static void kvm_get_time_scale(uint32_t 
> >> scaled_khz, uint32_t base_khz,
> >>            __func__, base_khz, scaled_khz, shift, *pmultiplier);
> >>   }
> >>
> >> +static inline u64 get_kernel_ns(void)
> >> +{
> >> +    struct timespec ts;
> >> +
> >> +    WARN_ON(preemptible());
> >> +    ktime_get_ts(&ts);
> >> +    monotonic_to_bootbased(&ts);
> >> +    return timespec_to_ns(&ts);
> >> +}
> >> +
> >>   static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
> >>
> >
> > Isn't something like this a candidate for the time infrastructure?
> >
> 
> Should it be?  It certainly seems reasonable.

Yea, probably should move to timekeeping.c or time.h.

You might also want a more descriptive name, since get_kernel_ns()
doesn't really express that this is the bootbased monotonic time. 

The similar sounding current_kernel_time() returns a coarse tick
granular CLOCK_REALTIME, so it could lead to confusion.

thanks
-john


