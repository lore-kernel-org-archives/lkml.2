Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab2FMMqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:46:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60087 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2FMMqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:46:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdW9D4FZSUibcd+qrtM+is75FyJXj+RxK+sb33XEjczdyg@mail.gmail.com>
References: <CAMuHMdW9D4FZSUibcd+qrtM+is75FyJXj+RxK+sb33XEjczdyg@mail.gmail.com>
Date: Wed, 13 Jun 2012 14:46:32 +0200
X-Google-Sender-Auth: pzBMUGWWzqBiqWhGByAcOmrDZcE
Message-ID: <CAMuHMdVM3zn_OUAtGTV_O0d3yFWBM5b_6ORHxaMLVE27Cf_XrQ@mail.gmail.com>
Subject: Re: asm/kvm_para.h from asm-generic (was: Re: linux-next: triage for
 April 19, 2012)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>, Avi Kivity <avi@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Linux/m68k" <linux-m68k@vger.kernel.org>, kvm@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 11:07 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Wed, May 30, 2012 at 10:52 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Mon, May 28, 2012 at 5:04 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> On Mon, May 28, 2012 at 4:37 PM, Avi Kivity <avi@redhat.com> wrote:
>>>> On 05/25/2012 11:59 PM, Geert Uytterhoeven wrote:
>>>>> On Fri, Apr 20, 2012 at 4:00 AM, Paul Gortmaker
>>>>> <paul.gortmaker@windriver.com> wrote:
>>>>>> The parisc got borked by some kvm header shuffle it seems?
>>>>>> Now complaining about "file 'asm-generic/kvm_para.h' is not exported"
>>>>>> [ http://kisskb.ellerman.id.au/kisskb/buildresult/6137786/ ]
>>>>>
>>>>> Not only parisc.
>>>>>
>>>>> This breakage has now entered mainline:
>>>>>
>>>>> parisc deconfig http://kisskb.ellerman.id.au/kisskb/buildresult/6365677/
>>>>> m68k allmodconfig: http://kisskb.ellerman.id.au/kisskb/buildresult/6365681/
>>>>
>>>>
>>>> Does the following patch help?
>>>
>>> Thanks, that fixes it!
>>>
>>> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>>
>>>> From: Avi Kivity <avi@redhat.com>
>>>> Date: Mon, 28 May 2012 17:35:22 +0300
>>>> Subject: [PATCH] KVM: Export asm-generic/kvm_para.h
>>>>
>>>> Prevents build failures on non-KVM archs.
>>>>
>>>> Signed-off-by: Avi Kivity <avi@redhat.com>
>>>> ---
>>>>  include/asm-generic/Kbuild |    1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
>>>> index 53f91b1..2c85a0f 100644
>>>> --- a/include/asm-generic/Kbuild
>>>> +++ b/include/asm-generic/Kbuild
>>>> @@ -8,6 +8,7 @@ header-y += int-ll64.h
>>>>  header-y += ioctl.h
>>>>  header-y += ioctls.h
>>>>  header-y += ipcbuf.h
>>>> +header-y += kvm_para.h
>>>>  header-y += mman-common.h
>>>>  header-y += mman.h
>>>>  header-y += msgbuf.h
>>
>> I just noticed include/asm-generic/Kbuild.asm already had
>>
>> ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
>>                  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
>> header-y  += kvm_para.h
>> endif
>>
>> but this doesn't seem to work.
>>
>> Kbuild people: which one is correct?
>
> Oops...
>
> After linux-next commit 2bbc89a8e9c652ee71c6c3b2e0679b7ecedb1a09
> ("m68k: Use Kbuild logic to import asm-generic headers"), which does:
>  - remove arch/m68k/include/asm/kvm_para.h, which just included the
>    asm-generic version,
>  - add "generic-y += kvm_para.h" to arch/m68k/include/asm/Kbuild,
> it fails again:
>
> $ make ARCH=m68k headers_check
>  CHK     include/linux/version.h
>  INSTALL include/asm-generic (35 files)
>  INSTALL include/linux (372 files)
>  CHECK   include/asm-generic (35 files)
>  CHECK   include/linux (372 files)
> usr/include/linux/kexec.h:49: userspace cannot reference function or
> variable defined in the kernel
> usr/include/linux/kvm_para.h:26: included file 'asm-m68k/kvm_para.h'
> is not exported
> usr/include/linux/soundcard.h:1054: userspace cannot reference
> function or variable defined in the kernel
> make[2]: *** [usr/include/linux/.check] Error 123
> make[1]: *** [linux] Error 2
> make: *** [headers_check] Error 2
> $
>
> After reverting Avi's fix (commit
> 7beb8e723c8d7da7decbbe217b79525aef73fccb. ("KVM:
> Export asm-generic/kvm_para.h")) it works again. Note that it now _removes_
> kvm_para.h:
>
> $ make ARCH=m68k headers_check
>  CHK     include/linux/version.h
>  REMOVE  kvm_para.h
>  INSTALL include/asm-generic (34 files)
>  REMOVE  kvm_para.h
>  INSTALL include/linux (371 files)
>  CHECK   include/asm-generic (34 files)
>  CHECK   include/linux (371 files)
> usr/include/linux/kexec.h:49: userspace cannot reference function or
> variable defined in the kernel
> usr/include/linux/soundcard.h:1054: userspace cannot reference
> function or variable defined in the kernel
> $
>
> What's the proper way to get this working in both cases??
>  1. arch has it's own asm/kvm_para.h (cfr. m68k and all other arches
> in mainline)
>  2. arch includes asm-generic/kvm_para.h via Kbuild logic (cfr.
> (only) m68k in -next)
> Or is this not possible, and should I create arch/m68k/include/asm/kvm_para.h
> again, like all other arches seem to do?

I dived into this, and spent a little more time on it than is healthy for me :-(

"make headers_check" is also broken on m32r since Avi's fix, as m32r
doesn't even
have <asm/kvm_param.h>:

| usr/include/linux/kvm_para.h:26: included file 'asm-m32r/kvm_para.h'
is not exported

commit 3b5d56b9317fa7b5407dff1aa7b115bf6cdbd494 ("kvmclock: Add functions to
check if the host has stopped the vm") created <asm/kvm_para.h> for
all architectures,
but forgot cris and m32r.

BTW, do we really want all these <asm/kvm_para.h> pointing to (empty)
<asm-generic/kvm_para.h> after exporting?

commit 7dcf2a9fced59e58e4694cdcf15850c01fdba89b ("remove dummy asm/kvm.h files")
removed the similar dummy <asm/kvm.h> files, and added a rule to
include/asm-generic/Kbuild.asm instead:

ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
                  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
header-y  += kvm.h
endif

There's a similar rule for kvm_para.h:

ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
                  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
header-y  += kvm_para.h
endif

It's this rule that's now biting m68k, as it no longer works when using
arch/*/include/asm/Kbuild to import <asm-generic/kvm_para.h>.
(I guess it'll bite SH soon, too).

I found two ways to fix it:
  1. Remove the "ifneq" above from include/asm-generic/Kbuild.asm,
     so kvm_para.h is exported unconditionally.
     Note that this breaks m32r and cris, as they don't have
asm/kvm_para.h yet),
   2. Add a similar "ifneq" to include/asm-generic/Kbuild, to make
     the export of <linux/kvm_para.h> conditional.
     I guess we want to remove all "dummy" kvm_para.h again, too?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
