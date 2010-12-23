Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab0LWGVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 01:21:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:4331 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab0LWGVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 01:21:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,217,1291622400"; 
   d="scan'208";a="690075275"
From: Youquan Song <youquan.song@intel.com>
To: davej@redhat.com, cpufreq@vger.kernel.org
Cc: venki@google.com, arjan@linux.intel.com, lenb@kernel.org,
        suresh.b.siddha@intel.com, kent.liu@intel.com, chaohong.guo@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 0/6] cpufreq: Add sampling window to enhance ondemand governor power efficiency 
Date: Thu, 23 Dec 2010 14:23:38 +0800
Message-Id: <1293085424-18212-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running a well-known power performance benchmark, current ondemand governor is
not power efficiency. Even when workload is at 10%~20% of full capability, the
CPU will also run much of time at highest frequency. In fact, in this situation,
the lowest frequency often can meet user requirement. When running this
benchmark on turbo mode enable machine, I compare the result of different
governors, the results of ondemand and performance governors are the closest.
There is no much power saving between ondemand and performance governor. If we
can ignore the little power saving, the perfomance governor even better than 
ondemand governor, at leaset for better performance. 

One potential reason for ondemand governor is not power efficiency is that
ondemand governor decide the next target frequency by instant requirement during
sampling interval (10ms or possible a little longer for deferrable timer in idle
tickless). The instant requirement can response quickly to workload change, but
it does not usually reflect workload real CPU usage requirement in a small 
longer time and it possibly causes frequently change between highest and lowest
frequency.     

This patchset add a sampling window for percpu ondemand thread. Each sampling
window with max 150 record items which slide every sampling interval and use to
track the workload requirement during latest sampling window timeframe. 
The average of workload during latest sample windows will be used to decide next
target frequency. The sampling window targets to be more truly reflects workload
requirement of CPU usage. 

The sampling window size can be set by user and default max sampling window
is one second. When it is set to default sampling rate, the sampling window will
roll back to original behaviour.

The sampling window size also can be dynamicly changed in according to current
system workload busy situation. The more idle, the smaller sampling window; the
more busy, the larger sampling window. It will increase the respnose speed by
decrease sampling window, while it will keep CPU working at high speed when busy
by increase sampling window and also avoid unefficiently dangle between highest
and lowest frequency in original ondemand.

We set to up_threshold to 80 and down_differential to 20, so when workload reach
 80% of current frequency, it will increase to highest frequency. When workload
decrease to below (up_threshold - down_differential)60% of current frequency
capability, it will decrease the frequency, which ensure that CPU work above 60%
of its current capability, otherwise lowest frequency will be used. 
   
The Turbo Mode (P0) will comsume much more power compare with second largest
frequency (P1) and P1 frequency is often double, even more, with Pn lowest
frequency; Current logic will increase sharply to highest frequency Turbo Mode
when workload reach to up_threshold of current frequency capacity, even current
frequency at lowest frequency. In this patchset, it will firstly evaluate P1 if
it is enough to support current workload before directly enter into Turbo Mode.
If P1 can meet workload requirement, it will save power compare of being Turbo
Mode.  

On my test platform with two sockets Westmere-EP server and run the well-known
power performance benchmark, when workload is low, the patched governor is 
power saving like powersave governor; while workload is high, the patched 
governor is as good as performance governor but the patched governor consume
less power than performance governor. Along with other patches in this patchset,
the patched governor power efficiey is improved about 10%, while the performance
has no apparently decrease.
Running other benchmarks in phoronix, kernel building save 5% power, while the
performance without decrease. compress-7zip save power 2%, while the performance
also does not apparently decrease. However, apache benchmark saves power but its
performance decrease a lot.


