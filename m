Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab0KIFfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 00:35:43 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35881 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0KIFfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 00:35:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=R1LEEXtTWTefz6fqhDeUW29NmPnxLFnoXEmadltFq5aodpOTdOOgiKh0btobsVSdUb
         5rcNJ+AoC9cn78fz8s2697JPsHtmTMGPXGc/sndF+jMJ4CSj/88Ufv6wUKyq8YN/1fo4
         bMR+sGA2lw5Ruos9Du/jDM738hNE2BYPdusTY=
MIME-Version: 1.0
In-Reply-To: <4CC9E5B5.5040402@suse.cz>
References: <3dc8cddf022eb7024f9f2cf857529a15bee8999a.1288196498.git.wuzhangjin@gmail.com>
	<4CC9E5B5.5040402@suse.cz>
Date: Tue, 9 Nov 2010 13:35:40 +0800
Message-ID: <AANLkTimS7YsZo+AGyTJq+G4kqsviRMRbdgt3NqZgEUws@mail.gmail.com>
Subject: Re: [v2 PATCH] ftrace: Speed up recordmcount
From: wu zhangjin <wuzhangjin@gmail.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        John Reiser <jreiser@bitwagon.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steve

On 10/29/10, Michal Marek <mmarek@suse.cz> wrote:
> On 27.10.2010 18:24, Wu Zhangjin wrote:
>> From: Wu Zhangjin <wuzhangjin@gmail.com>
>>
>> cmd_record_mcount is used to locate the _mcount symbols in the object
>> files, only the files compiled with -pg has the _mcount symbol, so, it
>> is only needed for such files, but the current cmd_record_mcount is used
>> for all of the object files, so, we need to fix it and speed it up.
>>
>> Since -pg may be removed by the method used in kernel/trace/Makefile:
>>
>> ORIG_CFLAGS := $(KBUILD_CFLAGS)
>> KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
>>
>> Or may be removed by the method used in arch/x86/kernel/Makefile:
>>
>> CONFIG_REMOVE_file.o = -pg
>
> CFLAGS_REMOVE_file.o
>

Did you apply this patch, should I fix this typo and resend it to you?

Best Regards,
Wu Zhangjin

>
>> So, we must check the last variable stores the compiling flags, that is
>> c_flags(Please refer to cmd_cc_o_c and rule_cc_o_c defined in
>> scripts/Makefile.build) and since the CFLAGS_REMOVE_file.o is already
>> filtered in _c_flags(Please refer to scripts/Makefile.lib) and _c_flags
>> has less symbols, therefore, we only need to check _c_flags.
>>
>> ---------------
>> Changes from v1:
>>
>>   o Don't touch Makefile for CONFIG_FTRACE_MCOUNT_RECORD is enough
>>   o Use _c_flags intead of KBUILD_CFLAGS to cover CONFIG_REMOVE_file.o =
>> -pg
>>   (feedback from Steven Rostedt <rostedt@goodmis.org>)
>>
>> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
>
> Acked-by: Michal Marek <mmarek@suse.cz>
>
>
>> ---
>>  scripts/Makefile.build |   13 +++++++++----
>>  1 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
>> index 5ad25e1..0ad6108 100644
>> --- a/scripts/Makefile.build
>> +++ b/scripts/Makefile.build
>> @@ -214,17 +214,22 @@ ifdef BUILD_C_RECORDMCOUNT
>>  # The empty.o file is created in the make process in order to determine
>>  #  the target endianness and word size. It is made before all other C
>>  #  files, including recordmcount.
>> -cmd_record_mcount = if [ $(@) != "scripts/mod/empty.o" ]; then			\
>> -			$(objtree)/scripts/recordmcount "$(@)";			\
>> -		    fi;
>> +sub_cmd_record_mcount =					\
>> +	if [ $(@) != "scripts/mod/empty.o" ]; then	\
>> +		$(objtree)/scripts/recordmcount "$(@)";	\
>> +	fi;
>>  else
>> -cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl
>> "$(ARCH)" \
>> +sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl
>> "$(ARCH)" \
>>  	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
>>  	"$(if $(CONFIG_64BIT),64,32)" \
>>  	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
>>  	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
>>  	"$(if $(part-of-module),1,0)" "$(@)";
>>  endif
>> +cmd_record_mcount = 						\
>> +	if [ "$(findstring -pg,$(_c_flags))" == "-pg" ]; then	\
>> +		$(sub_cmd_record_mcount)			\
>> +	fi;
>>  endif
>>
>>  define rule_cc_o_c
>
>
