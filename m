Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2A3Fz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 00:55:27 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:53434 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2A3FzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 00:55:25 -0500
Message-ID: <4F2630BB.10802@linux.vnet.ibm.com>
Date: Mon, 30 Jan 2012 11:25:07 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu, dsahern@gmail.com
Subject: Re: [PATCH v4 14/18] perf: fix endianness detection in perf.data
References: <1327697778-18515-1-git-send-email-eranian@google.com> <1327697778-18515-15-git-send-email-eranian@google.com>
In-Reply-To: <1327697778-18515-15-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12013005-3864-0000-0000-0000012A580B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 January 2012 02:26 AM, Stephane Eranian wrote:
> The current version of perf detects whether or not
> the perf.data file is written in a different endianness
> using the attr_size field in the header of the file. This
> field represents sizeof(struct perf_event_attr) as known
> to perf record. If the sizes do not match, then perf tries
> the byte-swapped version. If they match, then the tool assumes
> a different endianness.
> 
> The issue with the approach is that it assumes the size of
> perf_event_attr always has to match between perf record and
> perf report. However, the kernel perf_event ABI is extensible.
> New fields can be added to struct perf_event_attr. Consequently,
> it is not possible to use attr_size to detect endianness.
> 
> This patch takes another approach by using the magic number
> written at the beginning of the perf.data file to detect
> endianness. The magic number is an eight-byte signature.
> It's primary purpose is to identify (signature) a perf.data
> file. But it could also be used to encode the endianness.
> 
> The patch introduces a new value for this signature. The key
> difference is that the signature is written differently in
> the file depending on the endianness. Thus, by comparing the
> signature from the file with the tool's own signature it is
> possible to detect endianness. The new signature is "PERFILE2".
> 
> Backward compatiblity with existing perf.data file is
> ensured.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/util/header.c |   77 ++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 64 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index ecd7f4d..6f4187d 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -63,9 +63,20 @@ char *perf_header__find_event(u64 id)
>  	return NULL;
>  }
> 
> -static const char *__perf_magic = "PERFFILE";
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
In perf context, the variable '__perf_magic2_sw' (I guess 'sw' stands for switch)
sounds something related to SW events. Could we change this to something like
'__perf_magic2_revend' or simply '__perf_magic2_rev' which would mean reverse endianness ?
> 
> -#define PERF_MAGIC	(*(u64 *)__perf_magic)
> +#define PERF_MAGIC	__perf_magic2
> 
>  struct perf_file_attr {
>  	struct perf_event_attr	attr;
> @@ -1620,24 +1631,59 @@ int perf_header__process_sections(struct perf_header *header, int fd,
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
> +			ph->needs_swap = true;
> +		}
> +		return 0;
> +	}
> +
> +	/* check magic number with same endianness */
> +	if (*magic == __perf_magic2)
> +		return 0;
> +
> +	/* check magic number but opposite endianness */
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
> +	if (check_magic_endian(&header->magic, header, ph) < 0)
> +		return -1;
> 
> +	if (ph->needs_swap) {
>  		mem_bswap_64(header, offsetof(struct perf_file_header,
> -					    adds_features));
> -		ph->needs_swap = true;
> +			     adds_features));
>  	}
> 
>  	if (header->size != sizeof(*header)) {
> @@ -1873,8 +1919,13 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
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


-- 
Anshuman Khandual
Linux Technology Centre
IBM Systems and Technology Group

