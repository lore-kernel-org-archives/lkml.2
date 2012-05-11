Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab2EKS1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:27:32 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39229 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537Ab2EKS1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:27:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [PATCHv4 4/4] cpuidle: coupled: add parallel barrier function
Date: Fri, 11 May 2012 20:32:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
References: <1336438662-10484-1-git-send-email-ccross@android.com> <201205092331.24487.rjw@sisk.pl> <CAMbhsRRzc9hPYLZvuwqsOP3RrF1dZVmzM_qfy_xHNL6mhtJzDA@mail.gmail.com>
In-Reply-To: <CAMbhsRRzc9hPYLZvuwqsOP3RrF1dZVmzM_qfy_xHNL6mhtJzDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205112032.21117.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 11, 2012, Colin Cross wrote:
> On Wed, May 9, 2012 at 2:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, May 08, 2012, Colin Cross wrote:
> >> Adds cpuidle_coupled_parallel_barrier, which can be used by coupled
> >> cpuidle state enter functions to handle resynchronization after
> >> determining if any cpu needs to abort.  The normal use case will
> >> be:
> >>
> >> static bool abort_flag;
> >> static atomic_t abort_barrier;
> >>
> >> int arch_cpuidle_enter(struct cpuidle_device *dev, ...)
> >> {
> >>       if (arch_turn_off_irq_controller()) {
> >>               /* returns an error if an irq is pending and would be lost
> >>                  if idle continued and turned off power */
> >>               abort_flag = true;
> >>       }
> >>
> >>       cpuidle_coupled_parallel_barrier(dev, &abort_barrier);
> >>
> >>       if (abort_flag) {
> >>               /* One of the cpus didn't turn off it's irq controller */
> >>               arch_turn_on_irq_controller();
> >>               return -EINTR;
> >>       }
> >>
> >>       /* continue with idle */
> >>       ...
> >> }
> >>
> >> This will cause all cpus to abort idle together if one of them needs
> >> to abort.
> >>
> >> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >> Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >> Reviewed-by: Kevin Hilman <khilman@ti.com>
> >> Tested-by: Kevin Hilman <khilman@ti.com>
> >> Signed-off-by: Colin Cross <ccross@android.com>
> >> ---
> >>  drivers/cpuidle/coupled.c |   37 +++++++++++++++++++++++++++++++++++++
> >>  include/linux/cpuidle.h   |    4 ++++
> >>  2 files changed, 41 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> >> index 93101fb..3e65de1 100644
> >> --- a/drivers/cpuidle/coupled.c
> >> +++ b/drivers/cpuidle/coupled.c
> >> @@ -130,6 +130,43 @@ struct cpuidle_coupled {
> >>  static cpumask_t cpuidle_coupled_poked_mask;
> >>
> >>  /**
> >> + * cpuidle_coupled_parallel_barrier - synchronize all online coupled cpus
> >> + * @dev: cpuidle_device of the calling cpu
> >> + * @a:   atomic variable to hold the barrier
> >> + *
> >> + * No caller to this function will return from this function until all online
> >> + * cpus in the same coupled group have called this function.  Once any caller
> >> + * has returned from this function, the barrier is immediately available for
> >> + * reuse.
> >> + *
> >> + * The atomic variable a must be initialized to 0 before any cpu calls
> >> + * this function, will be reset to 0 before any cpu returns from this function.
> >> + *
> >> + * Must only be called from within a coupled idle state handler
> >> + * (state.enter when state.flags has CPUIDLE_FLAG_COUPLED set).
> >> + *
> >> + * Provides full smp barrier semantics before and after calling.
> >> + */
> >> +void cpuidle_coupled_parallel_barrier(struct cpuidle_device *dev, atomic_t *a)
> >> +{
> >> +     int n = dev->coupled->online_count;
> >> +
> >> +     smp_mb__before_atomic_inc();
> >> +     atomic_inc(a);
> >> +
> >> +     while (atomic_read(a) < n)
> >> +             cpu_relax();
> >> +
> >> +     if (atomic_inc_return(a) == n * 2) {
> >> +             atomic_set(a, 0);
> >> +             return;
> >> +     }
> >> +
> >> +     while (atomic_read(a) > n)
> >> +             cpu_relax();
> >> +}
> >
> > Well, this looks like "wait until all CPUs execute this code".  Don't we have
> > anything like this already somewhere?
> >
> >> +
> >> +/**
> >>   * cpuidle_state_is_coupled - check if a state is part of a coupled set
> >>   * @dev: struct cpuidle_device for the current cpu
> >>   * @drv: struct cpuidle_driver for the platform
> >> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> >> index 6038448..5ab7183 100644
> >> --- a/include/linux/cpuidle.h
> >> +++ b/include/linux/cpuidle.h
> >> @@ -183,6 +183,10 @@ static inline int cpuidle_wrap_enter(struct cpuidle_device *dev,
> >>
> >>  #endif
> >>
> >> +#ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
> >> +void cpuidle_coupled_parallel_barrier(struct cpuidle_device *dev, atomic_t *a);
> >> +#endif
> >
> > Why exactly is the extra Kconfig option necessary?
> 
> It prevents compiling in coupled.o (2k text section) on the majority
> of kernels that will never use it.

OK, sorry, for some unknown reason it seemed to me that the option was added by
this patch.

Thanks,
Rafael
