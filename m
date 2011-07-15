Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab1GOPrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:47:19 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48925 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab1GOPrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:47:18 -0400
Date: Fri, 15 Jul 2011 17:47:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org
Subject: Re: [PATCH] perf tools: fix endian conversion reading event attr
 from header
Message-ID: <20110715154711.GB6590@somewhere>
References: <1310483959-23621-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310483959-23621-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 09:19:19AM -0600, David Ahern wrote:
> The perf_event_attr struct has 2 __u32's at the top and need to
> be swapped individually. With this change I was able to analyze
> a perf.data collected in a 32-bit PPC VM on an x86 system. I
> tested both 32-bit and 64-bit binaries for the Intel analysis
> side; both read the PPC perf.data file correctly.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/util/header.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index afb0849..8044c6f 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -877,9 +877,16 @@ int perf_session__read_header(struct perf_session *session, int fd)
>  		struct perf_evsel *evsel;
>  		off_t tmp;
>  
> -		if (perf_header__getbuffer64(header, fd, &f_attr, sizeof(f_attr)))
> +		if (readn(fd, &f_attr, sizeof(f_attr)) <= 0)
>  			goto out_errno;
>  
> +		if (header->needs_swap) {
> +			f_attr.attr.type = bswap_32(f_attr.attr.type);
> +			f_attr.attr.size = bswap_32(f_attr.attr.size);
> +			mem_bswap_64(&f_attr.attr.config,
> +				     sizeof(struct perf_event_attr) - 8);
> +		}
> +

Good catch!

But would be nice to also handle the wakeup_events and bp_type fields.

Thanks.

>  		tmp = lseek(fd, 0, SEEK_CUR);
>  		evsel = perf_evsel__new(&f_attr.attr, i);
>  
> -- 
> 1.7.6
> 
