Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab2CHSeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:34:16 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35173 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab2CHSeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:34:15 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6643"; a="168420181"
Message-ID: <4F58FBA6.60509@codeaurora.org>
Date: Thu, 08 Mar 2012 10:34:14 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH] staging: ram_console: Fix section mismatches
References: <1331170478-30538-1-git-send-email-john.stultz@linaro.org> <1331197684-9163-1-git-send-email-sboyd@codeaurora.org> <20120308175645.GA22682@kroah.com> <4F58F677.8030102@codeaurora.org> <20120308182349.GB32187@kroah.com>
In-Reply-To: <20120308182349.GB32187@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/12 10:23, Greg KH wrote:
> On Thu, Mar 08, 2012 at 10:12:07AM -0800, Stephen Boyd wrote:
>> On 03/08/12 09:56, Greg KH wrote:
>>> On Thu, Mar 08, 2012 at 01:08:04AM -0800, Stephen Boyd wrote:
>>>> WARNING: vmlinux.o(.text+0x25d5fc): Section mismatch in reference
>>>> from the function ram_console_driver_probe() to the function
>>>> .init.text:ram_console_init()
>>>> The function ram_console_driver_probe() references
>>>> the function __init ram_console_init().
>>>> This is often because ram_console_driver_probe lacks a __init
>>>> annotation or the annotation of ram_console_init is wrong.
>>>>
>>>> Mark ram_console_driver_probe() as __devinit because it's a probe
>>>> function and propagate the __devinit markings to the __init
>>>> functions the probe calls.
>>> What .config configuration causes this to happen?  I don't see this here
>>> in my builds, what am I doing wrong?
>>>
>> #
>> # Android
>> #
>> CONFIG_ANDROID=y
>> # CONFIG_ANDROID_BINDER_IPC is not set
>> # CONFIG_ASHMEM is not set
>> # CONFIG_ANDROID_LOGGER is not set
>> CONFIG_ANDROID_RAM_CONSOLE=y
>> # CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION is not set
>> # CONFIG_ANDROID_TIMED_OUTPUT is not set
>> # CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
>> # CONFIG_ANDROID_SWITCH is not set
>> # CONFIG_PHONE is not set
>>
>>
>> Perhaps you're missing this patch if you're on an ARM compiler?
>>
>> 6e2e340 (ARM: 7324/1: modpost: Fix section warnings for ARM for many
>> compilers, 2012-02-14)
> Nope, I'm building this on x86-64 which warns on this type of thing all
> the time.
>
> My .config looks like this:
>
> #
> # Android
> #
> CONFIG_ANDROID=y
> CONFIG_ANDROID_BINDER_IPC=y
> CONFIG_ASHMEM=y
> CONFIG_ANDROID_LOGGER=m
> CONFIG_ANDROID_PERSISTENT_RAM=y
> CONFIG_ANDROID_RAM_CONSOLE=y
> CONFIG_ANDROID_TIMED_OUTPUT=y
> # CONFIG_ANDROID_TIMED_GPIO is not set
> CONFIG_ANDROID_LOW_MEMORY_KILLER=y
> CONFIG_ANDROID_SWITCH=m
> CONFIG_ANDROID_SWITCH_GPIO=m
> CONFIG_ANDROID_INTF_ALARM=y
> CONFIG_ANDROID_INTF_ALARM_DEV=y
> CONFIG_ANDROID_ALARM_OLDDRV_COMPAT=y
>
> And I can't duplicate this at all.  Could the recent fixes that John
> sent me be the reason?  Or something else?
>

This patch is based on your staging-next branch at c5ee121 (staging:
android: ram_console: drop verbose ram_console support, 2012-03-07). It
applied that ARM patch on top because I'm compiling with ARM.

It looks like aggressive inlining by the x86 compiler hides this from
you. I see that if I mark ram_console_init() as noinline

diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
index 73215e2..c468fa2 100644
--- a/drivers/staging/android/ram_console.c
+++ b/drivers/staging/android/ram_console.c
@@ -205,7 +205,7 @@ ram_console_save_old(struct ram_console_buffer *buffer, char *dest)
               &buffer->data[0], buffer->start);
 }
 
-static int __init ram_console_init(struct ram_console_buffer *buffer,
+static noinline int __init ram_console_init(struct ram_console_buffer *buffer,
                                   size_t buffer_size, char *old_buf)
 {
 #ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION


then I see the section mismatch when compiling on x86. Otherwise I don't
see anything. Is there a bug in the section mismatch detection with
respect to compiler inlining?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

