Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1HLWcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 18:32:23 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:60791 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1HLWcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 18:32:21 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MUq5M-XPOxV=8GKyEzjEzpmdeaF+mGrXJrK+ZZxa4SdeQ@mail.gmail.com>
References: <4E457682.5020107@codeaurora.org>
	<1313175602-21834-1-git-send-email-sboyd@codeaurora.org>
	<CACqU3MUq5M-XPOxV=8GKyEzjEzpmdeaF+mGrXJrK+ZZxa4SdeQ@mail.gmail.com>
Date: Fri, 12 Aug 2011 18:32:20 -0400
Message-ID: <CACqU3MXtcg_8si9WiuZngMB2C977PS4zen8_cQ9oyNtwTbt75Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: zImage: Skip relinking if nothing changes
From: Arnaud Lacombe <lacombar@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 12, 2011 at 4:48 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Fri, Aug 12, 2011 at 3:00 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> lib1funcs.S is reshipped even though the file hasn't changed
>> because the make rule is marked with FORCE. According to Sam
>> Ravnborg:
>>
>>        The FORCE prerequisite will tell make to always execute
>>        the command.
>>        But we only want to execute the command if:
>>        1) $(obj)/lib1funcs.S is missing
>>        2) or $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S is not
>>        older then $(obj)/lib1funcs.S
>>
>>        So dropping FORCE should be a safe thing to do.
>>
>> This fixes the shipped problem, but we still have to reassemble
>> lib1funcs.S because it isn't part of $targets. Add
>> lib1funcs.{S,o} to $targets to avoid relinking the compressed
>> vmlinux if nothing changes.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> Acked-by: Sam Ravnborg <sam@ravnborg.org>
>> ---
>>  arch/arm/boot/compressed/Makefile |    8 +++-----
>>  1 files changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
>> index 0c74a6f..937fd26 100644
>> --- a/arch/arm/boot/compressed/Makefile
>> +++ b/arch/arm/boot/compressed/Makefile
>> @@ -91,7 +91,7 @@ suffix_$(CONFIG_KERNEL_LZMA) = lzma
>>
>>  targets       := vmlinux vmlinux.lds \
>>                 piggy.$(suffix_y) piggy.$(suffix_y).o \
>> -                font.o font.c head.o misc.o $(OBJS)
>> +                font.o font.c head.o misc.o lib1funcs.o lib1funcs.S $(OBJS)
>>
>>  # Make sure files are removed during clean
>>  extra-y       += piggy.gzip piggy.lzo piggy.lzma lib1funcs.S
>> @@ -121,9 +121,7 @@ LDFLAGS_vmlinux += -X
>>  LDFLAGS_vmlinux += -T
>>
>>  # For __aeabi_uidivmod
>> -lib1funcs = $(obj)/lib1funcs.o
>> -
>> -$(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S FORCE
>> +$(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S
>>        $(call cmd,shipped)
>>
> You should be able to avoid the extra copy altogether by doing something ala:
>
> $(obj)/lib1funcs.o: $(srctree)/arch/arm/lib/lib1funcs.S
>        $(call cmd,as_o_S)
>
> note that I also remove the $(SRCARCH), as there is no other
> `arch/*/lib/lib1funcs.S' than `arch/arm/lib/lib1funcs.S'
>
I withdraw this proposal and will hack around this to find a proper
solution from within kbuild, and eventually come back on these uses
:-)

 - Arnaud

>>  # We need to prevent any GOTOFF relocs being used with references
>> @@ -140,7 +138,7 @@ bad_syms=$$($(CROSS_COMPILE)nm $@ | sed -n 's/^.\{8\} [bc] \(.*\)/\1/p') && \
>>     echo "$$bad_syms" >&2; rm -f $@; false )
>>
>>  $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.$(suffix_y).o \
>> -               $(addprefix $(obj)/, $(OBJS)) $(lib1funcs) FORCE
>> +               $(addprefix $(obj)/, $(OBJS)) $(obj)/lib1funcs.o FORCE
>>        $(call if_changed,ld)
>>        @$(check_for_bad_syms)
>>
>> --
>> Sent by an employee of the Qualcomm Innovation Center, Inc.
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
