Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946067Ab2K2AiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:38:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932614Ab2K2AiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:38:21 -0500
Date: Wed, 28 Nov 2012 16:38:16 -0800
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, bcrl@kvack.org, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 14/25] aio: Make aio_read_evt() more efficient
Message-ID: <20121129003816.GJ18574@lenny.home.zabbo.net>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <1354121029-1376-15-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354121029-1376-15-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We can't use cmpxchg() on the ring buffer's head pointer directly, since
> it's modded to nr_events and would be susceptible to ABA. So instead we
> maintain a shadow head that uses the full 32 bits, and cmpxchg() that
> and then updated the real head pointer.

Time to update this comment to reflect the mutex instead of the shadow
head? :)

> +		ev = kmap(page);
> +		copy_ret = copy_to_user(event + ret, ev + pos, sizeof(*ev) * i);
> +		kunmap(page);

For lack of a better time: do we want to bring up the missing
flush_dcache_page() calls around the kernel mappings of ring pages that
are also mapped to user addresses?

>  		prepare_to_wait_exclusive(&ctx->wait, &wait,
>  					  TASK_INTERRUPTIBLE);
>  
> +		ret = aio_read_events(ctx, event + i, nr - i);
> +		if (ret < 0)
>  			break;

As mentioned offlist: we don't want to be blocking under
TASK_INTERRUPTIBLE.  Is the plan to do a non-blocking check and pop
outside the wait loop to do a blocking copy?

- z
