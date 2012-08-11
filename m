Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2HKN2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 09:28:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64932 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab2HKN2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 09:28:16 -0400
Subject: Re: [PATCH 11/16] perf symbol: introduce symsrc structure.
From: Namhyung Kim <namhyung@kernel.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <1344637382-22789-12-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
	 <1344637382-22789-12-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Aug 2012 22:28:09 +0900
Message-ID: <1344691689.2003.11.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-08-10 (금), 15:22 -0700, Cody P Schafer:
> Factors opening of certain sections & tracking certain elf info into an
> external structure.
> 
> The goal here is to keep multiple elfs (and their looked up
> sections/indexes) around during the symbol generation process (in
> dso__load()).
> 
> We need this to properly resolve symbols on PPC due to the
> use of function descriptors & the .opd section (ie: symbols which are
> functions don't point to their actual location, they point to their
> function descriptor in .opd which contains their actual location.
> 
> It would be possible to just keep the (Elf *) around, but then we'd end
> up with duplicate code for looking up the same sections and checking for
> the existence of an important section wouldn't be as clean (and we need
> to keep the Elf stuff confined to symtab-elf.c).
> 
> Utilized by the later patch
> "perf symbol: use both runtime and debug images"
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  tools/perf/util/symbol-elf.c     | 119 +++++++++++++++++++++++++++++----------
>  tools/perf/util/symbol-minimal.c |  30 +++++++++-
>  tools/perf/util/symbol.c         |  22 ++++----
>  tools/perf/util/symbol.h         |  36 +++++++++++-
>  4 files changed, 163 insertions(+), 44 deletions(-)
> 
[SNIP]
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 37f1ea1..5e55f98 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -11,6 +11,12 @@
>  #include <stdio.h>
>  #include <byteswap.h>
>  
> +#ifndef NO_LIBELF

Should be NO_LIBELF_SUPPORT.


> +#include <libelf.h>
> +#include <gelf.h>
> +#include <elf.h>
> +#endif
> +
>  #ifdef HAVE_CPLUS_DEMANGLE
>  extern char *cplus_demangle(const char *, int);
>  
> @@ -219,6 +225,34 @@ struct dso {
>  	char		 name[0];
>  };
>  
> +struct symsrc {
> +	char *name;
> +	int fd;
> +	enum dso_binary_type type;
> +
> +#ifndef NO_LIBELF

Ditto.

Thanks,
Namhyung


> +	Elf *elf;
> +	GElf_Ehdr ehdr;
> +
> +	Elf_Scn *opdsec;
> +	size_t opdidx;
> +	GElf_Shdr opdshdr;
> +
> +	Elf_Scn *symtab;
> +	GElf_Shdr symshdr;
> +
> +	Elf_Scn *dynsym;
> +	size_t dynsym_idx;
> +	GElf_Shdr dynshdr;
> +
> +	bool adjust_symbols;
> +#endif
> +};
> +
> +void symsrc__destroy(struct symsrc *ss);
> +int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
> +		 enum dso_binary_type type);
> +
>  #define DSO__SWAP(dso, type, val)			\
>  ({							\
>  	type ____r = val;				\
> @@ -334,7 +368,7 @@ ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
>  			    struct machine *machine, u64 addr,
>  			    u8 *data, ssize_t size);
>  int dso__test_data(void);
> -int dso__load_sym(struct dso *dso, struct map *map, const char *name, int fd,
> +int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
>  		  symbol_filter_t filter, int kmodule, int want_symtab);
>  int dso__synthesize_plt_symbols(struct dso *dso, char *name, struct map *map,
>  				symbol_filter_t filter);



