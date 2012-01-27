Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2A0RD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:03:26 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:44727 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388Ab2A0RDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:03:24 -0500
Message-ID: <4F22D8D9.3010108@rgmadvisors.com>
Date: Fri, 27 Jan 2012 11:03:21 -0600
From: Andrew Steets <asteets@rgmadvisors.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prctl(PR_TASK_PERF_EVENTS_DISABLE) doesn't appear to disable perf event
counters.  Here is a demonstration program:

#include <linux/prctl.h>

void loop_events_disabled() {
     volatile int x;
     int i;
     for (i = 0; i < 1000000000; i++)
         x = i;
     return;
}

void loop_events_enabled() {
     volatile int x;
     int i;
     for (i = 0; i < 1000000000; i++)
         x = i;
     return;
}

int main(int argc, char **argv) {
     prctl(PR_TASK_PERF_EVENTS_ENABLE);
     loop_events_enabled();
     prctl(PR_TASK_PERF_EVENTS_DISABLE);
     loop_events_disabled();
}

I would not expect to see loop_events_disabled() show up in the profile
as reported by perf report, but it does.

$ perf record ./a.out
$ perf report -n --stdio
# Events: 3K cycles
#
# Overhead  Samples    Command      Shared Object                Symbol
# ........ ..........  .......  .................  ....................
#
     51.80%       1679    a.out  a.out              [.] loop_events_enabled
     48.07%       1578    a.out  a.out              [.] loop_events_disabled
      0.03%          5    a.out  [kernel.kallsyms]  [k] intel_pmu_enable_all
      0.03%          1    a.out  [kernel.kallsyms]  [k] sched_clock
      0.03%          1    a.out  [kernel.kallsyms]  [k] ktime_get
      0.03%          1    a.out  [kernel.kallsyms]  [k] update_cpu_load
      0.01%          1    a.out  [sunrpc]           [k] generic_match

I have tested this on several kernels including 3.3rc1.  Can anyone tell
me if I'm using this wrong or if this is a bug?

-Andrew

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
