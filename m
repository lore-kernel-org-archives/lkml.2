Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030328Ab2CTPCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:02:54 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:42595 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab2CTPCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:02:53 -0400
Message-ID: <4F689C14.9000708@linux.vnet.ibm.com>
Date: Tue, 20 Mar 2012 20:32:44 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix the race between smp_call_function and CPU booting
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com> <1331546307.18960.26.camel@twins> <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com> <1331654251.18960.78.camel@twins> <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com> <1331718197.18960.106.camel@twins> <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com> <1331808391.18960.160.camel@twins> <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com> <1331891364.18960.221.camel@twins> <27240C0AC20F114CBF8149A2696CBE4A058AAE@SHSMSX101.ccr.corp.intel.com> <1332151397.18960.252.camel@twins> <27240C0AC20F114CBF8149A2696CBE4A05A6BF@SHSMSX101.ccr.corp.intel.com> <1332245842.18960.413.camel@twins> <4F6882BA.2040000@linux.vnet.ibm.com> <1332250867.18960.423.camel@twins>
In-Reply-To: <1332250867.18960.423.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12032004-9264-0000-0000-000001172546
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 07:11 PM, Peter Zijlstra wrote:

> On Tue, 2012-03-20 at 18:44 +0530, Srivatsa S. Bhat wrote:
>>
>>
>> I don't think this patch would change anything, atleast it wouldn't get
>> rid of the warning that Liu reported. Because, he is running his stress
>> tests on a machine which has only 2 CPUs. So effectively, we are hotplugging
>> only CPU1 (since CPU0 can't be taken offline, on Intel boxes).
>>
>> Also, CPU1 is removed from cpu_active_mask during CPU_DOWN_PREPARE time itself,
>> and migrate_tasks() comes much later (during CPU_DYING). And in any case,
>> dest_cpu will never be CPU1, because it is the CPU that is going down. So it
>> *has* to be CPU0 anyway.
>>
>> So, I don't think changes to select_fallback_rq() to make it more careful is
>> going to make any difference in the particular scenario that Liu is testing.
>>
>> That said, even I don't know what the root cause of the warning is.. :-(
> 
> Its a race in cpu-up, we set active before online, when we do a wakeup
> select_task_rq() will see !cpu_online(), we then call
> select_fallback_rq() to compute a new cpu, select_fallback_rq() computes
> a new cpu against cpu_active (which is set) and can thus return cpu 1,
> even though it is still offline.
> 
> So we queue the task on cpu 1 and send a reschedule ipi, at which point
> we'll get the reported warning.
> 
> My change modifies select_fallback_rq() to require online && active.
> 


Ok, that makes sense.. Thanks a lot for the explanation!

Regards,
Srivatsa S. Bhat

