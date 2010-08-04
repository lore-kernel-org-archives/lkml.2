Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab0HDJvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:51:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:39196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab0HDJvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:51:09 -0400
Subject: Re: A question of perf NMI handler
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, robert.richter@amd.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <1280913670.20797.179.camel@minggr.sh.intel.com>
References: <1280913670.20797.179.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 11:50:55 +0200
Message-ID: <1280915455.1923.890.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 17:21 +0800, Lin Ming wrote:
> With nmi_watchdog enabled, perf_event_nmi_handler always return
> NOTIFY_STOP(active_events > 0), and the notifier call chain will not
> call further.
> 
> If it was not perf NMI, does the perf nmi handler may stop the real NMI
> handler get called because NOTIFY_STOP is returned??
> 
> static int __kprobes
> perf_event_nmi_handler(struct notifier_block *self,
> 			 unsigned long cmd, void *__args)
> {
> 	struct die_args *args = __args;
> 	struct pt_regs *regs;
> 
> 	if (!atomic_read(&active_events)) ===> With nmi_watchdog enabled, active_events > 0
> 		return NOTIFY_DONE;
> 
> 	switch (cmd) {
> 	case DIE_NMI:
> 	case DIE_NMI_IPI:
> 		break;
> 
> 	default:
> 		return NOTIFY_DONE;
> 	}
> 
> 	regs = args->regs;
> 
> 	apic_write(APIC_LVTPC, APIC_DM_NMI);
> 	/*
> 	 * Can't rely on the handled return value to say it was our NMI, two
> 	 * events could trigger 'simultaneously' raising two back-to-back NMIs.
> 	 *
> 	 * If the first NMI handles both, the latter will be empty and daze
> 	 * the CPU.
> 	 */
> 	x86_pmu.handle_irq(regs);
> 
> 	return NOTIFY_STOP;
> }

Urgh,.. right, so what is the alternative? we don't seem to have a
reliable way of telling where the NMI originated from.

As that comment says, the PMU can raise the NMI and raise the pending
NMI latch for a second over-run, at which point the first NMI will
likely see the overflow status for both, clear both, and the second NMI
will see a 0 overflow status, return it wasn't the PMU, but since the
PMU did raise it, nobody else will claim it, and we get these silly
dazed and confused thingies.

What NMI source are you concerned about and can it reliably tell if it
raised the NMI or not?


