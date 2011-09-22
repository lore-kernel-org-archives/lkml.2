Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1IVVHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:07:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47534 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753866Ab1IVVHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:07:13 -0400
Subject: Re: [PATCH 3/3] seq_file: convert seq buffer to vmalloc
From: Joe Perches <joe@perches.com>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Date: Thu, 22 Sep 2011 14:07:12 -0700
In-Reply-To: <1316725029-22737-4-git-send-email-ccross@android.com>
References: <1316725029-22737-1-git-send-email-ccross@android.com>
	 <1316725029-22737-4-git-send-email-ccross@android.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316725632.29447.21.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 13:57 -0700, Colin Cross wrote:
> seq_files are often used for debugging.  When things are going wrong
> due to failed physically contiguous allocations, the exponentially
> growing physically contiguous allocations in seq_read can make things
> worse.  There is no need for physically contiguous memory, so switch
> to virtually contiguous memory instead.

vmalloc's are relatively expensive.
Perhaps use kmalloc when appropriate instead?

[]
> -	/* don't ask for more than the kmalloc() max size */
> -	if (size > KMALLOC_MAX_SIZE)
> -		size = KMALLOC_MAX_SIZE;
> -
> -	buf = kmalloc(size, GFP_KERNEL);
> +	buf = vmalloc(size);
>  	if (!buf)
>  		return -ENOMEM;

	if (size > KMALLOC_MAX_SIZE)
		buf = vmalloc(size, GFP_KERNEL)
	else
		buf = kmalloc(size, GFP_KERNEL);
	
> +	vfree(m->buf);

	if (m->size > KMALLOC_MAX_SIZE)
		vfree(m->buf);
	else
		kfree(m->buf);

>  	m->buf = buf;
>  	m->size = size;
>  
> @@ -106,7 +103,7 @@ static int traverse(struct seq_file *m, loff_t offset)
>  		return 0;
>  	}
>  	if (!m->buf) {
> -		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
> +		m->buf = vmalloc(m->size = PAGE_SIZE);

embedding the set of m->size like this is ugly.

[do the same as above kmalloc/vmalloc based on size]

etc.

