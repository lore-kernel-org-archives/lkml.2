Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab0DCRon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 13:44:43 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39447 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab0DCRoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 13:44:37 -0400
To: Joerg Roedel <joro@8bytes.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>,
       nhorman@redhat.com, nhorman@tuxdriver.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
References: <20100403012751.834020949@sous-sol.org>
	<20100403012820.229410717@sous-sol.org>
	<20100403172224.GO24846@8bytes.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 03 Apr 2010 10:44:22 -0700
In-Reply-To: <20100403172224.GO24846@8bytes.org> (Joerg Roedel's message of "Sat\, 3 Apr 2010 19\:22\:24 +0200")
Message-ID: <m18w94l9c9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: joro@8bytes.org, vgoyal@redhat.com, iommu@lists.linux-foundation.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, nhorman@tuxdriver.com, nhorman@redhat.com, joerg.roedel@amd.com, chrisw@sous-sol.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:

> On Fri, Apr 02, 2010 at 06:27:54PM -0700, Chris Wright wrote:
>> This effectively reverts commit 61d047be99757fd9b0af900d7abce9a13a337488.
>> 
>> Disabling the IOMMU can potetially allow DMA transactions to
>> complete without being translated.  Leave it enabled, and allow
>> crash kernel to do the IOMMU reinitialization properly.
>> 
>> Cc: Joerg Roedel <joerg.roedel@amd.com>
>> Cc: Eric Biederman <ebiederm@xmission.com>
>> Cc: Neil Horman <nhorman@tuxdriver.com>
>> Cc: Vivek Goyal <vgoyal@redhat.com>
>> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
>> ---
>>  arch/x86/kernel/crash.c |    6 ------
>>  1 file changed, 6 deletions(-)
>> 
>> --- a/arch/x86/kernel/crash.c
>> +++ b/arch/x86/kernel/crash.c
>> @@ -27,7 +27,6 @@
>>  #include <asm/cpu.h>
>>  #include <asm/reboot.h>
>>  #include <asm/virtext.h>
>> -#include <asm/x86_init.h>
>>  
>>  #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
>>  
>> @@ -103,10 +102,5 @@ void native_machine_crash_shutdown(struc
>>  #ifdef CONFIG_HPET_TIMER
>>  	hpet_disable();
>>  #endif
>> -
>> -#ifdef CONFIG_X86_64
>> -	x86_platform.iommu_shutdown();
>> -#endif
>> -
>>  	crash_save_cpu(regs, safe_smp_processor_id());
>
> Hmm, I think for this we need to change the gart code too and disable
> the gart before its initialization runs to not re-introduce issues fixed
> in commit bc2cea6a34fdb30f118ec75db39a46a191870607, no?

That is a different code path with a different set of assumptions and
restrictions.  On a normal kexec of course we want to do an orderly shutdown.

For the gart with a little luck we can just ignore it on kexec on
panic.  Unlike a virtualization capable iommu it doesn't prevent access
to devices, when it is enabled.   Worst case is that we have to start
including iommu=off for gart systems. The best case is that we can
figure out how to have the gart code reinitialize itself sanely,
starting from some arbitrary point.

machine_crash_shutdown is about doing those things that we can not do
in any other way.

Eric
