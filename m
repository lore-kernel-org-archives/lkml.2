Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab2BULgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 06:36:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab2BULgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 06:36:04 -0500
Message-ID: <4F43818E.4010407@redhat.com>
Date: Tue, 21 Feb 2012 12:35:42 +0100
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, riel@redhat.com, amit shah <amit.shah@redhat.com>,
        mtosatti@redhat.com, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com
Subject: Re: [PATCH] BUG in pv_clock when overflow condition is detected
References: <28a9ca8a-4696-4c9c-bd15-f2fa5558740e@zmail16.collab.prod.int.phx2.redhat.com> <4F3D0CB1.5070707@redhat.com> <4F3E7150.7000804@redhat.com> <20120220152855.GA25535@phenom.dumpdata.com>
In-Reply-To: <20120220152855.GA25535@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 04:28 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Feb 17, 2012 at 04:25:04PM +0100, Igor Mammedov wrote:
>> On 02/16/2012 03:03 PM, Avi Kivity wrote:
>>> On 02/15/2012 07:18 PM, Igor Mammedov wrote:
>>>>> On 02/15/2012 01:23 PM, Igor Mammedov wrote:
>>>>>>>>    static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time
>>>>>>>> *shadow)
>>>>>>>>    {
>>>>>>>> -    u64 delta = native_read_tsc() - shadow->tsc_timestamp;
>>>>>>>> +    u64 delta;
>>>>>>>> +    u64 tsc = native_read_tsc();
>>>>>>>> +    BUG_ON(tsc<    shadow->tsc_timestamp);
>>>>>>>> +    delta = tsc - shadow->tsc_timestamp;
>>>>>>>>        return pvclock_scale_delta(delta, shadow->tsc_to_nsec_mul,
>>>>>>>>                       shadow->tsc_shift);
>>>>>>>
>>>>>>> Maybe a WARN_ON_ONCE()?  Otherwise a relatively minor hypervisor
>>>>>>> bug can
>>>>>>> kill the guest.
>>>>>>
>>>>>>
>>>>>> An attempt to print from this place is not perfect since it often
>>>>>> leads
>>>>>> to recursive calling to this very function and it hang there
>>>>>> anyway.
>>>>>> But if you insist I'll re-post it with WARN_ON_ONCE,
>>>>>> It won't make much difference because guest will hang/stall due
>>>>>> overflow
>>>>>> anyway.
>>>>>
>>>>> Won't a BUG_ON() also result in a printk?
>>>> Yes, it will. But stack will still keep failure point and poking
>>>> with crash/gdb at core will always show where it's BUGged.
>>>>
>>>> In case it manages to print dump somehow (saw it couple times from ~
>>>> 30 test cycles), logs from console or from kernel message buffer
>>>> (again poking with gdb) will show where it was called from.
>>>>
>>>> If WARN* is used, it will still totaly screwup clock and
>>>> "last value" and system will become unusable, requiring looking with
>>>> gdb/crash at the core any way.
>>>>
>>>> So I've just used more stable failure point that will leave trace
>>>> everywhere it manages (maybe in console log, but for sure in stack)
>>>> in case of WARN it might leave trace on console or not and probably
>>>> won't reflect failure point in stack either leaving only kernel
>>>> message buffer for clue.
>>>>
>>>
>>> Makes sense.  But do get an ack from the Xen people to ensure this
>>> doesn't break for them.
>>>
>> Konrad, Ian
>>
>> Could you please review patch form point of view of xen?
>> Whole thread could be found here https://lkml.org/lkml/2012/2/13/286
>
> What are the conditions under which this happens?
> You should probably include that in the git description as well?
This happens on cpu hot-plug in kvm guest:
https://lkml.org/lkml/2012/2/7/222

It probably doesn't affect xen pv guest but issue might affect hvm one.
I'm certainly not xen expert to say it for sure after a cursory look
at the code. If you can confirm that it affects xen hvm I will write
early_percpu_clock_init patch for it as well.

> Is this something that happens often?
Very seldom and unlikely.

> Hm, so are you asking for review for this patch
I was asking for review of subj patch
   "BUG in pv_clock when overflow condition is detected"
I'll update patch description and re-spin it.

>  If there is an overflow can you synthesize a value instead of
> crashing the guest?
> or for http://www.spinics.net/lists/kvm/msg68440.html ?
Probably could, but there was argument that it is fixing the symptoms
and not the root cause. It seems that you've already found patch that
proposes this "pvclock: Make pv_clock more robust and fixup it if overflow happens"

>
> (which would also entail a early_percpu_clock_init implementation
> in the Xen code naturally).
>

-- 
Thanks,
  Igor
