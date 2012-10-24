Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab2JXPux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:50:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53060 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab2JXPuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:50:52 -0400
Message-ID: <50880E59.3000309@canonical.com>
Date: Wed, 24 Oct 2012 17:50:49 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: matt@console-pimps.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        marko.kohtala@gmail.com, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH v2] x86: efi: Turn off efi_enabled after setup on mixed
 fw/kernel
References: <1349706500.15966.165.camel@mfleming-mobl1.ger.corp.intel.com> <1351059878-28795-1-git-send-email-olof@lixom.net> <5087A999.8090802@canonical.com> <CAOesGMiB3cDMOSz+t4Mhek5+AbyoRtoJHRu+_8TL=Ob+6uPSaA@mail.gmail.com>
In-Reply-To: <CAOesGMiB3cDMOSz+t4Mhek5+AbyoRtoJHRu+_8TL=Ob+6uPSaA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 24-10-12 17:21, Olof Johansson schreef:
> Hi,
>
> On Wed, Oct 24, 2012 at 1:40 AM, Maarten Lankhorst
> <maarten.lankhorst@canonical.com> wrote:
>> Op 24-10-12 08:24, Olof Johansson schreef:
>>> When 32-bit EFI is used with 64-bit kernel (or vice versa), turn off
>>> efi_enabled once setup is done. Beyond setup, it is normally used to
>>> determine if runtime services are available and we will have none.
>>>
>>> This will resolve issues stemming from efivars modprobe panicking on a
>>> 32/64-bit setup, as well as some reboot issues on similar setups.
>>>
>>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=45991
>>>
>>> Reported-by: Marko Kohtala <marko.kohtala@gmail.com>
>>> Reported-by: Maxim Kammerer <mk@dee.su>
>>> Signed-off-by: Olof Johansson <olof@lixom.net>
>>> Cc: stable@kernel.org # 3.4 - 3.6
>>> Cc: Matthew Garrett <mjg@redhat.com>
>>> Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>> ---
>>>
>>> v2: rebase due to context diffs, and simplified efi_is_native() logic.
>>>
>>>  arch/x86/kernel/setup.c     | 11 +++++++++++
>>>  arch/x86/platform/efi/efi.c | 16 +++++++++-------
>>>  2 files changed, 20 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>>> index 468e98d..ea2c587 100644
>>> --- a/arch/x86/kernel/setup.c
>>> +++ b/arch/x86/kernel/setup.c
>>> @@ -1048,6 +1048,17 @@ void __init setup_arch(char **cmdline_p)
>>>       arch_init_ideal_nops();
>>>
>>>       register_refined_jiffies(CLOCK_TICK_RATE);
>>> +
>>> +#ifdef CONFIG_EFI
>>> +     /* Once setup is done above, disable efi_enabled on mismatched
>>> +      * firmware/kernel archtectures since there is no support for
>>> +      * runtime services.
>>> +      */
>>> +     if (IS_ENABLED(CONFIG_X86_64) != efi_64bit) {
>>> +             pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
>>> +             efi_enabled = 0;
>>> +     }
>>> +#endif
>>>  }
>> Won't this give a spurious warning if it's already disabled?
> Ah, of course, my bad. v3 forthcoming.
>
>> And it should probably be moved to before the vga con setup, else it seems you
>> might not get a vga console when efifb is not used. Unless that's intentional,
>> but in that case please change the commit message to reflect that. :-)
> Hmm. I think the current logic and flow is valid -- it's likely a bad
> idea to enable VGA console if the memory isn't set aside in the memory
> map, since that possibly means that EFI didn't POST graphics for VGA
> text mode in the first place.
>
>> With those issues fixed in next version.
>>
>> Acked-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Please confirm if you agree with my reasoning above, I'll post v3
> right after if so.
>
Ack
