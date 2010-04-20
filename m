Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab0DTPRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:17:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab0DTPRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:17:00 -0400
Message-ID: <4BCDC567.6090708@redhat.com>
Date: Tue, 20 Apr 2010 18:16:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <4BC8CA52.4090703@goop.org> <20100419142624.GE14158@mothafucka.localdomain> <4BCC829A.6000803@goop.org> <20100419182542.GI14158@mothafucka.localdomain> <20100420015733.GA28249@amt.cnet> <4BCD7557.9090502@redhat.com> <20100420125902.GJ14158@mothafucka.localdomain>
In-Reply-To: <20100420125902.GJ14158@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2010 03:59 PM, Glauber Costa wrote:
>
>> Might be due to NMIs or SMIs interrupting the rdtsc(); ktime_get()
>> operation which establishes the timeline.  We could limit it by
>> having a loop doing rdtsc(); ktime_get(); rdtsc(); and checking for
>> some bound, but it isn't worthwhile (and will break nested
>> virtualization for sure).  Better to have the option to calibrate
>> kvmclock just once on machines with
>> X86_FEATURE_NONSTOP_TRULY_RELIABLE _TSC_HONESTLY.
>>      
> For the record, we can only even do that in those machines. If we try to update
> time structures only once in machines with the
> X86_FEATURE_TSC_SAYS_IT_IS_OKAY_BUT_IN_REALITY_IS_NOT_OKAY feature flag, guests
> won't even boot.
>
> We can detect that, and besides doing calculation only once, also export some
> bit indicating that to the guest. Humm... I'm thinking now, that because of
> migration, we should check this bit every time, because we might have changed host.
> So instead of using an expensive cpuid check, we should probably use some bit in
> the vcpu_time_info structure, and use a cpuid bit just to say it is enabled.
>    

Right, we need a bit in the structure itself that says you can trust the 
time not to go backwards, and a bit in cpuid that says you can trust the 
bit in the structure (unless we can be sure no implementations leak 
garbage into the padding field).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

