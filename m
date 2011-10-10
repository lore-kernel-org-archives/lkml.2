Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1JJSez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 14:34:55 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59333 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab1JJSex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 14:34:53 -0400
Date: Mon, 10 Oct 2011 20:34:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: "tj@kernel.org" <tj@kernel.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
Message-ID: <20111010183442.GC29415@aftab>
References: <Pine.LNX.4.44L0.1110101119550.18069-100000@netrider.rowland.org>
 <4E931018.8030904@linux.vnet.ibm.com>
 <20111010165343.GA29261@aftab>
 <4E932BBA.9090501@linux.vnet.ibm.com>
 <20111010175336.GA29415@aftab>
 <20111010180848.GI8100@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010180848.GI8100@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Mon, Oct 10, 2011 at 02:08:48PM -0400, tj@kernel.org wrote:
> Maybe I'm confused but is that patch correct for actual CPU hotplug
> case?  If not, what's the point in doing that?  What are we gonna do
> after six month some people come up with "CPU hotplug fails to load
> new microcode for the new CPU"?

Ok, first of all, we still will load ucode on the onlining path - we're
simply not going to reload it when the CPU has gone offline and onlined
again. For that case people should simply reload the module so that
ucode on _all_ CPUs is updated pretty much at same time.

Now, actually, the ucode driver shouldn't even exist as it is - ucode
should be loaded much much earlier when the cores are being trampolined.
Normally, ucode is loaded by BIOS and I imagine this facility here
exists for the sole purpose to apply ucode only when there's no new BIOS
available.

So, here's what ucode handling should actually be, IMHO:

* load ucode very early during booting of each CPU

* keep ucode in memory in case not all cores have been onlined from the
get-go to apply when they're onlined later

* do NOT reapply it when cores are off-/onlined because there's no need
(cores retain ucode when we offline them (basically, they enter C1,
probably C3 on Intel or similar so no problem)).

* when you have new ucode image, trigger a replacement of the image in
memory and subsequently trigger a re-application of the new ucode (sysfs
write, whatever).

> The invalidation code is there for a reason.

... and that reason being?

> The CPU is going away and the microcode tied to the CPU should go away
> too.

This is what I don't understand - as I said earlier, ucode is not
something you get on a monthly basis: you get only a very few updates
and that's it in the majority of the cases. So users going the trouble
of reloading the microcode.ko module a very few times (if ever!) during
a system's lifetime shouldn't be an issue.

> If somebody is sure that microcode don't need to be changed once
> loaded, then all's good and dandy but that's not the case here, right?

Well, basically the current situation didn't change the ucode - it
simply reloaded the same image from before going offline.

See, there's this another problem with what we have right now: imagine
you've just updated the ucode image on disk and offline only a subset of
the cores. Then you online them again and they now get the newer ucode
image while the others still run the old ucode. This could explode or
could not, one thing's for sure: all bets are off. If we don't reload it
on hotplug, we're fine - only module reload triggers the ucode update in
a fairly synchronized manner.

> If you want to optimize away microcode unloading during
> suspend/resume, the RTTD is doing revalidation / reload during
> CPU_ONLINE as necessary.

see above.

> If this use case doesn't really matter too much to anyone, just
> leaving it alone would be better than adding band aid which can lead
> to very obscure issues down the road (oooh, that microcode shouldn't
> have been loaded to that cpu).

I'd like to actually hear someone justify such a requirement.

I hope I'm making some sense here.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
