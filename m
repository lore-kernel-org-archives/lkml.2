Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab1IHEu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 00:50:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37114 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab1IHEuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 00:50:23 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1109071554480.20358@xanadu.home>
References: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
	<alpine.LFD.2.00.1109071437400.20358@xanadu.home>
	<CACqU3MVF8XSdKi0PeZF5SFaH9i2HPqCjkMqccyb83x4V_1Vs1g@mail.gmail.com>
	<alpine.LFD.2.00.1109071554480.20358@xanadu.home>
Date: Thu, 8 Sep 2011 00:50:22 -0400
Message-ID: <CACqU3MXcksYxdV_=OR40fPeZzu1ygr-Qs79TV6kfn0DpbXhjuA@mail.gmail.com>
Subject: Re: [RFC] Kbuild: allow code re-use across different directories
From: Arnaud Lacombe <lacombar@gmail.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 7, 2011 at 3:59 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Wed, 7 Sep 2011, Arnaud Lacombe wrote:
>
>> Hi,
>>
>> On Wed, Sep 7, 2011 at 3:07 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
>> > On Fri, 19 Aug 2011, Arnaud Lacombe wrote:
>> >
>> >> Hi folks,
>> >>
>> >> The attached patch modify Kbuild to allow to directly re-use code in multiple
>> >> directory without having to go through a copy. Technically, it changes Kbuild to
>> >> use by default the VPATH feature of GNU make and provides accessors for Makefile
>> >> to change it indirectly.
>> >>
>> >> Considering:
>> >>
>> >> arch/foo/lib:
>> >> fancy.c
>> >>
>> >> We want to be able to build it with -DPANTS=32 in the kernel, but the
>> >> bootloader requires -DPANTS_SIZE=30.
>> >>
>> >> Currently we would do, either:
>> >>
>> >> arch/foo/lib/Makefile
>> >> LDFLAGS_fancy.o := -DPANTS=32
>> >> obj-y += fancy.o
>> >>
>> >> and, either:
>> >>
>> >> arch/foo/boot/Makefile:
>> >> LDFLAGS_fancy.o := -DPANTS=30
>> >> obj-y += fancy.o
>> >> $(obj)/fancy.c: $(srctree)/arch/foo/lib/fancy.c
>> >>       $(call cmd,shipped)
>> >>
>> >> or
>> >>
>> >> arch/foo/boot/Makefile:
>> >> LDFLAGS_fancy.o := -DPANTS=30
>> >> obj-y += fancy.o
>> >> $(obj)/fancy.o: $(srctree)/arch/foo/lib/fancy.c
>> >>       $(call cmd,cc_c_o)
>> >>
>> >> The former implies an extra copy of the source file, the latter expose Kbuild
>> >> internal function.
>> >>
>> >> With the attached patch, we would do:
>> >>
>> >> arch/foo/boot/Makefile:
>> >> LDFLAGS_fancy.o := -DPANTS=30
>> >> obj-y += fancy.o
>> >> vpath-y += $(srctree)/arch/foo/lib
>> >>
>> >> and let GNU make do the job.
>> >>
>> >> Comments welcome,
>> >
>> > It doesn't work.  Whatever I do to arch/arm/boot/compressed/Makefile
>> > (which admittedly looks a bit hairy and could benefit from a shave) in
>> > order to remove the $(call cmd,shipped) used with lib1funcs.S, I always
>> > end up with:
>> >
>> > make[2]: *** No rule to make target `arch/arm/boot/compressed/lib1funcs.S', needed by `arch/arm/boot/compressed/lib1funcs.o'.  Stop.
>> >
>> What was the exact change you made which triggered this ?
>
> In its simplest expression (not caring about the now undefined lib1funcs
> variable):
>
> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> index 0c74a6fab9..b34ed80977 100644
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -70,6 +70,10 @@ ifeq ($(CONFIG_ARCH_SHMOBILE),y)
>  OBJS           += head-shmobile.o
>  endif
>
> +# For __aeabi_uidivmod
> +OBJS           += lib1funcs.o
> +vpath-y                += $(srctree)/arch/arm/lib
> +
>  #
>  # We now have a PIC decompressor implementation.  Decompressors running
>  # from RAM should not define ZTEXTADDR.  Decompressors running directly
> @@ -120,12 +124,6 @@ LDFLAGS_vmlinux += -X
>  # Next argument is a linker script
>  LDFLAGS_vmlinux += -T
>
> -# For __aeabi_uidivmod
> -lib1funcs = $(obj)/lib1funcs.o
> -
> -$(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S FORCE
> -       $(call cmd,shipped)
> -
>  # We need to prevent any GOTOFF relocs being used with references
>  # to symbols in the .bss section since we cannot relocate them
>  # independently from the rest at run time.  This can be achieved by
>
you missed:

 # Make sure files are removed during clean
-extra-y       += piggy.gzip piggy.lzo piggy.lzma lib1funcs.S
+extra-y       += piggy.gzip piggy.lzo piggy.lzma

This confused make.

before:

% rm -rf /linux/obj/vpath-arm/arch/arm/boot/compressed/
% make ARCH=arm V=2                       \
    CROSS_COMPILE=arm-none-linux-gnueabi- \
    O=/linux/obj/vpath-arm
[...]
  CC      arch/arm/boot/compressed/decompress.o - due to target missing
make[3]: *** No rule to make target
`arch/arm/boot/compressed/lib1funcs.S', needed by
`arch/arm/boot/compressed/lib1funcs.o'.  Stop.
make[2]: *** [arch/arm/boot/compressed/vmlinux] Error 2
make[1]: *** [zImage] Error 2
make: *** [sub-make] Error 2

after:

% rm -rf /linux/obj/vpath-arm/arch/arm/boot/compressed/
% make ARCH=arm V=2                       \
    CROSS_COMPILE=arm-none-linux-gnueabi- \
    O=/linux/obj/vpath-arm
[...]
  CC      arch/arm/boot/compressed/decompress.o - due to target missing
  AS      arch/arm/boot/compressed/lib1funcs.o - due to target missing
  LD      arch/arm/boot/compressed/vmlinux - due to target missing
  OBJCOPY arch/arm/boot/zImage - due to: arch/arm/boot/compressed/vmlinux
  Kernel: arch/arm/boot/zImage is ready
  Building modules, stage 2.
  MODPOST 33 modules - due to target is PHONY

 - Arnaud

>
> Nicolas
>
