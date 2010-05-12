Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0ELJxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:53:23 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19274 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab0ELJxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:53:20 -0400
Date: Wed, 12 May 2010 11:53:45 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
In-reply-to: <70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>
To: Viral Mehta <Viral.Mehta@lntinfotech.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <op.vck63vc77p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck4q0c87p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> fsg_common_init() as a first argument takes a pointer to a fsg_common
>> structure which, if not NULL, is reused and it is then assumed that
>> caller is responsible far maintaining allocation and deallocation of
>> this structure.
>>
>> The idea is that one can do:
>>
>> static struct fsg_common fsg_common;
>> /* ... */
>> fsg_common_init(&fsg_common, cdev, fsg_config);
>>
>> or allocate fsg_common structure as a part of a larger structure.  In such
>> cases kfree() cannot be called on the object.  Which case we are dealing
>> with is indicated by the common->free_storage_on_release flag.
>> fsg_common_release() consults it and either calls or does not call krfee().

On Wed, 12 May 2010 11:28:31 +0200, Viral Mehta <Viral.Mehta@lntinfotech.com> wrote:
> Oh, makes sense. All instances has fsg_common_init(0, ...) and so i just missed...

I'm preparing a some patches for g_multi which change that.

Also, a change for g_mass_storage which uses a static memory would be like 10 line
patch which I may submit later.

> But, still the central idea was, why should we go to whole error_release path which
> really does removing device file and closing luns and etc.
> However, it will not make any difference since curlun->nluns will be zero and so
> there will be no loop in fsg_common_releas() function.

The way I see it, it does not matter that much -- it's error recovery so we assume
it's unlikely to happen and as such speed optimisation is not really needed here --
it's better to optimise for space and minimise the number of possible paths.

> Apart from that, IMHO,
> 2894         kfree(common->luns);
> should crash in case if your error path is followed.
>
> common->luns is allocd
> 2712         /* Create the LUNs, open their backing files, and register the
> 2713          * LUN devices in sysfs. */
> 2714         curlun = kzalloc(nluns * sizeof *curlun, GFP_KERNEL);
> 2715         if (!curlun) {
> 2716                 kfree(common);
> 2717                 return ERR_PTR(-ENOMEM);
> 2718         }

Yes, that's why the submitted patch changes that to "rc = -ENOMEM;
goto errer_release;".

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
