Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2KEGXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:23:09 -0500
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:38292 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2KEGXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:23:07 -0500
Date: Mon, 5 Nov 2012 15:04:30 +0900
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: mitsuhiro.tanino.gm@hitachi.com
Cc: vgoyal@redhat.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com
Subject: Re: [PATCH 1/2 v2] makedumpfile: Add a default action to exclude
 hwpoison page from vmcore
Message-Id: <20121105150430.11a524bcfdcf17668e2bec20@mxc.nes.nec.co.jp>
In-Reply-To: <5091300D.5030106@hitachi.com>
References: <508FDEF3.8030601@hitachi.com>
	<20121030143750.GF2290@redhat.com>
	<5091300D.5030106@hitachi.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tanino-san,

On Wed, 31 Oct 2012 23:05:01 +0900
Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com> wrote:

> This patch introduces a function which excludes hwpoison pages
> from vmcore as a default action for makedumpfile.
> 
> Signed-off-by: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>

Thank you for your work. I think it's good feature.

I will merge this patch into makedumpfile-1.5.2 with the small change below.
Of course, I will accept --no-hwposion-filtering option when it's needed.


diff --git a/makedumpfile.c b/makedumpfile.c
index 30cf130..fcf42f6 100644
--- a/makedumpfile.c
+++ b/makedumpfile.c
@@ -3864,8 +3864,8 @@ __exclude_unnecessary_pages(unsigned long mem_map,
                 * Exclude the hwpoison page.
                 */
                else if (isHWPOISON(flags)) {
-                       clear_bit_on_2nd_bitmap_for_kernel(pfn);
-                       pfn_hwpoison++;
+                       if (clear_bit_on_2nd_bitmap_for_kernel(pfn))
+                               pfn_hwpoison++;
                }
        }
        return TRUE;


Thanks
Atsushi Kumagai


> diff -uprN a/makedumpfile.c b/makedumpfile.c
> --- a/makedumpfile.c	2012-10-01 15:26:54.510354074 +0900
> +++ b/makedumpfile.c	2012-10-29 22:32:24.913057535 +0900
> @@ -43,6 +43,7 @@ unsigned long long pfn_cache;
>  unsigned long long pfn_cache_private;
>  unsigned long long pfn_user;
>  unsigned long long pfn_free;
> +unsigned long long pfn_hwpoison;
>  
>  unsigned long long num_dumped;
>  
> @@ -969,6 +970,7 @@ get_structure_info(void)
>  	ENUM_NUMBER_INIT(PG_lru, "PG_lru");
>  	ENUM_NUMBER_INIT(PG_private, "PG_private");
>  	ENUM_NUMBER_INIT(PG_swapcache, "PG_swapcache");
> +	ENUM_NUMBER_INIT(PG_hwpoison, "PG_hwpoison");
>  
>  	TYPEDEF_SIZE_INIT(nodemask_t, "nodemask_t");
>  
> @@ -1371,6 +1373,7 @@ write_vmcoreinfo_data(void)
>  	WRITE_NUMBER("PG_lru", PG_lru);
>  	WRITE_NUMBER("PG_private", PG_private);
>  	WRITE_NUMBER("PG_swapcache", PG_swapcache);
> +	WRITE_NUMBER("PG_hwpoison", PG_hwpoison);
>  
>  	/*
>  	 * write the source file of 1st kernel
> @@ -1659,6 +1662,7 @@ read_vmcoreinfo(void)
>  	READ_NUMBER("PG_lru", PG_lru);
>  	READ_NUMBER("PG_private", PG_private);
>  	READ_NUMBER("PG_swapcache", PG_swapcache);
> +	READ_NUMBER("PG_hwpoison", PG_hwpoison);
>  
>  	READ_SRCFILE("pud_t", pud_t);
>  
> @@ -3856,6 +3860,13 @@ __exclude_unnecessary_pages(unsigned lon
>  			if (clear_bit_on_2nd_bitmap_for_kernel(pfn))
>  				pfn_user++;
>  		}
> +		/*
> +		 * Exclude the hwpoison page.
> +		 */
> +		else if (isHWPOISON(flags)) {
> +			clear_bit_on_2nd_bitmap_for_kernel(pfn);
> +			pfn_hwpoison++;
> +		}
>  	}
>  	return TRUE;
>  }
> @@ -3914,11 +3925,13 @@ exclude_unnecessary_pages_cyclic(void)
>  			return FALSE;
>  
>  	/*
> -	 * Exclude cache pages, cache private pages, user data pages, and free pages.
> +	 * Exclude cache pages, cache private pages, user data pages,
> +	   free pages and hwpoison pages.
>  	 */
>  	if (info->dump_level & DL_EXCLUDE_CACHE ||
>  	    info->dump_level & DL_EXCLUDE_CACHE_PRI ||
> -	    info->dump_level & DL_EXCLUDE_USER_DATA) {
> +	    info->dump_level & DL_EXCLUDE_USER_DATA ||
> +	    (NUMBER(PG_hwpoison) != NOT_FOUND_NUMBER)) {
>  
>  		gettimeofday(&tv_start, NULL);
>  
> @@ -4018,11 +4031,13 @@ create_2nd_bitmap(void)
>  	}
>  
>  	/*
> -	 * Exclude cache pages, cache private pages, user data pages.
> +	 * Exclude cache pages, cache private pages, user data pages,
> +	 * and hwpoison pages.
>  	 */
>  	if (info->dump_level & DL_EXCLUDE_CACHE ||
>  	    info->dump_level & DL_EXCLUDE_CACHE_PRI ||
> -	    info->dump_level & DL_EXCLUDE_USER_DATA) {
> +	    info->dump_level & DL_EXCLUDE_USER_DATA ||
> +	    (NUMBER(PG_hwpoison) != NOT_FOUND_NUMBER)) {
>  		if (!exclude_unnecessary_pages()) {
>  			ERRMSG("Can't exclude unnecessary pages.\n");
>  			return FALSE;
> @@ -5062,7 +5077,8 @@ write_elf_pages_cyclic(struct cache_data
>  	/*
>  	 * Reset counter for debug message.
>  	 */
> -	pfn_zero =  pfn_cache = pfn_cache_private = pfn_user = pfn_free = 0;
> +	pfn_zero = pfn_cache = pfn_cache_private = 0;
> +	pfn_user = pfn_free = pfn_hwpoison = 0;
>  	pfn_memhole = info->max_mapnr;
>  
>  	info->cyclic_start_pfn = 0;
> @@ -5902,7 +5918,8 @@ write_kdump_pages_and_bitmap_cyclic(stru
>  	/*
>  	 * Reset counter for debug message.
>  	 */
> -	pfn_zero =  pfn_cache = pfn_cache_private = pfn_user = pfn_free = 0;
> +	pfn_zero = pfn_cache = pfn_cache_private = 0;
> +	pfn_user = pfn_free = pfn_hwpoison = 0;
>  	pfn_memhole = info->max_mapnr;
>  
>  	cd_header->offset
> @@ -6687,7 +6704,7 @@ print_report(void)
>  	pfn_original = info->max_mapnr - pfn_memhole;
>  
>  	pfn_excluded = pfn_zero + pfn_cache + pfn_cache_private
> -	    + pfn_user + pfn_free;
> +	    + pfn_user + pfn_free + pfn_hwpoison;
>  	shrinking = (pfn_original - pfn_excluded) * 100;
>  	shrinking = shrinking / pfn_original;
>  
> @@ -6700,6 +6717,7 @@ print_report(void)
>  	    pfn_cache_private);
>  	REPORT_MSG("    User process data pages : 0x%016llx\n", pfn_user);
>  	REPORT_MSG("    Free pages              : 0x%016llx\n", pfn_free);
> +	REPORT_MSG("    Hwpoison pages          : 0x%016llx\n", pfn_hwpoison);
>  	REPORT_MSG("  Remaining pages  : 0x%016llx\n",
>  	    pfn_original - pfn_excluded);
>  	REPORT_MSG("  (The number of pages is reduced to %lld%%.)\n",
> diff -uprN a/makedumpfile.h b/makedumpfile.h
> --- a/makedumpfile.h	2012-10-01 15:26:54.512354076 +0900
> +++ b/makedumpfile.h	2012-10-29 20:59:19.723015190 +0900
> @@ -107,6 +107,8 @@ test_bit(int nr, unsigned long addr)
>  #define isLRU(flags)		test_bit(NUMBER(PG_lru), flags)
>  #define isPrivate(flags)	test_bit(NUMBER(PG_private), flags)
>  #define isSwapCache(flags)	test_bit(NUMBER(PG_swapcache), flags)
> +#define isHWPOISON(flags)	(test_bit(NUMBER(PG_hwpoison), flags) \
> +				&& (NUMBER(PG_hwpoison) != NOT_FOUND_NUMBER))
>  
>  static inline int
>  isAnon(unsigned long mapping)
> @@ -1244,6 +1246,7 @@ struct number_table {
>  	long	PG_lru;
>  	long	PG_private;
>  	long	PG_swapcache;
> +	long    PG_hwpoison;
>  };
>  
>  struct srcfile_table {
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
