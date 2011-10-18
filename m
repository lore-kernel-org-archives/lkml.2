Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1JRSVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:21:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49044 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab1JRSVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:21:16 -0400
Date: Tue, 18 Oct 2011 20:19:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Xu, Anhua" <anhua.xu@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: perf tools: interface for improved PEBS ABI can accept wrong
 parameter
Message-ID: <20111018181943.GC21666@elte.hu>
References: <1A42CE6F5F474C41B63392A5F80372B212DC93638A@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1A42CE6F5F474C41B63392A5F80372B212DC93638A@shsmsx501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Added more Cc:s of maintainers.

thanks,

	Ingo

* Xu, Anhua <anhua.xu@intel.com> wrote:

> For the commit: ab60834 perf, x86: Improve the PEBS ABI
> The precise_ip is restricted to 2 bits. The values larger than 3 are truncated less or equal to 3.
> This can effectively restricted value passing to syscall. But the user space interface can accept other wrong values which are larger than 3 and lowest 2 bits are 0 can meet the requirement.
> 
> # Here is an example, Monitor "All branches" events on Sandybridge platform( Please refer to SDM 3B Table 30-21 to check Sandybridge specific events )
> 
> perf top -e r04c4:p  # precise_ip = 1 , Correct
> perf top -e r04c4:pp  # precise_ip =2, Correct
> perf top -e r04c4:ppp  # not supported, Correct
> perf top -e r04c4:pppppp  # should not be supported, but after truncation , the number of 'p' treated as 2 which is accepted
> 
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index c816075..07d3cf9 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -216,6 +216,7 @@ struct perf_event_attr {
>  				 *
>  				 *  See also PERF_RECORD_MISC_EXACT_IP
>  				 */
> +#define SAMPLE_IP_MAX	3 
>  				precise_ip     :  2, /* skid constraint       */
>  				mmap_data      :  1, /* non-exec mmap data    */
>  				sample_id_all  :  1, /* sample_type all events */
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 928918b..a2068cc 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -775,7 +775,10 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
>  	attr->exclude_user   = eu;
>  	attr->exclude_kernel = ek;
>  	attr->exclude_hv     = eh;
> -	attr->precise_ip     = precise;
> +	if ( precise < SAMPLE_IP_MAX )
> +		attr->precise_ip = precise;
> +	else
> +		return -1;
>  
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Thanks,

	Ingo
