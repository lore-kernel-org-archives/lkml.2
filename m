Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab1EUUBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 16:01:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:16622 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab1EUUBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 16:01:52 -0400
X-ExtLoop1: 1
From: "Anvin, H Peter" <h.peter.anvin@intel.com>
To: "'hjl.tools@gmail.com'" <hjl.tools@gmail.com>
CC: "'x32-abi@googlegroups.com'" <x32-abi@googlegroups.com>,
        "'arnd@arndb.de'" <arnd@arndb.de>,
        "'gcc@gcc.gnu.org'" <gcc@gcc.gnu.org>,
        "'libc-alpha@sourceware.org'" <libc-alpha@sourceware.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Sat, 21 May 2011 13:01:51 -0700
Subject: RE: X32 project status update
Thread-Topic: X32 project status update
Thread-Index: AcwX7sJqIBlES0zzQaOFemcLbnJOrAAAynXX
Message-ID: <ADDEBCD9C145E542A8688C29F1FBDCB9012FD2C719@orsmsx502.amr.corp.intel.com>
References: <BANLkTinM_=bAjD59=GiKtTvjLtoOs7KCFA@mail.gmail.com>
	<201105211727.35985.arnd@arndb.de>
	<BANLkTi=tdfG3jpCJQpozpxjBmR7ZicgV9g@mail.gmail.com>
	<BANLkTikyg-SDtU9Z8KdCAeOkGR67ihVUkQ@mail.gmail.com>
	<4DD80A91.5070302@intel.com>
In-Reply-To: <4DD80A91.5070302@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
domainkey-signature: a=rsa-sha1; c=nofws;        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=H/3QpTuhhtbXekQlwfvZ4WqM4H+I7XLZYU5O0lHJbym5mf+/Q0uIqvcQOXE6Fy1C13
         2zzhI08KktWnS9aWNYgWhrudqT9MnJLSzkcDLpPWOp3Gfyqe8Y5hiiEwyeUXqvHeyNAk
         Btyj4rW4L6k1RHu8Gdgw/wtpXub4sSe1LQItY=
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4LK25Wj021847

I'll look at it but possibly not until the weekend.

-----Original Message-----
From: H.J. Lu [hjl.tools@gmail.com<mailto:hjl.tools@gmail.com>]
Sent: Saturday, May 21, 2011 12:39 PM Pacific Standard Time
To: Anvin, H Peter
Cc: x32-abi@googlegroups.com; Arnd Bergmann; GCC Development; GNU C Library; LKML
Subject: Re: X32 project status update


On Sat, May 21, 2011 at 11:55 AM, H. Peter Anvin
<h.peter.anvin@intel.com> wrote:
> On 05/21/2011 09:27 AM, H.J. Lu wrote:
>> On Sat, May 21, 2011 at 8:34 AM, H.J. Lu <hjl.tools@gmail.com> wrote:
>>> On Sat, May 21, 2011 at 8:27 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>> On Saturday 21 May 2011 17:01:33 H.J. Lu wrote:
>>>>> This is the x32 project status update:
>>>>>
>>>>> https://sites.google.com/site/x32abi/
>>>>>
>>>>
>>>> I've had another look at the kernel patch. It basically
>>>> looks all good, but the system call table appears to
>>>> diverge from the x86_64 list for no (documented) reason,
>>>> in the calls above 302. Is that intentional?
>>>>
>>>> I can see why you might want to keep the numbers identical,
>>>> but if they are already different, why not use the generic
>>>> system call table from asm-generic/unistd.h for the new
>>>> ABI?
>>>
>>> We can sort it out when we start merging x32 kernel changes.
>>>
>>
>> Peter, is that possible to use the single syscall table for
>> both x86-64 and x32 system calls? Out of 300+ system
>> calls, only 84 are different for x86-64 and x32.  That
>> is additional 8*84 == 672 bytes in syscall table.
>>
>
> Sort of... remember we talked about merging system calls at the tail
> end?  The problem with that is that some system calls (like read()!)
> actually are different system calls in very subtle situations, due to
> abuse in some subsystems of the is_compat() construct.  I think that may
> mean we have to have an unambiguous flag after all...
>
> Now, perhaps we can use a high bit for that and mask it before dispatch,
> then we don't need the additional table.  A bit of a hack, but it should
> work.

How about this patch?

   Merge x32 system calls with x86-64 system calls

    Implemented with

    1. Mark all x86-64 specific system calls with __NR_64_.
    2. Mark all x32 specific system calls with __NR_x32_.
    3. Include unistd_64_compat.h, instead of unistd_x32.h for kernel
    build, which provides __NR_ versions of x86-64 specific system calls.
    4. Append x32 specific system calls after the current x86-64 system
    calls.
    5. Generate unistd_x32.h from unistd_64.h, replacing __NR_x32_ with
    _NR_.
    6. Install user-space unistd_64.h, replacing __NR_64_ with _NR_.

--
H.J.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
