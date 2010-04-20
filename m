Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0DTJfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 05:35:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab0DTJfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 05:35:23 -0400
Message-ID: <4BCD7557.9090502@redhat.com>
Date: Tue, 20 Apr 2010 12:35:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <4BC8CA52.4090703@goop.org> <20100419142624.GE14158@mothafucka.localdomain> <4BCC829A.6000803@goop.org> <20100419182542.GI14158@mothafucka.localdomain> <20100420015733.GA28249@amt.cnet>
In-Reply-To: <20100420015733.GA28249@amt.cnet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2010 04:57 AM, Marcelo Tosatti wrote:
>
>> Marcelo can probably confirm it, but he has a nehalem with an appearently
>> very good tsc source. Even this machine warps.
>>
>> It stops warping if we only write pvclock data structure once and forget it,
>> (which only updated tsc_timestamp once), according to him.
>>      
> Yes. So its not as if the guest visible TSCs go out of sync (they don't
> on this machine Glauber mentioned, or even on a multi-core Core 2 Duo),
> but the delta calculation is very hard (if not impossible) to get right.
>
> The timewarps i've seen were in the 0-200ns range, and very rare (once
> every 10 minutes or so).
>    

Might be due to NMIs or SMIs interrupting the rdtsc(); ktime_get() 
operation which establishes the timeline.  We could limit it by having a 
loop doing rdtsc(); ktime_get(); rdtsc(); and checking for some bound, 
but it isn't worthwhile (and will break nested virtualization for 
sure).  Better to have the option to calibrate kvmclock just once on 
machines with X86_FEATURE_NONSTOP_TRULY_RELIABLE _TSC_HONESTLY.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

