Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab2EIM3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:29:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757155Ab2EIM3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:29:43 -0400
Message-ID: <4FAA630F.2000909@redhat.com>
Date: Wed, 09 May 2012 14:29:03 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, luto@mit.edu,
        suresh.b.siddha@intel.com, avi@redhat.com, johnstul@us.ibm.com,
        arjan@linux.intel.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/5] [x86]: Improve secondary CPU bring-up process robustness
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com> <1336555184.2527.6.camel@twins>
In-Reply-To: <1336555184.2527.6.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 11:19 AM, Peter Zijlstra wrote:
> On Wed, 2012-05-09 at 12:24 +0200, Igor Mammedov wrote:
>> Target audience for this patches is mostly virt. environments, where
>> physical CPUs are shared beetween many guests and on overcommited
>> host it can uncover different race conditions during secondary CPU
>> bring-up.
>
> The good news is that you're working on this, the bad news is that all
> this code is slated for the scrap heap :-)
>
> Thomas is currently in the process of doing a massive overhaul of the
> hotplug code, included in that would be the stuff you're touching.

If Thomas' rewrite is progressed well and could be completed for 3.5 then
there is no big harm in throwing this patches away. However if it's not,
it might have sense to apply these patches in 3.5 devel cycle.

Also massive rewrite would be unlikely backport candidate to stable 3.x trees,
and some of these patches might be considered as such ones.

> Every architecture does this hand-shake differently and probably buggy,
> all that needs to move into generic code. The only bits needed in the
> arch code are the cpu wakeup and initial trampoline, the rest should be
> generic.
>
> I'm not quite sure how far along he is, but it would be awesome if you
> could help him out somehow.

Sure, I could lend a hand as minimum in testing and maybe some rewriting
too if Thomas can give some part if so that we do not conflict on this.

PS:
There is still a couple hangs in 3.4-rc4+:

one looks like kvm host related, hangs when writing into apic register:
#0  native_apic_mem_write (reg=768, v=<value optimized out>) at /builds/imammedo/linux-2.6/arch/x86/include/asm/apic.h:107
#1  0xffffffff81034749 in apic_write (low=50432, id=<value optimized out>) at /builds/imammedo/linux-2.6/arch/x86/include/asm/apic.h:426
#2  native_apic_icr_write (low=50432, id=<value optimized out>) at arch/x86/kernel/apic/apic.c:273
#3  0xffffffff815a78fb in apic_icr_write (apicid=2, cpu=2) at /builds/imammedo/linux-2.6/arch/x86/include/asm/apic.h:436
#4  wakeup_secondary_cpu_via_init (apicid=2, cpu=2) at arch/x86/kernel/smpboot.c:563
#5  do_boot_cpu (apicid=2, cpu=2) at arch/x86/kernel/smpboot.c:782


And another one cannot be helped: RHBZ 816899 comment 7
https://bugzilla.redhat.com/show_bug.cgi?id=816899#c7

-- 
-----
  Igor
