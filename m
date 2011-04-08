Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1DHK5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 06:57:31 -0400
Received: from relay.parallels.com ([195.214.232.42]:37616 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1DHK5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 06:57:30 -0400
From: Vladimir Davydov <VDavydov@parallels.com>
To: Ken Chen <kenchen@google.com>
CC: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Apr 2011 14:57:24 +0400
Subject: Re: Subject: [PATCH] sched: fixed erroneous all_pinned logic.
Thread-Topic: Subject: [PATCH] sched: fixed erroneous all_pinned logic.
Thread-Index: Acv1276RTz1gXt7LRlK1Oqxj4TpQXg==
Message-ID: <870910A1-62AF-412F-A989-1FA57B715E35@parallels.com>
References: <20110408002420.3F3A912217F@elm.corp.google.com>
In-Reply-To: <20110408002420.3F3A912217F@elm.corp.google.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 8, 2011, at 4:24 AM, Ken Chen wrote:

> @@ -2302,6 +2292,9 @@ static int move_tasks(
> #endif
> 	} while (load_moved && max_load_move > total_load_moved);
> 
> +	if (total_load_moved)
> +		*all_pinned = 0;
> +
> 	return total_load_moved > 0;
> }
> 
> @@ -3300,7 +3293,7 @@ static int load_balance(
> 			struct sched_domain *sd, enum cpu_idle_type idle,
> 			int *balance)
> {
> -	int ld_moved, all_pinned = 0, active_balance = 0;
> +	int ld_moved, all_pinned = 1, active_balance = 0;
> 	struct sched_group *group;
> 	unsigned long imbalance;
> 	struct rq *busiest;

As far as I understand, this patch sets the all_pinned flag if and only if we fail to move any tasks during the load balance. However, the migration can fail because e.g. all tasks are cache hot on their cpus (can_migrate_task() returns 0 in this case), and in this case we shouldn't treat all tasks as cpu bound, should we?