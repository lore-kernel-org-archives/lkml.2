Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab0IBH7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 03:59:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38058 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0IBH7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 03:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=opdsBm4V56sH9dw5AHoinAn59m6eC7NB/UgSoz6xdKaURu2Lx4fe0Yn+7OXj2bnV6/
         GCyr3nhpk0hZelQOtdc6zm6KeOHRWAhT56zhbDMEPuPX5o+8fvx4TfTn0tYEgzOe01eA
         41nvROl1T82chqrjWtqa5BDun76m0QY71SKCs=
Message-ID: <4C7F5951.6040809@gmail.com>
Date: Thu, 02 Sep 2010 09:59:13 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>,
        Chris Mason <chris.mason@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, cluster-devel@redhat.com,
        linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2010 03:02 AM, David Rientjes wrote:
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -334,6 +334,57 @@ static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
>  	return kmalloc_node(size, flags | __GFP_ZERO, node);
>  }
>  
> +/**
> + * kmalloc_nofail - infinitely loop until kmalloc() succeeds.
> + * @size: how many bytes of memory are required.
> + * @flags: the type of memory to allocate (see kmalloc).
> + *
> + * NOTE: no new callers of this function should be implemented!
> + * All memory allocations should be failable whenever possible.
> + */
> +static inline void *kmalloc_nofail(size_t size, gfp_t flags)
> +{
> +	void *ret;
> +
> +	for (;;) {
> +		ret = kmalloc(size, flags);
> +		if (ret)
> +			return ret;
> +		WARN_ON_ONCE(get_order(size) > PAGE_ALLOC_COSTLY_ORDER);

This doesn't work as you expect. kmalloc will warn every time it fails.
__GFP_NOFAIL used to disable the warning. Actually what's wrong with
__GFP_NOFAIL? I cannot find a reason in the changelogs why the patches
are needed.

> +	}



-- 
js
