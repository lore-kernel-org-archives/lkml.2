Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0LLUQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 15:16:25 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:38424 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab0LLUQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 15:16:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V6HrnskNJiVzqssFQsYWWqbBmYK0LakoqhHdMSUg0/3h+rxkeQFyWhdWXGcvrddDqb
         x+Wz4InNOi82Z4AHy54NEiihFcO1ER10AE/Z7Dd98olfYnsv56YEBhuEzgHzN8usFS2N
         HpNbd9fBTBDnLUL9/RDwUdCwSPYY1VMeRVqQw=
Date: Sun, 12 Dec 2010 21:16:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
Message-ID: <20101212201613.GA1784@nowhere>
References: <1291773285-16254-1-git-send-email-daahern@cisco.com>
 <1291773285-16254-2-git-send-email-daahern@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291773285-16254-2-git-send-email-daahern@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 06:54:44PM -0700, David Ahern wrote:
> Add a reference timestamp to the perf header - snapshotting kernel
> time to gettimeofday. This allows 'perf report' to convert kernel
> timestamps to time-of-day which is convenient for comparing to other
> (non perf related) log files.
> 
> The timestamp is added using a feature bit for compatibility with
> older binaries and data files.
> 
> Signed-off-by: David Ahern <daahern@cisco.com>
> ---
>  tools/perf/util/header.c  |   51 +++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/header.h  |    3 ++
>  tools/perf/util/session.c |   26 +++++++++++++++++++++++
>  3 files changed, 80 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 76e949a..2fe893b 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -191,6 +191,40 @@ static int write_padded(int fd, const void *bf, size_t count,
>  	return err;
>  }
>  
> +static int perf_header__read_ref_time(struct perf_header *header,
> +			int fd, u64 offset, u64 size)
> +{
> +	size_t sz_nsec = sizeof(header->nsec_ref);
> +	size_t sz_tv   = sizeof(header->tv_ref);
> +	int err = -1;
> +
> +	if (((size - offset) < (sz_nsec + sz_tv)) ||
> +	    (read(fd, &header->nsec_ref, sz_nsec) != (ssize_t) sz_nsec) ||
> +	    (read(fd, &header->tv_ref, sz_tv) != (ssize_t) sz_tv))
> +		goto out;

Hmm, could we have endianness related troubles if we write the timespec on
an arch and cross read from another, or other cross read issues?

> +
> +	err = 0;
> +
> +out:
> +	return err;
> +}
> +
> +static int perf_header__write_ref_time(struct perf_header *header, int fd)
> +{
> +	size_t sz_nsec = sizeof(header->nsec_ref);
> +	size_t sz_tv   = sizeof(header->tv_ref);
> +	int err = -1;
> +
> +	if ((write(fd, &header->nsec_ref, sz_nsec) != (ssize_t) sz_nsec) ||
> +	    (write(fd, &header->tv_ref, sz_tv) != (ssize_t) sz_tv))
> +		goto out;
> +
> +	err = 0;
> +
> +out:
> +	return err;
> +}
> +
>  #define dsos__for_each_with_build_id(pos, head)	\
>  	list_for_each_entry(pos, head, node)	\
>  		if (!pos->has_build_id)		\
> @@ -483,6 +517,19 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
>  			perf_session__cache_build_ids(session);
>  	}
>  
> +	if (perf_header__has_feat(self, HEADER_REFERENCE_TIME)) {
> +		struct perf_file_section *tref_sec;
> +
> +		tref_sec = &feat_sec[idx++];
> +		tref_sec->offset = lseek(fd, 0, SEEK_CUR);
> +		err = perf_header__write_ref_time(self, fd);
> +		if (err < 0) {
> +			pr_debug("failed to write reference time\n");
> +			goto out_free;
> +		}
> +		tref_sec->size = lseek(fd, 0, SEEK_CUR) - tref_sec->offset;
> +	}
> +
>  	lseek(fd, sec_start, SEEK_SET);
>  	err = do_write(fd, feat_sec, sec_size);
>  	if (err < 0)
> @@ -810,6 +857,10 @@ static int perf_file_section__process(struct perf_file_section *self,
>  		if (perf_header__read_build_ids(ph, fd, self->offset, self->size))
>  			pr_debug("Failed to read buildids, continuing...\n");
>  		break;
> +	case HEADER_REFERENCE_TIME:
> +		if (perf_header__read_ref_time(ph, fd, self->offset, self->size))
> +			pr_debug("Failed to read reference time, continuing...\n");
> +		break;
>  	default:
>  		pr_debug("unknown feature %d, continuing...\n", feat);
>  	}
> diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
> index 6335965..0721c78 100644
> --- a/tools/perf/util/header.h
> +++ b/tools/perf/util/header.h
> @@ -19,6 +19,7 @@ struct perf_header_attr {
>  enum {
>  	HEADER_TRACE_INFO = 1,
>  	HEADER_BUILD_ID,
> +	HEADER_REFERENCE_TIME,
>  	HEADER_LAST_FEATURE,
>  };
>  
> @@ -59,6 +60,8 @@ struct perf_header {
>  	u64			data_size;
>  	u64			event_offset;
>  	u64			event_size;
> +	u64			nsec_ref;
> +	struct timeval		tv_ref;
>  	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
>  };
>  
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 3074d38..720838e 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -110,6 +110,29 @@ void perf_session__update_sample_type(struct perf_session *self)
>  	perf_session__id_header_size(self);
>  }
>  
> +static int perf_session__create_ref_time(struct perf_session *session)
> +{
> +	struct timespec tp;
> +
> +	/* race here between successive calls, but should be close enough */
> +	if (gettimeofday(&session->header.tv_ref, NULL) != 0) {
> +		pr_err("gettimeofday failed. Cannot set reference time.\n");
> +		return -1;
> +	}
> +
> +	if (clock_gettime(CLOCK_MONOTONIC, &tp) != 0) {
> +		pr_err("clock_gettime failed. Cannot set reference time.\n");
> +		return -1;
> +	}
> +
> +	session->header.nsec_ref = (u64) tp.tv_sec * NSEC_PER_SEC
> +		                       + (u64) tp.tv_nsec;
> +
> +	perf_header__set_feat(&session->header, HEADER_REFERENCE_TIME);
> +
> +	return 0;
> +}
> +
>  int perf_session__create_kernel_maps(struct perf_session *self)
>  {
>  	int ret = machine__create_kernel_maps(&self->host_machine);
> @@ -167,6 +190,9 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
>  		 */
>  		if (perf_session__create_kernel_maps(self) < 0)
>  			goto out_delete;
> +
> +		if (perf_session__create_ref_time(self) < 0)
> +			goto out_delete;

So, it does record it anytime?

>  	}
>  
>  	perf_session__update_sample_type(self);


Other than that, looks good!
