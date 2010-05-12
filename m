Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab0ELJC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:02:26 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30268 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0ELJCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:02:24 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 12 May 2010 11:02:50 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
In-reply-to: <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
To: Viral Mehta <Viral.Mehta@lntinfotech.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <op.vck4q0c87p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Michal Nazarewicz [m.nazarewicz@samsung.com]
>> In to places in fsg_common_init() an unconditional call to kfree()
>> on common was performed in error recovery which is not a valid

On Wed, 12 May 2010 10:29:02 +0200, Viral Mehta <Viral.Mehta@lntinfotech.com> wrote:
> If I am not wrong, common can not be NULL since it was already checked above.
>
> 2685         if (!common) {
> 2686                 common = kzalloc(sizeof *common, GFP_KERNEL);
> 2687                 if (!common)
> 2688                         return ERR_PTR(-ENOMEM);
> 2689                 common->free_storage_on_release = 1;

That is correct but it is not the issue.

fsg_common_init() as a first argument takes a pointer to a fsg_common
structure which, if not NULL, is reused and it is then assumed that
caller is responsible far maintaining allocation and deallocation of
this structure.

The idea is that one can do:

static struct fsg_common fsg_common;
/* ... */
fsg_common_init(&fsg_common, cdev, fsg_config);

or allocate fsg_common structure as a part of a larger structure.  In such
cases kfree() cannot be called on the object.  Which case we are dealing
with is indicated by the common->free_storage_on_release flag.
fsg_common_release() consults it and either calls or does not call krfee().

>> behaviour since fsg_common structure is not always allocated by
>> fsg_common_init().
>>
>> To fix, the calls has been replaced with a goto to a proper error
>> recovery which does the correct thing.

Uh, I've just noticed I forgot about the:

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
