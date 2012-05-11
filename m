Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab2EKDCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:02:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:62264 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab2EKDCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:02:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164756901"
From: Youquan Song <youquan.song@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, len.brown@intel.com,
        akpm@linux-foundation.org
Cc: arjan@linux.intel.com, len.brown@linux.intel.com,
        suresh.b.siddha@intel.com, Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 0/3] x86,idle: Enhance cpuidle prediction to handle its failure
Date: Fri, 11 May 2012 11:15:54 -0400
Message-Id: <1336749357-9133-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prediction for future is difficult and when the cpuidle governor prediction 
fails and govenor possibly choose the shallower C-state than it should. How to 
quickly notice and find the failure becomes important for power saving.    

cpuidle menu governor has a method to predict the repeat pattern if there are 8
C-states residency which are continuous and the same or very close, so it will
predict the next C-states residency will keep same residency time.

We encountered a real case that turbostat utility (tools/power/x86/turbostat) 
at kernel 3.3 or early. turbostat utility will read 10 registers one by one at
Sandybridge, so it will generate 10 IPIs to wake up idle CPUs. So cpuidle menu
 governor will predict it is repeat mode and there is another IPI wake up idle
 CPU soon, so it keeps idle CPU stay at C1 state even though CPU is totally 
idle. However, in the turbostat, following 10 registers reading is sleep 5 
seconds by default, so the idle CPU will keep at C1 for a long time though it is
 idle until break event occurs.

The "old turbostat" is specific case and it is already fix by skip to read CPU
MSRs. But we do not guarantee that other application will not do it like this.
So the proper ways is to enhance the logic of the men governor prediction for 
next C-states. 

This patchset adds a timer when menu governor choose a non-deepest C-state in
order to wake up quickly from shallow C-state to avoid staying too long at 
shallow C-state for prediction failure. If the timer is not triggered and CPU
is waken up from C-state, the timer will be cancelled initiatively to avoid the
adding timer bring affect to system. If the timer is time out, CPU will quickly
be waken up from shallow C-state and re-evaluates deeper C-states possibility. 

After plenty of testing and tuning, the patchset get about 1% power efficiency
ehancement in SpecPower2008 on Romley-EP. Especailly, when workload is not so 
high < 70%, it can notice 1~3 watts power saving; while workload is high > 80%,
It will cost more power consumption. Another benchmarks non-CPU intensive, like 
fio, apache and aio-stress will also get power saving while the performance does 
not drop.

While I try to fix the issue, I got a lot of help and suggestion from Arjan,
Thanks a lot Arjan!

Thanks 
-Youquan

