Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab1A1Bal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 20:30:41 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33043 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1A1Bak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 20:30:40 -0500
Message-ID: <4D421BD5.30903@oracle.com>
Date: Thu, 27 Jan 2011 17:28:53 -0800
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: dsterba@suse.cz, mfasheh@suse.com, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] fs/ocfs2/dlm: Use GFP_ATOMIC under spin_lock
References: <20101102223601.GA27513@ds.suse.cz> <20110127170948.9a0d8b60.akpm@linux-foundation.org>
In-Reply-To: <20110127170948.9a0d8b60.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2011 05:09 PM, Andrew Morton wrote:
> Switching to GFP_ATOMIC is the worst of all possible ways of "fixing"
> this bug.  GFP_ATOMIC is *unreliable*.  We don't want to introduce
> unreliability deep down inside our filesytems.  And fs maintainers who
> don't want to make their filesystems less reliable shouldn't blindly
> apply patches that do so :(
>
>
> A reliable way of fixing this bug is below.  As an added bonus, it
> makes the fs faster.
>
> --- a/fs/ocfs2/dlm/dlmdomain.c~a
> +++ a/fs/ocfs2/dlm/dlmdomain.c
> @@ -926,9 +926,9 @@ static int dlm_assert_joined_handler(str
>   }
>
>   static int dlm_match_regions(struct dlm_ctxt *dlm,
> -			     struct dlm_query_region *qr)
> +			     struct dlm_query_region *qr, u8 *local)
>   {
> -	char *local = NULL, *remote = qr->qr_regions;
> +	char *remote = qr->qr_regions;
>   	char *l, *r;
>   	int localnr, i, j, foundit;
>   	int status = 0;
> @@ -957,12 +957,6 @@ static int dlm_match_regions(struct dlm_
>   		r += O2HB_MAX_REGION_NAME_LEN;
>   	}
>
> -	local = kmalloc(sizeof(qr->qr_regions), GFP_ATOMIC);
> -	if (!local) {
> -		status = -ENOMEM;
> -		goto bail;
> -	}
> -
>   	localnr = o2hb_get_all_regions(local, O2NM_MAX_REGIONS);
>
>   	/* compare local regions with remote */
> @@ -1012,8 +1006,6 @@ static int dlm_match_regions(struct dlm_
>   	}
>
>   bail:
> -	kfree(local);
> -
>   	return status;
>   }
>
> @@ -1077,6 +1069,7 @@ static int dlm_query_region_handler(stru
>   	struct dlm_ctxt *dlm = NULL;
>   	int status = 0;
>   	int locked = 0;
> +	static u8 local[sizeof(qr->qr_regions)]; /* locked by dlm_domain_lock */
>
>   	qr = (struct dlm_query_region *) msg->buf;
>
> @@ -1112,7 +1105,7 @@ static int dlm_query_region_handler(stru
>   		goto bail;
>   	}
>
> -	status = dlm_match_regions(dlm, qr);
> +	status = dlm_match_regions(dlm, qr, local);
>
>   bail:
>   	if (locked)

That sizeof() is 1K. It maybe better if we moved the kmalloc() here.

Note that this handler is only called during mount. If the alloc fails, the
mount fails. It's not the end of the world.
