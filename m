Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab2JWDku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 23:40:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47453 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2JWDkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 23:40:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMOw1v7ySGT2g5s8djEbCGnqTNjqHky_LvaZsGEN6CSLNPMUgw@mail.gmail.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
	<CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
	<50749DE8.7010703@zytor.com>
	<CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com>
	<5074A0AB.8040207@zytor.com>
	<87d30o7iy6.fsf@rustcorp.com.au>
	<CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com>
	<87ipa8o4mn.fsf@rustcorp.com.au>
	<CAKgNAkiVxUiqJ1pYNq3wW_yQxcyhqntUzcEWscFOhJ3GaVn1aQ@mail.gmail.com>
	<87sj97hs5e.fsf@rustcorp.com.au>
	<CAMOw1v7ySGT2g5s8djEbCGnqTNjqHky_LvaZsGEN6CSLNPMUgw@mail.gmail.com>
Date: Mon, 22 Oct 2012 20:40:46 -0700
X-Google-Sender-Auth: 81I4r1u-84SCcJefYEh5ZZrrRmw
Message-ID: <CAGXu5jK5wCnG0Ks+8YPgubX9dOir786hY4N+S3yTirK2-hBLqQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
From: Kees Cook <keescook@chromium.org>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Rusty Russell <rusty@rustcorp.com.au>, mtk.manpages@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jonathon@jonmasters.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 7:37 PM, Lucas De Marchi
<lucas.demarchi@profusion.mobi> wrote:
> On Mon, Oct 22, 2012 at 5:39 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>> FIX: add flags arg to sys_finit_module()
>>>>
>>>> Thanks to Michael Kerrisk for keeping us honest.
>>>
>>> w00t! Thanks, Rusty ;-).
>>>
>>> Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
>>
>> Here's the version I ended up with when I added two flags.
>>
>> Lucas, is this useful to you?
>>
>> BTW Michael: why aren't the syscall man pages in the kernel source?
>>
>> Thanks,
>> Rusty.
>>
>> module: add flags arg to sys_finit_module()
>>
>> Thanks to Michael Kerrisk for keeping us honest.  These flags are actually
>> useful for eliminating the only case where kmod has to mangle a module's
>> internals: for overriding module versioning.
>>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Kees Cook <keescook@chromium.org>

> I wonder if we shouldn't get a new init_module2() as well, adding the
> flags parameter. Of course this would be in another patch.
>
> My worries are that for compressed modules we still need to use
> init_module() and then --force won't work with signed modules.

For those cases, I think it should remain up to userspace to do the
decompress and use init_module(). The code I'd written for patching
module-init-tools basically just kept the fd around if it didn't need
to mangle the module, and it would use finit_module (written before
the flags argument was added):

        /* request kernel linkage */
-       ret = init_module(module->data, module->len, opts);
+       if (fd < 0)
+               ret = init_module(module->data, module->len, opts);
+       else {
+           ret = finit_module(fd, opts);
+           if (ret != 0 && errno == ENOSYS)
+                   ret = init_module(module->data, module->len, opts);
+       }
        if (ret != 0) {

(And yes, I realize kmod is what'll actually be getting this logic.
This was for my testing in Chrome OS, which is still using
module-init-tools.)

-Kees

-- 
Kees Cook
Chrome OS Security
