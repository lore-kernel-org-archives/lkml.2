Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1JDBah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 21:30:37 -0400
Received: from shutemov.name ([188.40.19.243]:37396 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab1JDBag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 21:30:36 -0400
Date: Tue, 4 Oct 2011 04:30:34 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 07/10] res_counter: Allow charge failure pointer to be
 null
Message-ID: <20111004013034.GA7361@shutemov.name>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <1317668832-10784-8-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317668832-10784-8-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 09:07:09PM +0200, Frederic Weisbecker wrote:
> So that callers of res_counter_charge() don't have to create and
> pass this pointer even if they aren't interested in it.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Aditya Kali <adityakali@google.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Tim Hockin <thockin@hockin.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Containers <containers@lists.linux-foundation.org>
> ---
>  kernel/res_counter.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 8f4c728..6b36823 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -43,14 +43,16 @@ int res_counter_charge_until(struct res_counter *counter,
>  	unsigned long flags;
>  	struct res_counter *c, *u;
>  
> -	*limit_fail_at = NULL;
> +	if (limit_fail_at)
> +		*limit_fail_at = NULL;
>  	local_irq_save(flags);
>  	for (c = counter; c != limit; c = c->parent) {
>  		spin_lock(&c->lock);
>  		ret = res_counter_charge_locked(c, val);
>  		spin_unlock(&c->lock);
>  		if (ret < 0) {
> -			*limit_fail_at = c;
> +			if (limit_fail_at)
> +				*limit_fail_at = c;
>  			goto undo;
>  		}
>  	}
> -- 
> 1.7.5.4
> 

-- 
 Kirill A. Shutemov
