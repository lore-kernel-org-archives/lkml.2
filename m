Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab2IUA0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:26:13 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53996 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2IUA0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:26:10 -0400
X-AuditID: 9c930197-b7b6dae000000e70-c8-505bb4203a66
From: Namhyung Kim <namhyung@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH 3/4] perf annotate: configure objdump path at compile time
References: <1348179215-11160-1-git-send-email-irina.tirdea@gmail.com>
	<1348179215-11160-4-git-send-email-irina.tirdea@gmail.com>
Date: Fri, 21 Sep 2012 09:17:27 +0900
In-Reply-To: <1348179215-11160-4-git-send-email-irina.tirdea@gmail.com> (Irina
	Tirdea's message of "Fri, 21 Sep 2012 01:13:34 +0300")
Message-ID: <87fw6cz0tk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Irina,

On Fri, 21 Sep 2012 01:13:34 +0300, Irina Tirdea wrote:
> From: Irina Tirdea <irina.tirdea@intel.com>
>
> The default name for objdump is "objdump". For cross-compiling the name of
> objdump will be different (e.g. arm-eabi-objdump in Android).
>
> Setting the default objdump name in the Makefile with PERF_OBJDUMP_PATH.

Not a big deal, but how about DEFAULT_OBJDUMP_PATH?


>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> ---
>  tools/perf/Makefile        |    4 ++++
>  tools/perf/util/annotate.c |    2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 9021a1f..3d28150 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -140,6 +140,7 @@ ETC_PERFCONFIG = etc/perfconfig
>  endif
>  lib = lib
>  PERF_TMP_DIR = /tmp
> +objdump = objdump

More usual pattern would be

OBJDUMP = $(CROSS_COMPILE)objdump

? And it'd more fit to the description.

Thanks,
Namhyung


>  
>  export prefix bindir sharedir sysconfdir
>  
> @@ -883,6 +884,9 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
>  		'-DPREFIX="$(prefix_SQ)"' \
>  		$<
>  
> +$(OUTPUT)util/annotate.o: util/annotate.c $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_OBJDUMP_PATH='"$(objdump)"' $<
> +
>  $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
>  
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index f0a9103..a45ac77 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -824,7 +824,7 @@ fallback:
>  		 "%s %s%s --start-address=0x%016" PRIx64
>  		 " --stop-address=0x%016" PRIx64
>  		 " -d %s %s -C %s|grep -v %s|expand",
> -		 objdump_path ? objdump_path : "objdump",
> +		 objdump_path ? objdump_path : PERF_OBJDUMP_PATH,
>  		 disassembler_style ? "-M " : "",
>  		 disassembler_style ? disassembler_style : "",
>  		 map__rip_2objdump(map, sym->start),
