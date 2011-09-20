Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab1ITT5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:57:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab1ITT5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:57:15 -0400
Date: Tue, 20 Sep 2011 16:55:14 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: Anthony Liguori <anthony@codemonkey.ws>, avi@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm-ppc@vger.kernel.org,
        aliguori@us.ibm.com, raharper@us.ibm.com, kvm-ia64@vger.kernel.org,
        Glauber Costa <glommer@gmail.com>, mjwolf@us.ibm.com,
        haveblue@us.ibm.com
Subject: Re: [PATCH 0/4] Avoid soft lockup message when KVM is stopped by host
Message-ID: <20110920195514.GD32325@amt.cnet>
References: <1314660435-23293-1-git-send-email-emunson@mgebm.net>
 <20110830122630.GA19450@amt.cnet>
 <4E5FDBDC.2030302@codemonkey.ws>
 <6c387b0ab0b091253c1a1488dd625b94@mgebm.net>
 <20110909132955.GA19459@amt.cnet>
 <20110913204955.GD9096@mgebm.net>
 <20110915132614.GA7101@amt.cnet>
 <20110920190054.GA31415@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920190054.GA31415@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 03:00:54PM -0400, Eric B Munson wrote:
> On Thu, 15 Sep 2011, Marcelo Tosatti wrote:
> 
> > On Tue, Sep 13, 2011 at 04:49:55PM -0400, Eric B Munson wrote:
> > > On Fri, 09 Sep 2011, Marcelo Tosatti wrote:
> > > 
> > > > On Thu, Sep 01, 2011 at 02:27:49PM -0600, emunson@mgebm.net wrote:
> > > > > On Thu, 01 Sep 2011 14:24:12 -0500, Anthony Liguori wrote:
> > > > > >On 08/30/2011 07:26 AM, Marcelo Tosatti wrote:
> > > > > >>On Mon, Aug 29, 2011 at 05:27:11PM -0600, Eric B Munson wrote:
> > > > > >>>Currently, when qemu stops a guest kernel that guest will
> > > > > >>>issue a soft lockup
> > > > > >>>message when it resumes.  This set provides the ability for
> > > > > >>>qemu to comminucate
> > > > > >>>to the guest that it has been stopped.  When the guest hits
> > > > > >>>the watchdog on
> > > > > >>>resume it will check if it was suspended before issuing the
> > > > > >>>warning.
> > > > > >>>
> > > > > >>>Eric B Munson (4):
> > > > > >>>   Add flag to indicate that a vm was stopped by the host
> > > > > >>>   Add functions to check if the host has stopped the vm
> > > > > >>>   Add generic stubs for kvm stop check functions
> > > > > >>>   Add check for suspended vm in softlockup detector
> > > > > >>>
> > > > > >>>  arch/x86/include/asm/pvclock-abi.h |    1 +
> > > > > >>>  arch/x86/include/asm/pvclock.h     |    2 ++
> > > > > >>>  arch/x86/kernel/kvmclock.c         |   14 ++++++++++++++
> > > > > >>>  include/asm-generic/pvclock.h      |   14 ++++++++++++++
> > > > > >>>  kernel/watchdog.c                  |   12 ++++++++++++
> > > > > >>>  5 files changed, 43 insertions(+), 0 deletions(-)
> > > > > >>>  create mode 100644 include/asm-generic/pvclock.h
> > > > > >>>
> > > > > >>>--
> > > > > >>>1.7.4.1
> > > > > >>
> > > > > >>How is the host supposed to set this flag?
> > > > > >>
> > > > > >>As mentioned previously, if you save save/restore the offset
> > > > > >>added to
> > > > > >>kvmclock on stop/cont (and the TSC MSR, forgot to mention that), no
> > > > > >>paravirt infrastructure is required. Which means the issue is
> > > > > >>also fixed
> > > > > >>for older guests.
> > > > > >
> > > 
> > > Marcelo,
> > > 
> > > I think that stopping the TSC is the wrong approach because it will break time
> > > between the two systems so timething that expects the monotonic clock to move
> > > consistently will be wrong.
> > 
> > In case the VM stops for whatever reason, the host system is not
> > supposed to adjust time related hardware state to compensate, in an
> > attempt to present apparent continuous time.
> > 
> > If you save a VM and then restore it later, it is the guest
> > responsability to adjust its time representation.
> > 
> > QEMU exposing continuous TSC and kvmclock state between "stop" and
> > "cont" should not be a reason to introduce new paravirt infrastructure.
> > 
> > >  IMO, messing with the TSC at run time to avoid a watchdog message
> > > is the wrong solution, better to teach the watchdog to ignore this
> > > special case.
> > 
> > OK then, it is not a harmful addition, can you post the QEMU patches to
> > set the "ignore watchdog" bit.
> 
> I am about to start working on the interface to set this bit, but to double
> check I tried your suggestion to save the clock value on stop and restore it on
> continue (see qemu patch below) and I am seeing very odd behavior from it.  On
> random resumes the vm won't come back immediately (it took one 15 mintues to
> respond) 

You should also save/restore the TSC MSR for each VCPU. And it appears
there is a missing

kvm_for_each_vcpu(vcpu)
    kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu)

in KVM_SET_CLOCK ioctl handling.

> and the wall clock stays behind my host wall clock by the amount of
> time it took to resume.

This is expected, similar to savevm/loadvm.

> ---
>  cpus.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/cpus.c b/cpus.c
> index 54c188c..4573e23 100644
> --- a/cpus.c
> +++ b/cpus.c
> @@ -63,6 +63,7 @@
>  #endif /* CONFIG_LINUX */
>  
>  static CPUState *next_cpu;
> +struct kvm_clock_data data;
>  
>  /***********************************************************/
>  void hw_error(const char *fmt, ...)
> @@ -788,6 +789,7 @@ static int all_vcpus_paused(void)
>  void pause_all_vcpus(void)
>  {
>      CPUState *penv = first_cpu;
> +    int ret;
>  
>      while (penv) {
>          penv->stop = 1;
> @@ -803,11 +805,18 @@ void pause_all_vcpus(void)
>              penv = (CPUState *)penv->next_cpu;
>          }
>      }
> +
> +    ret = kvm_vm_ioctl(kvm_state, KVM_GET_CLOCK, &data);
> +    if (ret < 0) {
> +        fprintf(stderr, "KVM_GET_CLOCK failed: %s\n", strerror(ret));
> +        data.clock = 0;
> +    }
>  }
>  
>  void resume_all_vcpus(void)
>  {
>      CPUState *penv = first_cpu;
> +    int ret;
>  
>      while (penv) {
>          penv->stop = 0;
> @@ -815,6 +824,11 @@ void resume_all_vcpus(void)
>          qemu_cpu_kick(penv);
>          penv = (CPUState *)penv->next_cpu;
>      }
> +    if (data.clock != 0) {
> +        ret = kvm_vm_ioctl(kvm_state, KVM_SET_CLOCK, &data);
> +        if (ret < 0)
> +            fprintf(stderr, "KVM_SET_CLOCK failed: %s\n", strerror(ret));
> +    }
>  }
>  
>  static void qemu_tcg_init_vcpu(void *_env)
> > 


