Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab0FPOEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab0FPOEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:04:24 -0400
Date: Wed, 16 Jun 2010 11:03:31 -0300
From: Glauber Costa <glommer@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 12/17] Add helper function get_kernel_ns
Message-ID: <20100616140331.GN19104@mothafucka.localdomain>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
 <1276587259-32319-13-git-send-email-zamsden@redhat.com>
 <4C173CC3.8000506@redhat.com>
 <4C17EAA5.90009@redhat.com>
 <4C18877E.9070605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C18877E.9070605@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 04:12:46PM +0800, Jason Wang wrote:
> Zachary Amsden wrote:
> > On 06/14/2010 10:41 PM, Avi Kivity wrote:
> >   
> >> On 06/15/2010 10:34 AM, Zachary Amsden wrote:
> >>     
> >>> Add a helper function for the multiple places this is used.  Note 
> >>> that it
> >>> must not be called in preemptible context, as that would mean the kernel
> >>> could enter software suspend state, which would cause non-atomic 
> >>> operation
> >>> of the monotonic_to_bootbased computation.
> >>>
> >>> Open question: should the KVM_SET_CLOCK / KVM_GET_CLOCK ioctls use this
> >>> as well?  Currently, they are not bootbased (but perhaps should be).
> >>>
> >>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
> >>> ---
> >>>   arch/x86/kvm/x86.c |   26 +++++++++++++-------------
> >>>   1 files changed, 13 insertions(+), 13 deletions(-)
> >>>
> >>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >>> index 703ea43..15c7317 100644
> >>> --- a/arch/x86/kvm/x86.c
> >>> +++ b/arch/x86/kvm/x86.c
> >>> @@ -915,6 +915,16 @@ static void kvm_get_time_scale(uint32_t 
> >>> scaled_khz, uint32_t base_khz,
> >>>            __func__, base_khz, scaled_khz, shift, *pmultiplier);
> >>>   }
> >>>
> >>> +static inline u64 get_kernel_ns(void)
> >>> +{
> >>> +    struct timespec ts;
> >>> +
> >>> +    WARN_ON(preemptible());
> >>> +    ktime_get_ts(&ts);
> >>> +    monotonic_to_bootbased(&ts);
> >>> +    return timespec_to_ns(&ts);
> >>> +}
> >>> +
> >>>   static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
> >>>
> >>>       
> >> Isn't something like this a candidate for the time infrastructure?
> >>
> >>     
> >
> > Should it be?  It certainly seems reasonable.
> >
> >
> > Also, should we be using it for the cases KVM_GET_CLOCK / 
> > KVM_SET_CLOCK?  It seems global kvmclock_offset for the VM ignores the 
> > bootbased conversion.
> >
> >   
> Yes we should.
indeed. Also shows the importance of doing it in a central place.
Have we had an acessor like that before, we would probably not have
made this mistake.



