Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab2JWQZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:25:39 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:39339 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab2JWQZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:25:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+2vpA3J4sCUCaNkzCfO0yON2cVwSqFOiXku5u8GMwmmA@mail.gmail.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
 <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
 <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com>
 <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au>
 <CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com>
 <87ipa8o4mn.fsf@rustcorp.com.au> <CAKgNAkiVxUiqJ1pYNq3wW_yQxcyhqntUzcEWscFOhJ3GaVn1aQ@mail.gmail.com>
 <87sj97hs5e.fsf@rustcorp.com.au> <CAMOw1v7ySGT2g5s8djEbCGnqTNjqHky_LvaZsGEN6CSLNPMUgw@mail.gmail.com>
 <CAGXu5jK5wCnG0Ks+8YPgubX9dOir786hY4N+S3yTirK2-hBLqQ@mail.gmail.com>
 <CAMOw1v6bL2U2d6fKzqmGxk5GrjUzA7whcaCsp9e3EOOe+c=N_A@mail.gmail.com> <CAGXu5j+2vpA3J4sCUCaNkzCfO0yON2cVwSqFOiXku5u8GMwmmA@mail.gmail.com>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Tue, 23 Oct 2012 14:25:17 -0200
Message-ID: <CAMOw1v4KOcH+OckoFzWEr68aUweKD-6gH83BHmBm-1c7PqhCpQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
To: Kees Cook <keescook@chromium.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, mtk.manpages@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jonathon@jonmasters.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 1:42 PM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Oct 22, 2012 at 9:08 PM, Lucas De Marchi
> <lucas.demarchi@profusion.mobi> wrote:
>> On Tue, Oct 23, 2012 at 1:40 AM, Kees Cook <keescook@chromium.org> wrote:
>>> On Mon, Oct 22, 2012 at 7:37 PM, Lucas De Marchi
>>> <lucas.demarchi@profusion.mobi> wrote:
>>>> On Mon, Oct 22, 2012 at 5:39 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>>>>> FIX: add flags arg to sys_finit_module()
>>>>>>>
>>>>>>> Thanks to Michael Kerrisk for keeping us honest.
>>>>>>
>>>>>> w00t! Thanks, Rusty ;-).
>>>>>>
>>>>>> Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
>>>>>
>>>>> Here's the version I ended up with when I added two flags.
>>>>>
>>>>> Lucas, is this useful to you?
>>>>>
>>>>> BTW Michael: why aren't the syscall man pages in the kernel source?
>>>>>
>>>>> Thanks,
>>>>> Rusty.
>>>>>
>>>>> module: add flags arg to sys_finit_module()
>>>>>
>>>>> Thanks to Michael Kerrisk for keeping us honest.  These flags are actually
>>>>> useful for eliminating the only case where kmod has to mangle a module's
>>>>> internals: for overriding module versioning.
>>>>>
>>>>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>>
>>> Acked-by: Kees Cook <keescook@chromium.org>
>>>
>>>> I wonder if we shouldn't get a new init_module2() as well, adding the
>>>> flags parameter. Of course this would be in another patch.
>>>>
>>>> My worries are that for compressed modules we still need to use
>>>> init_module() and then --force won't work with signed modules.
>>>
>>> For those cases, I think it should remain up to userspace to do the
>>> decompress and use init_module(). The code I'd written for patching
>>> module-init-tools basically just kept the fd around if it didn't need
>>> to mangle the module, and it would use finit_module (written before
>>> the flags argument was added):
>>>
>>>         /* request kernel linkage */
>>> -       ret = init_module(module->data, module->len, opts);
>>> +       if (fd < 0)
>>> +               ret = init_module(module->data, module->len, opts);
>>> +       else {
>>> +           ret = finit_module(fd, opts);
>>> +           if (ret != 0 && errno == ENOSYS)
>>> +                   ret = init_module(module->data, module->len, opts);
>>> +       }
>>>         if (ret != 0) {
>>>
>>> (And yes, I realize kmod is what'll actually be getting this logic.
>>> This was for my testing in Chrome OS, which is still using
>>> module-init-tools.)
>>
>> sure... but do you realize this will fail in case kernel is checking
>> module signature and we passed --force to modprobe (therefore mangled
>> the decompressed memory area)?
>
> Hm, yeah, userspace mangling of a module plus signing would fail.
> Seems like mangling and signing aren't compatible. Doing it in
> kernel-space (as now written for finit_module) solves that, but it
> means that now compression isn't possible if you need both signing and
> mangling.
>
> I'm not a user of signing, compression, or mangling, so I'm probably a
> bit unimaginative here. It seems like the case for needing all three
> is pretty uncommon. (e.g. if you're doing compression, you're probably
> building embedded images, which means you're unlikely to need
> --force.)


Some desktop distros ship compressed modules by default. I received
feedback from distros some months ago that this is basically because
of the disk space, not performance.  However some measurements I did
in a regular laptop with spinning disk showed a small advantage
performance-wise, too  (with SSD is another story and uncompressed
wins by a large margin)

Since this only affects users of --force option, I think it only
affects module developers, who could uncompress the module, call
depmod again, and modprobe it. ( Mixing compressed and uncompressed
modules used not to work in module-init-tools and earlier versions of
kmod wrt dependencies, but now it should be a seamless operation )


Lucas De Marchi
