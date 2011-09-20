Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967Ab1ITTAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:00:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58749 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1ITS77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:59:59 -0400
Message-ID: <4E78E2A9.6060706@gmail.com>
Date: Tue, 20 Sep 2011 12:59:53 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, acme@redhat.com,
        mingo@elte.hu
Subject: Re: [PATCH] perf: fix perf.data endianness detection
References: <20110919095620.GA9607@quad>
In-Reply-To: <20110919095620.GA9607@quad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/19/2011 03:56 AM, Stephane Eranian wrote:
> 
> The current version of perf detects whether or not
> the perf.data file is written in a different endianness
> using the attr_size field in the header of the file. This
> field represents sizeof(struct perf_event) as known to perf
> record. If the size does not match, then perf tries the
> byte-swapped version. If they match, then the tool assumes
> a different endianness.
> 
> The issue with the approach is that it assumes the size of
> perf_event_attr always has to match between the file and the
> tool. However, the kernel API is designed to make it possible
> to extend perf_event_attr for new features. Consequently, it
> is not possible to use attr_size to detect endianness.
> 
> This patch takes another approach by using the magic number
> written at the beginning of the perf.data file to detect
> endianness mismatch. The magic number is an eight-byte
> signature. The patch introduces a new value for this
> signature. The key difference is that the signature
> is written differently in the file depending on the
> endianness. Thus, by comparing the signature from the file
> with the tool's own signature it is possible to detect if
> the endianness matches. The new signature is "PERFILE2".
> 
> Backward compatiblity with existing perf.data file is
> ensured.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index b6c1ad1..d824502 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -57,9 +57,20 @@ char *perf_header__find_event(u64 id)
>  	return NULL;
>  }
>  
> -static const char *__perf_magic = "PERFFILE";
> -
> -#define PERF_MAGIC	(*(u64 *)__perf_magic)
> +/*
> + * magic2 = "PERFILE2"
> + * must be a numerical value to let the endianness
> + * determine the memory layout. That way we are able
> + * to detect endianness when reading the perf.data file
> + * back.
> + *
> + * we check for legacy (PERFFILE) format.
> + */
> +static const char *__perf_magic1 = "PERFFILE";
> +static const u64 __perf_magic2    = 0x32454c4946524550ULL;
> +static const u64 __perf_magic2_sw = 0x50455246494c4532ULL;
> +
> +#define PERF_MAGIC	(__perf_magic2)
>  
>  struct perf_file_attr {
>  	struct perf_event_attr	attr;
> @@ -595,25 +606,57 @@ out_free:
>  	return err;
>  }
>  
> +static int check_magic_endian(u64 *magic, struct perf_file_header *header,
> +			      struct perf_header *ph)
> +{
> +	int ret;
> +
> +	/* check for legacy format */
> +	ret = memcmp(magic, __perf_magic1, sizeof(*magic));
> +	if (ret == 0) {
> +		pr_debug("legacy perf.data format\n");
> +		if (!header)
> +			return -1;
> +
> +		if (header->attr_size != sizeof(struct perf_file_attr)) {
> +			u64 attr_size = bswap_64(header->attr_size);
> +
> +			if (attr_size != sizeof(struct perf_file_attr))
> +				return -1;
> +
> +			mem_bswap_64(header, offsetof(struct perf_file_header,
> +						adds_features));
> +			ph->needs_swap = true;
> +		}
> +		return 0;
> +	}
> +
> +	/* check for our magic (same endianness) */
> +	if (*magic == __perf_magic2)
> +		return 0;
> +
> +	/* check for our magic (opposite endianness) */
> +	if (*magic != __perf_magic2_sw)
> +		return -1;
> +
> +	ph->needs_swap = true;
> +
> +	return 0;
> +}
> +
>  int perf_file_header__read(struct perf_file_header *header,
>  			   struct perf_header *ph, int fd)
>  {
> +	int ret;
> +
>  	lseek(fd, 0, SEEK_SET);
>  
> -	if (readn(fd, header, sizeof(*header)) <= 0 ||
> -	    memcmp(&header->magic, __perf_magic, sizeof(header->magic)))
> +	ret = readn(fd, header, sizeof(*header));
> +	if (ret <= 0)
>  		return -1;
>  
> -	if (header->attr_size != sizeof(struct perf_file_attr)) {
> -		u64 attr_size = bswap_64(header->attr_size);
> -
> -		if (attr_size != sizeof(struct perf_file_attr))
> -			return -1;
> -
> -		mem_bswap_64(header, offsetof(struct perf_file_header,
> -					    adds_features));
> -		ph->needs_swap = true;
> -	}
> +	if (check_magic_endian(&header->magic, header, ph) < 0)
> +		return -1;
>  
>  	if (header->size != sizeof(*header)) {
>  		/* Support the previous format */
> @@ -824,8 +867,13 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
>  				       struct perf_header *ph, int fd,
>  				       bool repipe)
>  {
> -	if (readn(fd, header, sizeof(*header)) <= 0 ||
> -	    memcmp(&header->magic, __perf_magic, sizeof(header->magic)))
> +	int ret;
> +
> +	ret = readn(fd, header, sizeof(*header));
> +	if (ret <= 0)
> +		return -1;
> +
> +	 if (check_magic_endian(&header->magic, NULL, ph) < 0)
>  		return -1;
>  
>  	if (repipe && do_write(STDOUT_FILENO, header, sizeof(*header)) < 0)


tip + this patch

new PPC data file created and then the data file is analyzed on x86
$ perf script -i /tmp/perf-new-ppc.data
  incompatible file format

on x86:
$ od -c /tmp/perf-new-ppc.data | head -1
0000000   2   E   L   I   F   R   E   P  \0  \0  \0  \0  \0  \0  \0   h

So it is using the new magic.

Same file on ppc:
# od -c /tmp/perf-new-ppc.data | head -1
0000000   2   E   L   I   F   R   E   P  \0  \0  \0  \0  \0  \0  \0   h

David
