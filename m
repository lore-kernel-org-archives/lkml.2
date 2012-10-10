Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab2JJNEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:04:39 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27559 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab2JJNEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:04:37 -0400
Date: Wed, 10 Oct 2012 08:52:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andre Przywara <andre.przywara@amd.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, mingo@elte.hu,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/perf: Fix virtualization sanity check
Message-ID: <20121010125228.GA3670@phenom.dumpdata.com>
References: <1349797115-28346-1-git-send-email-andre.przywara@amd.com>
 <20121009155118.GE7639@phenom.dumpdata.com>
 <5074A612.4090405@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5074A612.4090405@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 12:32:50AM +0200, Andre Przywara wrote:
> On 10/09/2012 05:51 PM, Konrad Rzeszutek Wilk wrote:
> >On Tue, Oct 09, 2012 at 05:38:34PM +0200, Andre Przywara wrote:
> >>In check_hw_exists() we try to detect non-emulated MSR accesses
> >>by writing an arbitrary value into one of the PMU registers
> >>and check if it's value after a readout is still the same.
> >>This algorithm silently assumes that the register does not contain
> >>the magic value already, which is wrong in at least one situation.
> >>
> >>Fix the algorithm to really do a read-modify-write cycle. This fixes
> >>a warning under Xen under some circumstances on AMD family 10h CPUs.
> >>
> >>The reasons in more details actually sound like a story from
> >>Believe It or Not!:
> >>First you need an AMD family 10h/12h CPU. These do not reset the
> >>PERF_CTR registers on a reboot.
> >>Now you boot bare metal Linux, which goes successfully through this
> >>check, but leaves the magic value of 0xabcd in the register. You
> >>don't use the performance counters, but do a reboot (warm reset).
> >>Then you choose to boot Xen. The check will be triggered with a
> >>recent Linux kernel as Dom0 again, trying to write 0xabcd into the
> >>MSR. Xen silently drops the write (expected), but the subsequent read
> >>will return the value in the register, which just happens to be the
> >>expected magic value. Thus the test misleadingly succeeds, leaving
> >
> >Is that an oversight in the hypervisor? as in should it disable
> >access to those MSRs? I thought it disabled to most of them already
> >unless you give some extra bootup parameters? (cpufreq=dom0 or something
> >like that).
> 
> Probably, it seems like HVM guest get a proper handling of these
> MSRs, but Dom0 (and other PV guests) have no special handling. This
> may be an addition to the list of things Dom0 is inadvertently
> allowed to do (or at least to discover). Found other traces of MCE
> MSR accesses (and APIC warnings) just today.
> Maybe we should scan the kernel (or dmesg) for those things and
> handle them properly in one final(tm) patch.
> 
> Btw.: Wei just today sent a patch for Xen to clear the PERF_CTR
> registers on boot, so we address this particular problem from both
> sides.

<nods>

OK, I am for this patch - doing extra sanity checks in case the hardware
(or the platform is doing silly things) is good.

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thanks for tracking this down.
> 
> Regards,
> Andre.
> 
> >
> >>the kernel in the belief that the PMU is available. This will trigger
> >>the following message:
> >>
> >>[    0.020294] ------------[ cut here ]------------
> >>[    0.020311] WARNING: at arch/x86/xen/enlighten.c:730 xen_apic_write+0x15/0x17()
> >>[    0.020318] Hardware name: empty
> >>[    0.020323] Modules linked in:
> >>[    0.020334] Pid: 1, comm: swapper/0 Not tainted 3.3.8 #7
> >>[    0.020340] Call Trace:
> >>[    0.020354]  [<ffffffff81050379>] warn_slowpath_common+0x80/0x98
> >>[    0.020369]  [<ffffffff810503a6>] warn_slowpath_null+0x15/0x17
> >>[    0.020378]  [<ffffffff810034df>] xen_apic_write+0x15/0x17
> >>[    0.020392]  [<ffffffff8101cb2b>] perf_events_lapic_init+0x2e/0x30
> >>[    0.020410]  [<ffffffff81ee4dd0>] init_hw_perf_events+0x250/0x407
> >>[    0.020419]  [<ffffffff81ee4b80>] ? check_bugs+0x2d/0x2d
> >>[    0.020430]  [<ffffffff81002181>] do_one_initcall+0x7a/0x131
> >>[    0.020444]  [<ffffffff81edbbf9>] kernel_init+0x91/0x15d
> >>[    0.020456]  [<ffffffff817caaa4>] kernel_thread_helper+0x4/0x10
> >>[    0.020471]  [<ffffffff817c347c>] ? retint_restore_args+0x5/0x6
> >>[    0.020481]  [<ffffffff817caaa0>] ? gs_change+0x13/0x13
> >>[    0.020500] ---[ end trace a7919e7f17c0a725 ]---
> >>
> >>The new code will change every of the 16 low bits read from the
> >>register and tries to write and read-back that modified number
> >>from the MSR.
> >>
> >>Signed-off-by: Andre Przywara <andre.przywara@amd.com>
> >>---
> >>  arch/x86/kernel/cpu/perf_event.c | 10 ++++++----
> >>  1 file changed, 6 insertions(+), 4 deletions(-)
> >>
> >>diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> >>index 915b876..d18b2b8 100644
> >>--- a/arch/x86/kernel/cpu/perf_event.c
> >>+++ b/arch/x86/kernel/cpu/perf_event.c
> >>@@ -208,12 +208,14 @@ static bool check_hw_exists(void)
> >>  	}
> >>
> >>  	/*
> >>-	 * Now write a value and read it back to see if it matches,
> >>-	 * this is needed to detect certain hardware emulators (qemu/kvm)
> >>-	 * that don't trap on the MSR access and always return 0s.
> >>+	 * Read the current value, change it and read it back to see if it
> >>+	 * matches, this is needed to detect certain hardware emulators
> >>+	 * (qemu/kvm) that don't trap on the MSR access and always return 0s.
> >>  	 */
> >>-	val = 0xabcdUL;
> >>  	reg = x86_pmu_event_addr(0);
> >>+	if (rdmsrl_safe(reg, &val))
> >>+		goto msr_fail;
> >>+	val ^= 0xffffUL;
> >>  	ret = wrmsrl_safe(reg, val);
> >>  	ret |= rdmsrl_safe(reg, &val_new);
> >>  	if (ret || val != val_new)
> >>--
> >>1.7.12.1
> >>
> >>
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>Please read the FAQ at  http://www.tux.org/lkml/
> >>
> >
> 
> 
