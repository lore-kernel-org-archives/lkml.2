Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab1GAOLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:11:36 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:45670 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756481Ab1GAOLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:11:34 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: uhkmUqIVM1mVN7MwQ4mQ67KQDZ3TOe2sbdRPKa2j3TYiU_S
 LbwuE7O8rOHDY3F2lXoXG9Rdnsjhxcsd3YN1aaCKucucQyLEcXdU4a17GCZT
 XtDYP2Q9O.9lWdCJv0vXLNLaY96Vbvs.vF2qiZtVHgakGFrW7YvKwTBFVQPX
 EwMPnmgeX2gX..XBoT4mHZ1aQ.jETAOiFpfLbP38_g9o95A6bT5Mn9ryEkq5
 BjP.NzXK8kQSqPPbbofhFfQqjWSAyy1iD7C1w34_zqDGSQytQ9sxprna7eH_
 Ql1ilQEUlwUs290LJ6GJjJPYTPzEx5T6keYPEZoGPRXsqacOj
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 1 Jul 2011 09:11:31 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ben Greear <greearb@candelatech.com>
cc: penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] slub:  Add method to verify memory is not
 freed.
In-Reply-To: <1309308462-20124-3-git-send-email-greearb@candelatech.com>
Message-ID: <alpine.DEB.2.00.1107010909060.2458@router.home>
References: <1309308462-20124-1-git-send-email-greearb@candelatech.com> <1309308462-20124-3-git-send-email-greearb@candelatech.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011, greearb@candelatech.com wrote:

> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index ad4dd1c..916ce0f 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -302,6 +302,19 @@ extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
>
>  #endif /* CONFIG_NUMA */
>
> +/**
> + * Calling this on allocated memory will check that the memory
> + * is expected to be in use, and print warnings if not.
> + */
> +#if defined(CONFIG_SLUB) && defined(CONFIG_SLUB_DEBUG)
> +extern bool verify_mem_not_deleted(const void *x);
> +#else
> +static inline bool verify_mem_not_deleted(const void *x)
> +{
> +	return true;
> +}
> +#endif
> +

Why is this in slab.h and not slub_def.h?

> diff --git a/mm/slub.c b/mm/slub.c
> index 3477ce5..f64caca 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2958,6 +2958,42 @@ size_t ksize(const void *object)
>  }
>  EXPORT_SYMBOL(ksize);
>
> +#ifdef CONFIG_SLUB_DEBUG
> +bool verify_mem_not_deleted(const void *x)
> +{
> +	struct page *page;
> +	void *object = (void *)x;
> +	unsigned long flags;
> +	bool rv;
> +
> +	if (unlikely(ZERO_OR_NULL_PTR(x)))
> +		return false;
> +
> +	local_irq_save(flags);
> +
> +	page = virt_to_head_page(x);
> +	if (unlikely(!PageSlab(page))) {
> +		/* maybe it was from stack? */
> +		rv = true;
> +		goto out_unlock;
> +	}

The above check is problematic for slabs that have SLAB_DESTROY_BY_RCU
set. PageSlab(page) may be true to the next rcu interval.
