Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2HTV7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:59:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63169 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2HTV7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:59:43 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <50320DBD.5080507@canonical.com>
References: <1345412920-10906-1-git-send-email-olof@lixom.net>
	<50320DBD.5080507@canonical.com>
Date: Mon, 20 Aug 2012 14:59:41 -0700
Message-ID: <CAOesGMiUOfg9aNjtsah-n_k-Uqbp4veppxgU=dDUOxBGyB5PxQ@mail.gmail.com>
Subject: Re: [PATCH] x86: efi: Turn off efi_enabled after setup on mixed fw/kernel
From: Olof Johansson <olof@lixom.net>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mk@dee.su,
        Marko Kohtala <marko.kohtala@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 3:13 AM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> Hey,
>
> Op 19-08-12 23:48, Olof Johansson schreef:
>> When 32-bit EFI is used with 64-bit kernel (or vice versa), turn off
>> efi_enabled once setup is done. Beyond setup, it is normally used to
>> determine if runtime services are available and we will have none.
>>
>> This will resolve issues stemming from efivars modprobe panicking on a
>> 32/64-bit setup, as well as some reboot issues on similar setups.
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>> Cc: stable@kernel.org # 3.4 and 3.5
>> Cc: Matt Fleming <matt.fleming@intel.com>
>> Cc: Matthew Garrett <mjg@redhat.com>
>> ---
>>  arch/x86/kernel/setup.c     | 11 +++++++++++
>>  arch/x86/platform/efi/efi.c | 14 ++++++++------
>>  2 files changed, 19 insertions(+), 6 deletions(-)
>> <snip>
>>
>> +static inline bool efi_is_native(void)
>> +{
>> +     return !(IS_ENABLED(CONFIG_X86_64) ^ efi_64bit);
>> +}
>>
> Isn't this just a more complicated way of writing
> IS_ENABLED(CONFIG_X86_64) == efi_64bit ?

Ah yes, of course.

> Also moving the assignment to efi_init will make it no longer call
> efi_reserve_boot_services, I don't know if that is intentional or not,
> but something to consider at least since it's a behavioral change.

That's why I kept it in setup.c instead of masking off at the end of
efi_init(). Either way works for me since I don't have firmware that
uses boot services at all, but I didn't want to risk regressing anyone
else.

> From a quick glance with some grepping, efi reboot and efifb will
> also no longer work, is that intentional?

That's the very point of this patch, the EFI services won't work since
there are no runtime services in this state, just boot time setup. If
efi_enabled is left on, the reboot will panic.


-Olof
