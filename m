Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab2E2OwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:52:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:56946 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab2E2OwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:52:01 -0400
Message-ID: <1338303106.26856.92.camel@twins>
Subject: Re: WARNING: at arch/x86/kernel/smpboot.c:310
 topology_sane.clone.1+0x6e/0x81()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        LKML <linux-kernel@vger.kernel.org>, hpa <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 29 May 2012 16:51:46 +0200
In-Reply-To: <20120529135442.GE29157@aftab.osrc.amd.com>
References: <20120529135442.GE29157@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 15:54 +0200, Borislav Petkov wrote:
> Dudes,
> 
> I'm getting the warning below on current linus. AFAICT, it is caused by
> 
> static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
> {
>         if (c->phys_proc_id == o->phys_proc_id)
>                 return topology_sane(c, o, "mc");
> 
>         return false;
> }
> 
> and the reason is, IMHO, that because this is a MCM box which has two
> nodes in one physical package, i.e., phys_proc_id is 0 on both CPU6 and
> CPU0 but it has two internal nodes, 0 and 1 and CPUs 0-5 are on node 0
> and CPUs 6-11 are on node 1, the warning fires.
> 
> Maybe we could do something like this untested hunk:
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 433529e29be4..e52538cd48bb 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -348,7 +348,8 @@ static bool __cpuinit match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
>  static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
>  {
>         if (c->phys_proc_id == o->phys_proc_id)
> -               return topology_sane(c, o, "mc");
> +               if (!cpu_has(c, X86_FEATURE_AMD_DCM))
> +                       return topology_sane(c, o, "mc");
>  
>         return false;
>  }
> 
> or you have a better idea...?

Ah,.. uhm.. unfortunate this... we only seem to use cpu_core_mask for
topology_core_cpumask() and its purpose is to enumerate cores in a
package for some very limited generic functions.

Its a bit sad we defined it thus, the multi-core concept only really
make sense if you share caches, otherwise its just smp.

Also, our generic topology as defined doesn't match nodes. Which is
weird to say the least.

I'd almost be tempted to say you should fake phys_id, but I can only
imagine what all would explode if we'd do that :-)

Yeah, I guess we should do the thing you propose, unless someone else
has a sane idea?


