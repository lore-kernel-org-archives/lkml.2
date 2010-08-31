Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab0HaOQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 10:16:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33194 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab0HaOQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 10:16:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ghk7cv+qBRnWiGfbea0UDZgGNpSxq3wc71rMXAWKfGUF4Ay/pLymiGTwufikL3RCkc
         mk+dvsnuvOppt9KyNCYbZfHgSGmq8i8Gr60VAPZSI0dGRSoyXoWoJZVGD48ENonOxGyK
         Ik9fT6UohYiGIhB7aHOY8aImYV4tKwvwB0LL0=
MIME-Version: 1.0
In-Reply-To: <20100830190330.GB12921@merkur.ravnborg.org>
References: <1283189270-7274-1-git-send-email-namhyung@gmail.com>
 <1283189270-7274-2-git-send-email-namhyung@gmail.com> <20100830190330.GB12921@merkur.ravnborg.org>
From: Namhyung Kim <namhyung@gmail.com>
Date: Tue, 31 Aug 2010 23:16:23 +0900
Message-ID: <AANLkTimysA_CmWVBOntV9bzUBy9Vbhi1MtUJQJAHbQxq@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] init: add sys-wrapper.h
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 04:03, Sam Ravnborg <sam@ravnborg.org> wrote:
> Hi Namhyung Kim.
>
> Some very basic comments.
>

Hi,
Thanks for your comments.


> On Tue, Aug 31, 2010 at 02:27:49AM +0900, Namhyung Kim wrote:
>> sys-wrapper.h contains wrapper functions for various syscalls used in init
>> code. This wrappers handle proper address space conversion so that it can
>> remove a lot of warnings from sparse.
>>
>> Suggested-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> ---
>>  init/sys-wrapper.h |  230 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 230 insertions(+), 0 deletions(-)
>>  create mode 100644 init/sys-wrapper.h
>>
>> diff --git a/init/sys-wrapper.h b/init/sys-wrapper.h
>> new file mode 100644
>> index 0000000..9aa904c
>> --- /dev/null
>> +++ b/init/sys-wrapper.h
>> @@ -0,0 +1,230 @@
>> +/*
>> + * init/sys-wrapper.h
> Drop the filename - it has a tendency to get outdated.
>
>> + *
>> + * Copyright (C) 2010  Namhyung Kim <namhyung@gmail.com>
>> + *
>> + * wrappers for various syscalls for use in the init code
>> + *
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public
>> + * License v2 as published by the Free Software Foundation.dummy
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public
>> + * License along with this program; if not, write to the
>> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
>> + * Boston, MA 021110-1307, USA.
>> + */
> Drop the license text. The kernel is covered by GPL v2 anyway.
>
>> +
>> +#include <linux/fs.h>
>> +#include <linux/types.h>
>> +#include <linux/fcntl.h>
>> +#include <linux/dirent.h>
>> +#include <linux/syscalls.h>
>> +
>
> I usually see the inverse christmas tree recommended, that is the longest name first.
>

OK. Then, how about this?
(I added <asm/uaccess.h> and removed <linux/fcntl.h> because I think it is
more appropriate.)

/*
 * wrappers for various syscalls for use in the init code
 *
 * Copyright (C) 2010  Namhyung Kim <namhyung@gmail.com>
 *
 * This file is released under the GPLv2.
 */

#include <linux/syscalls.h>
#include <linux/dirent.h>
#include <linux/types.h>
#include <linux/fs.h>

#include <asm/uaccess.h>


>> +
>> +#define kern_sys_call(call, ...)             \
>> +({                                           \
>> +     long result;                            \
>> +     mm_segment_t old_fs = get_fs();         \
>> +     set_fs(KERNEL_DS);                      \
>> +     result = call(__VA_ARGS__);             \
>> +     set_fs(old_fs);                         \
>> +     result;                                 \
>> +})
>> +
>
> Personal preference...
> Replace kern_ with kernel_ all over.
>

Is this just your preference or general tendency?


>> +static inline int kern_sys_mount(char *dev_name, char *dir_name, char *type,
>> +                              unsigned long flags, void *data)
>> +{
>> +     return kern_sys_call(sys_mount,
>> +                          (char __user __force *) dev_name,
>> +                          (char __user __force *) dir_name,
>> +                          (char __user __force *) type,
>> +                          flags,
>> +                          (void __user __force *) data);
>> +}
>> +
>
> I have not tried to investigate the sparse annotations.
> But I wonder whay strings are "(char __user __force *)".
> Is this because the sting usually come from userspace?
>

No, usual strings are in kernel space but syscall requires its arguments
to be __user pointers so we have to convert __force.



-- 
Regards,
Namhyung Kim
