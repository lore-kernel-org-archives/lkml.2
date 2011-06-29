Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1F2UBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:01:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56693 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1F2UBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:01:50 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=yGV206oZUtoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=gqQug379R1SxBP82P7cA:9 a=te3QK_OmJNrgwhZJ5k8A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] plist: add mutex to the blessed lock type for plists
From: Steven Rostedt <rostedt@goodmis.org>
To: Dima Zavin <dima@android.com>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1309376033-32005-1-git-send-email-dima@android.com>
References: <1309376033-32005-1-git-send-email-dima@android.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 29 Jun 2011 16:01:48 -0400
Message-ID: <1309377708.26417.41.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 12:33 -0700, Dima Zavin wrote:

> +#include <linux/mutex.h>
>  #include <linux/plist.h>
>  #include <linux/spinlock.h>
>  
> @@ -56,11 +57,14 @@ static void plist_check_list(struct list_head *top)
>  
>  static void plist_check_head(struct plist_head *head)
>  {
> -	WARN_ON(head != &test_head && !head->rawlock && !head->spinlock);
> +	WARN_ON(head != &test_head && !head->rawlock && !head->spinlock &&
> +		!head->mutex);
>  	if (head->rawlock)
>  		WARN_ON_SMP(!raw_spin_is_locked(head->rawlock));
>  	if (head->spinlock)
>  		WARN_ON_SMP(!spin_is_locked(head->spinlock));
> +	if (head->mutex)
> +		WARN_ON_SMP(!mutex_is_locked(head->mutex));

Spin locks are NOPs on SMP, but mutexes are not. Are you sure you want
this as WARN_ON_SMP()?

-- Steve

>  	if (!plist_head_empty(head))
>  		plist_check_list(&plist_first(head)->prio_list);
>  	plist_check_list(&head->node_list);


