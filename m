Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2D3NFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 09:05:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab2D3NFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 09:05:41 -0400
Date: Mon, 30 Apr 2012 09:05:25 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Sameer Nanda <snanda@chromium.org>, mingo@redhat.com, peterz@infradead.org,
        len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        akpm@linux-foundation.org, msb@chromium.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        olofj@chromium.org
Subject: Re: [PATCH] watchdog: fix for lockup detector breakage on resume
Message-ID: <20120430130525.GM28185@redhat.com>
References: <1335550240-17765-1-git-send-email-snanda@chromium.org>
 <4F9E2D3D.3000000@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9E2D3D.3000000@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 11:42:13AM +0530, Srivatsa S. Bhat wrote:
> > +void lockup_detector_bootcpu_resume(void)
> > +{
> > +	void *cpu = (void *)(long)smp_processor_id();
> > +
> > +	/*
> > +	 * On the suspend/resume path the boot CPU does not go though the
> > +	 * offline->online transition. This breaks the NMI detector post
> > +	 * resume. Force an offline->online transition for the boot CPU on
> > +	 * resume.
> > +	 */
> > +	cpu_callback(&cpu_nfb, CPU_DEAD, cpu);
> > +	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
> > +
> 
> 
> I have a couple of comments about this:
> 
> 1. Strictly speaking, we should be using the _FROZEN variants here (since the
> tasks are still frozen).
> 
> Like, cpu_callback(&cpu_nfb, CPU_DEAD_FROZEN, cpu);
> and   cpu_callback(&cpu_nfb, CPU_ONLINE_FROZEN, cpu);
> 
> Right now, since the same action is taken for either variant (ie., with or without
> _FROZEN), it really doesn't matter. But still, good to be on the safer side no?
> 
> 2. Why are we skipping the CPU_UP_PREPARE_FROZEN callback?
> 
> 3. How about hibernation? We don't hit this problem there?

Hi,

I have similar concerns as this patch seems kinda like a hack.  OTOH I
don't know all the available hooks for the suspend/resume paths.  I would
have assumed there was a special case call for the boot cpu to shutdown or
at least disable its services.  Wouldn't a lot of other tasks run into
similar problems as the watchdog?  I don't think the watchdog does
anything special that requires a special hook into the suspend path.

What do other hardware timers do on the suspend path?

Cheers,
Don
