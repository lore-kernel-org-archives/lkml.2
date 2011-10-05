Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab1JEHVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:21:08 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54714 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab1JEHVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:21:06 -0400
Date: Wed, 5 Oct 2011 09:21:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
Message-ID: <20111005072102.GA11172@aftab>
References: <20111002195023.GC31799@mtj.dyndns.org>
 <4E88C3D4.2020300@linux.vnet.ibm.com>
 <20111003004051.GD31799@mtj.dyndns.org>
 <4E894D75.808@linux.vnet.ibm.com>
 <20111003084754.GB4411@liondog.tnic>
 <20111004071508.GA15637@dhcp-172-17-108-109.mtv.corp.google.com>
 <4E8B06E0.2090501@linux.vnet.ibm.com>
 <20111004134653.GC3148@gere.osrc.amd.com>
 <20111004171415.GB3915@gere.osrc.amd.com>
 <4E8B7326.6000606@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8B7326.6000606@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 04:57:10PM -0400, Srivatsa S. Bhat wrote:
> 1. Since we never invalidate the microcode once we get it from userspace, it
>    also means that we will never be able to update the microcode for that cpu
>    ever again! (since we will continue to reuse the same old microcode over and
>    over again on every cpu online operation for that cpu).
>    This restriction introduced by my patch seems bad, isn't it?

Well, if you have a new microcode image, you are supposed to place it
under /lib/firmware/.. or where the kernel has been configured to find
it and then reload the microcode module.

> 2. Suppose we have a 16 cpu machine and we boot it with only 8 cpus (ie., we online
>    only 8 of the 16 cpus while booting). So it means that the kernel gets a copy
>    of the microcode for each of these 8 cpus, but not for the ones that were not
>    onlined while booting.
>    [Let us assume that cpu number 10 was one among the 8 cpus that were not onlined
>     while booting].
> 
>    Later on, let's say we start our cpu hotplug + suspend/resume tests simultaneously.
>    Now consider this possible scenario:
>    
>    * Userspace is not frozen
>    * We initiate a cpu online operation on cpu 10. At the same time, since suspend
>      is in progress, lets say the freezing begins.
>    * Just before cpu 10 could be brought up online, userspace gets frozen.
>    * Now while bringing up cpu 10, due to the CPU_ONLINE_FROZEN notification, the
>      microcode core tries to apply the microcode to the cpu. But unfortunately, it
>      doesn't have the microcode! (because this cpu is coming up for the first time
>      and hence we never got its microcode from userspace...)
> 
>      Now, again the same problem ensues: microcode core calls request_firmware and
>      depends on the (frozen) userspace to get the microcode.

Ok, but is this a real-life scenario you expect to happen somewhere or
is it something that happens only during test? IOW, if you have root
there are many ways to shoot yourself in the foot, right?

[..]

> I am still wondering if the approach I proposed earlier (the one in
> which we defer applying microcode and queue up a callback function
> etc) could solve all these issues. I am also playing around with the
> idea of coupling that with mutual exclusion between cpu hotplug and
> freezer to handle any problematic scenarios.

Well, all those solutions seem like they're not worth the trouble and
complexity if those cases are only conjecture - if you still trigger
them during your testing then probably mutually excluding freezer and
CPU hotplug is something I would lean towards but I could be wrong.

There's of course a much better fix which has been on the table for a
while now involving loading the ucode from the bootloader and applying
it much earlier than what we have now and keeping the ucode image in
memory. This would solve the CPU hotplug deal completely. Maybe it's
time I looked into it :-).

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
