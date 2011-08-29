Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1H2QEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:04:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab1H2QEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:04:24 -0400
Date: Mon, 29 Aug 2011 18:00:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 1/4] cgroup_freezer: fix freezer->state
	setting bug in freezer_change_state()
Message-ID: <20110829160031.GB8392@redhat.com>
References: <20110829140418.GB18871@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829140418.GB18871@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29, Tejun Heo wrote:
>
> --- work.orig/kernel/cgroup_freezer.c
> +++ work/kernel/cgroup_freezer.c
> @@ -311,14 +311,14 @@ static int freezer_change_state(struct c
>  	if (goal_state == freezer->state)
>  		goto out;
>  
> -	freezer->state = goal_state;
> -
>  	switch (goal_state) {
>  	case CGROUP_THAWED:
> +		freezer->state = CGROUP_THAWED;
>  		atomic_dec(&system_freezing_cnt);
>  		unfreeze_cgroup(cgroup, freezer);
>  		break;
>  	case CGROUP_FROZEN:
> +		freezer->state = CGROUP_FREEZING;

At first glance, this is correct. I'll try to recheck.

But,

>  		atomic_inc(&system_freezing_cnt);

iiuc this becomes wrong... Suppose a user writes "FROZEN" twice,
before freezer->state becomes CGROUP_FROZEN.

I think we should actually fix the "goal_state == freezer->state"
check above.

Oleg.

