Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1DTR1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 13:27:22 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:37812 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808Ab1DTR1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 13:27:20 -0400
From: Kevin Hilman <khilman@ti.com>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [linux-pm] [RFC PATCH V3 1/4] cpuidle: Move dev->last_residency update to driver	enter routine; remove dev->last_state
Organization: Texas Instruments, Inc.
References: <20110420065445.332.13688.stgit@tringupt.in.ibm.com>
	<20110420065523.332.58678.stgit@tringupt.in.ibm.com>
Date: Wed, 20 Apr 2011 10:27:15 -0700
In-Reply-To: <20110420065523.332.58678.stgit@tringupt.in.ibm.com> (Trinabh
	Gupta's message of "Wed, 20 Apr 2011 12:25:34 +0530")
Message-ID: <87pqog6dfw.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trinabh Gupta <trinabh@linux.vnet.ibm.com> writes:

> Cpuidle subsystem only suggests the state to enter and does not
> guarantee if the suggested state is entered. The actual entered state
> may be different because of software or hardware demotion. Software
> demotion is done by the back-end cpuidle driver and can be accounted
> correctly. Current cpuidle code uses last_state field to capture the
> actual state entered and based on that updates the statistics for the
> state entered.
>
> Ideally the driver enter routine should update the counters,
> and it should return the state actually entered rather than the time
> spent there. 

OK, the return type was changed to return the state index instead of the
time, but since the governors are still relying on dev->last_residency,
drivers are required to update it.

Because of that, why not keep the update of the  time/usage counters
in common code rather than duplicating it (9 times in this patch) into 
all the drivers?

Something like the patch below should suffice.

Kevin


diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 845d3ef..875d241 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -91,6 +91,11 @@ static void cpuidle_idle_call(void)
 
 	entered_state = target_state->enter(dev, drv, next_state);
 
+	/* Update cpuidle counters */
+	dev->states_usage[entered_state].time += 
+		(unsigned long long)dev->last_residency;
+	dev->states_usage[entered_state].usage++;
+
 	trace_power_end(dev->cpu);
 	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
 
