Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab1GELBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:01:12 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:51323 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab1GELBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:01:11 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20110705104742.GO17941@sun>
References: <20110705104742.GO17941@sun>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 12:00:56 +0100
Message-ID: <1309863656.634.111.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Q x86-64] on kernel_eflags
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 14:47 +0400, Cyrill Gorcunov wrote:
> While were looking into ret_from_fork code I somehow wondered
> about the global kernel_eflags variable here.
> 
> arch/x86/cpu/common.c
> ---------------------
> unsigned long kernel_eflags;
> 
> void __cpuinit cpu_init(void)
> {
> 	...
> 	raw_local_save_flags(kernel_eflags);
> }
> 
> arch/x86/kernel/entry_64.S
> --------------------------
> ENTRY(ret_from_fork)
> 	DEFAULT_FRAME
> 	LOCK ; btr $TIF_FORK,TI_flags(%r8)
> 	pushq_cfi kernel_eflags(%rip)
> 	popfq_cfi                               # reset kernel eflags
> 
> Every call to cpu_init renew global kernel_eflags
> and every task switching does use this variable in a
> sake of cleaning carry bit of flags register as far as
> I can tell.
> 
> Should not every cpu has own copy of kernel_eflags? Just
> to be consistent in style? Or this would be space waisting
> and an optimization is done here?

I noticed this a while ago and couldn't figure out why it was done this
way. On 32-bit the initial EFLAGS is simply hardcoded and that seems to
make sense to me since it's not clear that the specific value of EFLAGS
at the point it is saved in cpu_init() has any particular meaning.

I posted http://lkml.org/lkml/2010/2/9/155 to switch to the hardcoded
version for 64 bit too. Is it worth my rebasing and reposting that?

(http://lkml.org/lkml/2010/2/9/152 and http://lkml.org/lkml/2010/2/9/154
were followon cleanups).

Ian.

-- 
Ian Campbell
Current Noise: Kylesa - Drop Out

"... all the modern inconveniences ..."
		-- Mark Twain

