Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab2BOOCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:02:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab2BOOCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:02:14 -0500
Message-ID: <4F3BBADC.7020305@redhat.com>
Date: Wed, 15 Feb 2012 16:02:04 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, riel@redhat.com, amit.shah@redhat.com,
        mtosatti@redhat.com
Subject: Re: [PATCH] BUG in pv_clock when overflow condition is detected
References: <1329157256-19926-1-git-send-email-imammedo@redhat.com> <4F3B8DC9.8040100@redhat.com> <4F3B95A5.3050704@redhat.com>
In-Reply-To: <4F3B95A5.3050704@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 01:23 PM, Igor Mammedov wrote:
>>>   static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time
>>> *shadow)
>>>   {
>>> -    u64 delta = native_read_tsc() - shadow->tsc_timestamp;
>>> +    u64 delta;
>>> +    u64 tsc = native_read_tsc();
>>> +    BUG_ON(tsc<  shadow->tsc_timestamp);
>>> +    delta = tsc - shadow->tsc_timestamp;
>>>       return pvclock_scale_delta(delta, shadow->tsc_to_nsec_mul,
>>>                      shadow->tsc_shift);
>>
>> Maybe a WARN_ON_ONCE()?  Otherwise a relatively minor hypervisor bug can
>> kill the guest.
>
>
> An attempt to print from this place is not perfect since it often leads
> to recursive calling to this very function and it hang there anyway.
> But if you insist I'll re-post it with WARN_ON_ONCE,
> It won't make much difference because guest will hang/stall due overflow
> anyway.

Won't a BUG_ON() also result in a printk?

>
> If there is an intention to keep guest functional after the event then
> maybe this patch is a way to go
>   http://www.spinics.net/lists/kvm/msg68463.html
> this way clock will be re-silent to this kind of errors, like bare-metal
> one is.

It's the same patch... do you mean something that detects the overflow
and uses the last value?

-- 
error compiling committee.c: too many arguments to function

