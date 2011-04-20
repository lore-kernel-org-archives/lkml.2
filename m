Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1DTCT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 22:19:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44439 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab1DTCT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 22:19:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] break out page allocation warning code
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20110420105059.460C.A69D9226@jp.fujitsu.com>
References: <1303263673.5076.612.camel@nimitz> <20110420105059.460C.A69D9226@jp.fujitsu.com>
Message-Id: <20110420112006.461A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 20 Apr 2011 11:19:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The concept is ok to me. but AFAIK some caller are now using ARRAY_SIZE(tsk->comm).
> or sizeof(tsk->comm). Probably callers need to be changed too.

one more correction.

>  void set_task_comm(struct task_struct *tsk, char *buf)
>  {
> +	char tmp_comm[TASK_COMM_LEN];
> +
>  	task_lock(tsk);
>  
> +	memcpy(tmp_comm, tsk->comm_buf, TASK_COMM_LEN);
> +	tsk->comm = tmp;
>  	/*
> -	 * Threads may access current->comm without holding
> -	 * the task lock, so write the string carefully.
> -	 * Readers without a lock may see incomplete new
> -	 * names but are safe from non-terminating string reads.
> +	 * Make sure no one is still looking at tsk->comm_buf
>  	 */
> -	memset(tsk->comm, 0, TASK_COMM_LEN);
> -	wmb();
> -	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
> +	synchronize_rcu();

The doc says,

/**
 * synchronize_rcu - wait until a grace period has elapsed.
 *

And here is under spinlock.



