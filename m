Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2EICFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 22:05:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:28641 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab2EICFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 22:05:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140655053"
Message-ID: <4FA9D07D.8000401@intel.com>
Date: Wed, 09 May 2012 10:03:41 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] x86/tlb: add tlb flush all factor for specific
 CPUs
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com>  <1336485790-30902-5-git-send-email-alex.shi@intel.com> <1336489685.16236.48.camel@twins>
In-Reply-To: <1336489685.16236.48.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 11:08 PM, Peter Zijlstra wrote:

> On Tue, 2012-05-08 at 22:03 +0800, Alex Shi wrote:
>> +void intel_tlb_flushall_factor_set(struct cpuinfo_x86 *c)
>> +{
>> +       switch (c->x86_model) {
>> +       case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
>> +               tlb_flushall_factor = 0;
>> +               break;
> 
> Why isn't this is the bottom list of core chips?


It was tested. but the bottom list cpu was not tested.

> 
>> +       case 26: /* 45 nm nehalem, "Bloomfield" */
>> +       case 30: /* 45 nm nehalem, "Lynnfield" */
>> +       case 37: /* 32 nm nehalem, "Clarkdale" */
>> +       case 44: /* 32 nm nehalem, "Gulftown" */
>> +       case 46: /* 45 nm nehalem-ex, "Beckton" */
>> +               tlb_flushall_factor = 64;
>> +               break;
>> +       case 42: /* SandyBridge */
>> +       case 45: /* SandyBridge, "Romely-EP" */
>> +               tlb_flushall_factor = 32;
>> +               break;
>> +       case 28: /* Atom */
>> +       case 47: /* 32 nm Xeon E7 */
> 
> This is a wsm-ex, right? Why isn't it listed with the other nehalems?


I don't know this. Thanks for this info

> 
>> +       case 14: /* 65 nm core solo/duo, "Yonah" */
>> +       case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
>> +       case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
>> +       case 29: /* six-core 45 nm xeon "Dunnington" */
> 
> So never use invlpg for Atom/Core/Core2?


Uh, I will remove the CPU list if they weren't tested.

> 
>> +       default:
>> +               tlb_flushall_factor = 0;
>> +       }
>> +}
> 
> 
>> @@ -364,7 +363,8 @@ flush_all:
>>                         act_entries = tlb_entries > mm->total_vm ?
>>                                         mm->total_vm : tlb_entries;
>>  
>> +                       if ((end - start)/PAGE_SIZE >
>> +                                       act_entries/tlb_flushall_factor) 
> 
> You're doing an actual full division, wouldn't a shift be better?


Thanks!

