Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab2EaNqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:46:05 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54699 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab2EaNqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:46:03 -0400
Date: Thu, 31 May 2012 10:45:57 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Sunjin Yang <fan4326@gmail.com>
Subject: Re: [PATCH/RFC 2/2] perf tools: Check callchain is corrupted
Message-ID: <20120531134557.GB13591@infradead.org>
References: <1338443007-24857-1-git-send-email-namhyung.kim@lge.com>
 <1338443007-24857-2-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338443007-24857-2-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 31, 2012 at 02:43:27PM +0900, Namhyung Kim escreveu:
> We faced segmentation fault on perf top -G at very high sampling
> rate due to a corrupted callchain. While the root cause was not
> revealed (I failed to figure it out), this patch tries to protect
> us from the segfault on such cases.

Capping the callchain lenght may even be a feature, not a consistency
check, but I don't know how long, for consistency checking, we should
consider too much, as there are cases of loooong callchains.

Ingo? Peter?

- Arnaldo
 
> Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  include/linux/perf_event.h |    4 ++--
>  tools/perf/util/session.c  |   14 +++++++++++++-
>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 8adf70e9e3cc..0430ea6054ef 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -555,6 +555,8 @@ enum perf_event_type {
>  	PERF_RECORD_MAX,			/* non-ABI */
>  };
>  
> +#define PERF_MAX_STACK_DEPTH		255
> +
>  enum perf_callchain_context {
>  	PERF_CONTEXT_HV			= (__u64)-32,
>  	PERF_CONTEXT_KERNEL		= (__u64)-128,
> @@ -609,8 +611,6 @@ struct perf_guest_info_callbacks {
>  #include <linux/sysfs.h>
>  #include <asm/local.h>
>  
> -#define PERF_MAX_STACK_DEPTH		255
> -
>  struct perf_callchain_entry {
>  	__u64				nr;
>  	__u64				ip[PERF_MAX_STACK_DEPTH];
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index a7de2acac460..fa14e60ed459 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -300,6 +300,11 @@ int machine__resolve_callchain(struct machine *self,
>  
>  	callchain_cursor_reset(&callchain_cursor);
>  
> +	if (chain->nr > PERF_MAX_STACK_DEPTH) {
> +		pr_warning("corrupted callchain. skipping...\n");
> +		return 0;
> +	}
> +
>  	for (i = 0; i < chain->nr; i++) {
>  		u64 ip;
>  		struct addr_location al;
> @@ -318,7 +323,14 @@ int machine__resolve_callchain(struct machine *self,
>  			case PERF_CONTEXT_USER:
>  				cpumode = PERF_RECORD_MISC_USER;	break;
>  			default:
> -				break;
> +				pr_debug("invalid callchain context: "
> +					 "%"PRId64"\n", (s64) ip);
> +				/*
> +				 * It seems the callchain is corrupted.
> +				 * Discard all.
> +				 */
> +				callchain_cursor_reset(&callchain_cursor);
> +				return 0;
>  			}
>  			continue;
>  		}
> -- 
> 1.7.10.1
