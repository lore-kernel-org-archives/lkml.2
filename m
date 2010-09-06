Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab0IFMJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:09:44 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:35191 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab0IFMJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:09:43 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zzbb2dK1432N98dN148cM9371Pzz1202hzz8275bhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L8BR0F-02-F6Y-02
X-M-MSG: 
Message-ID: <4C84D903.6010104@amd.com>
Date: Mon, 6 Sep 2010 14:05:23 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090820)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] x86: Fix allowed CPUID bits for KVM guests
References: <1283506069-1096-1-git-send-email-andre.przywara@amd.com> <1283506069-1096-4-git-send-email-andre.przywara@amd.com> <4C8350C5.7050302@redhat.com>
In-Reply-To: <4C8350C5.7050302@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>   On 09/03/2010 12:27 PM, Andre Przywara wrote:
>> The AMD extension to AVX (FMA4, XOP) work on the same YMM register set
>> as AVX, so they are safe for guests to use, as long as AVX itself
>> is allowed.
>>
>> Signed-off-by: Andre Przywara<andre.przywara@amd.com>
>> ---
>>   arch/x86/kvm/x86.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 3a09c62..eb89e7b 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1996,8 +1996,8 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>>   	const u32 kvm_supported_word6_x86_features =
>>   		F(LAHF_LM) | F(CMP_LEGACY) | F(SVM) | 0 /* ExtApicSpace */ |
>>   		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
>> -		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(SSE5) |
>> -		0 /* SKINIT */ | 0 /* WDT */;
>> +		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(XOP) |
>> +		0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM);
>>
> 
> Should be folded into patch 1 to avoid build breakage.
Right you are. Thanks for spotting this. I fixed that and will sent out 
a version 2 later.
> 
> Did we really enable "sse5" before xsave?  That looks broken, but I 
> guess no real harm if xsave itself is not enabled.
Yes. It somehow slipped through when you introduced the other feature 
flags to KVM. I also think this is not a serious problem.
BTW: I realized that AES is currently denied. Reading the manual I see 
that it operates on SSE registers, so it should be safe to be passed 
through. The only drawback is that it would change the visible CPUID on 
CPUs that already have AES, whereas earlier KVM versions did hide it. 
This could become a problem with migration. But if you agree, I'd 
integrate this flag in the v2 series.

Regards,
Andre.



-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany
Tel: +49 351 448-3567-12

