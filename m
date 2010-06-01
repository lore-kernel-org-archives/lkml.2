Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab0FAT2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:28:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab0FAT2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:28:54 -0400
Date: Tue, 1 Jun 2010 21:27:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 3/5] oom: Fix child process iteration properly
Message-ID: <20100601192726.GA19120@redhat.com>
References: <20100601144238.243A.A69D9226@jp.fujitsu.com> <20100601144810.2440.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601144810.2440.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, KOSAKI Motohiro wrote:
>
> @@ -88,6 +88,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
>  {
>  	unsigned long points, cpu_time, run_time;
>  	struct task_struct *c;
> +	struct task_struct *t = p;

This initialization should be moved down to

> +	do {
> +		list_for_each_entry(c, &t->children, sibling) {
> +			child = find_lock_task_mm(c);
> +			if (child) {
> +				if (child->mm != p->mm)
> +					points += child->mm->total_vm/2 + 1;
> +				task_unlock(child);
> +			}
>  		}
> -	}
> +	} while_each_thread(p, t);

this loop. We have "p = find_lock_task_mm(p)" in between which can change p.

Apart from this, I think the whole series is nice.

Oleg.

