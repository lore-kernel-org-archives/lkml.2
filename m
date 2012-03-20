Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab2CTNlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:41:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51863 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab2CTNlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:41:21 -0400
Message-ID: <1332250867.18960.423.camel@twins>
Subject: Re: [PATCH] Fix the race between smp_call_function and CPU booting
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Tue, 20 Mar 2012 14:41:07 +0100
In-Reply-To: <4F6882BA.2040000@linux.vnet.ibm.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
	 <1331654251.18960.78.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
	 <1331718197.18960.106.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
	 <1331808391.18960.160.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com>
	 <1331891364.18960.221.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A058AAE@SHSMSX101.ccr.corp.intel.com>
	 <1332151397.18960.252.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05A6BF@SHSMSX101.ccr.corp.intel.com>
	 <1332245842.18960.413.camel@twins> <4F6882BA.2040000@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 18:44 +0530, Srivatsa S. Bhat wrote:
> 
> 
> I don't think this patch would change anything, atleast it wouldn't get
> rid of the warning that Liu reported. Because, he is running his stress
> tests on a machine which has only 2 CPUs. So effectively, we are hotplugging
> only CPU1 (since CPU0 can't be taken offline, on Intel boxes).
> 
> Also, CPU1 is removed from cpu_active_mask during CPU_DOWN_PREPARE time itself,
> and migrate_tasks() comes much later (during CPU_DYING). And in any case,
> dest_cpu will never be CPU1, because it is the CPU that is going down. So it
> *has* to be CPU0 anyway.
> 
> So, I don't think changes to select_fallback_rq() to make it more careful is
> going to make any difference in the particular scenario that Liu is testing.
> 
> That said, even I don't know what the root cause of the warning is.. :-(

Its a race in cpu-up, we set active before online, when we do a wakeup
select_task_rq() will see !cpu_online(), we then call
select_fallback_rq() to compute a new cpu, select_fallback_rq() computes
a new cpu against cpu_active (which is set) and can thus return cpu 1,
even though it is still offline.

So we queue the task on cpu 1 and send a reschedule ipi, at which point
we'll get the reported warning.

My change modifies select_fallback_rq() to require online && active.
