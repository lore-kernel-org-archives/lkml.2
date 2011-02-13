Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1BMPUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 10:20:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab1BMPUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 10:20:25 -0500
Message-ID: <4D57F677.3090004@redhat.com>
Date: Sun, 13 Feb 2011 17:19:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 0/6] KVM support for TSC scaling
References: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 07:29 PM, Joerg Roedel wrote:
> Hi Avi, Marcelo,
>
> here is the patch-set to implement the TSC-scaling feature of upcoming
> AMD CPUs. When this feature is supported the CPU provides a new MSR
> which holds a multiplier for the hardware TSC which is applied on the
> value rdtsc[p] and reads of MSR 0x10. This feature can be used to
> emulate a given tsc frequency for the guest.
> Patch 1 is not directly related to this patch-set because it only fixes
> a bug which prevented me from testing these patches. In fact it fixes
> the same bug Andre sent a patch for. But after the discussion about his
> patch he told me to just post my patch and thus here it is.
>

Questions:
- the tsc multiplier really is a multiplier, right?  Not an addend that 
is added every cycle.

So

     wrmsr(TSC, 1e9)
     wrmsr(TSC_MULT, 2.0000)
     t = rdtsc()

will return about 2e9, not 1e9 + 2*(time to execute the code snippet) ?

- what's the cost of wrmsr(TSC_MULT)?

There are really two ways to implement this feature.  One is fully 
generic, like you did.  The other is to implement it at the host level - 
have a sysfs file and/or kernel parameter for the desired tsc frequency, 
write it once, and forget about it.  Trust management to set the host 
tsc frequency to the same value on all hosts in a migration cluster.

The advantages of the the simpler implementation are, well, that it's 
simpler, and second that it avoids two wrmsrs per exit.  We could 
combine both implementations, and have

   if (guest_mult != host_mult)
       wrmsr(TSC_MULT, guest_mult)

etc.  But I'd like to understand if there are additional motivations for 
per-guest tsc frequency.

-- 
error compiling committee.c: too many arguments to function

