Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0HWQXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:23:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab0HWQXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:23:46 -0400
Message-ID: <4C72A05D.70603@redhat.com>
Date: Mon, 23 Aug 2010 19:22:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, hpa@zytor.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v5 04/12] Provide special async page fault handler when
 async PF capability is detected
References: <1279553462-7036-1-git-send-email-gleb@redhat.com> <1279553462-7036-5-git-send-email-gleb@redhat.com> <4C729865.3050409@redhat.com> <4C729937.3030605@redhat.com>
In-Reply-To: <4C729937.3030605@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/23/2010 06:52 PM, Rik van Riel wrote:
> On 08/23/2010 11:48 AM, Avi Kivity wrote:
>
>> Do you need to match cpu here as well? Or is token globally unique?
>>
>> Perhaps we should make it locally unique to remove a requirement from
>> the host to synchronize? I haven't seen how you generate it yet.
>
> If a task goes to sleep on one VCPU, but that VCPU ends
> up not being runnable later on, it would be nice to wake
> the task up on on a different VCPU.
>
> I do not remember why it is safe to send this wakeup
> event as an exception rather than an interrupt...

Wakeup could definitely be an interrupt, but the apf needs to be an 
exception so we reuse it.

>
>> The other cpu might be waiting for us to yield. We can fix it later with
>> the the pv spinlock infrastructure.
>>
>> Or, we can avoid the allocation. If at most one apf can be pending (is
>> this true?), we can use a per-cpu variable for this dummy entry.
>
> Having a limit of just one APF pending kind of defeats
> the point.

Yes.  How about, one APF pending before it is seen by the guest - but 
how can we tell without an annoying xchg?

>
> At that point, a second one of these faults would put
> the VCPU to sleep, which prevents the first task from
> running once its pagefault (which started earlier)
> completes...
>


-- 
error compiling committee.c: too many arguments to function

