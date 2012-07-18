Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2GRMdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 08:33:04 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50581 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2GRMdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 08:33:02 -0400
MIME-Version: 1.0
In-Reply-To: <201207181158.07236.arnd@arndb.de>
References: <1342607393-32254-1-git-send-email-will.deacon@arm.com>
	<201207181158.07236.arnd@arndb.de>
Date: Wed, 18 Jul 2012 14:33:01 +0200
X-Google-Sender-Auth: R2LtHpHmcwsmB3izwMgVn-E_fAE
Message-ID: <CAMuHMdXiWdtrH74BBkw402W=M5jjeu+uQAkHUitWJD06f1tZdQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "KVM: Export asm-generic/kvm_para.h"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 1:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 18 July 2012, Will Deacon wrote:
>> This reverts commit 56457f38f212344fb38b250cfa7e7311c065022f.
>>
>> For architectures without asm/kvm_para.h, asm-generic/Kbuild
>> unconditionally tries to export the non-existent header file, resulting
>> in failure to build the user headers. Since the logic in
>> asm-generic/Kbuild.asm will only export the file if it exists (which in
>> turn causes linux/kvm_para.h to be exported), we can just remove the
>> unconditional header export.
>
> This doesn't look right.
>
>> I'm not sure what specific problem the original commit was fixing, so we
>> may need to solve this another way if there's something I've missed.

See below.

>>  include/asm-generic/Kbuild |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
>> index 2c85a0f..53f91b1 100644
>> --- a/include/asm-generic/Kbuild
>> +++ b/include/asm-generic/Kbuild
>> @@ -8,7 +8,6 @@ header-y += int-ll64.h
>>  header-y += ioctl.h
>>  header-y += ioctls.h
>>  header-y += ipcbuf.h
>> -header-y += kvm_para.h
>>  header-y += mman-common.h
>>  header-y += mman.h
>>  header-y += msgbuf.h
>
> include/asm-generic/Kbuild lists the header files in the asm-generic
> directory, and the asm-generic/kvm_para.h always exists, it's
> not architecture specific.
>
> arch/arm/include/asm/kvm_para.h also always exists, it was added
> in 3b5d56b93 "kvmclock: Add functions to check if the host has
> stopped the vm", although it should have added that to the generated
> header files listed in arch/arm/include/asm/Kbuild.
>
> I'm still not sure what you are actually trying to fix here.

m68k/allmodconfig http://kisskb.ellerman.id.au/kisskb/buildresult/6695245/

make[4]: *** No rule to make target
`/scratch/kisskb/build/linux-next_m68k-allmodconfig_m68k/usr/include/linux/kvm_para.h',
needed by `/scratch/kisskb/build/linux-next_m68k-allmodconfig_m68k/usr/include/linux/.check'.
make[3]: *** [linux] Error 2
make[2]: *** [headers_check] Error 2

Before 56457f38f212344fb38b250cfa7e7311c065022f, "make headers_check"
was broken on all architectures that do not support kvm (i.e. all but
ia64/powerpc/s390/x86).

After 56457f38f212344fb38b250cfa7e7311c065022f, it became broken on
all architectures that do not support kvm and converted from

    #include <asm-generic/kvm_para.h>

in their arch/$arch/include/asm/kvm_para.h to

    generic-y += kvm_para.h

in their arch/$arch/include/asm/Kbuild OR just don't have a
arch/$arch/include/asm/kvm_para.h.

So far the former case is limited to sh (mainline) and m68k (next), but I expect
more architectures to start using the "generic-y += ..." idiom.

The latter is limited to cris and m32r.

Hence just reverting 56457f38f212344fb38b250cfa7e7311c065022f is not the
right fix, as it will cause more breakage.

See also https://lkml.org/lkml/2012/6/13/226

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
