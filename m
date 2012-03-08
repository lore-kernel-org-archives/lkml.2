Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab2CHBL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 20:11:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2CHBL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 20:11:56 -0500
Date: Wed, 7 Mar 2012 17:11:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/2] mm, counters: remove task argument to sync_mm_rss
 and __sync_task_rss_stat
Message-Id: <20120307171155.f9bb71b6.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1203061919260.21806@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203061919260.21806@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012 19:21:39 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> -static void __sync_task_rss_stat(struct task_struct *task, struct mm_struct *mm)
> +static void __sync_task_rss_stat(struct mm_struct *mm)
>  {
>  	int i;
>  
>  	for (i = 0; i < NR_MM_COUNTERS; i++) {
> -		if (task->rss_stat.count[i]) {
> -			add_mm_counter(mm, i, task->rss_stat.count[i]);
> -			task->rss_stat.count[i] = 0;
> +		if (current->rss_stat.count[i]) {
> +			add_mm_counter(mm, i, current->rss_stat.count[i]);
> +			current->rss_stat.count[i] = 0;
>  		}
>  	}
> -	task->rss_stat.events = 0;
> +	current->rss_stat.events = 0;
>  }

hm, with my gcc it's beneficial to cache `current' in a local.  But
when I tried that, Weird Things happened, because gcc has gone and
decided to inline __sync_task_rss_stat() into its callers.  I don't see
how that could have been the right thing to do.
