Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab2HGHOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:14:15 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49199 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2HGHON (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Tue, 7 Aug 2012 03:14:13 -0400
Message-Id: <5020DC5F02000078000931C2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 07 Aug 2012 08:14:07 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "=?UTF-8?B?SsOpcsO0bWVDYXJyZXRlcm8=?=" <cJ-ko@zougloub.eu>
Cc: "Ingo Molnar" <mingo@kernel.org>,
        "Matt Fleming" <matt.fleming@linux.intel.com>,
        "Matthew Garrett" <mjg59@srcf.ucam.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "H. PeterAnvin" <hpa@zytor.com>
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform
 wall clock" prevents my machine from booting
References: <20120805172903.5f8bb24c@zougloub.eu>
 <501EF3A2.20200@zytor.com> <501F83F20200007800092C1C@nat28.tlf.novell.com>
 <20120806125216.GA11863@srcf.ucam.org>
 <501FDDD30200007800092DDE@nat28.tlf.novell.com>
 <20120806091627.2ad5ed2e@zougloub.eu>
 <20120806223208.5301be0d@zougloub.eu>
 <20120806230629.153d33bd@zougloub.eu>
In-Reply-To: <20120806230629.153d33bd@zougloub.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.08.12 at 05:06, JérômeCarretero <cJ-ko@zougloub.eu> wrote:
> On Mon, 6 Aug 2012 22:32:08 -0400
> Jérôme Carretero <cJ-ko@zougloub.eu> wrote:
> 
>> For troubleshooting purposes I edited over your patch.
>> So far:
>> [...]
>> Maybe I can get more...
> 
> With the following:
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 2dc29f5..46729f3 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -97,8 +97,9 @@ static efi_status_t virt_efi_get_time(efi_time_t *tm, 
> efi_time_cap_t *tc)
>         unsigned long flags;
>         efi_status_t status;
>  
> +       printk("%s: get_time=0x%p\n", __func__, 
> efi.systab->runtime->get_time);
>         spin_lock_irqsave(&rtc_lock, flags);
> -       status = efi_call_virt2(get_time, tm, tc);
> +       status = EFI_SUCCESS + 1;// efi_call_virt2(get_time, tm, tc);
>         spin_unlock_irqrestore(&rtc_lock, flags);
>         return status;
>  }
> @@ -270,8 +271,10 @@ static unsigned long efi_get_time(void)
>         efi_time_cap_t cap;
>  
>         status = efi.get_time(&eft, &cap);
> -       if (status != EFI_SUCCESS)
> -               pr_err("Oops: efitime: can't read time!\n");
> +       if (status != EFI_SUCCESS) {
> +               /* fall back to RTC time */
> +               return mach_get_cmos_time();
> +       }
>  
>         return mktime(eft.year, eft.month, eft.day, eft.hour,
>                       eft.minute, eft.second);
> 
> The system boots, at that point...

That's not surprising. The question really is what goes wrong
when the call is being made - page fault, some other fault, or
silent hang. A page fault would point to an incorrect memory
map as the prime candidate for causing the problem. My
primary suspect would be #NM, i.e. the implementation using
floating point (SSE to be precise) instructions when they're
unavailable.

> I would say my BIOS is broken,
> but it can be expected that others can have the same issue.

Likely. The question is whether we could make Linux be spec
compliant on sane systems _and_ tolerate broken ones like
this. But whether e.g. adding a command line option (or DMI-
based quirk) is appropriate depends on whether this really is
a firmware issue or a flaw in the patch.

Jan
