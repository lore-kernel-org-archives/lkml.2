Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab0FQOtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 10:49:49 -0400
Received: from ozlabs.org ([203.10.76.45]:38517 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab0FQOts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 10:49:48 -0400
Date: Fri, 18 Jun 2010 00:46:08 +1000
From: Anton Blanchard <anton@samba.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, amodra@gmail.com
Subject: Re: [PATCH] perf lookup of ppc64 symbols
Message-ID: <20100617144608.GS28295@kryten>
References: <1276523793-15422-1-git-send-email-ebmunson@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276523793-15422-1-git-send-email-ebmunson@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> Currently symbol resolution does not work for 64-bit programs
> using perf.  For this to work perf needs to lookup symbol names in
> the OPD.  This patch adds this functionality.  The OPD data is
> used to find symbol names when available.

To clarify, this is an issue with 64bit architectures that use function
descriptors (eg ppc64). The problem is that a symbol doesn't point to a text
address, it points to a data area that contains (amongst other things) a
pointer to the text address.

We look for a section called ".opd" which is the function descriptor
area. To create the full symbol table, when we see a symbol in the function
descriptor section we load the first pointer and use that as the text
address. The only tricky part here is working out which section the
text address is in. Right now we have a loop which is sub optimal:

> +	while ((sec = elf_nextscn(elf, sec)) != NULL) {
> +		gelf_getshdr(sec, &shdr);
> +
> +		if ((addr >= shdr.sh_addr) &&
> +		    (addr < (shdr.sh_addr + shdr.sh_size)))
> +			return cnt;
> +
> +		++cnt;
> +	}

Anton

> Signed-off-by: Anton Blanchard <anton@samba.org>
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> ---
>  tools/perf/util/symbol.c |   37 ++++++++++++++++++++++++++++++++++---
>  1 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index b63e571..971d0a0 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -933,6 +933,25 @@ static bool elf_sec__is_a(GElf_Shdr *self, Elf_Data *secstrs, enum map_type type
>  	}
>  }
>  
> +static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
> +{
> +	Elf_Scn *sec = NULL;
> +	GElf_Shdr shdr;
> +	size_t cnt = 1;
> +
> +	while ((sec = elf_nextscn(elf, sec)) != NULL) {
> +		gelf_getshdr(sec, &shdr);
> +
> +		if ((addr >= shdr.sh_addr) &&
> +		    (addr < (shdr.sh_addr + shdr.sh_size)))
> +			return cnt;
> +
> +		++cnt;
> +	}
> +
> +	return -1;
> +}
> +
>  static int dso__load_sym(struct dso *self, struct map *map, const char *name,
>  			 int fd, symbol_filter_t filter, int kmodule)
>  {
> @@ -944,12 +963,13 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
>  	int err = -1;
>  	uint32_t idx;
>  	GElf_Ehdr ehdr;
> -	GElf_Shdr shdr;
> -	Elf_Data *syms;
> +	GElf_Shdr shdr, opdshdr;
> +	Elf_Data *syms, *opddata = NULL;
>  	GElf_Sym sym;
> -	Elf_Scn *sec, *sec_strndx;
> +	Elf_Scn *sec, *sec_strndx, *opdsec;
>  	Elf *elf;
>  	int nr = 0;
> +	size_t opdidx = 0;
>  
>  	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
>  	if (elf == NULL) {
> @@ -969,6 +989,10 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
>  			goto out_elf_end;
>  	}
>  
> +	opdsec = elf_section_by_name(elf, &ehdr, &opdshdr, ".opd", &opdidx);
> +	if (opdsec)
> +		opddata = elf_rawdata(opdsec, NULL);
> +
>  	syms = elf_getdata(sec, NULL);
>  	if (syms == NULL)
>  		goto out_elf_end;
> @@ -1013,6 +1037,13 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
>  		if (!is_label && !elf_sym__is_a(&sym, map->type))
>  			continue;
>  
> +		if (opdsec && sym.st_shndx == opdidx) {
> +			u32 offset = sym.st_value - opdshdr.sh_addr;
> +			u64 *opd = opddata->d_buf + offset;
> +			sym.st_value = *opd;
> +			sym.st_shndx = elf_addr_to_index(elf, sym.st_value);
> +		}
> +
>  		sec = elf_getscn(elf, sym.st_shndx);
>  		if (!sec)
>  			goto out_elf_end;
> -- 
> 1.7.0.4
