Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab2HTCYa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 22:24:30 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43070 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2HTCY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 22:24:29 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-d2-50319fdbf7e4
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf: fix builds with NO_LIBELF set
References: <1345391234-71906-1-git-send-email-dsahern@gmail.com>
Date: Mon, 20 Aug 2012 11:17:31 +0900
In-Reply-To: <1345391234-71906-1-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Sun, 19 Aug 2012 09:47:14 -0600")
Message-ID: <87r4r2i9xg.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2012 09:47:14 -0600, David Ahern wrote:
> Build currently fails:
> $ make -C tools/perf O=/tmp/pbuild NO_LIBELF=1
>
> util/symbol.c: In function ‘dso__load’:
> util/symbol.c:1128:27: error: ‘struct symsrc’ has no member named ‘dynsym’
>     CC /tmp/pbuild/util/pager.o
> make: *** [/tmp/pbuild/util/symbol.o] Error 1
> make: *** Waiting for unfinished jobs....
>
> Moving the dynsym reference to symbol-elf.c reveals that NO_LIBELF requires
> NO_LIBUNWIND:
>
> $ make -C tools/perf O=/tmp/pbuild NO_LIBELF=1
>
>     LINK /tmp/pbuild/perf
> /tmp/pbuild/libperf.a(unwind.o): In function `elf_section_offset':
> /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:176: undefined reference to `elf_begin'
> /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:181: undefined reference to `gelf_getehdr'
> /tmp/pbuild/libperf.a(unwind.o): In function `elf_section_by_name':
> /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:157: undefined reference to `elf_nextscn'
> /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:160: undefined reference to `gelf_getshdr'
> /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:161: undefined reference to `elf_strptr'
> /tmp/pbuild/libperf.a(unwind.o): In function `elf_section_offset':
> /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:190: undefined reference to `elf_end'
> /tmp/pbuild/libperf.a(unwind.o): In function `read_unwind_spec':
> /opt/sw/ahern/perf.git/tools/perf/util/unwind.c:190: undefined reference to `elf_end'
> collect2: ld returned 1 exit status
> make: *** [/tmp/pbuild/perf] Error 1
> make: Leaving directory `/opt/sw/ahern/perf.git/tools/perf'
>
> This patch fixes both.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Jiri Olsa <jolsa@redhat.com>

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/Makefile          |    1 +
>  tools/perf/util/symbol-elf.c |    3 +++
>  tools/perf/util/symbol.c     |    2 +-
>  3 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 75af93d..1eb7f12 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -469,6 +469,7 @@ PYRF_OBJS += $(OUTPUT)util/xyarray.o
>  ifdef NO_LIBELF
>  	NO_DWARF := 1
>  	NO_DEMANGLE := 1
> +	NO_LIBUNWIND := 1
>  else
>  FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
>  ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 5b37e13..db0cc92 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -183,6 +183,9 @@ int dso__synthesize_plt_symbols(struct dso *dso, struct symsrc *ss, struct map *
>  	Elf *elf;
>  	int nr = 0, symidx, err = 0;
>  
> +	if (!ss->dynsym)
> +		return 0;
> +
>  	elf = ss->elf;
>  	ehdr = ss->ehdr;
>  
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 2293a4a..753699a 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1125,7 +1125,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
>  	else
>  		ret = -1;
>  
> -	if (ret > 0 && runtime_ss->dynsym) {
> +	if (ret > 0) {
>  		int nr_plt;
>  
>  		nr_plt = dso__synthesize_plt_symbols(dso, runtime_ss, map, filter);
