Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1KUSLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:11:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58723 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab1KUSLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:11:02 -0500
MIME-Version: 1.0
In-Reply-To: <4EC77605.5090605@gmail.com>
References: <1321644698-13677-1-git-send-email-keescook@chromium.org>
	<1321644698-13677-3-git-send-email-keescook@chromium.org>
	<4EC77605.5090605@gmail.com>
Date: Mon, 21 Nov 2011 10:11:00 -0800
X-Google-Sender-Auth: 8npzLKY3FCum-ssBOLhj1JEPYX0
Message-ID: <CAGXu5j+Dh2jbAymcreOwX_T6=7FA8bOuwUFnwshdsVonAD5_EA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ramoops: remove module parameters
From: Kees Cook <keescook@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 1:25 AM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> Il 18/11/2011 20:31, Kees Cook ha scritto:
>>
>> The ramoops driver is intended to be used with platforms that define
>> persistent memory regions. If memory regions were configurable with
>> module parameters, it would be possible to read some RAM regions via
>> the pstore interface without access to /dev/mem (which would result
>> in a loss of kernel memory privacy when a system is built with
>> STRICT_DEVMEM), so remove this ability completely.
>>
>
> I don't like it very much. The loss of module parameters give us less
> flexibility. The main goal of this driver is debug, so I think it should be
> fast to use. I mean it's not more possible reserve a memory region and load
> the module "on-the-fly", it needs a platform device, it's ok but I think
> it's a little bit more complicated, (without talking about platforms without
> a device tree source).
> I don't understand the problem of strict devmem. We shouldn't use kernel
> memory region but only reserved ones and the driver doesn't use the
> request_mem_region_exclusive, am I wrong?

Hmmm, maybe I'm reading it backwards, but I think we want it to use
..._exclusive().

int devmem_is_allowed(unsigned long pagenr)
{
        if (pagenr <= 256)
                return 1;
        if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
                return 0;
        if (!page_is_ram(pagenr))
                return 1;
        return 0;
}

If the region is exclusive, access is not allowed (return 0). ramoops
currently uses request_mem_region() instead of
request_mem_region_exclusive(). If we made that switch, I think I'd be
happy. Would this create some problem I'm not seeing?

-Kees

-- 
Kees Cook
ChromeOS Security
