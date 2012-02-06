Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2BFWTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:19:21 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45461 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab2BFWTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:19:20 -0500
Message-ID: <4F3051E3.5050402@gmail.com>
Date: Mon, 06 Feb 2012 15:19:15 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com
Subject: Re: [PATCH v5 16/18] perf: enable reading of perf.data files from
 different ABI rev
References: <1328187288-24395-1-git-send-email-eranian@google.com> <1328187288-24395-17-git-send-email-eranian@google.com>
In-Reply-To: <1328187288-24395-17-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/02/2012 05:54 AM, Stephane Eranian wrote:
> This patch allows perf to process perf.data files generated
> using an ABI that has a different perf_event_attr struct size, i.e.,
> a different ABI version.
> 
> The perf_event_attr can be extended, yet perf needs to cope with
> older perf.data files. Similarly, perf must be able to cope with
> a perf.data file which is using a newer version of the ABI than
> what it knows about.
> 
> This patch adds read_attr(), a routine that reads a perf_event_attr
> struct from a file incrementally based on its advertised size. If
> the on-file struct is smaller than what perf knows, then the extra
> fields are zeroed. If the on-file struct is bigger, then perf only
> uses what it knows about, the rest is skipped.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/util/header.c |   49 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 47 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 6f4187d..8d6c18d 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -1959,6 +1959,51 @@ static int perf_header__read_pipe(struct perf_session *session, int fd)
>  	return 0;
>  }
>  
> +static int read_attr(int fd, struct perf_header *ph,
> +		     struct perf_file_attr *f_attr)
> +{
> +	struct perf_event_attr *attr = &f_attr->attr;
> +	size_t sz, left;
> +	size_t our_sz = sizeof(f_attr->attr);
> +	int ret;
> +
> +	memset(f_attr, 0, sizeof(*f_attr));
> +
> +	/* read minimal guaranteed structure */
> +	ret = readn(fd, attr, PERF_ATTR_SIZE_VER0);
> +	if (ret <= 0)
> +		return -1;

As I recall the first bump in that structure happened in 2.6.32. Why add
backward compatibility for it now? ie., why not just expect VER1

> +
> +	/* on file perf_event_attr size */
> +	sz = attr->size;
> +	if (ph->needs_swap)
> +		sz = bswap_32(sz);
> +
> +	if (sz == 0) {
> +		/* assume ABI0 */
> +		sz =  PERF_ATTR_SIZE_VER0;

Shouldn't this be a failure? ie., problem with the file (or the
swapping) since size can't be 0

And then for the following why not restrict sz to known, expected sizes
-- using the PERF_ATTR_SIZE_VER defines introduced in patch 15?

> +	} else if (sz > our_sz) {
> +		/* bigger than what we know about */
> +		sz = our_sz;
> +
> +		/* skip what we do not know about */
> +		lseek(fd, SEEK_CUR, attr->size - our_sz);
> +	}
> +	/* what we have not yet read and that we know about */
> +	left = sz - PERF_ATTR_SIZE_VER0;
> +	if (left) {
> +		void *ptr = attr;
> +		ptr += PERF_ATTR_SIZE_VER0;
> +
> +		ret = readn(fd, ptr, left);
> +		if (ret <= 0)
> +			return -1;
> +	}
> +	/* read the ids */
> +	ret = readn(fd, &f_attr->ids, sizeof(struct perf_file_section));

Confused by the above? It is not done in the old code, so why read the
ids here? I scanned the other patches, but don't see other code movement
on this file.

David

> +	return ret <= 0 ? -1 : 0;
> +}
> +
>  int perf_session__read_header(struct perf_session *session, int fd)
>  {
>  	struct perf_header *header = &session->header;
> @@ -1979,14 +2024,14 @@ int perf_session__read_header(struct perf_session *session, int fd)
>  		return -EINVAL;
>  	}
>  
> -	nr_attrs = f_header.attrs.size / sizeof(f_attr);
> +	nr_attrs = f_header.attrs.size / f_header.attr_size;
>  	lseek(fd, f_header.attrs.offset, SEEK_SET);
>  
>  	for (i = 0; i < nr_attrs; i++) {
>  		struct perf_evsel *evsel;
>  		off_t tmp;
>  
> -		if (readn(fd, &f_attr, sizeof(f_attr)) <= 0)
> +		if (read_attr(fd, header, &f_attr) < 0)
>  			goto out_errno;
>  
>  		if (header->needs_swap)
