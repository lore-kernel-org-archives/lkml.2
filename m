Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507Ab2CNVCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:02:46 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:47460 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877Ab2CNVCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:02:45 -0400
X-Greylist: delayed 2641 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2012 17:02:45 EDT
Message-ID: <4F60FD0A.5090103@numascale.com>
Date: Wed, 14 Mar 2012 21:18:18 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH] Move APIC ID validity check into platform APIC code
References: <1331680589.18900.76.camel@sbsiddha-desk.sc.intel.com> <1331709454-27966-1-git-send-email-daniel@numascale-asia.com> <CAE9FiQX_o8GXqi1A+LTE4pseb81d1Aj5zR49NBvJiyAx24yYfw@mail.gmail.com>
In-Reply-To: <CAE9FiQX_o8GXqi1A+LTE4pseb81d1Aj5zR49NBvJiyAx24yYfw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/2012 18:58, Yinghai Lu wrote:
> On Wed, Mar 14, 2012 at 12:17 AM, Daniel J Blueman
[]
>
> can you check if you can update
>
> !cpu_has_x2apic&&  (apic_id>= 0xff)&&  enabled
>
> in arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic()
>
> to use some kind of apic_id_valid()
>
> so you could avoid setting that feature bit.
>
> the checking in SRAT could be removed.
>

Yinghai/Team,

One question (as I don't really know *why* this was added to the 
acpi/srat parsing code). In arch/x86/kernel/smpboot.c the check was 
originally :

!x2apic_mode && apicid >= 255

However in arch/x86/kernel/acpi/boot.c and arch/x86/mm/srat.c these 
tests are used :

!cpu_has_x2apic && (apic_id >= 0xff)

Clearly, "cpu_has_x2apic" and "x2apic_mode" are two different things.

Since we can force "cpu_has_x2apic", when Daniel crafted this patch he 
made the following "default" function :

static inline int default_apic_id_valid(int apicid)
{
	return x2apic_mode || (apicid < 255);
}

which, as you can see, checks against "x2apic_mode".

My question is; Is checking for "x2apic_mode" going to do the trick in 
the arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic() ?

If the answer is yes, the patch is going to be very simple. But we can't 
verify that the code in arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic() 
actually triggers for the case you wanted it to trigger for because then 
it will check against "x2apic_mode" and not "cpu_has_x2apic".

Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
