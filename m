Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab2BIWjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:39:14 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62952 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab2BIWjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:39:12 -0500
Message-ID: <4F344B0C.8060203@gmail.com>
Date: Thu, 09 Feb 2012 15:39:08 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com
Subject: Re: [PATCH v6 16/18] perf: enable reading of perf.data files from
 different ABI rev
References: <1328826068-11713-1-git-send-email-eranian@google.com> <1328826068-11713-17-git-send-email-eranian@google.com>
In-Reply-To: <1328826068-11713-17-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 03:21 PM, Stephane Eranian wrote:
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
>  tools/perf/util/header.c  |   53 ++++++++++++++++++++++++++++++++++++++++----
>  tools/perf/util/session.c |    4 +-
>  2 files changed, 50 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 6f4187d..c2a3410 100644
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
> +	if (ret <= 0) {
> +		pr_debug("cannot read %d bytes of header attr\n",
> +			 PERF_ATTR_SIZE_VER0);
> +		return -1;
> +	}
> +
> +	/* on file perf_event_attr size */
> +	sz = attr->size;
> +	if (ph->needs_swap)
> +		sz = bswap_32(sz);
> +
> +	if (sz == 0) {
> +		/* assume ABI0 */
> +		sz =  PERF_ATTR_SIZE_VER0;
> +	} else if (sz > our_sz) {
> +		pr_debug("file uses a more recent and unsupported ABI"
> +			 " (%zu bytes extra)\n", sz - our_sz);
> +		return -1;
> +	}
> +	/* what we have not yet read and that we know about */
> +	left = sz - PERF_ATTR_SIZE_VER0;
> +	if (left) {
> +		void *ptr = attr;
> +		ptr += PERF_ATTR_SIZE_VER0;
> +
> +		ret = readn(fd, ptr, left);
> +	}
> +	/* read perf_file_section, ids are read in caller */
> +	ret = readn(fd, &f_attr->ids, sizeof(f_attr->ids));

I thought the above 2 lines were to be removed.

David


> +
> +	return ret <= 0 ? -1 : 0;
> +}
> +
>  int perf_session__read_header(struct perf_session *session, int fd)
>  {
>  	struct perf_header *header = &session->header;
> @@ -1974,19 +2019,17 @@ int perf_session__read_header(struct perf_session *session, int fd)
>  	if (session->fd_pipe)
>  		return perf_header__read_pipe(session, fd);
>  
> -	if (perf_file_header__read(&f_header, header, fd) < 0) {
> -		pr_debug("incompatible file format\n");
> +	if (perf_file_header__read(&f_header, header, fd) < 0)
>  		return -EINVAL;
> -	}
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
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 3f3afed..5476320 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -24,7 +24,7 @@ static int perf_session__open(struct perf_session *self, bool force)
>  		self->fd = STDIN_FILENO;
>  
>  		if (perf_session__read_header(self, self->fd) < 0)
> -			pr_err("incompatible file format");
> +			pr_err("incompatible file format (rerun with -v to learn more)");
>  
>  		return 0;
>  	}
> @@ -56,7 +56,7 @@ static int perf_session__open(struct perf_session *self, bool force)
>  	}
>  
>  	if (perf_session__read_header(self, self->fd) < 0) {
> -		pr_err("incompatible file format");
> +		pr_err("incompatible file format (rerun with -v to learn more)");
>  		goto out_close;
>  	}
>  
