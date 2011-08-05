Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1HEP0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:26:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62383 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1HEP0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:26:46 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vn9O8SEpdqYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=XgS40gwUCIYEoqc6sL8A:9 a=zpbxpyy5fl8F2DrueAEA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched/cpupri: Remove cpupri->pri_active
From: Steven Rostedt <rostedt@goodmis.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <mgalbraith@suse.de>,
        "Luis Claudio R." =?UTF-8?Q?Gon=EF=BF=BDalves?= 
	<lgoncalv@redhat.com>,
        Matthew Hank Sabins <msabins@linux.vnet.ibm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110805143822.GA3199@zhy>
References: <1312317372.18583.101.camel@gandalf.stny.rr.com>
	 <20110805082008.GA6628@zhy>
	 <1312547447.18583.195.camel@gandalf.stny.rr.com>
	 <20110805143822.GA3199@zhy>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 05 Aug 2011 11:26:40 -0400
Message-ID: <1312558000.18583.201.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-05 at 22:38 +0800, Yong Zhang wrote:

> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  kernel/sched_cpupri.c |    3 ---
>  kernel/sched_cpupri.h |    2 --
>  2 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
> index 90faffd..5839559 100644
> --- a/kernel/sched_cpupri.c
> +++ b/kernel/sched_cpupri.c
> @@ -151,9 +151,6 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
>  	/*
>  	 * If the cpu was currently mapped to a different value, we
>  	 * need to map it to the new value then remove the old value.
> -	 * Note, we must add the new value first, otherwise we risk the
> -	 * cpu being cleared from pri_active, and this cpu could be
> -	 * missed for a push or pull.

Actually, the above still holds true, just not for pri_active. Probably
should be changed to:

	* Note, we must add the new value first, otherwise we risk the
	* cpu being missed by the priority loop in cpupri_find.

or something as such.

>  	 */
>  	if (likely(newpri != CPUPRI_INVALID)) {
>  		struct cpupri_vec *vec = &cp->pri_to_cpu[newpri];
> diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
> index 6b4cd17..f6d7561 100644
> --- a/kernel/sched_cpupri.h
> +++ b/kernel/sched_cpupri.h
> @@ -4,7 +4,6 @@
>  #include <linux/sched.h>
>  
>  #define CPUPRI_NR_PRIORITIES	(MAX_RT_PRIO + 2)
> -#define CPUPRI_NR_PRI_WORDS	BITS_TO_LONGS(CPUPRI_NR_PRIORITIES)
>  
>  #define CPUPRI_INVALID -1
>  #define CPUPRI_IDLE     0
> @@ -18,7 +17,6 @@ struct cpupri_vec {
>  
>  struct cpupri {
>  	struct cpupri_vec pri_to_cpu[CPUPRI_NR_PRIORITIES];
> -	long              pri_active[CPUPRI_NR_PRI_WORDS];
>  	int               cpu_to_pri[NR_CPUS];
>  };
>  


Otherwise looks good.

-- Steve


