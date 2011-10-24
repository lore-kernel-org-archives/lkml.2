Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab1JXEKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 00:10:14 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45741 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1JXEKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 00:10:12 -0400
MIME-Version: 1.0
In-Reply-To: <4EA4B164.4000009@oracle.com>
References: <s5hwrbvv227.wl%tiwai@suse.de>
	<4EA4B164.4000009@oracle.com>
Date: Sun, 23 Oct 2011 21:10:11 -0700
X-Google-Sender-Auth: Qd3mcTtF_RMaDUPtuwa4B6SdYVo
Message-ID: <CAE9FiQX7efVf0rtQW0NcJRjwDN=4a7nzhyfVEPKs6BvLxQwrkw@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix S4 regression
From: Yinghai Lu <yinghai@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J.Wysocki" <rjw@sisk.pl>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 5:29 PM, Yinghai Lu <yinghai.lu@oracle.com> wrote:
> On 10/23/2011 02:19 PM, Takashi Iwai wrote:
>
>> The commit 4b239f458: [x86-64, mm: Put early page table high] causes
>> a S4 regression since 2.6.39, namely the machine reboots occasionally
>> at S4 resume.  It doesn't happen always, overall rate is about 1/20.
>> But, like other bugs, once when this happens, it continues to happen.
>>
>> This patch fixes the problem by essentially reverting the memory
>> assignment in the older way.
>>
>> Cc: <stable@kernel.org>
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>
>> ---
>> I resend this as a "fix" patch now before it's forgotten and rotten.
>> It's just papering again over the mystery, but IMO better than the
>> hard-reset behavior as of now.  Unfortunately, bisection is pretty
>> much difficult because the bug itself is fairly unstable...
>
>
>
> Did you try to check several commit that Rafael pointed out:
>
>
> On Wed, Sep 28, 2011 at 12:30 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Wednesday, September 28, 2011, Takashi Iwai wrote:
>>>
>>> If my previous test -- 2.6.37+Yinghai's patches didn't show the
>>> problem -- is correct, it means that some change in 2.6.38 reacted
>>> badly with Yinghai's patches, not about 2.6.39.  I'll check tomorrow
>>> again whether this observation is really correct.
>>
>> Yes, that would be good to know, thanks for doing this!
>>
>> If that turns out to be the case, there are the following commits
>> looking like worth checking:
>>
>> d344e38 x86, nx: Mark the ACPI resume trampoline code as +x
>> 884b821 ACPI: Fix acpi_os_read_memory() and acpi_os_write_memory() (v2)
>> d551d81 ACPI / PM: Call suspend_nvs_free() earlier during resume
>> 2d6d9fd ACPI: Introduce acpi_os_ioremap()
>

Also, can you check if reverting following patch could help?

| commit e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e
| Author: Yinghai Lu <yinghai@kernel.org>
| Date:   Fri Feb 18 11:30:30 2011 +0000
|
|    x86: Cleanup highmap after brk is concluded
|
|    Now cleanup_highmap actually is in two steps: one is early in head64.c
|    and only clears above _end; a second one is in init_memory_mapping() and
|    tries to clean from _brk_end to _end.
|    It should check if those boundaries are PMD_SIZE aligned but currently
|    does not.
|    Also init_memory_mapping() is called several times for numa or memory
|    hotplug, so we really should not handle initial kernel mappings there.
|
|   This patch moves cleanup_highmap() down after _brk_end is settled so
|    we can do everything in one step.
|    Also we honor max_pfn_mapped in the implementation of cleanup_highmap.

Thanks

Yinghai Lu
