Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965801Ab2B2AI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:08:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53532 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab2B2AIZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:08:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.85.35 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4D663D.2040100@xenotime.net>
References: <1330462222-25201-1-git-send-email-geert@linux-m68k.org> <4F4D663D.2040100@xenotime.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Feb 2012 16:08:04 -0800
X-Google-Sender-Auth: KNMyHqiBlYSYnmAivxQ-FTVsKvE
Message-ID: <CA+55aFzzfuiu-ScRmRFYWDmrstYC4kvS0QQidBZsmjCpL_tkqw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.3-rc5 (C lang questions)
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 3:41 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>
>>   + src/drivers/usb/misc/sisusbvga/sisusb.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 982
>>   + src/fs/ecryptfs/miscdev.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 448, 488
>
> Do the (2) above mean that some platform's gcc is borked?
> (I don't see these on i386 or x86_64.)

Hmm. We had something similar long ago on i386, where the kernel
"size_t" was "unsigned long", but user-mode size_t was "unsigned int"
(or maybe it was the other way around). Anyway, it's obviously
physically the same type, but it would make gcc unhappy because gcc
felt that somebody was doing something bad.

>>   + src/fs/ecryptfs/miscdev.c: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int':  => 433, 433:60
>
> I can see that warning on 32-bit i386 (X86_32), but if I change the
> "%lu" to "%u", it causes this warning on 64-bit x86_64:
>
> fs/ecryptfs/miscdev.c:433:38: warning: format '%u' expects type 'unsigned int', but argument 4 has type 'long unsigned int'
>
> so how is this supposed to be handled?

I suspect that one should be "%zu", because we have

  /* 4 + ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES comes from tag 65 packet format */
  #define MAX_MSG_PKT_SIZE        (PKT_TYPE_SIZE + PKT_CTR_SIZE \
                                 + ECRYPTFS_MAX_PKT_LEN_SIZE \
                                 + sizeof(struct ecryptfs_message) \
                                 + 4 + ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES)

so it's the "sizeof(struct ecryptfs_message)" that makes it a size_t
(everything else is int, if I look at it right, and int+size_t is
going to be size_t)

Of course, if the platform then has the compiler and the kernel
disagreeing about size_t like above, that isn't going to help
anything. But does it fix the x86-32/64 warnings?

                   Linus
