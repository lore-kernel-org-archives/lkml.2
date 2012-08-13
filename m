Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2HMWMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:12:25 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58065 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2HMWMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:12:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120813212151.GA15429@phenom.dumpdata.com>
References: <1344891431-30869-1-git-send-email-blquythai@gmail.com> <20120813212151.GA15429@phenom.dumpdata.com>
From: Thai Bui <blquythai@gmail.com>
Date: Mon, 13 Aug 2012 18:11:59 -0400
Message-ID: <CAKkTMC6B+Sddyy6eDePek73wRDC=TNt+Z5R0eUGf6DpYPwYVCA@mail.gmail.com>
Subject: Re: [PATCH 1/1] boot: Put initcall_debug into its own Kconfig option DEBUG_INITCALL
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am as part of a capstone group at Portland State University is
working to tinify the kernel as small as possible. The ultimate goal
is to make the kernel small enough to use on micro-controller (or
under < 200k). This patch is one of them, it saves 176 bytes on a
minimal configuration of the kernel (the bzImage file was reduced from
363264 bytes to 363264 bytes applying this patch).

Aside from the purpose of reducing the size of the kernel. We are also
trying to clean up the kernel by making Kconfig options to compile out
the stuffs that aren't used often.

On Mon, Aug 13, 2012 at 5:21 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Mon, Aug 13, 2012 at 01:57:11PM -0700, Thai Bui wrote:
>> Putting DEBUG_INITCALL config option to compile out the command-line option
>> "initcall_debug".
>
> Can you explain the benfits of this please?
>>
>> Signed-off-by: Thai Bui <blquythai@gmail.com>
>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>> ---
>>  Documentation/kernel-parameters.txt |    3 ++-
>>  include/linux/init.h                |    4 ++++
>>  init/main.c                         |    2 ++
>>  lib/Kconfig.debug                   |    9 +++++++++
>>  4 files changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index d99fd9c..3dbaf15 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1026,7 +1026,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>
>>       initcall_debug  [KNL] Trace initcalls as they are executed.  Useful
>>                       for working out where the kernel is dying during
>> -                     startup.
>> +                     startup. DEBUG_INITCALL needs to be enabled in order
>> +                     for this option to work.
>>
>>       initrd=         [BOOT] Specify the location of the initial ramdisk
>>
>> diff --git a/include/linux/init.h b/include/linux/init.h
>> index 6b95109..d2f31f1 100644
>> --- a/include/linux/init.h
>> +++ b/include/linux/init.h
>> @@ -157,7 +157,11 @@ void prepare_namespace(void);
>>
>>  extern void (*late_time_init)(void);
>>
>> +#ifdef CONFIG_DEBUG_INITCALL
>>  extern bool initcall_debug;
>> +#else
>> +static const bool initcall_debug = false;
>> +#endif /* CONFIG_DEBUG_INITCALL */
>>
>>  #endif
>>
>> diff --git a/init/main.c b/init/main.c
>> index ff49a6d..65837f7 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -648,8 +648,10 @@ static void __init do_ctors(void)
>>  #endif
>>  }
>>
>> +#ifdef CONFIG_DEBUG_INITCALL
>>  bool initcall_debug;
>>  core_param(initcall_debug, initcall_debug, bool, 0644);
>> +#endif /* CONFIG_DEBUG_INITCALL */
>>
>>  static char msgbuf[64];
>>
>> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
>> index 8745ac7..424ac93 100644
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -769,6 +769,15 @@ config DEBUG_WRITECOUNT
>>
>>         If unsure, say N.
>>
>> +config DEBUG_INITCALL
>> +     bool "Debug initcalls as they are executed"
>> +     depends on DEBUG_KERNEL
>> +     help
>> +       Enable this for tracing initcalls during startup. Useful for working
>> +       out where the kernel is dying during startup.
>> +
>> +       If unsure, say N
>> +
>>  config DEBUG_MEMORY_INIT
>>       bool "Debug memory initialisation" if EXPERT
>>       default !EXPERT
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thai
