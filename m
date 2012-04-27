Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab2D0AnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 20:43:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab2D0AnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 20:43:10 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wom5GMh1gUkA:10 a=Co6SMZqKBZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=tmtSDGaQAAAA:8 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8 a=omOdbC7AAAAA:8 a=ufHFDILaAAAA:8 a=20KFwNOVAAAA:8 a=oCcaPWc0AAAA:8 a=rZka0BHWTyhvCDx21JkA:9 a=VzH2aI6hw9fiATg0AasA:7 a=CjuIK1q_8ugA:10 a=jkObVMfX7fAA:10 a=LI9Vle30uBYA:10 a=hPjdaMEvmhQA:10 a=l7ZknGph1ugA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Thu, 26 Apr 2012 20:43:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>, kamezawa.hiroyu@jp.fujitsu.com,
        linux-mm@kvack.org, devel@openvz.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH v4 1/3] make jump_labels wait while updates are in place
Message-ID: <20120427004305.GC23877@home.goodmis.org>
References: <1335480667-8301-1-git-send-email-glommer@parallels.com>
 <1335480667-8301-2-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335480667-8301-2-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 07:51:05PM -0300, Glauber Costa wrote:
> In mem cgroup, we need to guarantee that two concurrent updates
> of the jump_label interface wait for each other. IOW, we can't have
> other updates returning while the first one is still patching the
> kernel around, otherwise we'll race.

But it shouldn't. The code as is should prevent that.

> 
> I believe this is something that can fit well in the static branch
> API, without noticeable disadvantages:
> 
> * in the common case, it will be a quite simple lock/unlock operation
> * Every context that calls static_branch_slow* already expects to be
>   in sleeping context because it will mutex_lock the unlikely case.
> * static_key_slow_inc is not expected to be called in any fast path,
>   otherwise it would be expected to have quite a different name. Therefore
>   the mutex + atomic combination instead of just an atomic should not kill
>   us.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Li Zefan <lizefan@huawei.com>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Jason Baron <jbaron@redhat.com>
> ---
>  kernel/jump_label.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 4304919..5d09cb4 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -57,17 +57,16 @@ static void jump_label_update(struct static_key *key, int enable);
>  
>  void static_key_slow_inc(struct static_key *key)
>  {
> +	jump_label_lock();
>  	if (atomic_inc_not_zero(&key->enabled))
> -		return;

If key->enabled is not zero, there's nothing to be done. As the jump
label has already been enabled. Note, the key->enabled doesn't get set
until after the jump label is updated. Thus, if two tasks were to come
in, they both would be locked on the jump_label_lock().


> +		goto out;
>  
> -	jump_label_lock();
> -	if (atomic_read(&key->enabled) == 0) {
> -		if (!jump_label_get_branch_default(key))
> -			jump_label_update(key, JUMP_LABEL_ENABLE);
> -		else
> -			jump_label_update(key, JUMP_LABEL_DISABLE);
> -	}
> +	if (!jump_label_get_branch_default(key))
> +		jump_label_update(key, JUMP_LABEL_ENABLE);
> +	else
> +		jump_label_update(key, JUMP_LABEL_DISABLE);
>  	atomic_inc(&key->enabled);
> +out:
>  	jump_label_unlock();
>  }
>  EXPORT_SYMBOL_GPL(static_key_slow_inc);
> @@ -75,10 +74,11 @@ EXPORT_SYMBOL_GPL(static_key_slow_inc);
>  static void __static_key_slow_dec(struct static_key *key,
>  		unsigned long rate_limit, struct delayed_work *work)
>  {
> -	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex)) {
> +	jump_label_lock();
> +	if (atomic_dec_and_test(&key->enabled)) {
>  		WARN(atomic_read(&key->enabled) < 0,
>  		     "jump label: negative count!\n");
> -		return;

Here, it is similar. If enabled is > 1, it wouldn't need to do anything,
thus it would dec the counter and return. But if it were one, then the
lock would be taken. and set to zero. There shouldn't be a case where
two tasks came in to set it less than zero (then something is
unbalanced).

Are you hitting the WARN_ON?

-- Steve

> +		goto out;
>  	}
>  
>  	if (rate_limit) {
> @@ -90,6 +90,7 @@ static void __static_key_slow_dec(struct static_key *key,
>  		else
>  			jump_label_update(key, JUMP_LABEL_ENABLE);
>  	}
> +out:
>  	jump_label_unlock();
>  }
>  
> -- 
> 1.7.7.6
