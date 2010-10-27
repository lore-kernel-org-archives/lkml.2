Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab0J0Ipi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:45:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40002 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab0J0Ipg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:45:36 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Robert Richter <robert.richter@amd.com>
CC: "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "R, Sricharan" <r.sricharan@ti.com>
Date: Wed, 27 Oct 2010 14:15:21 +0530
Subject: RE: [PATCH] oprofile: Fix the hang while offline the cpu
Thread-Topic: [PATCH] oprofile: Fix the hang while offline the cpu
Thread-Index: Act1rfDmfbHCNXeSRGm+pBlLruyMIAABQ8RQ
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB030D3107BA@dbde02.ent.ti.com>
References: <1287835926-1957-1-git-send-email-santosh.shilimkar@ti.com>
 <20101027080651.GV5969@erda.amd.com>
In-Reply-To: <20101027080651.GV5969@erda.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Robert Richter [mailto:robert.richter@amd.com]
> Sent: Wednesday, October 27, 2010 1:37 PM
> To: Shilimkar, Santosh
> Cc: oprofile-list@lists.sf.net; linux-kernel@vger.kernel.org; R, Sricharan
> Subject: Re: [PATCH] oprofile: Fix the hang while offline the cpu
> 
> On 23.10.10 08:12:06, Santosh Shilimkar wrote:
> > The kernel build with CONFIG_OPROFILE and CPU_HOTPLUG enabled.
> > The oprofile is initialised using system timer in absence of hardware
> > counters supports. Oprofile isn't started from userland.
> >
> > In this setup while doing a CPU offline the kernel hangs in infinite
> > for loop inside lock_hrtimer_base() function
> >
> > This happens because as part of oprofile_cpu_notify(, it tries to
> > stop an hrtimer which was never started. These per-cpu hrtimers
> > are started when the oprfile is started.
> > 	echo 1	> /dev/oprofile/enable
> 
> Indeed, this is true.
> 
> There is also the case vice versa, the cpu is booted with maxcpus
> parameter set. When bringing the remaining cpus online the timers are
> started even if oprofile is not yet enabled.
> 
> >
> > This patch fix this issue by adding a state variable so that
> > these hrtimer start/stop is only attempted when oprofile is
> > started
> >
> > Reported-by: Jan Sebastien <s-jan@ti.com>
> > Signed-off-by: sricharan <r.sricharan@ti.com>
> > Tested-by: sricharan <r.sricharan@ti.com>
> > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >
> > Cc: Robert Richter <robert.richter@amd.com>
> > ---
> >  drivers/oprofile/timer_int.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
> > index dc0ae4d..de487ba 100644
> > --- a/drivers/oprofile/timer_int.c
> > +++ b/drivers/oprofile/timer_int.c
> > @@ -21,6 +21,7 @@
> >  #include "oprof.h"
> >
> >  static DEFINE_PER_CPU(struct hrtimer, oprofile_hrtimer);
> > +static int oprofile_hrtimer_started;
> 
> Maybe we rename this in ctr_running. This is similar to the arch/x86
> implementation. We don't need the oprofile_ prefix as this is static.
> 'started' is a bit irritating as we start the timer if the timer is
> started.
> 
Will rename it to 'ctr_running' 
> >
> >  static enum hrtimer_restart oprofile_hrtimer_notify(struct hrtimer
> *hrtimer)
> >  {
> > @@ -33,6 +34,9 @@ static void __oprofile_hrtimer_start(void *unused)
> >  {
> >  	struct hrtimer *hrtimer = &__get_cpu_var(oprofile_hrtimer);
> >
> > +	if (!oprofile_hrtimer_started)
> > +		return;
> > +
> >  	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> >  	hrtimer->function = oprofile_hrtimer_notify;
> >
> > @@ -42,6 +46,7 @@ static void __oprofile_hrtimer_start(void *unused)
> >
> >  static int oprofile_hrtimer_start(void)
> >  {
> > +	oprofile_hrtimer_started = 1;
> >  	on_each_cpu(__oprofile_hrtimer_start, NULL, 1);
> 
> We must protect on_each_cpu() and the variable assignment with
> get/put_online_cpus(). See also implementation in
> arch/x86/oprofile/nmi_int.c.
> 
Good point. Will fix this.

> >  	return 0;
> >  }
> > @@ -50,6 +55,9 @@ static void __oprofile_hrtimer_stop(int cpu)
> >  {
> >  	struct hrtimer *hrtimer = &per_cpu(oprofile_hrtimer, cpu);
> >
> > +	if (!oprofile_hrtimer_started)
> > +		return;
> > +
> >  	hrtimer_cancel(hrtimer);
> >  }
> >
> > @@ -59,6 +67,7 @@ static void oprofile_hrtimer_stop(void)
> >
> >  	for_each_online_cpu(cpu)
> >  		__oprofile_hrtimer_stop(cpu);
> > +	oprofile_hrtimer_started = 0;
> 
> Same here, protect this with get/put_online_cpus().
Ok.

Will send v2 with above fixes.

Regards,
Santosh
