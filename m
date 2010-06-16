Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab0FPIDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:03:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab0FPIDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:03:05 -0400
Message-ID: <4C188527.9040305@redhat.com>
Date: Wed, 16 Jun 2010 11:02:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Really lazy fpu
References: <1276441427-31514-1-git-send-email-avi@redhat.com> <4C187C22.2080505@redhat.com> <4C187DF1.9030007@zytor.com>
In-Reply-To: <4C187DF1.9030007@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 10:32 AM, H. Peter Anvin wrote:
> On 06/16/2010 12:24 AM, Avi Kivity wrote:
>    
>> Ingo, Peter, any feedback on this?
>>      
> Conceptually, this makes sense to me.  However, I have a concern what
> happens when a task is scheduled on another CPU, while its FPU state is
> still in registers in the original CPU.  That would seem to require
> expensive IPIs to spill the state in order for the rescheduling to
> proceed, and this could really damage performance.
>    

Right, this optimization isn't free.

I think the tradeoff is favourable since task migrations are much less 
frequent than context switches within the same cpu, can the scheduler 
experts comment?

We can also mitigate some of the IPIs if we know that we're migrating on 
the cpu we're migrating from (i.e. we're pushing tasks to another cpu, 
not pulling them from their cpu).  Is that a common case, and if so, 
where can I hook a call to unlazy_fpu() (or its new equivalent)?

Note that kvm on intel has exactly the same issue (the VMPTR and VMCS 
are on-chip registers that are expensive to load and save, so we keep 
them loaded even while not scheduled, and IPI if we notice we've 
migrated; note that architecturally the cpu can cache multiple VMCSs 
simultaneously (though I doubt they cache multiple VMCSs 
microarchitecturally at this point)).

-- 
error compiling committee.c: too many arguments to function

