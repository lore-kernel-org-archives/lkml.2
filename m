Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab2IUNxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:53:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab2IUNxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:53:53 -0400
Message-ID: <505C712F.4060800@redhat.com>
Date: Fri, 21 Sep 2012 09:52:47 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 2/2] kvm: Be courteous to other VMs in overcommitted
 scenario in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120019.27611.66093.sendpatchset@codeblue> <20120921224636.18cccbd6c33b161975f2a8cb@gmail.com>
In-Reply-To: <20120921224636.18cccbd6c33b161975f2a8cb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 09:46 AM, Takuya Yoshikawa wrote:
> On Fri, 21 Sep 2012 17:30:20 +0530
> Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:
>
>> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>>
>> When PLE handler fails to find a better candidate to yield_to, it
>> goes back and does spin again. This is acceptable when we do not
>> have overcommit.
>> But in overcommitted scenarios (especially when we have large
>> number of small guests), it is better to yield.
>>
>> Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>> ---
>>   virt/kvm/kvm_main.c |    4 ++++
>>   1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 8323685..713b677 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1660,6 +1660,10 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>   			}
>>   		}
>>   	}
>> +	/* In overcommitted cases, yield instead of spinning */
>> +	if (!yielded && rq_nr_running() > 1)
>> +		schedule();
>
> How about doing cond_resched() instead?

Actually, an actual call to yield() may be better.

That will set scheduler hints to make the scheduler pick
another task for one round, while preserving this task's
top position in the runqueue.

-- 
All rights reversed
