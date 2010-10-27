Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928Ab0J0Ojs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:39:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53448 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab0J0Ojr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OwAdy06h7A2dot3PesqiDGaJ0IFsZnXKfZ8KXJqkhW8hvtC9Ij+l3E8Kap1rT6ZixG
         OAKiLL2ICwiVybdx7ZpriS/RKV/w8yF3XL8y6qXdkD6NUj2UCIHlVYylxvvGZc1TtAPC
         +aJuwa2wAaNmpPypEhljLeZ5FqoML79pP3Vu4=
MIME-Version: 1.0
In-Reply-To: <1288185700.18238.117.camel@gandalf.stny.rr.com>
References: <f603e1dc44524b81ebc423dd226eb44d837a37be.1288175801.git.wuzhangjin@gmail.com>
	<1288185700.18238.117.camel@gandalf.stny.rr.com>
Date: Wed, 27 Oct 2010 22:39:45 +0800
Message-ID: <AANLkTikxQxCYHEe5bJCx9dNY6AZNpVBgHLxp99+MbzgH@mail.gmail.com>
Subject: Re: [PATCH] ftrace: Speed up recordmcount
From: wu zhangjin <wuzhangjin@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        John Reiser <jreiser@bitwagon.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 9:21 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> [ Added kbuild maintainers ]
>
> On Wed, 2010-10-27 at 18:39 +0800, Wu Zhangjin wrote:
>> From: Wu Zhangjin <wuzhangjin@gmail.com>
>>
>> cmd_record_mcount is only needed for the targets who are compiled with
>> -pg, so, only define it when CONFIG_FTRACE_MCOUNT_RECORD is defined and
>> only use it for the targets who are compiled with -pg.
>
> Thanks! I was going to do this myself, but just have not gotten around
> to it.

When I found the C version of recordmcount tried to cope with the
files under arch/mips/boot/compressed/, I felt a little nervous and
tried to fix it ;-)

>
>>
>> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
>
> I need a SoB from Michal to apply it.
>
>> ---
>>  Makefile               |   11 ++++++++---
>>  scripts/Makefile.build |   26 ++++++++++++++++----------
>>  2 files changed, 24 insertions(+), 13 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 3e43805..60d7a87 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -576,9 +576,14 @@ endif
>>  ifdef CONFIG_FUNCTION_TRACER
>>  KBUILD_CFLAGS        += -pg
>>  ifdef CONFIG_DYNAMIC_FTRACE
>> -     ifdef CONFIG_HAVE_C_RECORDMCOUNT
>> -             BUILD_C_RECORDMCOUNT := y
>> -             export BUILD_C_RECORDMCOUNT
>> +     ifdef CONFIG_FTRACE_MCOUNT_RECORD
>
> FTRACE_MCOUNT_RECORD depends on DYNAMIC_FTRACE, so if you require
> FTRACE_MCOUNT_RECORD, you can remove the ifdef CONFIG_DYNAMIC_FTRACE.

ok, will remove it.

>
>
>> +             DEFINE_CMD_RECORD_MCOUNT := y
>> +             export DEFINE_CMD_RECORD_MCOUNT
>> +
>> +             ifdef CONFIG_HAVE_C_RECORDMCOUNT
>> +                     BUILD_C_RECORDMCOUNT := y
>> +                     export BUILD_C_RECORDMCOUNT
>> +             endif
>>       endif
>>  endif
>>  endif
>> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
>> index 5ad25e1..ceb5175 100644
>> --- a/scripts/Makefile.build
>> +++ b/scripts/Makefile.build
>> @@ -208,22 +208,28 @@ cmd_modversions =                                                               \
>>       fi;
>>  endif
>>
>> -ifdef CONFIG_FTRACE_MCOUNT_RECORD
>> +ifdef DEFINE_CMD_RECORD_MCOUNT
>>  ifdef BUILD_C_RECORDMCOUNT
>>  # Due to recursion, we must skip empty.o.
>>  # The empty.o file is created in the make process in order to determine
>>  #  the target endianness and word size. It is made before all other C
>>  #  files, including recordmcount.
>> -cmd_record_mcount = if [ $(@) != "scripts/mod/empty.o" ]; then                       \
>> -                     $(objtree)/scripts/recordmcount "$(@)";                 \
>> -                 fi;
>> +cmd_record_mcount =                                                  \
>> +     if [ "$(findstring -pg,$(KBUILD_CFLAGS))" == "-pg" ]; then      \
>> +             if [ $(@) != "scripts/mod/empty.o" ]; then              \
>> +                     $(objtree)/scripts/recordmcount "$(@)";         \
>> +             fi;                                                     \
>> +     fi;
>>  else
>> -cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
>> -     "$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
>> -     "$(if $(CONFIG_64BIT),64,32)" \
>> -     "$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
>> -     "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
>> -     "$(if $(part-of-module),1,0)" "$(@)";
>> +cmd_record_mcount =                                                  \
>> +     if [ "$(findstring -pg,$(KBUILD_CFLAGS))" == "-pg" ]; then      \
>> +             set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
>> +             "$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)"             \
>> +             "$(if $(CONFIG_64BIT),64,32)"                           \
>> +             "$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)"      \
>> +             "$(LD)" "$(NM)" "$(RM)" "$(MV)"                         \
>> +             "$(if $(part-of-module),1,0)" "$(@)";                   \
>> +     fi;
>>  endif
>>  endif
>>
>
>
> Note, this does not catch objects that have the -pg stripped by
> CFLAGS_REMOVE_object.o

Just checked the scripts/Makefile.lib and found c_flags:

106 _c_flags       = $(filter-out $(CFLAGS_REMOVE_$(basetarget).o),
$(orig_c_flags))

And after used it instead of KBUILD_CFLAGS, it works well. Here is the
testing result:

1. The normal files with -pg

$ make ARCH=mips CROSS_COMPILE=mips64el-unknown-linux-gnu- -j5 init/main.o
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  Checking missing-syscalls for N32
  CALL    scripts/checksyscalls.sh
  Checking missing-syscalls for O32
  CALL    scripts/checksyscalls.sh
  CALL    scripts/checksyscalls.sh
  CC      init/main.o
****printed by scripts/recordmcount.c: main

2. the files with CONFIG_REMOVE_file.o = -pg

$ make ARCH=mips CROSS_COMPILE=mips64el-unknown-linux-gnu- -j5
arch/mips/kernel/ftrace.o
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  Checking missing-syscalls for N32
  CALL    scripts/checksyscalls.sh
  Checking missing-syscalls for O32
  CALL    scripts/checksyscalls.sh
  CALL    scripts/checksyscalls.sh
  CC      arch/mips/kernel/ftrace.o

3. the files with obvious filter of -pg

$ make ARCH=mips CROSS_COMPILE=mips64el-unknown-linux-gnu- -j5
arch/mips/boot/compressed/dbg.o
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  Checking missing-syscalls for N32
  CALL    scripts/checksyscalls.sh
  Checking missing-syscalls for O32
  CALL    scripts/checksyscalls.sh
  CALL    scripts/checksyscalls.sh
  CC      arch/mips/boot/compressed/dbg.o

$ make ARCH=mips CROSS_COMPILE=mips64el-unknown-linux-gnu- -j5
kernel/trace/ftrace.o
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  Checking missing-syscalls for N32
  CALL    scripts/checksyscalls.sh
  Checking missing-syscalls for O32
  CALL    scripts/checksyscalls.sh
  CALL    scripts/checksyscalls.sh
  CC      kernel/trace/ftrace.o

>
>
> How about something like this:
>
> ifdef DEFINE_CMD_RECORD_MCOUNT
> ifdef BUILD_C_RECORDMCOUNT
> sub_cmd_record_mcount = if [ $(@) != "scripts/mod/empty.o" ]; then              \
>                        $(objtree)/scripts/recordmcount "$(@)";                 \
>                    fi;
> else
> sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
>        "$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)"                     \
>        "$(if $(CONFIG_64BIT),64,32)"                                   \
>        "$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)"              \
>        "$(LD)" "$(NM)" "$(RM)" "$(MV)"                                 \
>        "$(if $(part-of-module),1,0)" "$(@)";
> endif
> cmd_record_mcount =                                                     \
>        if [ "$(findstring -pg, $(_c_flags))" == "-pg" ]; then          \
>                $(sub_cmd_record_mcount)                                \
>        fi;
> endif
>
>
>
> I tested the above and it seemed to work (although, I did it on another
> machine, and copied it here by hand, so this version may have a typo).
>

Yeah, this removed the duplicated findstring, will fix the typo and apply it.

Thanks!
Wu Zhangjin
