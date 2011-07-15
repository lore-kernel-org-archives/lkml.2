Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab1GOPbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:31:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55036 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1GOPbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:31:07 -0400
Message-ID: <4E205D36.3010707@gmail.com>
Date: Fri, 15 Jul 2011 09:31:02 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: mingo@elte.hu, fweisbec@gmail.com
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, peterz@infradead.org, paulus@samba.org
Subject: Re: [PATCH] perf tools: fix endian conversion reading event attr
 from header
References: <1310483959-23621-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1310483959-23621-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/12/2011 09:19 AM, David Ahern wrote:
> The perf_event_attr struct has 2 __u32's at the top and need to
> be swapped individually. With this change I was able to analyze
> a perf.data collected in a 32-bit PPC VM on an x86 system. I
> tested both 32-bit and 64-bit binaries for the Intel analysis
> side; both read the PPC perf.data file correctly.

Similarly with this one. It replaces a call to perf_header__getbuffer64
with what it does inline -- only doing the swap of the attr struct after
the initial 2 u32's. I spent 2 days tracking this down and would hate to
lose it waiting for Arnaldo's return.

David

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
>  		tmp = lseek(fd, 0, SEEK_CUR);
>  		evsel = perf_evsel__new(&f_attr.attr, i);
>  
