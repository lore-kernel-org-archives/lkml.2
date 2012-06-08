Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab2FHOpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:45:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:45551 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2FHOpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:45:31 -0400
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <20120608143636.GG31359@aftab.osrc.amd.com>
References: <1339065932.23343.18.camel@twins>
	 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
	 <20120608135117.GB31359@aftab.osrc.amd.com>
	 <1339163669.2507.16.camel@laptop>
	 <20120608141543.GD31359@aftab.osrc.amd.com>
	 <1339165250.2507.27.camel@laptop>
	 <20120608143636.GG31359@aftab.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 16:45:18 +0200
Message-ID: <1339166718.2507.37.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 16:36 +0200, Borislav Petkov wrote:
> On Fri, Jun 08, 2012 at 04:20:50PM +0200, Peter Zijlstra wrote:
> > On Fri, 2012-06-08 at 16:15 +0200, Borislav Petkov wrote:
> > > have a variable which gets initialized to the number of all CPUs and
> > > each time ->apply_microcode() finishes by returning 0, we decrement it
> > > once.
> > 
> > > 
> > > Hmm, I'm probably missing some obscure case. 
> > 
> > Since its all per-cpu sysfs muck, userspace could update a random
> > subsets of cpus.. leaving us hanging.
> 
> I'm afraid I don't understand - when you modprobe microcode.ko,
> it goes and loads /lib/firmware/amd-ucode/microcode_amd.bin (in
> the AMD case) on each CPU when the driver gets regged through
> subsys_interface_register().
> 
> It calls ->add_dev() on each CPU - this should be guaranteed because it
> uses the cpu_subsys from drivers/base/cpu.c which onlines all CPUs, I'd
> assume.
> 
> So, I'd say that once subsys_interface_register() returns, we have
> updated ucode on all CPUs, if successful...
> 
> We probably could run the notifier at that moment, before we do
> put_online_cpus().

I was thinking about reload_store(), that seems to only reload ucode for
a single cpu.

> > The 'bestestet' idea I came up with is doing the verify thing I have
> > from a delayed work -- say 1 second into the future. That way, when
> > there's lots of cpus they all try and enqueue the one work, which at
> > the end executes only once, provided the entire update scan took less
> > than the second.
> 
> You're saying, you want the last CPU that gets to update its microcode
> gets to also run the delayed work...? Probably, I'd assume ucode update
> on a single CPU takes less than a second IIUC.

Nah.. it'll probably be the first. But it doesn't matter which cpu does
it. So the idea was:

static void intel_snb_verify_work(struct work_struct *work)
{
	/* do the verify thing.. */
}

static DECLARE_DELAYED_WORK(intel_snb_delayed_work, intel_snb_verify_ucode);

static int intel_snb_ucode_notifier(struct notifier_block *self,
                                   unsigned long action, void *_uci)
{
        /*
         * Since ucode cannot be down-graded, and no future ucode revision
         * is known to break PEBS again, we're ok with MICROCODE_CAN_UPDATE.
         */

        if (action == MICROCODE_UPDATED)
		schedule_delayed_work(&intel_snb_delayed_work, HZ);

        return NOTIFY_DONE;
}

Thus it will queue the delayed work when the work isn't already queued
for execution. Resulting in the work only happening once a second (at
most). 

