Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab1JDAU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 20:20:26 -0400
Received: from shutemov.name ([188.40.19.243]:46061 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab1JDAUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 20:20:25 -0400
Date: Tue, 4 Oct 2011 03:20:24 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 02/10] cgroups: New resource counter inheritance API
Message-ID: <20111004002024.GB6727@shutemov.name>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <1317668832-10784-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317668832-10784-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 09:07:04PM +0200, Frederic Weisbecker wrote:
> Provide an API to inherit a counter value from a parent.
> This can be useful to implement cgroup.clone_children on
> a resource counter.
> 
> Still the resources of the children are limited by those
> of the parent, so this is only to provide a default setting
> behaviour when clone_children is set.
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
>  include/linux/res_counter.h |    2 ++
>  kernel/res_counter.c        |   18 ++++++++++++++++++
>  2 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> index 1b3fe05..109d118 100644
> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -84,6 +84,8 @@ int res_counter_write(struct res_counter *counter, int member,
>  
>  void res_counter_write_u64(struct res_counter *counter, int member, u64 val);
>  
> +void res_counter_inherit(struct res_counter *counter, int member);
> +
>  /*
>   * the field descriptors. one for each member of res_counter
>   */
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 0faafcc..37abf4e 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -202,3 +202,21 @@ int res_counter_write(struct res_counter *counter, int member,
>  
>  	return 0;
>  }
> +
> +/*
> + * Simple inheritance implementation to get the same value
> + * than a parent. However this doesn't enforce the child value
> + * to be always below the one of the parent. But the child is
> + * subject to its parent limitation anyway.
> + */
> +void res_counter_inherit(struct res_counter *counter, int member)
> +{
> +	struct res_counter *parent;
> +	unsigned long long val;
> +
> +	parent = counter->parent;
> +	if (parent) {
> +		val = res_counter_read_u64(parent, member);
> +		res_counter_write_u64(counter, member, val);
> +	}
> +}
> -- 
> 1.7.5.4
> 

-- 
 Kirill A. Shutemov
