Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1IFW1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 18:27:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab1IFW1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 18:27:14 -0400
Date: Tue, 6 Sep 2011 15:26:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/12] cgroups: Pull up res counter charge failure
 interpretation to caller
Message-Id: <20110906152650.a2f33bbd.akpm@linux-foundation.org>
In-Reply-To: <1315267986-28937-9-git-send-email-fweisbec@gmail.com>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
	<1315267986-28937-9-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Sep 2011 02:13:02 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

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
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Aditya Kali <adityakali@google.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Tim Hockin <thockin@hockin.org>
> Cc: Tejun Heo <tj@kernel.org>
> ---
>  kernel/res_counter.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 4aaa790..45fa6fb 100644
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

This also affects the return value of your new and undocumented
res_counter_charge_until().

That's a bit of a hand-grenade which could lead to system calls
returning -1 (ie: EPERM) to userspace.

