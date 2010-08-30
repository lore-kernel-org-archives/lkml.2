Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab0H3OR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:17:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48105 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab0H3OR6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:17:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bijUoJRHaIlI6mSheM2c1mvgHYHKhdNf7XZPKbd+B40VTfZQR2nO97dFMFXNeipIyu
         gt1emE2JU0HGF64NJZo1tldKZZGQPIKWIOwx2zG5miO3hGWtCmP5xYmV5OtP4FBEUq3K
         tJl0ZMp2UhoM01W/7LZ4JSx7UsSHHfObmDFM8=
MIME-Version: 1.0
In-Reply-To: <201008301411.43910.arnd@arndb.de>
References: <1283102928-3051-1-git-send-email-namhyung@gmail.com>
 <1283102928-3051-2-git-send-email-namhyung@gmail.com> <201008301411.43910.arnd@arndb.de>
From: Namhyung Kim <namhyung@gmail.com>
Date: Mon, 30 Aug 2010 23:17:38 +0900
Message-ID: <AANLkTi=1mL_t-ado8yXntQFJR6P97JNdcTbXArXU0=ic@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 1/3] init: add sys-wrapper.h
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 21:11, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 29 August 2010, Namhyung Kim wrote:
>> +
>> +/* These macro are called just before/after actual syscalls. */
>> +#define KSYS_PREPARE                         \
>> +     mm_segment_t old_fs = get_fs();         \
>> +     set_fs(KERNEL_DS);
>> +
>> +#define KSYS_RESTORE                         \
>> +     set_fs(old_fs);
>
> These macros are not that nice, because they depend on context.
> I would probably open-code them in each function, or possibly
> use a single macro to combine it to something like
>
> #define kern_sys_call(call, ...)        \
> ({                                      \
>        mm_segment_t old_fs = get_fs(); \
>        long result;                    \
>        set_fs(KERNEL_DS);              \
>        result = call(__VA_ARGS__);     \
>        set_fs(old_fs);                 \
>        result;                         \
> })
>
> static inline int kern_sys_link(const char *oldname, const char *newname)
> {
>        return kern_sys_call(sys_link, (const char __user __force *)oldname,
>                             (const char __user __force *)newname);
> }
>

Cool. Will use it. :-)


>> +static inline int kern_sys_fchown(unsigned int fd, uid_t user, gid_t group)
>> +{
>> +     int ret;
>> +     KSYS_PREPARE;
>> +
>> +     ret = sys_fchown(fd, user, group);
>> +
>> +     KSYS_RESTORE;
>> +     return ret;
>> +}
>
> When there are no pointer arguments, there is no need to do set_fs
> tricks.
>

My intentions was it might be good, IMHO, if we have common setup/tear-down code
around actual syscall possibly extended in future. But now I think
it's a kind of over-
engineering so I'll discard it and follow your advice above.

Thanks.


-- 
Regards,
Namhyung Kim
