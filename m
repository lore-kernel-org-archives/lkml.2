Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab2CDRvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 12:51:37 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49517 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab2CDRvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 12:51:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.221.73 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Sun, 4 Mar 2012 09:51:01 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Hillf Danton <dhillf@gmail.com>
cc: Linux-MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: shmem: unlock valid page
In-Reply-To: <CAJd=RBBYdY1rgoW+0bgKh6Cn8n=guB2_zq2nzaMr8-arqNkr_A@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1203040943240.18498@eggly.anvils>
References: <CAJd=RBBYdY1rgoW+0bgKh6Cn8n=guB2_zq2nzaMr8-arqNkr_A@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2012, Hillf Danton wrote:
> In shmem_read_mapping_page_gfp() page is unlocked if no error returned,
> so the unlocked page has to valid.
> 
> To guarantee that validity, when getting page, success result is feed
> back to caller only when page is valid.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

I don't understand your description, nor its relation to the patch.

NAK to the patch: when no page has previously been allocated, the
SGP_READ case avoids allocation and returns NULL - do_shmem_file_read
then copies the ZERO_PAGE instead, avoiding lots of unnecessary memory
allocation when reading a large sparse file.

Hugh

> ---
> 
> --- a/mm/shmem.c	Sun Mar  4 12:17:42 2012
> +++ b/mm/shmem.c	Sun Mar  4 12:26:56 2012
> @@ -889,13 +889,13 @@ repeat:
>  		goto failed;
>  	}
> 
> -	if (page || (sgp == SGP_READ && !swap.val)) {
> +	if (page) {
>  		/*
>  		 * Once we can get the page lock, it must be uptodate:
>  		 * if there were an error in reading back from swap,
>  		 * the page would not be inserted into the filecache.
>  		 */
> -		BUG_ON(page && !PageUptodate(page));
> +		BUG_ON(!PageUptodate(page));
>  		*pagep = page;
>  		return 0;
>  	}
> --
> 
