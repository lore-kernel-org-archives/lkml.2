Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3AGJSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 04:18:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab3AGJSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 04:18:00 -0500
Date: Mon, 7 Jan 2013 10:16:09 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frank Eigler <fche@redhat.com>, Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] uprobes: Move alloc_page() from xol_add_vma() to
 xol_alloc_area()
Message-ID: <20130107091609.GA24171@bandura.brq.redhat.com>
References: <20121231175150.GA32066@redhat.com>
 <20121231175212.GA32088@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121231175212.GA32088@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2012 at 06:52:12PM +0100, Oleg Nesterov wrote:
> Move alloc_page() from xol_add_vma() to xol_alloc_area() to cleanup
> the code. This separates the memory allocations and consolidates the
> -EALREADY cleanups and the error handling.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |   32 +++++++++++++-------------------
>  1 files changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index f883813..1456f7d 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1104,21 +1093,26 @@ static struct xol_area *xol_alloc_area(void)
>  
>  	area = kzalloc(sizeof(*area), GFP_KERNEL);
>  	if (unlikely(!area))
> -		return NULL;
> +		goto out;
>  
>  	area->bitmap = kzalloc(BITS_TO_LONGS(UINSNS_PER_PAGE) * sizeof(long), GFP_KERNEL);
> -
>  	if (!area->bitmap)
> -		goto fail;
> +		goto free_area;
> +
> +	area->page = area->page = alloc_page(GFP_HIGHUSER);

fyi: didn't review this patch set yet, just caught the string above. ;)

Anton.
