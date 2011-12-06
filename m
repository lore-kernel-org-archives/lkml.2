Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390Ab1LFNlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:41:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933315Ab1LFNlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:41:03 -0500
Date: Tue, 6 Dec 2011 11:40:54 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] perf tools: Use for_each_set_bit() to iterate
	over feature flags
Message-ID: <20111206134054.GJ7059@infradead.org>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com> <1323167560-2282-11-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323167560-2282-11-git-send-email-robert.richter@amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 06, 2011 at 11:32:40AM +0100, Robert Richter escreveu:
> This patch introduces the for_each_set_bit() macro and modifies
> feature implementation to use it.

That is cool and thanks for following the convention of using the same
include file as in the kernel proper.

What would be really great would be to just use the kernel one like in

tools/perf/util/include/linux/list.h
tools/perf/util/include/linux/rbtree.h

But that was source of contention in the past when changes in the kernel
side broke the tools, i.e. the headers were not explicitely designed for
such sharing.

I wouldn't mind fixing the tools when such things happen tho, as most of
the time what happens is not breakage, but the tools reaping the
benefits of fixes and improvements done in the much larger hacker pool
that is the landlord of the major source repository where perf lives 8-)

- Arnaldo
 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  tools/perf/util/header.c               |  118 ++++++++------------------------
>  tools/perf/util/header.h               |    6 +-
>  tools/perf/util/include/linux/bitops.h |  118 ++++++++++++++++++++++++++++++++
>  3 files changed, 149 insertions(+), 93 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 915a5f7..7bea6e4 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -8,6 +8,7 @@
>  #include <stdlib.h>
>  #include <linux/list.h>
>  #include <linux/kernel.h>
> +#include <linux/bitops.h>
>  #include <sys/utsname.h>
>  
>  #include "evlist.h"
> @@ -1353,7 +1354,7 @@ static int perf_file_section__fprintf_info(struct perf_file_section *section,
>  				"%d, continuing...\n", section->offset, feat);
>  		return 0;
>  	}
> -	if (feat < HEADER_TRACE_INFO || feat >= HEADER_LAST_FEATURE) {
> +	if (feat >= HEADER_LAST_FEATURE) {
>  		pr_warning("unknown feature %d\n", feat);
>  		return 0;
>  	}
> @@ -1390,6 +1391,8 @@ static int do_write_feat(int fd, struct perf_header *h, int type,
>  	int ret = 0;
>  
>  	if (perf_header__has_feat(h, type)) {
> +		if (!feat_ops[type].write)
> +			return -1;
>  
>  		(*p)->offset = lseek(fd, 0, SEEK_CUR);
>  
> @@ -1416,6 +1419,7 @@ static int perf_header__adds_write(struct perf_header *header,
>  	struct perf_file_section *feat_sec, *p;
>  	int sec_size;
>  	u64 sec_start;
> +	int feat;
>  	int err;
>  
>  	session = container_of(header, struct perf_session, header);
> @@ -1433,61 +1437,10 @@ static int perf_header__adds_write(struct perf_header *header,
>  	sec_start = header->data_offset + header->data_size;
>  	lseek(fd, sec_start + sec_size, SEEK_SET);
>  
> -	err = do_write_feat(fd, header, HEADER_TRACE_INFO, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_TRACE_INFO);
> -
> -	err = do_write_feat(fd, header, HEADER_BUILD_ID, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_BUILD_ID);
> -
> -	err = do_write_feat(fd, header, HEADER_HOSTNAME, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_HOSTNAME);
> -
> -	err = do_write_feat(fd, header, HEADER_OSRELEASE, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_OSRELEASE);
> -
> -	err = do_write_feat(fd, header, HEADER_VERSION, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_VERSION);
> -
> -	err = do_write_feat(fd, header, HEADER_ARCH, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_ARCH);
> -
> -	err = do_write_feat(fd, header, HEADER_NRCPUS, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_NRCPUS);
> -
> -	err = do_write_feat(fd, header, HEADER_CPUDESC, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_CPUDESC);
> -
> -	err = do_write_feat(fd, header, HEADER_CPUID, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_CPUID);
> -
> -	err = do_write_feat(fd, header, HEADER_TOTAL_MEM, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_TOTAL_MEM);
> -
> -	err = do_write_feat(fd, header, HEADER_CMDLINE, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_CMDLINE);
> -
> -	err = do_write_feat(fd, header, HEADER_EVENT_DESC, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_EVENT_DESC);
> -
> -	err = do_write_feat(fd, header, HEADER_CPU_TOPOLOGY, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_CPU_TOPOLOGY);
> -
> -	err = do_write_feat(fd, header, HEADER_NUMA_TOPOLOGY, &p, evlist);
> -	if (err)
> -		perf_header__clear_feat(header, HEADER_NUMA_TOPOLOGY);
> +	for_each_set_bit(feat, header->adds_features, HEADER_FEAT_BITS) {
> +		if (do_write_feat(fd, header, feat, &p, evlist))
> +			perf_header__clear_feat(header, feat);
> +	}
>  
>  	lseek(fd, sec_start, SEEK_SET);
>  	/*
> @@ -1634,20 +1587,20 @@ static int perf_header__getbuffer64(struct perf_header *header,
>  int perf_header__process_sections(struct perf_header *header, int fd,
>  				  void *data,
>  				  int (*process)(struct perf_file_section *section,
> -				  struct perf_header *ph,
> -				  int feat, int fd, void *data))
> +						 struct perf_header *ph,
> +						 int feat, int fd, void *data))
>  {
> -	struct perf_file_section *feat_sec;
> +	struct perf_file_section *feat_sec, *sec;
>  	int nr_sections;
>  	int sec_size;
> -	int idx = 0;
> -	int err = -1, feat = 1;
> +	int feat;
> +	int err;
>  
>  	nr_sections = bitmap_weight(header->adds_features, HEADER_FEAT_BITS);
>  	if (!nr_sections)
>  		return 0;
>  
> -	feat_sec = calloc(sizeof(*feat_sec), nr_sections);
> +	feat_sec = sec = calloc(sizeof(*feat_sec), nr_sections);
>  	if (!feat_sec)
>  		return -1;
>  
> @@ -1655,20 +1608,16 @@ int perf_header__process_sections(struct perf_header *header, int fd,
>  
>  	lseek(fd, header->data_offset + header->data_size, SEEK_SET);
>  
> -	if (perf_header__getbuffer64(header, fd, feat_sec, sec_size))
> +	err = perf_header__getbuffer64(header, fd, feat_sec, sec_size);
> +	if (err < 0)
>  		goto out_free;
>  
> -	err = 0;
> -	while (idx < nr_sections && feat < HEADER_LAST_FEATURE) {
> -		if (perf_header__has_feat(header, feat)) {
> -			struct perf_file_section *sec = &feat_sec[idx++];
> -
> -			err = process(sec, header, feat, fd, data);
> -			if (err < 0)
> -				break;
> -		}
> -		++feat;
> +	for_each_set_bit(feat, header->adds_features, HEADER_LAST_FEATURE) {
> +		err = process(sec++, header, feat, fd, data);
> +		if (err < 0)
> +			goto out_free;
>  	}
> +	err = 0;
>  out_free:
>  	free(feat_sec);
>  	return err;
> @@ -1903,32 +1852,21 @@ static int perf_file_section__process(struct perf_file_section *section,
>  		return 0;
>  	}
>  
> +	if (feat >= HEADER_LAST_FEATURE) {
> +		pr_debug("unknown feature %d, continuing...\n", feat);
> +		return 0;
> +	}
> +
>  	switch (feat) {
>  	case HEADER_TRACE_INFO:
>  		trace_report(fd, false);
>  		break;
> -
>  	case HEADER_BUILD_ID:
>  		if (perf_header__read_build_ids(ph, fd, section->offset, section->size))
>  			pr_debug("Failed to read buildids, continuing...\n");
>  		break;
> -
> -	case HEADER_HOSTNAME:
> -	case HEADER_OSRELEASE:
> -	case HEADER_VERSION:
> -	case HEADER_ARCH:
> -	case HEADER_NRCPUS:
> -	case HEADER_CPUDESC:
> -	case HEADER_CPUID:
> -	case HEADER_TOTAL_MEM:
> -	case HEADER_CMDLINE:
> -	case HEADER_EVENT_DESC:
> -	case HEADER_CPU_TOPOLOGY:
> -	case HEADER_NUMA_TOPOLOGY:
> -		break;
> -
>  	default:
> -		pr_debug("unknown feature %d, continuing...\n", feat);
> +		break;
>  	}
>  
>  	return 0;
> diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
> index 3d5a742..5082efb 100644
> --- a/tools/perf/util/header.h
> +++ b/tools/perf/util/header.h
> @@ -10,7 +10,8 @@
>  #include <linux/bitmap.h>
>  
>  enum {
> -	HEADER_TRACE_INFO = 1,
> +	HEADER_RESERVED		= 0,	/* always cleared */
> +	HEADER_TRACE_INFO	= 1,
>  	HEADER_BUILD_ID,
>  
>  	HEADER_HOSTNAME,
> @@ -27,10 +28,9 @@ enum {
>  	HEADER_NUMA_TOPOLOGY,
>  
>  	HEADER_LAST_FEATURE,
> +	HEADER_FEAT_BITS	= 256,
>  };
>  
> -#define HEADER_FEAT_BITS			256
> -
>  struct perf_file_section {
>  	u64 offset;
>  	u64 size;
> diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
> index 305c848..62cdee7 100644
> --- a/tools/perf/util/include/linux/bitops.h
> +++ b/tools/perf/util/include/linux/bitops.h
> @@ -9,6 +9,17 @@
>  #define BITS_PER_BYTE           8
>  #define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
>  
> +#define for_each_set_bit(bit, addr, size) \
> +	for ((bit) = find_first_bit((addr), (size));		\
> +	     (bit) < (size);					\
> +	     (bit) = find_next_bit((addr), (size), (bit) + 1))
> +
> +/* same as for_each_set_bit() but use bit as value to start with */
> +#define for_each_set_bit_cont(bit, addr, size) \
> +	for ((bit) = find_next_bit((addr), (size), (bit));	\
> +	     (bit) < (size);					\
> +	     (bit) = find_next_bit((addr), (size), (bit) + 1))
> +
>  static inline void set_bit(int nr, unsigned long *addr)
>  {
>  	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
> @@ -30,4 +41,111 @@ static inline unsigned long hweight_long(unsigned long w)
>  	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
>  }
>  
> +#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
> +
> +/**
> + * __ffs - find first bit in word.
> + * @word: The word to search
> + *
> + * Undefined if no bit exists, so code should check against 0 first.
> + */
> +static __always_inline unsigned long __ffs(unsigned long word)
> +{
> +	int num = 0;
> +
> +#if BITS_PER_LONG == 64
> +	if ((word & 0xffffffff) == 0) {
> +		num += 32;
> +		word >>= 32;
> +	}
> +#endif
> +	if ((word & 0xffff) == 0) {
> +		num += 16;
> +		word >>= 16;
> +	}
> +	if ((word & 0xff) == 0) {
> +		num += 8;
> +		word >>= 8;
> +	}
> +	if ((word & 0xf) == 0) {
> +		num += 4;
> +		word >>= 4;
> +	}
> +	if ((word & 0x3) == 0) {
> +		num += 2;
> +		word >>= 2;
> +	}
> +	if ((word & 0x1) == 0)
> +		num += 1;
> +	return num;
> +}
> +
> +/*
> + * Find the first set bit in a memory region.
> + */
> +static inline unsigned long
> +find_first_bit(const unsigned long *addr, unsigned long size)
> +{
> +	const unsigned long *p = addr;
> +	unsigned long result = 0;
> +	unsigned long tmp;
> +
> +	while (size & ~(BITS_PER_LONG-1)) {
> +		if ((tmp = *(p++)))
> +			goto found;
> +		result += BITS_PER_LONG;
> +		size -= BITS_PER_LONG;
> +	}
> +	if (!size)
> +		return result;
> +
> +	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
> +	if (tmp == 0UL)		/* Are any bits set? */
> +		return result + size;	/* Nope. */
> +found:
> +	return result + __ffs(tmp);
> +}
> +
> +/*
> + * Find the next set bit in a memory region.
> + */
> +static inline unsigned long
> +find_next_bit(const unsigned long *addr, unsigned long size, unsigned long offset)
> +{
> +	const unsigned long *p = addr + BITOP_WORD(offset);
> +	unsigned long result = offset & ~(BITS_PER_LONG-1);
> +	unsigned long tmp;
> +
> +	if (offset >= size)
> +		return size;
> +	size -= result;
> +	offset %= BITS_PER_LONG;
> +	if (offset) {
> +		tmp = *(p++);
> +		tmp &= (~0UL << offset);
> +		if (size < BITS_PER_LONG)
> +			goto found_first;
> +		if (tmp)
> +			goto found_middle;
> +		size -= BITS_PER_LONG;
> +		result += BITS_PER_LONG;
> +	}
> +	while (size & ~(BITS_PER_LONG-1)) {
> +		if ((tmp = *(p++)))
> +			goto found_middle;
> +		result += BITS_PER_LONG;
> +		size -= BITS_PER_LONG;
> +	}
> +	if (!size)
> +		return result;
> +	tmp = *p;
> +
> +found_first:
> +	tmp &= (~0UL >> (BITS_PER_LONG - size));
> +	if (tmp == 0UL)		/* Are any bits set? */
> +		return result + size;	/* Nope. */
> +found_middle:
> +	return result + __ffs(tmp);
> +}
> +
>  #endif
> -- 
> 1.7.7
> 
