Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2FMGvC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 02:51:02 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60812 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2FMGu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 02:50:59 -0400
Date: Wed, 13 Jun 2012 08:51:19 +0200
From: Borislav Petkov <bp@amd64.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120613065119.GB15661@aftab.osrc.amd.com>
References: <1339161972.2507.13.camel@laptop>
 <20120612170725.GE5046@erda.amd.com>
 <CABPqkBRJAA7yRcswM1iYESSwhiGD4SEbir=q=ouQSevi7OAxqQ@mail.gmail.com>
 <1339521203.31548.92.camel@twins>
 <20120612171734.GI8404@aftab.osrc.amd.com>
 <1339521493.31548.93.camel@twins>
 <20120612172352.GA4802@aftab.osrc.amd.com>
 <1339521996.31548.95.camel@twins>
 <20120612173506.GB4802@aftab.osrc.amd.com>
 <20120613010413.GA28174@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613010413.GA28174@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 10:04:13PM -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 12 Jun 2012, Borislav Petkov wrote:
> > I'd guess this is still there to support mixed ucode revisions for some
> 
> It is still there because of the stable ABI rules.  As far as I can tell,
> it was a crap interface when it got in, and it still is a crap interface
> now because there simply isn't any sane usercase that requires it, it is
> dangerous as implemented right now (at least in the Intel case), and even
> if we fixed the kernel to do the right thing, userspace would not be able
> to know that and would still need to request 1 microcode refresh per core.

Well, I'm disabling it on AMD.

We could make it iterate over _all_ cores and do the update on each one
of them even though the user does a sysfs write only for a single core..

> As far as I know, we always want to refresh the microcode on every core,
> use the firmware interface to pick up a copy of the newest version of the
> microcode matching the signature of each core, and leave no core behind
> without an update.

Yep.

> And preferably, we want to request_firmware() only once per microcode,
> which is rather easy to do: cache every microcode that will be needed,
> check cache first before doing request_firmware() in the per-core
> worker threads, and invalidate the cache when the user requests
> "refresh_all_microcode". So, the cache speeds up multi-core updates,
> and is also usable when restoring the system from suspend/hibernation,
> but doesn't get in the way of userspace trying to apply a microcode
> update.

Yes, agreed too.

> This would make my pathetic system do one request_firmware instead of
> eight. And even the old junk with mixed-stepping SMP at work would
> only require two, instead of four (or eight? I don't recall how many
> cores per die it has) request_firmware calls.

Ok.

> > described above. Maybe this interface should be behind a family, model
> > check or so, so that users don't shoot themselves in the foot but it is
> > root-only anyway.
> 
> This interface should _DIE_.

Yeppers! :-)

> Perhaps we could make it work only for CPU 0 and return EBUSY or whatever
> for all others (or just don't publish the sysfs attribute for the others),
> and change the CPU0 refresh firmware request into a refresh all cores call.

That could also work, it sounds like a sane thing to do having in mind
the current sysfs layout. I will cook up something soonish.

> We could then add a new sysfs attribute to cleanly do the
> update-all-cores request.

That's what Fenghua is doing.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
