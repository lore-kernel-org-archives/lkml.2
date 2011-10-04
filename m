Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1JDBcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 21:32:47 -0400
Received: from shutemov.name ([188.40.19.243]:43198 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab1JDBcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 21:32:46 -0400
Date: Tue, 4 Oct 2011 04:32:45 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 08/10] cgroups: Pull up res counter charge failure
 interpretation to caller
Message-ID: <20111004013245.GB7361@shutemov.name>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <1317668832-10784-9-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317668832-10784-9-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 09:07:10PM +0200, Frederic Weisbecker wrote:
> res_counter_charge() always returns -ENOMEM when the limit is reached
> and the charge thus can't happen.
> 
> However it's up to the caller to interpret this failure and return
> the appropriate error value. The task counter subsystem will need
> to report the user that a fork() has been cancelled because of some
> limit reached, not because we are too short on memory.
> 
> Fix this by returning -1 when res_counter_charge() fails.
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
>  Documentation/cgroups/resource_counter.txt |    2 ++
>  kernel/res_counter.c                       |    2 +-
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/cgroups/resource_counter.txt b/Documentation/cgroups/resource_counter.txt
> index a2cd05b..24ec61c 100644
> --- a/Documentation/cgroups/resource_counter.txt
> +++ b/Documentation/cgroups/resource_counter.txt
> @@ -76,6 +76,8 @@ to work with it.
>  	limit_fail_at parameter is set to the particular res_counter element
>  	where the charging failed.
>  
> +	It returns 0 on success and -1 on failure.
> +
>   d. int res_counter_charge_locked
>  			(struct res_counter *rc, unsigned long val)
>  
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 6b36823..b814d6c 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -26,7 +26,7 @@ int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
>  {
>  	if (counter->usage + val > counter->limit) {
>  		counter->failcnt++;
> -		return -ENOMEM;
> +		return -1;
>  	}
>  
>  	counter->usage += val;
> -- 
> 1.7.5.4
> 

-- 
 Kirill A. Shutemov
