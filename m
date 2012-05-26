Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab2EZI1W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 04:27:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44652 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750732Ab2EZI1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 04:27:19 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Z6c4iyOSZLcamiG6XufBXqE6o8jElXg//5u4H/6
	qesJpOXvKgw9Uh
Message-ID: <1338020834.7747.8.camel@marge.simpson.net>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Sat, 26 May 2012 10:27:14 +0200
In-Reply-To: <1338017364.14636.9.camel@twins>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop> <1337865641.9783.149.camel@laptop>
	 <1337926468.5415.48.camel@marge.simpson.net>
	 <1338014259.7302.26.camel@marge.simpson.net>
	 <1338017364.14636.9.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-26 at 09:29 +0200, Peter Zijlstra wrote: 
> On Sat, 2012-05-26 at 08:37 +0200, Mike Galbraith wrote:
> 
> > Ew. 3.4 went broke for Q6600, and performance went... far far away.
> > 
> > [    0.200057] CPU0 attaching sched-domain:
> > [    0.204016]  domain 0: span 0-3 level MC
> > [    0.208015]   groups: 0 1 2 3
> > [    0.210970] CPU1 attaching sched-domain:
> > [    0.212014]  domain 0: span 0-3 level MC
> > [    0.216016]   groups: 1 2 3 0
> > [    0.220016] CPU2 attaching sched-domain:
> > [    0.224015]  domain 0: span 0-3 level MC
> > [    0.228016]   groups: 2 3 0 1
> > [    0.232015] CPU3 attaching sched-domain:
> > [    0.236016]  domain 0: span 0-3 level MC
> > [    0.240017]   groups: 3 0 1 2
> 
> 
> Oh yikes, I guess I wrecked
> arch/x86/kernel/smpboot.c:cpu_coregroup_mask() in
> 8e7fbcbc22c12414bcc9dfdd683637f58fb32759.
> 
> That should very much always return llc mask, I just got that AMD case
> confused. It looks like it should look like:
> 
> 
> const struct cpumask *cpu_coregroup_mask(int cpu)
> {
> 	return cpu_llc_mask(cpu);
> }

All better.

Too bad 'enterprise dude' turned cpuhog at 3.0, 'silly tester guy' would
have spotted this instantly.  Hohum, back to finding out what happened
to cpufreq.

[    0.212062] CPU0 attaching sched-domain:
[    0.216016]  domain 0: span 0-1 level MC
[    0.220013]   groups: 0 1
[    0.222664]   domain 1: span 0-3 level CPU
[    0.225754]    groups: 0-1 (cpu_power = 2048) 2-3 (cpu_power = 2048)
[    0.233859] CPU1 attaching sched-domain:
[    0.236015]  domain 0: span 0-1 level MC
[    0.241673]   groups: 1 0
[    0.244385]   domain 1: span 0-3 level CPU
[    0.248016]    groups: 0-1 (cpu_power = 2048) 2-3 (cpu_power = 2048)
[    0.254219] CPU2 attaching sched-domain:
[    0.256016]  domain 0: span 2-3 level MC
[    0.261673]   groups: 2 3
[    0.264578]   domain 1: span 0-3 level CPU
[    0.268016]    groups: 2-3 (cpu_power = 2048) 0-1 (cpu_power = 2048)
[    0.276020] CPU3 attaching sched-domain:
[    0.279929]  domain 0: span 2-3 level MC
[    0.281675]   groups: 3 2
[    0.284577]   domain 1: span 0-3 level CPU
[    0.289764]    groups: 2-3 (cpu_power = 2048) 0-1 (cpu_power = 2048)



