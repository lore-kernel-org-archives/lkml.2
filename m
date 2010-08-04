Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab0HDJVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:21:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:23808 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789Ab0HDJVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:21:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,314,1278313200"; 
   d="scan'208";a="592782300"
Subject: A question of perf NMI handler
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        robert.richter@amd.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 17:21:10 +0800
Message-ID: <1280913670.20797.179.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With nmi_watchdog enabled, perf_event_nmi_handler always return
NOTIFY_STOP(active_events > 0), and the notifier call chain will not
call further.

If it was not perf NMI, does the perf nmi handler may stop the real NMI
handler get called because NOTIFY_STOP is returned??

static int __kprobes
perf_event_nmi_handler(struct notifier_block *self,
			 unsigned long cmd, void *__args)
{
	struct die_args *args = __args;
	struct pt_regs *regs;

	if (!atomic_read(&active_events)) ===> With nmi_watchdog enabled, active_events > 0
		return NOTIFY_DONE;

	switch (cmd) {
	case DIE_NMI:
	case DIE_NMI_IPI:
		break;

	default:
		return NOTIFY_DONE;
	}

	regs = args->regs;

	apic_write(APIC_LVTPC, APIC_DM_NMI);
	/*
	 * Can't rely on the handled return value to say it was our NMI, two
	 * events could trigger 'simultaneously' raising two back-to-back NMIs.
	 *
	 * If the first NMI handles both, the latter will be empty and daze
	 * the CPU.
	 */
	x86_pmu.handle_irq(regs);

	return NOTIFY_STOP;
}

Thanks,
Lin Ming


