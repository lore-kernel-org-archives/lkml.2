Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab2BJQQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:16:50 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:17813 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2BJQQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:16:48 -0500
Date: Fri, 10 Feb 2012 11:12:53 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Steven Noonan <steven@uplinklabs.net>, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: bisected: 'perf top' causing soft lockups under Xen
Message-ID: <20120210161253.GA11690@phenom.dumpdata.com>
References: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090204.4F3542BB.0173,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 06:32:07PM -0800, Steven Noonan wrote:
> This lockup is pretty reliably reproducible (but only under Xen). I've
> seen this happen under multiple hardware configurations and multiple
> different configs.

Hm, during bootup what does perf say about the CPU availability? Is
it that it can only do perf via NMI's?
.. snip..
> I did a bit of manual bisection (based on tags) and noticed the issue
> was introduced sometime between v3.0 and v3.1-rc1. This is where the

Whoa, 3.1? Yikes!

> bisection took me:
> 
> # bad: [322a8b034003c0d46d39af85bf24fee27b902f48] Linux 3.1-rc1
> # good: [02f8c6aee8df3cdc935e9bdd4f2d020306035dbe] Linux 3.0
> git bisect start 'v3.1-rc1' 'v3.0'
> # bad: [0003230e8200699860f0b10af524dc47bf8aecad] Merge branch
> 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6
> git bisect bad 0003230e8200699860f0b10af524dc47bf8aecad
> # good: [72f96e0e38d7e29ba16dcfd824ecaebe38b8293e] Merge branch
> 'for-linus-core' of
> git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
> git bisect good 72f96e0e38d7e29ba16dcfd824ecaebe38b8293e
> # bad: [f5fc87905ea075a0b14878086fd4fe38be128844] Merge branch
> 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
> git bisect bad f5fc87905ea075a0b14878086fd4fe38be128844
> # bad: [f5fc87905ea075a0b14878086fd4fe38be128844] Merge branch
> 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
> git bisect bad f5fc87905ea075a0b14878086fd4fe38be128844
> # bad: [bbd9d6f7fbb0305c9a592bf05a32e87eb364a4ff] Merge branch
> 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6
> git bisect bad bbd9d6f7fbb0305c9a592bf05a32e87eb364a4ff
> # bad: [4d4abdcb1dee03a4f9d6d2021622ed07e14dfd17] Merge branch
> 'perf-core-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> git bisect bad 4d4abdcb1dee03a4f9d6d2021622ed07e14dfd17
> # bad: [190b57fcb9c5fed5414935a174094f534fc510bc] perf probe: Add
> probed module in front of function
> git bisect bad 190b57fcb9c5fed5414935a174094f534fc510bc
> # bad: [26ca5c11fb45ae2b2ac7e3574b8db6b3a3c7d350] perf: export
> perf_event_refresh() to modules
> git bisect bad 26ca5c11fb45ae2b2ac7e3574b8db6b3a3c7d350
> # bad: [26ca5c11fb45ae2b2ac7e3574b8db6b3a3c7d350] perf: export
> perf_event_refresh() to modules
> git bisect bad 26ca5c11fb45ae2b2ac7e3574b8db6b3a3c7d350
> # good: [b0af8dfdd67699e25083478c63eedef2e72ebd85] Linux 3.0-rc5
> git bisect good b0af8dfdd67699e25083478c63eedef2e72ebd85
> # good: [b0af8dfdd67699e25083478c63eedef2e72ebd85] Linux 3.0-rc5
> git bisect good b0af8dfdd67699e25083478c63eedef2e72ebd85
> # good: [af07ce3e77d3b24ab1d71fcc5833d41800f23b2b] Merge branch
> 'tip/perf/core-2' of
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace
> into perf/core
> git bisect good af07ce3e77d3b24ab1d71fcc5833d41800f23b2b
> # good: [af07ce3e77d3b24ab1d71fcc5833d41800f23b2b] Merge branch
> 'tip/perf/core-2' of
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace
> into perf/core
> git bisect good af07ce3e77d3b24ab1d71fcc5833d41800f23b2b
> # good: [1880c4ae182afb5650c5678949ecfe7ff66a724e] perf, x86: Add
> hw_watchdog_set_attr() in a sake of nmi-watchdog on P4
> git bisect good 1880c4ae182afb5650c5678949ecfe7ff66a724e
> # bad: [ee89cbc2d48150c7c0e9f2aaac00afde99af098c] perf_events: Add
> Intel Sandy Bridge offcore_response low-level support
> git bisect bad ee89cbc2d48150c7c0e9f2aaac00afde99af098c
> # bad: [a7ac67ea021b4603095d2aa458bc41641238f22c] perf: Remove the
> perf_output_begin(.sample) argument
> git bisect bad a7ac67ea021b4603095d2aa458bc41641238f22c
> # bad: [a8b0ca17b80e92faab46ee7179ba9e99ccb61233] perf: Remove the nmi
> parameter from the swevent and overflow interface
> git bisect bad a8b0ca17b80e92faab46ee7179ba9e99ccb61233
> 
> 
> So, it looks like somehow this broke things:


Hm, Peter any thoughts? Is there a need to introduce some new code
to utilize this?

> 
> commit a8b0ca17b80e92faab46ee7179ba9e99ccb61233
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Mon Jun 27 14:41:57 2011 +0200
> 
>     perf: Remove the nmi parameter from the swevent and overflow interface
> 
>     The nmi parameter indicated if we could do wakeups from the current
>     context, if not, we would set some state and self-IPI and let the
>     resulting interrupt do the wakeup.
> 
>     For the various event classes:
> 
>       - hardware: nmi=0; PMI is in fact an NMI or we run irq_work_run from
>         the PMI-tail (ARM etc.)
>       - tracepoint: nmi=0; since tracepoint could be from NMI context.
>       - software: nmi=[0,1]; some, like the schedule thing cannot
>         perform wakeups, and hence need 0.
> 
>     As one can see, there is very little nmi=1 usage, and the down-side of
>     not using it is that on some platforms some software events can have a
>     jiffy delay in wakeup (when arch_irq_work_raise isn't implemented).
> 
>     The up-side however is that we can remove the nmi parameter and save a
>     bunch of conditionals in fast paths.
> 
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Cc: Michael Cree <mcree@orcon.net.nz>
>     Cc: Will Deacon <will.deacon@arm.com>
>     Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
>     Cc: Anton Blanchard <anton@samba.org>
>     Cc: Eric B Munson <emunson@mgebm.net>
>     Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
>     Cc: Paul Mundt <lethal@linux-sh.org>
>     Cc: David S. Miller <davem@davemloft.net>
>     Cc: Frederic Weisbecker <fweisbec@gmail.com>
>     Cc: Jason Wessel <jason.wessel@windriver.com>
>     Cc: Don Zickus <dzickus@redhat.com>
>     Link: http://lkml.kernel.org/n/tip-agjev8eu666tvknpb3iaj0fg@git.kernel.org
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> Relevant maintainers CC'd. Any ideas, folks?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
