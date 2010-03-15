Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936936Ab0COVvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:51:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936926Ab0COVuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:50:55 -0400
Date: Mon, 15 Mar 2010 14:50:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kirill@shutemov.name" <kirill@shutemov.name>
Subject: Re: [PATCH 1/3] memcg: oom wakeup filter
Message-Id: <20100315145013.ee5919fd.akpm@linux-foundation.org>
In-Reply-To: <20100312143137.f4cf0a04.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100312143137.f4cf0a04.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010 14:31:37 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> +static int memcg_oom_wake_function(wait_queue_t *wait,
> +	unsigned mode, int sync, void *arg)
> +{
> +	struct mem_cgroup *wake_mem = (struct mem_cgroup *)arg;
> +	struct oom_wait_info *oom_wait_info;
> +
> +	/* both of oom_wait_info->mem and wake_mem are stable under us */
> +	oom_wait_info = container_of(wait, struct oom_wait_info, wait);
> +
> +	if (oom_wait_info->mem == wake_mem)
> +		goto wakeup;
> +	/* if no hierarchy, no match */
> +	if (!oom_wait_info->mem->use_hierarchy || !wake_mem->use_hierarchy)
> +		return 0;
> +	/* check hierarchy */
> +	if (!css_is_ancestor(&oom_wait_info->mem->css, &wake_mem->css) &&
> +	    !css_is_ancestor(&wake_mem->css, &oom_wait_info->mem->css))
> +		return 0;
> +
> +wakeup:
> +	return autoremove_wake_function(wait, mode, sync, arg);
> +}

What are the locking rules for calling css_is_ancestor()?
