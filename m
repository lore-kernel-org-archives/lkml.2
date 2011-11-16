Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab1KPOMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:12:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55904 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759Ab1KPOMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:12:42 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=xtFQHgqWy1oA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=FOR7tLuvQPymXm2Qlr4A:9 a=SdAuw5DGwUmN3ZfSpggA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH -rt] memcg: use migrate_disable()/migrate_enable( ) in
 memcg_check_events()
From: Steven Rostedt <rostedt@goodmis.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20111116091653.GA8692@zhy>
References: <alpine.LFD.2.02.1111150050590.4902@ionos>
	 <20111115084059.GA23250@zhy>  <20111116091653.GA8692@zhy>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 09:12:38 -0500
Message-ID: <1321452758.4181.18.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 17:16 +0800, Yong Zhang wrote:
> Looking at commit 4799401f [memcg: Fix race condition in
> memcg_check_events() with this_cpu usage], we just want
> to disable migration. So use the right API in -rt. This
> will cure below warning.
> 

>  mm/memcontrol.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6aff93c..afa1954 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -722,7 +722,7 @@ static void __mem_cgroup_target_update(struct mem_cgroup *memcg, int target)
>   */
>  static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
>  {
> -	preempt_disable();
> +	migrate_disable();

No this won't work. Not even for -rt. If we disable migration but not
preemption, then two tasks can take this path. And the checks in
__memcg_event_check() will be corrupted because nothing is protecting
the updates from two tasks going into the same path.

Perhaps a local_lock would work.

-- Steve

>  	/* threshold event is triggered in finer grain than soft limit */
>  	if (unlikely(__memcg_event_check(memcg, MEM_CGROUP_TARGET_THRESH))) {
>  		mem_cgroup_threshold(memcg);
> @@ -742,7 +742,7 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
>  		}
>  #endif
>  	}
> -	preempt_enable();
> +	migrate_enable();
>  }
>  
>  static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)


