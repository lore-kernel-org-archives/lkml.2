Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1FGSiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:38:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:10074 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab1FGSiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:38:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,333,1304319600"; 
   d="scan'208";a="13108776"
Subject: Re: [patch 1/2] stop_machine: enable __stop_machine() to be called
 from the cpu online path
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "stable@kernel.org" <stable@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20110607180244.GA27552@elte.hu>
References: <20110606231655.824641917@sbsiddha-MOBL3.sc.intel.com>
	 <20110606231752.023885847@sbsiddha-MOBL3.sc.intel.com>
	 <20110607180244.GA27552@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 07 Jun 2011 11:38:22 -0700
Message-Id: <1307471902.21608.4476.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 11:02 -0700, Ingo Molnar wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > Currently stop machine infrastructure can be called only from a cpu 
> > that is online. But for !CONFIG_SMP, we do allow calling 
> > __stop_machine() before the cpu is online.
> > 
> > x86 for example requires stop machine infrastructure in the cpu 
> > online path and currently implements its own stop machine (using 
> > stop_one_cpu_nowait()) for MTRR initialization in the cpu online 
> > path.
> > 
> > Enhance the __stop_machine() so that it can be called before the 
> > cpu is onlined. This will pave the way for code consolidation and 
> > address potential deadlocks caused by multiple mechanisms of doing 
> > system wide rendezvous.
> > 
> > This will also address the behavioral differences of 
> > __stop_machine() between SMP and UP builds.
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > Cc: stable@kernel.org    # v2.6.35+
> > ---
> >  kernel/stop_machine.c |   62 +++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 57 insertions(+), 5 deletions(-)
> 
> This patch is causing problems:
> 
>  [   19.835435] BUG: using smp_processor_id() in preemptible [00000000] code: perf/701
>  [   19.838718] caller is __stop_machine+0x3c/0xbe

This is kind of a false positive. We are just checking if the calling
cpu is online/offline (and there is no possible process migration
between an online and offline cpu).

So I can use either raw_smp_processor_id() or probably wrap it around
get/put_cpu()'s. I would prefer raw_smp_processor_id() instead of the
unnecessary get/put_cpu().

We already have preempt disable/enable down this code path and would
like to keep the preempt disable section to the minimum needed code,
instead of increasing it to address this false positive.

Thoughts?

thanks,
suresh

>  [   19.842079] Pid: 701, comm: perf Not tainted 3.0.0-rc2-tip+ #132432
>  [   19.845378] Call Trace:
>  [   19.847838]  [<c1112431>] ? debug_smp_processor_id+0xbd/0xd0
>  [   19.848712]  [<c1050be6>] ? __stop_machine+0x3c/0xbe
>  [   19.852046]  [<c1005b74>] ? text_poke+0xec/0xec
>  [   19.855379]  [<c1014447>] ? do_page_fault+0xb0/0x361
>  [   19.858711]  [<c1005f00>] ? text_poke_smp+0x48/0x4f
>  [   19.862044]  [<c1014447>] ? do_page_fault+0xb0/0x361
>  [   19.865378]  [<c100519c>] ? arch_jump_label_transform+0x50/0x64
>  [   19.868712]  [<c103d61a>] ? __jump_label_update+0x28/0x39
>  [   19.872044]  [<c103d647>] ? jump_label_update+0x1c/0x49
>  [   19.875377]  [<c103d892>] ? jump_label_inc+0x38/0x40
>  [   19.878710]  [<c105cfaf>] ? perf_swevent_init+0x118/0x129
>  [   19.882044]  [<c10625b6>] ? perf_init_event+0x47/0x7c
>  [   19.885376]  [<c10627f7>] ? perf_event_alloc+0x20c/0x416
>  [   19.888710]  [<c1062fb1>] ? sys_perf_event_open+0x313/0x634
>  [   19.892042]  [<c101469a>] ? do_page_fault+0x303/0x361
>  [   19.895379]  [<c1281e70>] ? sysenter_do_call+0x12/0x26
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

