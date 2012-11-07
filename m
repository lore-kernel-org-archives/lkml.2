Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2KGMm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:42:28 -0500
Received: from mga14.intel.com ([143.182.124.37]:18186 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab2KGMm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:42:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,730,1344236400"; 
   d="scan'208";a="165483218"
Message-ID: <509A571A.6050803@intel.com>
Date: Wed, 07 Nov 2012 20:42:02 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, cl@linux.com, pjt@google.com
Subject: Re: [RFC PATCH 2/3] sched: power aware load balance,
References: <1352207399-29497-1-git-send-email-alex.shi@intel.com> <1352207399-29497-3-git-send-email-alex.shi@intel.com> <20121106115105.4ba6ab32.akpm@linux-foundation.org>
In-Reply-To: <20121106115105.4ba6ab32.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 03:51 AM, Andrew Morton wrote:
> On Tue,  6 Nov 2012 21:09:58 +0800
> Alex Shi <alex.shi@intel.com> wrote:
> 
>> $for ((i=0; i < I; i++)) ; do while true; do : ; done & done
>>
>> Checking the power consuming with a powermeter on the NHM EP.
>> 	powersaving     performance
>> I = 2   148w            160w
>> I = 4   175w            181w
>> I = 8   207w            224w
>> I = 16  324w            324w
>>
>> On a SNB laptop(4 cores *HT)
>> 	powersaving     performance
>> I = 2   28w             35w
>> I = 4   38w             52w
>> I = 6   44w             54w
>> I = 8   56w             56w
>>
>> On the SNB EP machine, when I = 16, power saved more than 100 Watts.
> 
> Confused.  According to the above table, at I=16 the EP machine saved 0
> watts.  Typo in the data?

Not typo, since the LCPU number in the EP machine is 16, so if I = 16,
the powersaving policy doesn't work actually. That is the patch designed
for race to idle assumption.

The result looks same as the third patch(for fork/exec/wu) applied.
Result put here because it is from this patch.

> 
> 
> Also, that's a pretty narrow test - it's doing fork and exec at very
> high frequency and things such as task placement decisions at process
> startup might be affecting the results.  Also, the load will be quite
> kernel-intensive, as opposed to the more typical userspace-intensive
> loads.

Sorry, why you think it keep do fork/exec? It just generate several
'bash' task to burn CPU, without fork/exec.

with I = 8, on my 32 LCPU SNB EP machine:
No do_fork calling in 5 seconds.

$ sudo perf stat -e probe:* -a sleep 5
 Performance counter stats for 'sleep 5':
           3 probe:do_execve           [100.00%]
           0 probe:do_fork             [100.00%]

And it is not kernel-intensive, it nearly running all in user level.

'Top' output: 25:0%us VS 0.0%sy

Tasks: 319 total,   9 running, 310 sleeping,   0 stopped,   0 zombie
Cpu(s): 25.0%us,  0.0%sy,  0.0%ni, 74.5%id,  0.4%wa,  0.1%hi,  0.0%si,
0.0%st
...

> So, please run a broader set of tests so we can see the effects?
> 

Really, I have no more ideas for the suitable benchmarks.

Just tried the kbuild -j 16 on the 32 LCPU SNB EP, power just saved 10%,
but compile time increase about ~15%.
Seems if the task number is variation around the powersaving criteria
number, that just cause trouble.




-- 
Thanks
    Alex
