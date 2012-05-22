Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979Ab2EVD0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 23:26:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40974 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165Ab2EVD0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 23:26:46 -0400
Message-ID: <4FBB0771.1010009@gmail.com>
Date: Mon, 21 May 2012 21:26:41 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] perf, tool: Handle different endians properly during
 symbol load
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com> <1337151548-2396-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337151548-2396-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/12 12:59 AM, Jiri Olsa wrote:
> Currently we dont care about the file object's endianness. It's possible
> we read buildid file object from different architecture than we are
> currentlly running on. So we need to care about properly reading such
> object's data - handle different endianness properly.
>
> Adding:
> 	needs_swap DSO field
> 	dso__swap_init function to initialize DSO's needs_swap
> 	DSO__READ to read the data with proper swaps
>
> Note, running following to test perf endianity handling:
> test 1)
>    - origin system:
>      # perf record -a -- sleep 10 (any perf record will do)
>      # perf report>  report.origin
>      # perf archive perf.data
>
>    - copy the perf.data, report.origin and perf.data.tar.bz2
>      to a target system and run:
>      # tar xjvf perf.data.tar.bz2 -C ~/.debug
>      # perf report>  report.target
>      # diff -u report.origin report.target
>
>    - the diff should produce no output
>      (besides some white space stuff and possibly different
>       date/TZ output)
>
> test 1)
>    - origin system:
>      # perf record -ag -fo /tmp/perf.data -- sleep 1
>    - mount origin system root to the target system on /mnt/origin
>    - target system:
>      # perf script --symfs /mnt/origin -I -i /mnt/origin/tmp/perf.data \
>       --kallsyms /mnt/origin/proc/kallsyms
>    - complete perf.data header is displayed
>
> Signed-off-by: Jiri Olsa<jolsa@redhat.com>
> ---
>   tools/perf/util/symbol.c |   33 ++++++++++++++++++++++++++++++++-
>   tools/perf/util/symbol.h |   30 ++++++++++++++++++++++++++++++
>   2 files changed, 62 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index e2ba885..04a83c5 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -323,6 +323,7 @@ struct dso *dso__new(const char *name)
>   		dso->sorted_by_name = 0;
>   		dso->has_build_id = 0;
>   		dso->kernel = DSO_TYPE_USER;
> +		dso->needs_swap = DSO_SWAP__UNSET;
>   		INIT_LIST_HEAD(&dso->node);
>   	}
>
> @@ -1156,6 +1157,33 @@ static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
>   	return -1;
>   }
>
> +static int dso__swap_init(struct dso *dso, unsigned char eidata)
> +{
> +	static unsigned int const endian = 1;
> +
> +	dso->needs_swap = DSO_SWAP__NO;
> +
> +	switch (eidata) {
> +	case ELFDATA2LSB:
> +		/* We are big endian, DSO is little endian. */
> +		if (*(unsigned char const *)&endian != 1)
> +			dso->needs_swap = DSO_SWAP__YES;
> +		break;
> +
> +	case ELFDATA2MSB:
> +		/* We are little endian, DSO is big endian. */
> +		if (*(unsigned char const *)&endian != 0)
> +			dso->needs_swap = DSO_SWAP__YES;
> +		break;
> +
> +	default:
> +		pr_err("unrecognized DSO data encoding %d\n", eidata);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>   static int dso__load_sym(struct dso *dso, struct map *map, const char *name,
>   			 int fd, symbol_filter_t filter, int kmodule,
>   			 int want_symtab)
> @@ -1187,6 +1215,9 @@ static int dso__load_sym(struct dso *dso, struct map *map, const char *name,
>   		goto out_elf_end;
>   	}
>
> +	if (dso__swap_init(dso, ehdr.e_ident[EI_DATA]))
> +		goto out_elf_end;
> +
>   	/* Always reject images with a mismatched build-id: */
>   	if (dso->has_build_id) {
>   		u8 build_id[BUILD_ID_SIZE];
> @@ -1272,7 +1303,7 @@ static int dso__load_sym(struct dso *dso, struct map *map, const char *name,
>   		if (opdsec&&  sym.st_shndx == opdidx) {
>   			u32 offset = sym.st_value - opdshdr.sh_addr;
>   			u64 *opd = opddata->d_buf + offset;
> -			sym.st_value = *opd;
> +			sym.st_value = DSO__READ(dso, u64, *opd);
>   			sym.st_shndx = elf_addr_to_index(elf, sym.st_value);
>   		}
>
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 5649d63..be14744 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -9,6 +9,7 @@
>   #include<linux/list.h>
>   #include<linux/rbtree.h>
>   #include<stdio.h>
> +#include<byteswap.h>
>
>   #ifdef HAVE_CPLUS_DEMANGLE
>   extern char *cplus_demangle(const char *, int);
> @@ -160,11 +161,18 @@ enum dso_kernel_type {
>   	DSO_TYPE_GUEST_KERNEL
>   };
>
> +enum dso_swap_type {
> +	DSO_SWAP__UNSET,
> +	DSO_SWAP__NO,
> +	DSO_SWAP__YES,
> +};
> +
>   struct dso {
>   	struct list_head node;
>   	struct rb_root	 symbols[MAP__NR_TYPES];
>   	struct rb_root	 symbol_names[MAP__NR_TYPES];
>   	enum dso_kernel_type	kernel;
> +	enum dso_swap_type	needs_swap;
>   	u8		 adjust_symbols:1;
>   	u8		 has_build_id:1;
>   	u8		 hit:1;
> @@ -182,6 +190,28 @@ struct dso {
>   	char		 name[0];
>   };
>
> +#define DSO__READ(dso, type, val)			\

s/DSO__READ/DSO__SWAP/? it's swapping byes, not reading.

David

