Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030532Ab2B2AYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:24:37 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:38362 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757116Ab2B2AYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:24:36 -0500
Message-ID: <4F4D704A.7040508@xenotime.net>
Date: Tue, 28 Feb 2012 16:24:42 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Build regressions/improvements in v3.3-rc5 (C lang questions)
References: <1330462222-25201-1-git-send-email-geert@linux-m68k.org> <4F4D663D.2040100@xenotime.net> <CA+55aFzzfuiu-ScRmRFYWDmrstYC4kvS0QQidBZsmjCpL_tkqw@mail.gmail.com>
In-Reply-To: <CA+55aFzzfuiu-ScRmRFYWDmrstYC4kvS0QQidBZsmjCpL_tkqw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 04:08 PM, Linus Torvalds wrote:

> On Tue, Feb 28, 2012 at 3:41 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>>
>>>   + src/drivers/usb/misc/sisusbvga/sisusb.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 982
>>>   + src/fs/ecryptfs/miscdev.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 448, 488
>>
>> Do the (2) above mean that some platform's gcc is borked?
>> (I don't see these on i386 or x86_64.)
> 
> Hmm. We had something similar long ago on i386, where the kernel
> "size_t" was "unsigned long", but user-mode size_t was "unsigned int"
> (or maybe it was the other way around). Anyway, it's obviously
> physically the same type, but it would make gcc unhappy because gcc
> felt that somebody was doing something bad.
> 
>>>   + src/fs/ecryptfs/miscdev.c: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int':  => 433, 433:60
>>
>> I can see that warning on 32-bit i386 (X86_32), but if I change the
>> "%lu" to "%u", it causes this warning on 64-bit x86_64:
>>
>> fs/ecryptfs/miscdev.c:433:38: warning: format '%u' expects type 'unsigned int', but argument 4 has type 'long unsigned int'
>>
>> so how is this supposed to be handled?
> 
> I suspect that one should be "%zu", because we have
> 
>   /* 4 + ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES comes from tag 65 packet format */
>   #define MAX_MSG_PKT_SIZE        (PKT_TYPE_SIZE + PKT_CTR_SIZE \
>                                  + ECRYPTFS_MAX_PKT_LEN_SIZE \
>                                  + sizeof(struct ecryptfs_message) \
>                                  + 4 + ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES)
> 
> so it's the "sizeof(struct ecryptfs_message)" that makes it a size_t
> (everything else is int, if I look at it right, and int+size_t is
> going to be size_t)
> 
> Of course, if the platform then has the compiler and the kernel
> disagreeing about size_t like above, that isn't going to help
> anything. But does it fix the x86-32/64 warnings?


Yes, it does fix both cases (and I should have tried that).
Thanks.

-- 
