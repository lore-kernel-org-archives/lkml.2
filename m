Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab1IDSGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 14:06:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab1IDSGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 14:06:02 -0400
Date: Sun, 4 Sep 2011 20:02:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] cgroup_freezer: fix freezer->state setting bug in
	freezer_change_state()
Message-ID: <20110904180206.GA28520@redhat.com>
References: <1314988070-12244-1-git-send-email-tj@kernel.org> <1314988070-12244-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314988070-12244-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Tejun Heo wrote:
>
> @@ -308,24 +308,24 @@ static int freezer_change_state(struct cgroup *cgroup,
>  	spin_lock_irq(&freezer->lock);
>  
>  	update_if_frozen(cgroup, freezer);
> -	if (goal_state == freezer->state)
> -		goto out;
> -
> -	freezer->state = goal_state;
>  
>  	switch (goal_state) {
>  	case CGROUP_THAWED:
> -		atomic_dec(&system_freezing_cnt);
> +		if (freezer->state != CGROUP_THAWED)
> +			atomic_dec(&system_freezing_cnt);
> +		freezer->state = CGROUP_THAWED;
>  		unfreeze_cgroup(cgroup, freezer);
>  		break;
>  	case CGROUP_FROZEN:
> -		atomic_inc(&system_freezing_cnt);
> +		if (freezer->state == CGROUP_THAWED)
> +			atomic_inc(&system_freezing_cnt);
> +		freezer->state = CGROUP_FREEZING;
>  		retval = try_to_freeze_cgroup(cgroup, freezer);

Cough. Now it doesn't look right to me ;)

If the user write "FROZEN" into the control file, we should not
turn the CGROUP_FROZEN state into CGROUP_FREEZING. Probably this
is harmless, but this looks wrong and this doesn't match the
current behaviour, user-visible change.

Oleg.

