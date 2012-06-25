Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab2FYUbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:31:46 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39326 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2FYUbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:31:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: Re: boot hang on commit "PM / ACPI: Fix suspend/resume regression caused by cpuidle cleanup."
Date: Mon, 25 Jun 2012 22:37:07 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc4-test+; KDE/4.6.0; x86_64; ; )
Cc: Fengguang Wu <wfg@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Preeti Murthy <preeti@linux.vnet.ibm.com>,
        Srivatsa S Bhat <srivatsa.bhat@linux.vnet.ibm.com>
References: <20120622073513.GA15864@localhost> <201206250018.15384.rjw@sisk.pl> <4FE85A0B.4000108@linux.vnet.ibm.com>
In-Reply-To: <4FE85A0B.4000108@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206252237.07518.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 25, 2012, Deepthi Dharwar wrote:
> On 06/25/2012 03:48 AM, Rafael J. Wysocki wrote:
> 
> > On Friday, June 22, 2012, Fengguang Wu wrote:
> >> Hi Deepthi,
> >>
> >> I can no longer reproduce this issue... Sorry for the noise!
> > 
> > But I do, 100% of the time on real hardware which is Acer Ferrari One.
> > 
> > The symptom is that the new WARN_ON() triggers pretty much on every
> > cpuidle transition for me which makes the machine unuseable.
> > 
> > That may be a result of a different bug, but the box evidently works
> > without the hunk in arch/x86/kernel/process.c, so I'd prefer to drop it
> > for now.
> 
> If cpu is coming out of cpuidle with WARN_ON every-time, is suspend 
> on this device working ?

Yes, it is.

> Wanted to get some clarity about this hardware .
> We can remove this check for now.

OK

> > Moreover, I have a couple of questions regarding the implementation.
> > 
> > First, why are we returning -EINVAL if acpi_idle_suspend is set?  Surely,
> > something like -EBUSY or -EAGAIN would be better here, wouldn't it?
> > 
> 
> 
> Any negative return value will serve the purpose. We put it as -EINVAL
> as cpu_idle operation during suspend was termed invalid. I will change it to 
> -EBUSY for better readability. 

OK

> > Second, is the cpu_relax() before returning really necessary?
> 
> 
> cpu_relax operation is mainly to lower CPU power consumption.
> If the system is idle, we would want to at-least reduce 
> power consumption. Better than busy looping in and out of idle when 
> suspend is triggered. There is no harm having it. 

It seems kind of redundant, though.  The system is suspending at this point,
so the increased power consumption, if any, shouldn't be that much anyway,
right?

> > Finally, the hunk in acpi_idle_enter_bm() still looks ugly.  I'd prefer
> > something like this instead:
> > 
> > @@ -907,7 +928,10 @@ static int acpi_idle_enter_bm(struct cpu
> >  						drv, drv->safe_state_index);
> >  		} else {
> >  			local_irq_disable();
> > -			acpi_safe_halt();
> > +
> > +			if (!acpi_idle_suspend)
> > +				acpi_safe_halt();
> > +
> >  			local_irq_enable();
> >  			return -EINVAL;
> >  		}
> > @@ -915,6 +939,12 @@ static int acpi_idle_enter_bm(struct cpu
> > 
> >  	local_irq_disable();
> > 
> > +	if (acpi_idle_suspend) {
> > +		local_irq_enable();
> > +		cpu_relax();
> > +		return -EBUSY;
> > +	}
> > +
> >  	if (cx->entry_method != ACPI_CSTATE_FFH) {
> >  		current_thread_info()->status &= ~TS_POLLING;
> >  		/*
> > 
> > Hmm?
> 
> 
> Yes, I'll will re-factor the code.

Good.

Thanks,
Rafael
