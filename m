Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936938Ab0COVzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:55:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936880Ab0COVy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:54:58 -0400
Date: Mon, 15 Mar 2010 14:54:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kirill@shutemov.name" <kirill@shutemov.name>
Subject: Re: [PATCH 2/3] memcg: oom notifier
Message-Id: <20100315145420.07f2bbe5.akpm@linux-foundation.org>
In-Reply-To: <20100312143435.e648e361.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100312143137.f4cf0a04.kamezawa.hiroyu@jp.fujitsu.com>
	<20100312143435.e648e361.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010 14:34:35 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> +static int mem_cgroup_oom_register_event(struct cgroup *cgrp,
> +	struct cftype *cft, struct eventfd_ctx *eventfd, const char *args)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> +	struct mem_cgroup_eventfd_list *event;
> +	int type = MEMFILE_TYPE(cft->private);
> +	int ret = -ENOMEM;
> +
> +	BUG_ON(type != _OOM_TYPE);
> +
> +	mutex_lock(&memcg_oom_mutex);
> +
> +	event = kmalloc(sizeof(*event),	GFP_KERNEL);
> +	if (!event)
> +		goto unlock;
> +
> +	event->eventfd = eventfd;
> +	list_add(&event->list, &memcg->oom_notify);
> +
> +	/* already in OOM ? */
> +	if (atomic_read(&memcg->oom_lock))
> +		eventfd_signal(eventfd, 1);
> +	ret = 0;
> +unlock:
> +	mutex_unlock(&memcg_oom_mutex);
> +
> +	return ret;
> +}

We can move that kmalloc() outside the lock.  It's more scalable and the
code's cleaner.

--- a/mm/memcontrol.c~memcg-oom-notifier-fix
+++ a/mm/memcontrol.c
@@ -3603,27 +3603,23 @@ static int mem_cgroup_oom_register_event
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup_eventfd_list *event;
 	int type = MEMFILE_TYPE(cft->private);
-	int ret = -ENOMEM;
 
 	BUG_ON(type != _OOM_TYPE);
 
-	mutex_lock(&memcg_oom_mutex);
-
 	event = kmalloc(sizeof(*event),	GFP_KERNEL);
 	if (!event)
-		goto unlock;
+		return -ENOMEM;
 
+	mutex_lock(&memcg_oom_mutex);
 	event->eventfd = eventfd;
 	list_add(&event->list, &memcg->oom_notify);
 
 	/* already in OOM ? */
 	if (atomic_read(&memcg->oom_lock))
 		eventfd_signal(eventfd, 1);
-	ret = 0;
-unlock:
 	mutex_unlock(&memcg_oom_mutex);
 
-	return ret;
+	return 0;
 }
 
 static int mem_cgroup_oom_unregister_event(struct cgroup *cgrp,
_

