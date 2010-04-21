Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab0DUIIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:08:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab0DUII2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:08:28 -0400
Message-ID: <4BCEB276.6050909@redhat.com>
Date: Wed, 21 Apr 2010 11:08:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>	 <1271356648-5108-2-git-send-email-glommer@redhat.com>	 <4BCA026D.3070309@redhat.com> <1271673975.1674.763.camel@laptop>	 <4BCC3520.6090305@redhat.com> <1271674273.1674.777.camel@laptop> <4BCC3654.2090600@redhat.com> <4BCCA281.6040509@redhat.com> <4BCD7643.4000102@redhat.com> <4BCE4153.4010801@redhat.com>
In-Reply-To: <4BCE4153.4010801@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 03:05 AM, Zachary Amsden wrote:
> On 04/19/2010 11:39 PM, Avi Kivity wrote:
>> On 04/19/2010 09:35 PM, Zachary Amsden wrote:
>>>>>> Sockets and boards too?  (IOW, how reliable is TSC_RELIABLE)?
>>>>> Not sure, IIRC we clear that when the TSC sync test fails, eg when we
>>>>> mark the tsc clocksource unusable.
>>>>
>>>> Worrying.  By the time we detect this the guest may already have 
>>>> gotten confused by clocks going backwards.
>>>
>>>
>>> Upstream, we are marking the TSC unstable preemptively when hardware 
>>> which will eventually sync test is detected, so this should be fine.
>>
>> ENOPARSE?
>>
>
> Instead of detecting TSC warp, c1e_idle, power_saving_mwait_init, 
> tsc_check_state, dmi_mark_tsc_unstable all do something similar to 
> this to disable TSC before warp even occurs:
>
> static void c1e_idle(void)
> {
>         if (need_resched())
>                 return;
>
>         if (!c1e_detected) {
>                 u32 lo, hi;
>
>                 rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
>                 if (lo & K8_INTP_C1E_ACTIVE_MASK) {
>                         c1e_detected = 1;
>                         if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
>                                 mark_tsc_unstable("TSC halt in AMD C1E");
>                         printk(KERN_INFO "System has AMD C1E enabled\n");
>                         set_cpu_cap(&boot_cpu_data, X86_FEATURE_AMDC1E);
>                 }
>         }
>
>

That works within a socket; but multiple socket machines need not feed 
all sockets from the same crystal and reset line (esp. likely for 
multiple board machines, but might even happen with single board 
FSB-less processors).

-- 
error compiling committee.c: too many arguments to function

