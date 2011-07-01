Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1GAOI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:08:29 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:29814 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756481Ab1GAOI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:08:29 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: pgaKRXoVM1kv9EWF_LHWVw.JtxUnPQ7FCzNo3B1B2R11Bph
 DJJXvFHzdna3bI_dgKTVWq._RK9ApgXlPAeud2jti6DPEYYHvIyJ4EVxxz5m
 jP7q3ERE1rA76nSw30duCQGUf6ZoNOHbkTZJMbqzUwlnWpGLMjJ487YjFTx4
 ykUnZIv9p_5Yxxmg7FDNMRIsawKz2PSOZdICQmJgwKgngYlSa8.3ZnFOi9lr
 mOJJJIGkTylZ3qP46yCAJlQw.yQa2m37dLwiAW3HihSjsDkux2zexdXdPqjz
 XOA3qcC1k9Og4.KrnTKTRfbUUsvz_5eNkclklyOfhOZ6FKDYb
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 1 Jul 2011 09:08:26 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ben Greear <greearb@candelatech.com>
cc: penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] slub: Enable backtrace for create/delete
 points.
In-Reply-To: <1309308462-20124-2-git-send-email-greearb@candelatech.com>
Message-ID: <alpine.DEB.2.00.1107010905350.2458@router.home>
References: <1309308462-20124-1-git-send-email-greearb@candelatech.com> <1309308462-20124-2-git-send-email-greearb@candelatech.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011, greearb@candelatech.com wrote:

> diff --git a/mm/slub.c b/mm/slub.c
> index 35f351f..3477ce5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -191,8 +191,12 @@ static LIST_HEAD(slab_caches);
>  /*
>   * Tracking user of a slab.
>   */
> +#define TRACK_ADDRS_COUNT 16
>  struct track {
> -	unsigned long addr;	/* Called from address */
> +	unsigned long caddr;

Keep the name the same since its role does not change. That makes the
patch touch less code.

> +#ifdef CONFIG_STACKTRACE
> +	unsigned long addrs[TRACK_ADDRS_COUNT];	/* Called from address */
> +#endif
>  	int cpu;		/* Was running on cpu */
>  	int pid;		/* Pid context */
>  	unsigned long when;	/* When did the operation occur */
> @@ -420,7 +424,25 @@ static void set_track(struct kmem_cache *s, void *object,
>  	struct track *p = get_track(s, object, alloc);
>
>  	if (addr) {
> -		p->addr = addr;
> +#ifdef CONFIG_STACKTRACE
> +		struct stack_trace trace;
> +		int i;
> +
> +		trace.nr_entries = 0;
> +		trace.max_entries = TRACK_ADDRS_COUNT;
> +		trace.entries = p->addrs;
> +		trace.skip = 3;
> +		save_stack_trace(&trace);
> +
> +		/* See rant in lockdep.c */
> +		if (trace.nr_entries != 0 &&
> +		    trace.entries[trace.nr_entries - 1] == ULONG_MAX)
> +			trace.nr_entries--;
> +
> +		for (i = trace.nr_entries; i < TRACK_ADDRS_COUNT; i++)
> +			p->addrs[i] = 0;
> +#endif

Hmmm... Is this really working on all architectures? I remember from years
past that we had issues with adding the same functionality to slab.

Otherwise the patch is quite straightforward (and it will be much cleaner
if you do not change the name of "addr").

