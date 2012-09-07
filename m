Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab2IGRS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:18:56 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:11187
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217Ab2IGRSy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:18:54 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432Izz1202hzzz2dh668h839h93fhd25hf0ah11b5h121eh1288h1155h)
X-WSS-ID: 0M9ZPFC-01-LHZ-02
X-M-MSG: 
Date: Fri, 7 Sep 2012 19:18:45 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, ibs: Check syscall attribute flags
Message-ID: <20120907171845.GL8285@erda.amd.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
 <20120906190238.GA29278@erda.amd.com>
 <5048F6BF.70106@gmail.com>
 <20120906195645.GD8285@erda.amd.com>
 <20120907164114.GJ8285@erda.amd.com>
 <1347036987.2124.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1347036987.2124.3.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.09.12 18:56:27, Peter Zijlstra wrote:

> > +               .exclude_user   = 1,
> > +               .exclude_kernel = 1,
> > +               .exclude_hv     = 1,
> > +               .exclude_idle   = 1,
> > +               .exclude_host   = 1,
> > +               .exclude_guest  = 1,
> 
> Ideally we'd grow support for those using SVM entry/exit hooks though.

Yes, I will look at this too. This patch is inteded for stable and
urgent.

> > +#define perf_flags(attr)       (*(&(attr)->read_format + 1))
> 
> 
> Another anonymous union shouldn't hurt..
> 
> ---
>  include/linux/perf_event.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index cc5e2cd..5df37a0 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -236,7 +236,9 @@ struct perf_event_attr {
>  	__u64			sample_type;
>  	__u64			read_format;
>  
> -	__u64			disabled       :  1, /* off by default        */
> +	union {
> +		__u64		flags;
> +		__u64		disabled       :  1, /* off by default        */
>  				inherit	       :  1, /* children inherit it   */
>  				pinned	       :  1, /* must always be on PMU */
>  				exclusive      :  1, /* only group on PMU     */
> @@ -272,6 +274,7 @@ struct perf_event_attr {
>  				exclude_callchain_user   : 1, /* exclude user callchains */
>  
>  				__reserved_1   : 41;
> +	};
>  
>  	union {
>  		__u32		wakeup_events;	  /* wakeup every n events */

I was thinking of this too. But this breaks existing code to compile
since static initialization of struct perf_event_attr fails, e.g.:

 builtin-test.c:469:3: error: unknown field ‘watermark’ specified in initializer

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

