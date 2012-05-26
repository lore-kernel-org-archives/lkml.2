Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab2EZH3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:29:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:45481 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2EZH3d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:29:33 -0400
Message-ID: <1338017364.14636.9.camel@twins>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Sat, 26 May 2012 09:29:24 +0200
In-Reply-To: <1338014259.7302.26.camel@marge.simpson.net>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop> <1337865641.9783.149.camel@laptop>
	 <1337926468.5415.48.camel@marge.simpson.net>
	 <1338014259.7302.26.camel@marge.simpson.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-26 at 08:37 +0200, Mike Galbraith wrote:

> Ew. 3.4 went broke for Q6600, and performance went... far far away.
> 
> [    0.200057] CPU0 attaching sched-domain:
> [    0.204016]  domain 0: span 0-3 level MC
> [    0.208015]   groups: 0 1 2 3
> [    0.210970] CPU1 attaching sched-domain:
> [    0.212014]  domain 0: span 0-3 level MC
> [    0.216016]   groups: 1 2 3 0
> [    0.220016] CPU2 attaching sched-domain:
> [    0.224015]  domain 0: span 0-3 level MC
> [    0.228016]   groups: 2 3 0 1
> [    0.232015] CPU3 attaching sched-domain:
> [    0.236016]  domain 0: span 0-3 level MC
> [    0.240017]   groups: 3 0 1 2


Oh yikes, I guess I wrecked
arch/x86/kernel/smpboot.c:cpu_coregroup_mask() in
8e7fbcbc22c12414bcc9dfdd683637f58fb32759.

That should very much always return llc mask, I just got that AMD case
confused. It looks like it should look like:


const struct cpumask *cpu_coregroup_mask(int cpu)
{
	return cpu_llc_mask(cpu);
}

And the AMD_DCM check was just to undo powersavings damage on
Magny-Cours or somesuch.

Andreas?
