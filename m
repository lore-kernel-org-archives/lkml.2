Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1IGUwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 16:52:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63996 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab1IGUwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 16:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1109071554480.20358@xanadu.home>
References: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
	<alpine.LFD.2.00.1109071437400.20358@xanadu.home>
	<CACqU3MVF8XSdKi0PeZF5SFaH9i2HPqCjkMqccyb83x4V_1Vs1g@mail.gmail.com>
	<alpine.LFD.2.00.1109071554480.20358@xanadu.home>
Date: Wed, 7 Sep 2011 16:52:15 -0400
Message-ID: <CACqU3MUiie5Zv+FwFkXcY7yZ1-wgCB7xVpHn36WaV7EpecU4Cw@mail.gmail.com>
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
that look correct to me, however, the error you get:

make[2]: *** No rule to make target
`arch/arm/boot/compressed/lib1funcs.S', needed by
`arch/arm/boot/compressed/lib1funcs.o'.  Stop.

seem odd to me.

I just re-tried on x86 with:

diff --git a/arch/x86/boot/compressed/Makefile
b/arch/x86/boot/compressed/Makefile
index 09664ef..65c89f7 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -23,7 +23,9 @@ LDFLAGS_vmlinux := -T

 hostprogs-y    := mkpiggy

-$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/head_$(BITS).o
$(obj)/misc.o $(obj)/string.o $(obj)/cmdline.o
$(obj)/early_serial_console.o $(obj)/piggy.o FORCE
+vpath-y += $(srctree)/arch/x86/lib
+
+$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/checksum_32.o
$(obj)/head_$(BITS).o $(obj)/misc.o $(obj)/string.o $(obj)/cmdline.o
$(obj)/early_serial_console.o $(obj)/piggy.o FORCE
        $(call if_changed,ld)
        @:

and `checksum_32.o' gets built just fine from
`$(srctree)/arch/x86/lib/checksum_32.S'. I guess I'll ends up building
an arm toolchain tonight and see closer.

 - Arnaud
