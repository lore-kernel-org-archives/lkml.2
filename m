Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab0ESGd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 02:33:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:57794 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab0ESGd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 02:33:27 -0400
Subject: Re: [PATCH] perf: fix cmpxchg warning in perf_event_amd.c
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: eranian@googlemail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, perfmon2-devel@lists.sf.net
In-Reply-To: <20100518204330.GA30624@redhat.com>
References: <20100518204330.GA30624@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 08:32:56 +0200
Message-ID: <1274250776.5605.10000.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 16:43 -0400, Jason Baron wrote:
> Hi,
> 
> I'm getting the following warnings:
> 
> In file included from arch/x86/kernel/cpu/perf_event.c:1343:
> arch/x86/kernel/cpu/perf_event_amd.c: In function
> ‘amd_put_event_constraints’:
> arch/x86/kernel/cpu/perf_event_amd.c:167: warning: value computed is not
> used
> 
> Since cmpxchg returns a value, we need to use it. We can use it to test if its
> equal to "event".

Should we:

 a) add a WARN_ONCE() there and make use of the return value (it should
never happen)

or

 b) replace the lot with: nb->owners[i] = NULL; which should I _think_
work.

> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  arch/x86/kernel/cpu/perf_event_amd.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> index 611df11..e13ce4a 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -163,10 +163,8 @@ static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
>  	 * when we come here
>  	 */
>  	for (i = 0; i < x86_pmu.num_counters; i++) {
> -		if (nb->owners[i] == event) {
> -			cmpxchg(nb->owners+i, event, NULL);
> +		if (cmpxchg(nb->owners+i, event, NULL) == event)
>  			break;
> -		}
>  	}
>  }
>  

