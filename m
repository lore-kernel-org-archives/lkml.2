Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412Ab1ETSLC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:11:02 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:15312 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933309Ab1ETSLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:11:01 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zzbb2dK9371Oc3f2M1432N98dKzz1202hzz8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLIAI5-01-OEM-02
X-M-MSG: 
Message-ID: <4DD6AEA5.7020003@amd.com>
Date: Fri, 20 May 2011 14:10:45 -0400
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Borislav Petkov <bp@amd64.org>, Greg Kroah-Hartman <greg@kroah.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] AMD ARAT fixes
References: <1305636919-31165-1-git-send-email-bp@amd64.org>	<20110518155017.GA14324@gere.osrc.amd.com> <20110520103746.70caaf3c@katamari>
In-Reply-To: <20110520103746.70caaf3c@katamari>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2011 10:37 AM, Chuck Ebbert wrote:
> On Wed, 18 May 2011 17:50:17 +0200
> Borislav Petkov<bp@amd64.org>  wrote:
>
>> Hi Greg,
>>
>> Ingo just confirmed that the following two fixes went upstream. I
>> haven't tagged them for stable so I'd appreciate if you could take them
>> for the next cycle. AFAICT, the relevant trees should be .38-stable,
>> 32-longterm and 33-longterm.
>>
>> There should be no problem cherry-picking them but if there is, please
>> let me know and I'll give you rebased versions.
>>
>> Here the commit ids again, for reference:
>>
>> http://git.kernel.org/tip/14fb57dccb6e1defe9f89a66f548fcb24c374c1d
>> http://git.kernel.org/tip/328935e6348c6a7cb34798a68c326f4b8372e68a
>>
>
> This still leaves family 10h model 6 stepping 2 (and possibly others)
> broken in -stable as well as 2.6.39.
>
> Looking at -stable, this whole mess was caused by:
>
>    commit b87cf80af3ba4b4c008b4face3c68d604e1715c6
>    x86, AMD: Set ARAT feature on AMD processors
>
> That caused stalls on family 0fh and family 10h processors, and then
> the (partial) fix for that in 2.6.38.6:
>
>    commit e20a2d205c05cef6b5783df339a7d54adeb50962
>    x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors
>
> caused instant crashes on boot on older family 0fh processors.
>
> Now it looks like family 0fh is finally fixed in 2.6.38.7.
>
> But I can't find any reason for the original commit that went in 2.6.38.4
> to be there in the first place. It doesn't fix any bug whatsoever and
> appears to be just a performance enhancement. So how did it get there?
>
> I came up with this (untested) hack for now to fix the remaining bug,
> should something like this go in -stable to fix family 10h until a
> better way is found?


There will be a fix for this, hopefully next week. We need to do more 
testing, which is why it's been taking longer than it should.

-boris


>
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -724,6 +724,15 @@ bool cpu_has_amd_erratum(const int *erra
>   		return false;
>
>   	/*
> +	 * Temporary workaround for ARAT bug on Sempron.
> +	 * The BIOS clears the bit in OSVW, so the check
> +	 * fails, then ARAT gets set and when the processor
> +	 * uses C3 it hangs. Always return true for that CPU.
> +	 */
> +	if (cpu->x86 == 0x10&&  cpu->x86_model == 6&&  cpu->x86_mask == 2)
> +		return true;
> +
> +	/*
>   	 * Must match family-model-stepping range first so that the
>   	 * range checks will override OSVW checking.
>   	 */
>


